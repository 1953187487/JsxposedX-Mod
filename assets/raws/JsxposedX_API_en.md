# JsXposed API Documentation

JsXposed lets you write Xposed Hook scripts in JavaScript. All APIs are mounted on the global object `Jx`.

---

# 0. Script Authoring Rules (Read Before Generating Scripts)

The following are hard requirements. Violating any of them will make the script fail to run or be rejected by validation.

## 0.1 Use Only the `Jx.*` APIs Listed Here

Native Xposed APIs are forbidden. Never guess method names or parameter orders:

| Forbidden | Correct |
|---|---|
| `XposedHelpers.findAndHookMethod(...)` | `Jx.use(cls).hook(name, types, {...})` |
| `XposedBridge.hookAllMethods(...)` | `Jx.use(cls).hookAllMethods(name, {...})` |
| `XposedBridge.log(...)` | `Jx.log(...)` |
| `XposedHelpers.getObjectField(obj, name)` | `Jx.wrap(obj).getField(name)` |
| `XposedHelpers.setIntField(...)` | `Jx.setIntField(obj, name, v)` |

Any API not found in this document must be treated as non-existent.

## 0.2 Hook Callbacks Take a Single `param` Argument

Do not write `function(self, ...args)` or any other form:

```javascript
Jx.use("com.example.Target").hook("checkVip", [], {
  before: function(param) { /* before the method runs */ },
  after:  function(param) { /* after the method runs */ }
});
```

Members available on `param`:

| Member | Description |
|---|---|
| `param.thisObject` | Current instance (`null` for static methods) |
| `param.method` | The hooked method object |
| `param.argsLength` | Number of arguments |
| `param.getArg(i)` / `param.setArg(i, v)` | Read / write argument i |
| `param.getResult()` / `param.setResult(v)` | Read / write the return value. Setting a result in `before` skips the original method; in `after` it overrides the return value |
| `param.hasThrowable()` / `param.getThrowable()` / `param.setThrowable(t)` | Read / write the thrown exception |

## 0.3 The Parameter Type Array Is Mandatory

The second argument is the Java parameter type array. Pass `[]` for no-arg methods; it cannot be omitted:

```javascript
Jx.use(cls).hook("isVip", [], { ... });                               // no args
Jx.use(cls).hook("setFlag", ["int", "java.lang.String"], { ... });    // (int, String)
```

Use Java type names: `"int"`, `"boolean"`, `"long"`, `"java.lang.String"`, `"java.util.List"`.

## 0.4 Wrap Every Callback in try-catch

An exception in one callback aborts that hook. Always record it with `Jx.logException`:

```javascript
Jx.use("com.example.Target").hook("checkVip", [], {
  after: function(param) {
    try {
      param.setResult(true);
    } catch (e) {
      Jx.logException(e);
    }
  }
});
```

## 0.5 Log with `Jx.log` / `Jx.logException`

The log tag is `JsxposedX-JS` and output is visible in the script log panel. Log key branches, inputs and return values.

## 0.6 Do Not Put `[tradition]` Inside the Script

`[tradition]` is a **filename prefix** for Xposed scripts and is added automatically on save. Including it in the code body causes errors.

## 0.7 Minimal Working Skeleton

```javascript
// Goal: make com.example.Target#checkVip() always return true
Jx.use("com.example.Target").hook("checkVip", [], {
  before: function(param) {
    Jx.log("[Hook] checkVip called");
  },
  after: function(param) {
    try {
      Jx.log("[Hook] original result: " + param.getResult());
      param.setResult(true);
    } catch (e) {
      Jx.logException(e);
    }
  }
});
```

To pin a return value in one line:

```javascript
Jx.use("com.example.Target").returnConst("checkVip", [], true);
```

---

# 1. Core API (Native Bridge Layer)

These are low-level APIs directly exposed by the Kotlin Bridge, offering full functionality for scenarios requiring precise control.

---

## 1. Logging

### `Jx.log(message)`
Output log to Xposed log (visible in LSPosed logs).

```js
Jx.log("This is a log message");
```

### `Jx.logException(message)`
Output log as an exception stack trace, useful for tracking issue sources.

```js
Jx.logException("Something went wrong!");
```

### `console.log / console.info / console.warn / console.error`
Standard console methods are also available, forwarded to Native Logcat output (tag: `JsxposedX-JS`).

```js
console.log("Hello from JS");
console.error("Error occurred");
```

---

## 2. Class Operations

### `Jx.findClass(className)`
Check if a class exists in the target application.

- **Parameters**: `className` - Fully qualified class name
- **Returns**: `true` if exists / `false` if not

```js
if (Jx.findClass("com.example.app.UserManager")) {
    Jx.log("Class exists");
}
```

### `Jx.loadClass(className)`
Load and return the Class object (wrapped) for the specified class. Unlike `findClass` which returns a boolean, `loadClass` returns the actual class object for further reflection.

- **Parameters**: `className` - Fully qualified class name
- **Returns**: Wrapped Class object, or `null` if not found

```js
var cls = Jx.loadClass("com.example.app.UserManager");
if (cls) {
    Jx.log("Class loaded: " + cls.toString());
}
```

### `Jx.newInstance(className, paramTypes, paramValues)`
Create an instance of the specified class.

- **Parameters**:
  - `className` - Fully qualified class name
  - `paramTypes` - Constructor parameter type array (strings), pass `[]` for no params
  - `paramValues` - Constructor parameter value array, pass `[]` for no params
- **Returns**: Created Java object (wrapped)

```js
// No-arg constructor
var obj = Jx.newInstance("com.example.app.Config", [], []);

// With arguments
var obj = Jx.newInstance("com.example.app.User",
    ["java.lang.String", "int"],
    ["John", 18]
);
```

---

## 3. Method Invocation

### `Jx.callMethod(obj, methodName, paramTypes, paramValues)`
Call an instance method on an object.

- **Parameters**:
  - `obj` - Target object (Java wrapped object)
  - `methodName` - Method name
  - `paramTypes` - Parameter type array, pass `[]` for no params
  - `paramValues` - Parameter value array, pass `[]` for no params
- **Returns**: Method return value (wrapped)

```js
// No-arg call
var name = Jx.callMethod(user, "getName", [], []);

// With arguments
Jx.callMethod(user, "setAge", ["int"], [25]);
```

### `Jx.callStaticMethod(className, methodName, paramTypes, paramValues)`
Call a static method on a class.

- **Parameters**:
  - `className` - Fully qualified class name
  - `methodName` - Static method name
  - `paramTypes` - Parameter type array
  - `paramValues` - Parameter value array
- **Returns**: Method return value (wrapped)

```js
var result = Jx.callStaticMethod(
    "android.widget.Toast", "makeText",
    ["android.content.Context", "java.lang.CharSequence", "int"],
    [context, "Hello", 0]
);
Jx.callMethod(result, "show", [], []);
```

---

## 4. Field Access

### Instance Fields

```js
// Read object field (returns wrapped Java object)
var value = Jx.getObjectField(obj, "fieldName");

// Write object field
Jx.setObjectField(obj, "fieldName", newValue);

// Read/write int fields (returns JS number directly)
var count = Jx.getIntField(obj, "count");
Jx.setIntField(obj, "count", 100);

// Read/write boolean fields (returns JS boolean directly)
var flag = Jx.getBooleanField(obj, "isVip");
Jx.setBooleanField(obj, "isVip", true);
```

### Static Fields

```js
// Read static field
var value = Jx.getStaticObjectField("com.example.app.Config", "API_URL");

// Write static field
Jx.setStaticObjectField("com.example.app.Config", "API_URL", "https://new.api.com");
```

---

## 5. Hook

### `Jx.hookMethod(className, methodName, paramTypes, callbacks)`
Hook a specific method of a class.

- **Parameters**:
  - `className` - Fully qualified class name
  - `methodName` - Method name
  - `paramTypes` - Method parameter type array
  - `callbacks` - Callback object containing `before` and/or `after` functions
- **Callback parameter `param`**: See "Hook callback param object" below

```js
Jx.hookMethod(
    "com.example.app.UserManager",
    "login",
    ["java.lang.String", "java.lang.String"],
    {
        before: function(param) {
            Jx.log("Before login: username = " + param.getArg(0));
        },
        after: function(param) {
            Jx.log("After login: result = " + param.getResult());
        }
    }
);
```

### `Jx.hookConstructor(className, paramTypes, callbacks)`
Hook a class constructor.

```js
Jx.hookConstructor(
    "com.example.app.User",
    ["java.lang.String", "int"],
    {
        after: function(param) {
            var user = param.thisObject;
            Jx.log("New user created: " + user.toString());
        }
    }
);
```

### Hook Callback param Object

Each time a hook triggers, `before` and `after` callbacks receive a `param` object with these properties and methods:

| Property/Method | Description |
|---|---|
| `param.thisObject` | The caller of the hooked method (`this` in Java), a wrapped Java object |
| `param.raw` | The original Xposed `MethodHookParam` object, operable via `Jx.getObjectField` |
| `param.argsLength` | Number of method parameters |
| `param.getArg(index)` | Get parameter at index (0-based), returns wrapped Java object |
| `param.setArg(index, value)` | Modify parameter at index |
| `param.getResult()` | Get method return value (typically used in `after`) |
| `param.setResult(value)` | Modify return value. Calling in `before` intercepts the method |

```js
// Intercept method, return false directly, original method won't execute
Jx.hookMethod("com.example.app.Security", "checkRoot", [], {
    before: function(param) {
        param.setResult(false); // setResult in before = intercept original method
    }
});

// Modify method return value
Jx.hookMethod("com.example.app.Config", "getApiUrl", [], {
    after: function(param) {
        param.setResult("https://my-proxy.com/api");
    }
});

// Modify method arguments
Jx.hookMethod("com.example.app.Net", "request", ["java.lang.String"], {
    before: function(param) {
        Jx.log("Original URL: " + param.getArg(0));
        param.setArg(0, "https://new-url.com");
    }
});
```

---

## 6. Java Object Notes

All complex Java objects returned from the Bridge are **wrapped objects** — JS objects holding a reference to the Java object internally.

Each wrapped object has:
- `__java_obj_id` - Internal ID (do not modify manually)
- `__java_class_name` - Original Java class name (useful for debugging)
- `.toString()` - Calls the Java object's toString
- `.release()` - Manually release the reference (prevents memory leaks, recommended for long-running scripts)

Primitive types (String, Number, Boolean) are returned directly as native JS values, not wrapped.

```js
var obj = Jx.getObjectField(activity, "mTitle");
Jx.log(obj.__java_class_name); // "java.lang.String"
Jx.log(obj.toString());         // Actual title text

// Release objects held for a long time
obj.release();
```

---

## 7. Parameter Type Reference

Type strings used in `paramTypes` arrays:

| Type String | Java Type |
|---|---|
| `"int"` | int |
| `"long"` | long |
| `"boolean"` | boolean |
| `"byte"` | byte |
| `"short"` | short |
| `"float"` | float |
| `"double"` | double |
| `"char"` | char |
| `"java.lang.String"` | String |
| `"java.lang.CharSequence"` | CharSequence |
| `"android.content.Context"` | Context |
| `"android.os.Bundle"` | Bundle |
| Other fully qualified names | Corresponding class |

---

# 2. Sugar API

Convenient wrappers built on top of the core API for cleaner, more concise code.

---

## 1. `Jx.use(className)` — Class Proxy

Chain all operations on a class without repeating the fully qualified name.

The following Hook registration methods now return the same class proxy, so they can be chained safely:

- `hook(...)`
- `before(...)`
- `after(...)`
- `replace(...)`
- `returnConst(...)`
- `hookConstructor(...)`
- `beforeConstructor(...)`
- `afterConstructor(...)`
- `hookAllMethods(...)`
- `hookAllConstructors(...)`

This lets you register multiple hooks on the same proxy in one expression:

```js
var cls = Jx.use("com.example.app.Security")
    .before("checkRoot", [], function(param) {
        Jx.log("checkRoot called");
    })
    .returnConst("detectMagisk", [], false)
    .after("isVip", [], function(param) {
        Jx.log("isVip => " + param.getResult());
    });
```

If you still need the generated `hookId` / `hookId[]`, use:

- `cls.getLastHookResult()` to get the most recent registration result
- `cls.getHookResults()` to get all recorded registration results on the proxy
- `cls.clearHookResults()` to clear the recorded results and keep chaining

### Static Method Calls

```js
var cls = Jx.use("com.example.app.Utils");

// Auto-infer types (no need for paramTypes)
cls.call("staticMethod", arg1, arg2);

// Explicit types
cls.callTyped("staticMethod", ["int", "java.lang.String"], [1, "test"]);
```

### Static Field Access

```js
var cls = Jx.use("com.example.app.Config");

var url = cls.getField("API_URL");
cls.setField("API_URL", "https://new.com");
```

### Create Instances

```js
var cls = Jx.use("com.example.app.User");

// Auto-infer
var user = cls.newInstance("John", 18);

// Explicit types
var user = cls.newInstanceTyped(["java.lang.String", "int"], ["John", 18]);
```

### Hook Methods

```js
var cls = Jx.use("com.example.app.UserManager");

// Full form
cls.hook("login", ["java.lang.String", "java.lang.String"], {
    before: function(param) { },
    after: function(param) { }
});

// Before only
cls.before("login", ["java.lang.String", "java.lang.String"], function(param) {
    Jx.log("About to login: " + param.getArg(0));
});

// After only
cls.after("login", ["java.lang.String", "java.lang.String"], function(param) {
    Jx.log("Login result: " + param.getResult());
});

// Replace method logic (fn return value becomes method return value, original won't execute)
cls.replace("isVip", [], function(param) {
    return true; // Everyone is VIP
});

// Fix return value (one-liner)
cls.returnConst("isVip", [], true);
cls.returnConst("checkRoot", [], false);
cls.returnConst("getDebugMode", [], false);
```

### Hook Constructors

```js
var cls = Jx.use("com.example.app.User");

cls.hookConstructor(["java.lang.String", "int"], {
    before: function(param) { },
    after: function(param) { }
});

// Shorthand
cls.beforeConstructor(["java.lang.String", "int"], function(param) {
    Jx.log("About to create User");
});

cls.afterConstructor(["java.lang.String", "int"], function(param) {
    Jx.log("User created: " + param.thisObject.toString());
});
```

---

## 2. `Jx.wrap(obj)` — Instance Proxy

Convenient operations on an existing Java object.

```js
var w = Jx.wrap(someJavaObject);

// Call methods
w.call("getName");
w.call("setAge", 25);
w.callTyped("setAge", ["int"], [25]);

// Field access
var name = w.getField("mName");
w.setField("mName", "New Name");

// Primitive type fields
var count = w.getInt("mCount");
w.setInt("mCount", 100);

var flag = w.getBool("mEnabled");
w.setBool("mEnabled", true);

// Get class name
Jx.log(w.getClassName()); // "class com.example.app.User"
```

### Combined Usage in Hooks

```js
Jx.use("com.example.app.Activity").after("onCreate", ["android.os.Bundle"], function(param) {
    var activity = Jx.wrap(param.thisObject);
    var title = activity.call("getTitle");
    Jx.log("Activity title: " + title);
    activity.call("setTitle", "Hooked!");
});
```

---

## 3. `Jx.ext` — Extension Toolkit

Built-in common Android utility functions, also a registration point for custom tools.

### Built-in Tools

#### `Jx.ext.toast(context, text, duration?)`
Show a Toast.

```js
// Short Toast (default)
Jx.ext.toast(activity, "Hello!");

// Long Toast
Jx.ext.toast(activity, "Long display", 1);
```

#### `Jx.ext.getApplication()`
Get the current app's Application object.

```js
var app = Jx.ext.getApplication();
Jx.log("Package: " + Jx.ext.getPackageName(app));
```

#### `Jx.ext.getPackageName(context)`
Get the package name.

```js
var pkg = Jx.ext.getPackageName(activity);
```

#### `Jx.ext.getSharedPrefs(context, name, mode?)`
Get a SharedPreferences object.

```js
var sp = Jx.ext.getSharedPrefs(context, "app_config");
```

#### `Jx.ext.getPrefString(prefs, key, defaultValue?)`
#### `Jx.ext.getPrefInt(prefs, key, defaultValue?)`
#### `Jx.ext.getPrefBool(prefs, key, defaultValue?)`
Read values from SharedPreferences.

```js
var sp = Jx.ext.getSharedPrefs(context, "app_config");
var token = Jx.ext.getPrefString(sp, "token", "");
var level = Jx.ext.getPrefInt(sp, "level", 0);
var isVip = Jx.ext.getPrefBool(sp, "is_vip", false);
```

#### `Jx.ext.getSystemProp(key)`
Read system properties.

```js
var buildType = Jx.ext.getSystemProp("ro.build.type");
```

#### `Jx.ext.getBuild(fieldName)`
Read `android.os.Build` fields.

```js
var model = Jx.ext.getBuild("MODEL");
var brand = Jx.ext.getBuild("BRAND");
var sdk = Jx.ext.getBuild("VERSION.SDK_INT");
```

#### `Jx.ext.startActivity(context, className)`
Start an Activity.

```js
Jx.ext.startActivity(activity, "com.example.app.SettingsActivity");
```

#### `Jx.ext.stackTrace(tag?)`
Print current call stack to Xposed log, useful for tracing method call origins.

```js
Jx.use("com.example.app.Net").before("request", ["java.lang.String"], function(param) {
    Jx.log("Request URL: " + param.getArg(0));
    Jx.ext.stackTrace("Net.request");
});
```

### Custom Extensions

You can register your own utility functions on `Jx.ext`:

```js
Jx.ext.getVersionName = function(context) {
    var pm = Jx.callMethod(context, "getPackageManager", [], []);
    var pkg = Jx.ext.getPackageName(context);
    var info = Jx.callMethod(pm, "getPackageInfo",
        ["java.lang.String", "int"], [pkg, 0]
    );
    return Jx.getObjectField(info, "versionName");
};

// Usage
Jx.use("android.app.Activity").after("onCreate", ["android.os.Bundle"], function(param) {
    var version = Jx.ext.getVersionName(param.thisObject);
    Jx.log("App version: " + version);
});
```

---

# 3. Complete Examples

## Example 1: Hook Activity and Show Toast

```js
Jx.use("android.app.Activity").after("onCreate", ["android.os.Bundle"], function(param) {
    Jx.ext.toast(param.thisObject, "JsXposed Hook Success!");
});
```

## Example 2: Bypass Root Detection

```js
Jx.use("com.example.app.Security").returnConst("isRooted", [], false);
Jx.use("com.example.app.Security").returnConst("checkSu", [], false);
Jx.use("com.example.app.Security").returnConst("detectMagisk", [], false);
```

## Example 3: Modify VIP Status

```js
Jx.use("com.example.app.UserManager").replace("isVip", [], function(param) {
    return true;
});

// Or even simpler
Jx.use("com.example.app.UserManager").returnConst("isVip", [], true);
```

## Example 4: Intercept Network Requests

```js
Jx.use("com.example.app.HttpClient").before("post",
    ["java.lang.String", "java.lang.String"],
    function(param) {
        Jx.log("===== HTTP POST =====");
        Jx.log("URL: " + param.getArg(0));
        Jx.log("Body: " + param.getArg(1));
        Jx.ext.stackTrace("HttpClient.post");
    }
);
```

## Example 5: Hook Constructor and Modify Initial Values

```js
Jx.use("com.example.app.AppConfig").afterConstructor([], function(param) {
    var config = Jx.wrap(param.thisObject);
    config.setBool("adEnabled", false);
    config.setField("apiUrl", "https://my-server.com/api");
    Jx.log("AppConfig modified");
});
```

## Example 6: Read App SharedPreferences

```js
Jx.use("android.app.Activity").after("onCreate", ["android.os.Bundle"], function(param) {
    var activity = param.thisObject;
    var sp = Jx.ext.getSharedPrefs(activity, "user_data");
    var token = Jx.ext.getPrefString(sp, "access_token", "N/A");
    Jx.log("Token: " + token);
});
```

## Example 7: Modify Method Arguments

```js
Jx.use("com.example.app.Api").before("request",
    ["java.lang.String", "java.lang.String"],
    function(param) {
        param.setArg(0, "https://my-proxy.com/api");
        Jx.log("URL replaced");
    }
);
```

## Example 8: All-in-One — Remove Ads + Unlock + Logging

```js
// 1. Remove ads
Jx.use("com.example.app.AdManager").returnConst("shouldShowAd", [], false);
Jx.use("com.example.app.AdManager").returnConst("loadAd", [], null);

// 2. Unlock premium
Jx.use("com.example.app.UserManager").returnConst("isPremium", [], true);
Jx.use("com.example.app.UserManager").returnConst("getVipLevel", [], 10);

// 3. Trace key method calls
Jx.use("com.example.app.PayManager").before("pay",
    ["java.lang.String", "int"],
    function(param) {
        Jx.log("===== Payment Request =====");
        Jx.log("Product ID: " + param.getArg(0));
        Jx.log("Amount: " + param.getArg(1));
        Jx.ext.stackTrace("PayManager.pay");
    }
);
```
