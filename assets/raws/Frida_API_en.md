# Frida API Documentation

Frida is a powerful dynamic instrumentation toolkit. JsXposed_X integrates Frida and provides `Fx` syntax sugar for writing Frida Hook scripts more concisely.

---

# 0. Script Authoring Rules (Read Before Generating Scripts)

The following are hard requirements. Violating any of them will make the script fail to run or be rejected by validation.

## 0.1 Use Only the `Fx.*` APIs Listed Here

Native Frida APIs are forbidden (validation rejects them):

| Forbidden | Correct |
|---|---|
| `Java.perform(function(){...})` | Omit it. The loader already wraps scripts in `Java.perform` |
| `Java.use("com.a.B")` | `Fx.use("com.a.B")` |
| `Java.use(cls).m.overload(...).implementation = fn` | `Fx.use(cls).hook("m", [...], {...})` |
| `Java.cast(obj, Java.use(cls))` | `Fx.wrap(obj).cast(cls)` |

Any API not found in this document must be treated as non-existent.

## 0.2 Write Statements at the Top Level

Do **not** wrap your code in `Java.perform` and do not defer execution. The loader places the whole script inside the Java context already:

```javascript
// Correct: top-level statements
Fx.use("com.example.Target").hook("checkVip", [], {
  after: function(retval, args, thisObj) {
    try {
      return true;
    } catch (e) {
      console.log("[Fx] error: " + e);
    }
  }
});
```

## 0.3 Hook Callback Signature Is `(args, thisObj)`, Not `param`

`Fx` differs from `Jx`: there is **no** `param` object; arguments arrive as function parameters:

| Callback | Signature | Description |
|---|---|---|
| `before` | `function(args, thisObj)` | `args` is the argument array; mutate with `args[0] = x` |
| `after` | `function(retval, args, thisObj)` | `retval` is the original return value |
| `replace` | `function(args, thisObj)` | Its `return` becomes the method result; the original method does not run |

```javascript
Fx.use("com.example.Target").hook("checkVip", [], {
  before: function(args, thisObj) { console.log("[Fx] called, arg0: " + args[0]); },
  after:  function(retval, args, thisObj) { console.log("[Fx] returned: " + retval); }
});
```

## 0.4 `after` Returning a Falsy Value Has No Effect

An `after` return value replaces the original only when **truthy**:

```javascript
// To force true -- works
after: function(retval, args, thisObj) { return true; }

// To force false -- this does NOT work! false is falsy, so the original value is kept
after: function(retval, args, thisObj) { return false; }   // wrong

// Correct option 1: returnConst
Fx.use(cls).returnConst("isVip", [], false);

// Correct option 2: replace
Fx.use(cls).replace("isVip", [], function(args, thisObj) { return false; });
```

## 0.5 The Parameter Type Array Is Mandatory

The second argument is the Java parameter type array; pass `[]` for no-arg methods:

```javascript
Fx.use(cls).hook("isVip", [], { ... });                             // no args
Fx.use(cls).hook("setFlag", ["int", "java.lang.String"], { ... });  // (int, String)
```

Passing `[]` matches the method's first overload; when a method has several overloads and you need a specific one, list all types.

## 0.6 Wrap Every Callback in try-catch

```javascript
after: function(retval, args, thisObj) {
  try {
    console.log("[Fx] original result: " + retval);
  } catch (e) {
    console.log("[Fx] error: " + e);
  }
}
```

## 0.7 Log with `console.log` / `Fx.log`

The log tag is `JsxposedX-Frida` and output is visible in the script log panel.

## 0.8 Minimal Working Skeleton

```javascript
// Goal: make com.example.Target#checkVip() always return true
Fx.use("com.example.Target").hook("checkVip", [], {
  before: function(args, thisObj) {
    console.log("[Fx] checkVip called");
  },
  after: function(retval, args, thisObj) {
    try {
      console.log("[Fx] original result: " + retval);
      return true;
    } catch (e) {
      console.log("[Fx] error: " + e);
    }
  }
});
```

To pin a return value in one line:

```javascript
Fx.use("com.example.Target").returnConst("checkVip", [], true);
```

---

# 1. Frida Native API

These are Frida's core APIs, powerful and flexible.

---

## 1. Java API

### `Java.perform(fn)`
Execute code in Java VM context. All Java-related operations must be performed within this callback.

```js
Java.perform(function() {
    console.log("Java VM ready");
    var Activity = Java.use("android.app.Activity");
});
```

### `Java.use(className)`
Get a wrapper for the specified class, used for calling static methods, hooking methods, etc.

```js
Java.perform(function() {
    var Toast = Java.use("android.widget.Toast");
    var String = Java.use("java.lang.String");
});
```

### `Java.choose(className, callbacks)`
Enumerate all instances of the specified class in the heap.

```js
Java.perform(function() {
    Java.choose("com.example.app.User", {
        onMatch: function(instance) {
            console.log("Found instance: " + instance.toString());
        },
        onComplete: function() {
            console.log("Enumeration complete");
        }
    });
});
```

### `Java.cast(obj, klass)`
Cast an object to the specified type.

```js
Java.perform(function() {
    var obj = getSomeObject();
    var Activity = Java.use("android.app.Activity");
    var activity = Java.cast(obj, Activity);
});
```

### `Java.enumerateLoadedClasses(callbacks)`
Enumerate all loaded classes.

```js
Java.perform(function() {
    Java.enumerateLoadedClasses({
        onMatch: function(className) {
            if (className.indexOf("com.example") !== -1) {
                console.log("Found class: " + className);
            }
        },
        onComplete: function() {}
    });
});
```

### `Java.enumerateClassLoaders(callbacks)`
Enumerate all class loaders.

```js
Java.perform(function() {
    Java.enumerateClassLoaders({
        onMatch: function(loader) {
            console.log("Class loader: " + loader);
        },
        onComplete: function() {}
    });
});
```

### `Java.scheduleOnMainThread(fn)`
Execute code on the main thread.

```js
Java.perform(function() {
    Java.scheduleOnMainThread(function() {
        console.log("Running on main thread");
    });
});
```

---

## 2. Interceptor API

### `Interceptor.attach(target, callbacks)`
Attach an interceptor to the specified address.

```js
var addr = Module.findExportByName("libc.so", "open");
Interceptor.attach(addr, {
    onEnter: function(args) {
        console.log("open() called");
        console.log("Path: " + Memory.readUtf8String(args[0]));
    },
    onLeave: function(retval) {
        console.log("Return value: " + retval);
    }
});
```

### `Interceptor.replace(target, replacement)`
Replace function implementation.

```js
var addr = Module.findExportByName("libc.so", "strlen");
Interceptor.replace(addr, new NativeCallback(function(str) {
    console.log("strlen called");
    return 0;
}, 'int', ['pointer']));
```

---

## 3. Module API

### `Module.findExportByName(moduleName, exportName)`
Find the address of an exported function in a module.

```js
var openAddr = Module.findExportByName("libc.so", "open");
var mallocAddr = Module.findExportByName(null, "malloc"); // null = all modules
```

### `Module.findBaseAddress(moduleName)`
Get the base address of a module.

```js
var base = Module.findBaseAddress("libnative.so");
console.log("Base address: " + base);
```

### `Module.enumerateExports(moduleName)`
Enumerate all exported functions in a module.

```js
var exports = Module.enumerateExports("libc.so");
exports.forEach(function(exp) {
    console.log(exp.name + " @ " + exp.address);
});
```

### `Module.enumerateImports(moduleName)`
Enumerate all imported functions in a module.

```js
var imports = Module.enumerateImports("libnative.so");
imports.forEach(function(imp) {
    console.log(imp.name + " from " + imp.module);
});
```

### `Module.load(path)`
Load a module from the specified path.

```js
var mod = Module.load("/data/local/tmp/test.so");
```

---

## 4. Memory API

### `Memory.alloc(size)`
Allocate memory.

```js
var buf = Memory.alloc(1024);
```

### `Memory.allocUtf8String(str)`
Allocate a UTF-8 string.

```js
var str = Memory.allocUtf8String("Hello Frida");
```

### `Memory.readUtf8String(address, length?)`
Read a UTF-8 string.

```js
var str = Memory.readUtf8String(ptr);
var str2 = Memory.readUtf8String(ptr, 100); // Read up to 100 bytes
```

### `Memory.writeUtf8String(address, str)`
Write a UTF-8 string.

```js
Memory.writeUtf8String(ptr, "New String");
```

### `Memory.readByteArray(address, length)`
Read a byte array.

```js
var bytes = Memory.readByteArray(ptr, 16);
console.log(hexdump(bytes));
```

### `Memory.writeByteArray(address, bytes)`
Write a byte array.

```js
Memory.writeByteArray(ptr, [0x90, 0x90, 0x90, 0x90]);
```

### `Memory.scan(address, size, pattern, callbacks)`
Scan memory for a pattern.

```js
Memory.scan(base, 0x1000, "48 8b ?? ?? 00 00 00", {
    onMatch: function(address, size) {
        console.log("Found match: " + address);
    },
    onComplete: function() {}
});
```

---

## 5. Process API

### `Process.enumerateModules()`
Enumerate all loaded modules.

```js
var modules = Process.enumerateModules();
modules.forEach(function(mod) {
    console.log(mod.name + " @ " + mod.base);
});
```

### `Process.enumerateThreads()`
Enumerate all threads.

```js
var threads = Process.enumerateThreads();
threads.forEach(function(thread) {
    console.log("Thread ID: " + thread.id);
});
```

### `Process.getCurrentThreadId()`
Get the current thread ID.

```js
var tid = Process.getCurrentThreadId();
console.log("Current thread: " + tid);
```

### `Process.arch`
Get the architecture (arm, arm64, ia32, x64).

```js
console.log("Architecture: " + Process.arch);
```

### `Process.platform`
Get the platform (linux, darwin, windows).

```js
console.log("Platform: " + Process.platform);
```

---

## 6. console API

### `console.log(message)`
Output log (tag: `JsxposedX-Frida`).

```js
console.log("This is a log");
console.log("Username:", username, "Age:", age);
```

### `console.warn(message)`
Output warning log.

```js
console.warn("This is a warning");
```

### `console.error(message)`
Output error log.

```js
console.error("This is an error");
```

---

# 2. Fx Syntax Sugar API

`Fx` is the syntax sugar provided by JsXposed_X to simplify common Frida operations. All APIs are mounted on the global object `Fx`.

---

## 1. `Fx.use(className)` — Class Proxy

All operations on a class can be chained.

The following Hook-related methods now return the same class proxy, so they can be chained safely:

- `hook(...)`
- `before(...)`
- `after(...)`
- `replace(...)`
- `returnConst(...)`
- `hookConstructor(...)`
- `hookAll(...)`

This allows multiple hooks to be registered on the same proxy in one expression:

```js
Fx.use("com.example.app.UserManager")
    .hook("login", ["java.lang.String", "java.lang.String"], {
        before: function(args) {
            console.log("login user=" + args[0]);
        }
    })
    .hook("logout", [], {
        before: function() {
            console.log("logout called");
        }
    })
    .returnConst("isVip", [], true);
```

Note: methods like `call(...)`, `getField(...)`, and `newInstance(...)` return invocation results, so they are not meant for chained Hook registration.

### Call static methods

```js
var cls = Fx.use("com.example.app.Utils");
cls.call("staticMethod", arg1, arg2);
```

### Read/write static fields

```js
var cls = Fx.use("com.example.app.Config");
var url = cls.getField("API_URL");
cls.setField("API_URL", "https://new.com");
```

### Create instances

```js
var cls = Fx.use("com.example.app.User");
var user = cls.newInstance("John", 18);
```

### Hook methods

```js
var cls = Fx.use("com.example.app.UserManager");

// Full form
cls.hook("login", ["java.lang.String", "java.lang.String"], {
    before: function(args, thisObj) {
        console.log("Before login: " + args[0]);
    },
    after: function(ret, args, thisObj) {
        console.log("After login: " + ret);
    }
});

// Shorthand: before only
cls.before("login", ["java.lang.String", "java.lang.String"], function(args, thisObj) {
    console.log("Username: " + args[0]);
});

// Shorthand: after only
cls.after("login", ["java.lang.String", "java.lang.String"], function(ret, args, thisObj) {
    console.log("Return value: " + ret);
});

// Replace method logic
cls.replace("isVip", [], function(args, thisObj) {
    return true; // Everyone is VIP
});

// Fixed return value
cls.returnConst("isVip", [], true);
cls.returnConst("checkRoot", [], false);
```

### Hook constructors

```js
var cls = Fx.use("com.example.app.User");

cls.hookConstructor(["java.lang.String", "int"], {
    before: function(args, thisObj) {
        console.log("About to create User");
    },
    after: function(args, thisObj) {
        console.log("User created");
    }
});
```

### Hook all overloads

```js
var cls = Fx.use("com.example.app.Net");

// Hook all methods named request
cls.hookAll("request", {
    before: function(args, thisObj) {
        console.log("request called");
    }
});
```

---

## 2. `Fx.wrap(obj)` — Instance Proxy

Convenient operations on an existing Java object.

```js
var w = Fx.wrap(someJavaObject);

// Call methods
var name = w.call("getName");
w.call("setAge", 25);

// Read/write fields
var count = w.getField("mCount");
w.setField("mCount", 100);

// Get class name
console.log(w.getClassName());

// Type casting
var activity = w.cast("android.app.Activity");
```

---

## 3. `Fx.ext` — Extension Utilities

Built-in common Android utility functions.

### `Fx.ext.toJava(value)`
Convert JavaScript types to Java wrapper types.

```js
// Boolean conversion
var javaTrue = Fx.ext.toJava(true);  // Returns java.lang.Boolean
cls.returnConst("getVip", [], Fx.ext.toJava(true));

// Number conversion
var javaInt = Fx.ext.toJava(123);     // Returns java.lang.Integer
var javaDouble = Fx.ext.toJava(3.14); // Returns java.lang.Double

// String conversion
var javaStr = Fx.ext.toJava("hello"); // Returns java.lang.String

// null/undefined returns null
var javaNull = Fx.ext.toJava(null);   // Returns null
```

**Use cases:**
- When hooking methods that return Java wrapper types (like `Boolean`, `Integer`)
- Avoid `NullPointerException` and other type conversion errors

### `Fx.ext.toast(text, duration?)`
Show a Toast.

```js
Fx.ext.toast("Hello Frida!");
Fx.ext.toast("Long display", 1);
```

### `Fx.ext.getApplication()`
Get the Application object.

```js
var app = Fx.ext.getApplication();
```

### `Fx.ext.getPackageName()`
Get the package name.

```js
var pkg = Fx.ext.getPackageName();
console.log("Package: " + pkg);
```

### `Fx.ext.getSharedPrefs(name, mode?)`
Get SharedPreferences.

```js
var sp = Fx.ext.getSharedPrefs("app_config");
```

### `Fx.ext.getPrefString(prefs, key, def?)`
### `Fx.ext.getPrefInt(prefs, key, def?)`
### `Fx.ext.getPrefBool(prefs, key, def?)`
Read SharedPreferences values.

```js
var sp = Fx.ext.getSharedPrefs("app_config");
var token = Fx.ext.getPrefString(sp, "token", "");
var level = Fx.ext.getPrefInt(sp, "level", 0);
var isVip = Fx.ext.getPrefBool(sp, "is_vip", false);
```

### `Fx.ext.getSystemProp(key)`
Read system properties.

```js
var buildType = Fx.ext.getSystemProp("ro.build.type");
```

### `Fx.ext.getBuild(fieldName)`
Read Build information.

```js
var model = Fx.ext.getBuild("MODEL");
var brand = Fx.ext.getBuild("BRAND");
var sdk = Fx.ext.getBuild("VERSION.SDK_INT");
```

### `Fx.ext.startActivity(className)`
Start an Activity.

```js
Fx.ext.startActivity("com.example.app.MainActivity");
```

### `Fx.ext.stackTrace(tag?)`
Print the call stack.

```js
Fx.ext.stackTrace("MyTag");
```

---

## 4. `Fx.hookNative(moduleName, exportName, callbacks)` — Native Hook

Quick Native Hook wrapper.

```js
Fx.hookNative("libc.so", "open", {
    onEnter: function(args) {
        console.log("open: " + Memory.readUtf8String(args[0]));
    },
    onLeave: function(retval) {
        console.log("Return: " + retval);
    }
});
```

---

## 5. `Fx.java.*` — Java API Shortcuts

### `Fx.java.choose(className, callbacks)`
Enumerate instances.

```js
Fx.java.choose("com.example.app.User", {
    onMatch: function(instance) {
        console.log("Found: " + instance);
    },
    onComplete: function() {}
});
```

### `Fx.java.cast(obj, className)`
Type casting.

```js
var activity = Fx.java.cast(obj, "android.app.Activity");
```

### `Fx.java.enumerateLoadedClasses(callbacks)`
Enumerate loaded classes.

```js
Fx.java.enumerateLoadedClasses({
    onMatch: function(className) {
        if (className.indexOf("com.example") !== -1) {
            console.log(className);
        }
    },
    onComplete: function() {}
});
```

### `Fx.java.enumerateClassLoaders(callbacks)`
Enumerate class loaders.

```js
Fx.java.enumerateClassLoaders({
    onMatch: function(loader) {
        console.log(loader);
    },
    onComplete: function() {}
});
```

### `Fx.java.scheduleOnMainThread(fn)`
Execute on main thread.

```js
Fx.java.scheduleOnMainThread(function() {
    console.log("Main thread");
});
```

---

## 6. `Fx.module.*` — Module API Shortcuts

### `Fx.module.findExport(moduleName, exportName)`
Find exported function.

```js
var addr = Fx.module.findExport("libc.so", "open");
```

### `Fx.module.findBase(moduleName)`
Find module base address.

```js
var base = Fx.module.findBase("libnative.so");
```

### `Fx.module.enumerateExports(moduleName)`
Enumerate exports.

```js
var exports = Fx.module.enumerateExports("libc.so");
```

### `Fx.module.enumerateImports(moduleName)`
Enumerate imports.

```js
var imports = Fx.module.enumerateImports("libnative.so");
```

### `Fx.module.load(path)`
Load module.

```js
Fx.module.load("/data/local/tmp/test.so");
```

---

## 7. `Fx.interceptor.*` — Interceptor API Shortcuts

### `Fx.interceptor.attach(target, callbacks)`
Attach interceptor.

```js
var addr = Fx.module.findExport("libc.so", "open");
Fx.interceptor.attach(addr, {
    onEnter: function(args) {
        console.log("open called");
    }
});
```

### `Fx.interceptor.replace(target, replacement)`
Replace function.

```js
var addr = Fx.module.findExport("libc.so", "strlen");
Fx.interceptor.replace(addr, new NativeCallback(function(str) {
    return 0;
}, 'int', ['pointer']));
```

---

## 8. `Fx.memory.*` — Memory API Shortcuts

### `Fx.memory.alloc(size)`
Allocate memory.

```js
var buf = Fx.memory.alloc(1024);
```

### `Fx.memory.allocUtf8(str)`
Allocate UTF-8 string.

```js
var str = Fx.memory.allocUtf8("Hello");
```

### `Fx.memory.readUtf8(address, length?)`
Read UTF-8 string.

```js
var str = Fx.memory.readUtf8(ptr);
```

### `Fx.memory.writeUtf8(address, str)`
Write UTF-8 string.

```js
Fx.memory.writeUtf8(ptr, "New String");
```

### `Fx.memory.readBytes(address, length)`
Read byte array.

```js
var bytes = Fx.memory.readBytes(ptr, 16);
```

### `Fx.memory.writeBytes(address, bytes)`
Write byte array.

```js
Fx.memory.writeBytes(ptr, [0x90, 0x90]);
```

### `Fx.memory.scan(address, size, pattern, callbacks)`
Scan memory.

```js
Fx.memory.scan(base, 0x1000, "48 8b ?? ??", {
    onMatch: function(address, size) {
        console.log("Found: " + address);
    },
    onComplete: function() {}
});
```

---

## 9. `Fx.process.*` — Process API Shortcuts

### `Fx.process.enumerateModules()`
Enumerate modules.

```js
var modules = Fx.process.enumerateModules();
modules.forEach(function(mod) {
    console.log(mod.name);
});
```

### `Fx.process.enumerateThreads()`
Enumerate threads.

```js
var threads = Fx.process.enumerateThreads();
```

### `Fx.process.getCurrentThreadId()`
Get current thread ID.

```js
var tid = Fx.process.getCurrentThreadId();
```

---

## 10. `Fx.log(message)` / `Fx.logError(message)` — Logging

Unified logging output (tag: `JsxposedX-Frida`).

```js
Fx.log("This is a log");
Fx.logError("This is an error");
```

---

# 3. Complete Examples

## Example 1: Hook Activity and Show Toast

```js
Fx.use("android.app.Activity").after("onCreate", ["android.os.Bundle"], function(ret, args, thisObj) {
    Fx.ext.toast("Frida Hook Success!");
});
```

## Example 2: Bypass Root Detection

```js
Fx.use("com.example.app.Security").returnConst("isRooted", [], false);
Fx.use("com.example.app.Security").returnConst("checkSu", [], false);
```

## Example 3: Modify VIP Status

```js
Fx.use("com.example.app.UserManager").returnConst("isVip", [], true);
```

## Example 4: Intercept Network Requests

```js
Fx.use("com.example.app.HttpClient").before("post",
    ["java.lang.String", "java.lang.String"],
    function(args, thisObj) {
        console.log("===== HTTP POST =====");
        console.log("URL: " + args[0]);
        console.log("Body: " + args[1]);
    }
);
```

## Example 5: Enumerate All Activity Instances

```js
Fx.java.choose("android.app.Activity", {
    onMatch: function(activity) {
        var w = Fx.wrap(activity);
        var title = w.call("getTitle");
        console.log("Activity: " + title);
    },
    onComplete: function() {
        console.log("Enumeration complete");
    }
});
```

## Example 6: Native Hook

```js
Fx.hookNative("libc.so", "open", {
    onEnter: function(args) {
        var path = Memory.readUtf8String(args[0]);
        if (path.indexOf("/data") !== -1) {
            console.log("Opening file: " + path);
        }
    }
});
```

## Example 7: Memory Scanning

```js
var base = Fx.module.findBase("libnative.so");
Fx.memory.scan(base, 0x10000, "48 8b 05 ?? ?? ?? ??", {
    onMatch: function(address, size) {
        console.log("Found pattern: " + address);
    },
    onComplete: function() {
        console.log("Scan complete");
    }
});
```

## Example 8: Comprehensive — Remove Ads + Unlock

```js
// 1. Remove ads
Fx.use("com.example.app.AdManager").returnConst("shouldShowAd", [], false);

// 2. Unlock premium
Fx.use("com.example.app.UserManager").returnConst("isPremium", [], true);

// 3. Track payments
Fx.use("com.example.app.PayManager").before("pay",
    ["java.lang.String", "int"],
    function(args, thisObj) {
        console.log("===== Payment Request =====");
        console.log("Product ID: " + args[0]);
        console.log("Amount: " + args[1]);
        Fx.ext.stackTrace("PayManager.pay");
    }
);
```
