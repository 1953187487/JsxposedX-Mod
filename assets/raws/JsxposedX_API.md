# JsXposed API 文档

JsXposed 让你用 JavaScript 编写 Xposed Hook 脚本。所有 API 都挂载在全局对象 `Jx` 上。

---

# 零、脚本编写规范（生成脚本前必读）

以下为硬性要求。违反任意一条，脚本都无法正常运行或被校验拒绝。

## 0.1 只用本文档列出的 `Jx.*` API

禁止出现原生 Xposed API，禁止凭经验猜测方法名或参数：

| 禁止写法 | 正确写法 |
|---|---|
| `XposedHelpers.findAndHookMethod(...)` | `Jx.use(cls).hook(name, types, {...})` |
| `XposedBridge.hookAllMethods(...)` | `Jx.use(cls).hookAllMethods(name, {...})` |
| `XposedBridge.log(...)` | `Jx.log(...)` |
| `XposedHelpers.getObjectField(obj, name)` | `Jx.wrap(obj).getField(name)` |
| `XposedHelpers.setIntField(...)` | `Jx.setIntField(obj, name, v)` |

本文档中查不到的 API 一律视为不存在。

## 0.2 Hook 回调只有一个参数 `param`

不要写 `function(self, ...args)`，也不要写其他形式：

```javascript
Jx.use("com.example.Target").hook("checkVip", [], {
  before: function(param) { /* 方法执行前 */ },
  after:  function(param) { /* 方法执行后 */ }
});
```

`param` 的可用成员：

| 成员 | 说明 |
|---|---|
| `param.thisObject` | 当前实例（静态方法为 `null`） |
| `param.method` | 被 Hook 的方法对象 |
| `param.argsLength` | 参数个数 |
| `param.getArg(i)` / `param.setArg(i, v)` | 读 / 写第 i 个参数 |
| `param.getResult()` / `param.setResult(v)` | 读 / 写返回值。在 `before` 中 `setResult` 会跳过原方法直接返回；在 `after` 中则是覆盖返回值 |
| `param.hasThrowable()` / `param.getThrowable()` / `param.setThrowable(t)` | 读 / 写抛出的异常 |

## 0.3 参数类型数组必传

第二个参数是 Java 参数类型数组，无参方法传 `[]`，不可省略：

```javascript
Jx.use(cls).hook("isVip", [], { ... });                               // 无参
Jx.use(cls).hook("setFlag", ["int", "java.lang.String"], { ... });    // (int, String)
```

类型写 Java 类型名：`"int"`、`"boolean"`、`"long"`、`"java.lang.String"`、`"java.util.List"`。

## 0.4 每个回调都要 try-catch

单个回调抛异常会打断该 Hook，务必用 `Jx.logException` 记录：

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

## 0.5 日志统一用 `Jx.log` / `Jx.logException`

日志 tag 为 `JsxposedX-JS`，在脚本日志面板中可见。关键分支、入参、返回值都应留痕。

## 0.6 `[tradition]` 不要写进脚本内容

`[tradition]` 是 Xposed 脚本的**文件名前缀**，保存时由系统自动添加。写进代码里会被当成脚本体内容，导致异常。

## 0.7 最小可用骨架

```javascript
// 目标：让 com.example.Target#checkVip() 恒返回 true
Jx.use("com.example.Target").hook("checkVip", [], {
  before: function(param) {
    Jx.log("[Hook] checkVip 被调用");
  },
  after: function(param) {
    try {
      Jx.log("[Hook] 原返回值: " + param.getResult());
      param.setResult(true);
    } catch (e) {
      Jx.logException(e);
    }
  }
});
```

一行固定返回值可用简写：

```javascript
Jx.use("com.example.Target").returnConst("checkVip", [], true);
```

---

# 一、基础 API（原生桥接层）

这些是直接由 Kotlin Bridge 暴露的底层 API，功能最完整，适合需要精确控制的场景。

---

## 1. 日志

### `Jx.log(message)`
输出日志到 Xposed 日志（LSPosed 日志可见）。

```js
Jx.log("这是一条日志");
```

### `Jx.logException(message)`
以异常堆栈的形式输出日志，便于追踪问题来源。

```js
Jx.logException("出错了!");
```

### `console.log / console.info / console.warn / console.error`
标准 console 也可以用，会转发到 Native 层的 Logcat 输出（tag 为 `JsxposedX-JS`）。

```js
console.log("Hello from JS");
console.error("出错了");
```

---

## 2. 类操作

### `Jx.findClass(className)`
检查目标应用中是否存在某个类。

- **参数**: `className` - 类的全限定名
- **返回**: `true` 存在 / `false` 不存在

```js
if (Jx.findClass("com.example.app.UserManager")) {
    Jx.log("类存在");
}
```

### `Jx.loadClass(className)`
加载并返回指定类的 Class 对象（wrapped），可用于后续反射操作。与 `findClass` 不同，`loadClass` 返回的是类对象而非布尔值。

- **参数**: `className` - 类的全限定名
- **返回**: wrapped Class 对象，找不到则返回 `null`

```js
var cls = Jx.loadClass("com.example.app.UserManager");
if (cls) {
    Jx.log("类已加载: " + cls.toString());
}
```

### `Jx.newInstance(className, paramTypes, paramValues)`
创建指定类的实例。

- **参数**:
  - `className` - 类的全限定名
  - `paramTypes` - 构造函数参数类型数组（字符串），无参传 `[]`
  - `paramValues` - 构造函数参数值数组，无参传 `[]`
- **返回**: 创建的 Java 对象（wrapped）

```js
// 无参构造
var obj = Jx.newInstance("com.example.app.Config", [], []);

// 有参构造
var obj = Jx.newInstance("com.example.app.User",
    ["java.lang.String", "int"],
    ["张三", 18]
);
```

---

## 3. 方法调用

### `Jx.callMethod(obj, methodName, paramTypes, paramValues)`
调用对象的实例方法。

- **参数**:
  - `obj` - 目标对象（Java wrapped 对象）
  - `methodName` - 方法名
  - `paramTypes` - 参数类型数组，无参传 `[]`
  - `paramValues` - 参数值数组，无参传 `[]`
- **返回**: 方法的返回值（wrapped）

```js
// 无参调用
var name = Jx.callMethod(user, "getName", [], []);

// 有参调用
Jx.callMethod(user, "setAge", ["int"], [25]);
```

### `Jx.callStaticMethod(className, methodName, paramTypes, paramValues)`
调用类的静态方法。

- **参数**:
  - `className` - 类的全限定名
  - `methodName` - 静态方法名
  - `paramTypes` - 参数类型数组
  - `paramValues` - 参数值数组
- **返回**: 方法的返回值（wrapped）

```js
var result = Jx.callStaticMethod(
    "android.widget.Toast", "makeText",
    ["android.content.Context", "java.lang.CharSequence", "int"],
    [context, "Hello", 0]
);
Jx.callMethod(result, "show", [], []);
```

---

## 4. 字段读写

### 实例字段

```js
// 读取/写入对象字段（返回 wrapped Java 对象）
var value = Jx.getObjectField(obj, "fieldName");
Jx.setObjectField(obj, "fieldName", newValue);

// int
var count = Jx.getIntField(obj, "count");
Jx.setIntField(obj, "count", 100);

// boolean
var flag = Jx.getBooleanField(obj, "isVip");
Jx.setBooleanField(obj, "isVip", true);

// long
var ts = Jx.getLongField(obj, "timestamp");
Jx.setLongField(obj, "timestamp", 1234567890);

// float
var rate = Jx.getFloatField(obj, "rate");
Jx.setFloatField(obj, "rate", 0.5);

// double
var price = Jx.getDoubleField(obj, "price");
Jx.setDoubleField(obj, "price", 99.99);

// short / byte / char
var s = Jx.getShortField(obj, "shortVal");
Jx.setShortField(obj, "shortVal", 10);
var b = Jx.getByteField(obj, "byteVal");
Jx.setByteField(obj, "byteVal", 0x7F);
var c = Jx.getCharField(obj, "charVal");
Jx.setCharField(obj, "charVal", "A");
```

### 静态字段

```js
// Object 类型
var value = Jx.getStaticObjectField("com.example.app.Config", "API_URL");
Jx.setStaticObjectField("com.example.app.Config", "API_URL", "https://new.api.com");

// 基本类型（int/boolean/long/float/double/short/byte/char 均支持）
var maxRetry = Jx.getStaticIntField("com.example.app.Config", "MAX_RETRY");
Jx.setStaticIntField("com.example.app.Config", "MAX_RETRY", 5);

var debug = Jx.getStaticBooleanField("com.example.app.Config", "DEBUG");
Jx.setStaticBooleanField("com.example.app.Config", "DEBUG", true);

var timeout = Jx.getStaticLongField("com.example.app.Config", "TIMEOUT");
Jx.setStaticLongField("com.example.app.Config", "TIMEOUT", 30000);

// float/double/short/byte/char 同理：
// Jx.getStaticFloatField / setStaticFloatField
// Jx.getStaticDoubleField / setStaticDoubleField
// Jx.getStaticShortField / setStaticShortField
// Jx.getStaticByteField / setStaticByteField
// Jx.getStaticCharField / setStaticCharField
```

### 附加字段（Additional Instance Field）

给任意 Java 对象附加自定义数据，不修改原类结构。对应 Xposed 的 `setAdditionalInstanceField`。

```js
// 给对象附加数据
Jx.setExtra(obj, "myTag", "hello");

// 读取附加数据
var tag = Jx.getExtra(obj, "myTag");

// 移除附加数据
Jx.removeExtra(obj, "myTag");
```

---

## 5. Hook

### `Jx.hookMethod(className, methodName, paramTypes, callbacks)`
Hook 指定类的指定方法。返回 hookId（整数），可用于后续 unhook。

- **参数**:
  - `className` - 类的全限定名
  - `methodName` - 方法名
  - `paramTypes` - 方法参数类型数组
  - `callbacks` - 回调对象，包含 `before` 和/或 `after` 函数
- **返回**: `hookId`（整数），失败返回 `-1`

```js
var id = Jx.hookMethod(
    "com.example.app.UserManager",
    "login",
    ["java.lang.String", "java.lang.String"],
    {
        before: function(param) {
            Jx.log("登录前: 用户名 = " + param.getArg(0));
        },
        after: function(param) {
            Jx.log("登录后: 返回值 = " + param.getResult());
        }
    }
);
```

### `Jx.hookConstructor(className, paramTypes, callbacks)`
Hook 指定类的构造函数。返回 hookId。

```js
var id = Jx.hookConstructor(
    "com.example.app.User",
    ["java.lang.String", "int"],
    {
        after: function(param) {
            Jx.log("创建了新用户: " + param.thisObject.toString());
        }
    }
);
```

### `Jx.unhook(hookId)`
移除已安装的 Hook。

```js
var id = Jx.hookMethod("com.example.app.Test", "foo", [], {
    before: function(param) { Jx.log("hooked"); }
});
// 之后移除
Jx.unhook(id);
```

### `Jx.hookAllMethods(className, methodName, callbacks)`
Hook 某方法的所有重载版本（无需指定参数类型）。返回 hookId 数组。

```js
var ids = Jx.hookAllMethods("com.example.app.Net", "request", {
    before: function(param) {
        Jx.log("request 被调用，参数数量: " + param.argsLength);
    }
});
```

### `Jx.hookAllConstructors(className, callbacks)`
Hook 某类的所有构造函数。返回 hookId 数组。

```js
var ids = Jx.hookAllConstructors("com.example.app.User", {
    after: function(param) {
        Jx.log("User 构造完成");
    }
});
```

### `Jx.invokeOriginal(method, thisObj, args)`
调用被 Hook 方法的原始实现。`method` 来自 `param.method`。

```js
Jx.hookMethod("com.example.app.Foo", "bar", [], {
    before: function(param) {
        // 调用原始方法
        var original = Jx.invokeOriginal(param.method, param.thisObject, []);
        Jx.log("原始返回: " + original);
    }
});
```

### Hook 回调中的 param 对象

每次 Hook 触发时，`before` 和 `after` 回调都会收到一个 `param` 对象：

| 属性/方法 | 说明 |
|---|---|
| `param.thisObject` | 被 Hook 方法的调用者（Java `this`），wrapped 对象 |
| `param.method` | 被 Hook 的 Method/Constructor 对象（wrapped） |
| `param.raw` | 原始 Xposed `MethodHookParam` 对象 |
| `param.argsLength` | 方法参数个数 |
| `param.getArg(index)` | 获取第 index 个参数（从 0 开始） |
| `param.setArg(index, value)` | 修改第 index 个参数 |
| `param.getResult()` | 获取方法返回值（通常在 `after` 中使用） |
| `param.setResult(value)` | 修改返回值。在 `before` 中调用可拦截原方法 |
| `param.hasThrowable()` | 方法是否抛出了异常 |
| `param.getThrowable()` | 获取抛出的异常对象 |
| `param.setThrowable(message)` | 设置异常，阻止原方法执行 |

```js
// 示例: 拦截方法，直接返回 true，原方法不会执行
Jx.hookMethod("com.example.app.Security", "checkRoot", [], {
    before: function(param) {
        param.setResult(false); // 在 before 中 setResult = 拦截原方法
    }
});

// 示例: 修改方法的返回值
Jx.hookMethod("com.example.app.Config", "getApiUrl", [], {
    after: function(param) {
        param.setResult("https://my-proxy.com/api");
    }
});

// 示例: 修改方法参数
Jx.hookMethod("com.example.app.Net", "request", ["java.lang.String"], {
    before: function(param) {
        Jx.log("原始 URL: " + param.getArg(0));
        param.setArg(0, "https://new-url.com");
    }
});
```

---

## 6. Java 对象说明

所有从 Bridge 返回的复杂 Java 对象都是 **wrapped 对象**，它们是 JS 对象但内部持有 Java 对象的引用。

每个 wrapped 对象都有：
- `__java_obj_id` - 内部 ID（不要手动修改）
- `__java_class_name` - 原始 Java 类名（可用于调试）
- `.toString()` - 调用 Java 对象的 toString
- `.release()` - 手动释放引用（防止内存泄露，长时间运行的脚本建议使用）

基本类型（String、Number、Boolean）会直接作为 JS 原生值返回，不会被 wrap。

```js
var obj = Jx.getObjectField(activity, "mTitle");
Jx.log(obj.__java_class_name); // "java.lang.String"
Jx.log(obj.toString());         // 实际的标题文字

// 长时间持有的对象，用完后释放
obj.release();
```

---

## 7. 类内省

### `Jx.getMethods(className)`
获取类的所有声明方法名列表。

```js
var methods = Jx.getMethods("com.example.app.UserManager");
for (var i = 0; i < methods.length; i++) {
    Jx.log("方法: " + methods[i]);
}
```

### `Jx.getFields(className)`
获取类的所有声明字段名列表。

```js
var fields = Jx.getFields("com.example.app.User");
```

### `Jx.getConstructors(className)`
获取类的所有构造函数签名列表。

```js
var ctors = Jx.getConstructors("com.example.app.User");
// 每项是参数类型的逗号分隔字符串，如 "java.lang.String,int"
```

### `Jx.getSuperclass(className)`
获取父类名。

```js
var parent = Jx.getSuperclass("com.example.app.VipUser");
Jx.log("父类: " + parent); // "com.example.app.User"
```

### `Jx.getInterfaces(className)`
获取实现的接口列表。

```js
var ifaces = Jx.getInterfaces("com.example.app.UserManager");
```

### `Jx.instanceOf(obj, className)`
类型检查。

```js
if (Jx.instanceOf(someObj, "android.app.Activity")) {
    Jx.log("是 Activity");
}
```

---

## 8. 参数类型速查表

在 `paramTypes` 数组中使用的类型字符串：

| 类型字符串 | Java 类型 |
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
| 其他全限定类名 | 对应的类 |

---

# 二、语法糖 API

基于底层 API 封装的便捷写法，让代码更简洁。

---

## 1. `Jx.use(className)` — 类代理

对一个类的所有操作都可以链式调用，不用每次写全限定类名。

当前支持链式返回的 Hook 注册方法有：

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

你可以连续在同一个类代理上注册多个 Hook：

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

如果你还需要获取本次注册产生的 `hookId` / `hookId[]`，可使用：

- `cls.getLastHookResult()`：获取最近一次 Hook 注册结果
- `cls.getHookResults()`：获取当前类代理记录过的所有 Hook 注册结果
- `cls.clearHookResults()`：清空记录并返回当前类代理，便于继续链式调用

### 静态方法调用

```js
var cls = Jx.use("com.example.app.Utils");

// 自动推断类型（无需传 paramTypes）
cls.call("staticMethod", arg1, arg2);

// 显式指定类型
cls.callTyped("staticMethod", ["int", "java.lang.String"], [1, "test"]);
```

### 静态字段读写

```js
var cls = Jx.use("com.example.app.Config");

// Object 类型
var url = cls.getField("API_URL");
cls.setField("API_URL", "https://new.com");

// 基本类型
var count = cls.getStaticInt("MAX_RETRY");
cls.setStaticInt("MAX_RETRY", 5);
var debug = cls.getStaticBool("DEBUG");
cls.setStaticBool("DEBUG", true);
var timeout = cls.getStaticLong("TIMEOUT");
cls.setStaticLong("TIMEOUT", 30000);
// 同理: getStaticFloat/setStaticFloat, getStaticDouble/setStaticDouble
```

### 创建实例

```js
var cls = Jx.use("com.example.app.User");

// 自动推断
var user = cls.newInstance("张三", 18);

// 显式指定类型
var user = cls.newInstanceTyped(["java.lang.String", "int"], ["张三", 18]);
```

### Hook 方法

```js
var cls = Jx.use("com.example.app.UserManager");

// 完整形式
cls.hook("login", ["java.lang.String", "java.lang.String"], {
    before: function(param) { },
    after: function(param) { }
});

// 只关心 before
cls.before("login", ["java.lang.String", "java.lang.String"], function(param) {
    Jx.log("准备登录: " + param.getArg(0));
});

// 只关心 after
cls.after("login", ["java.lang.String", "java.lang.String"], function(param) {
    Jx.log("登录结果: " + param.getResult());
});

// 替换方法逻辑（fn 的返回值会作为方法返回值，原方法不执行）
cls.replace("isVip", [], function(param) {
    return true; // 所有人都是 VIP
});

// 直接固定返回值（一行搞定）
cls.returnConst("isVip", [], true);
cls.returnConst("checkRoot", [], false);
cls.returnConst("getDebugMode", [], false);
```

### Hook 构造函数

```js
var cls = Jx.use("com.example.app.User");

cls.hookConstructor(["java.lang.String", "int"], {
    before: function(param) { },
    after: function(param) { }
});

// 简写
cls.beforeConstructor(["java.lang.String", "int"], function(param) {
    Jx.log("即将创建 User");
});

cls.afterConstructor(["java.lang.String", "int"], function(param) {
    Jx.log("User 创建完成: " + param.thisObject.toString());
});
```

### Hook 所有重载 / 所有构造函数

```js
var cls = Jx.use("com.example.app.Net");

// Hook 所有名为 request 的方法（无需指定参数类型）
cls.hookAllMethods("request", {
    before: function(param) { Jx.log("request called"); }
});

// Hook 所有构造函数
cls.hookAllConstructors({
    after: function(param) { Jx.log("constructed"); }
});
```

`Jx.use()` 的 Hook 注册方法现在返回类代理本身，用于链式调用；如需取消 Hook，请先通过 `getLastHookResult()` 或 `getHookResults()` 取出 `hookId` / `hookId[]`，再调用 `Jx.unhook(id)`。

---

## 2. `Jx.wrap(obj)` — 实例代理

对一个已有的 Java 对象进行便捷操作。

```js
var w = Jx.wrap(someJavaObject);

// 调用方法
w.call("getName");
w.call("setAge", 25);
w.callTyped("setAge", ["int"], [25]);

// 字段读写
var name = w.getField("mName");
w.setField("mName", "新名字");

// 基本类型字段
var count = w.getInt("mCount");
w.setInt("mCount", 100);

var flag = w.getBool("mEnabled");
w.setBool("mEnabled", true);

var ts = w.getLong("mTimestamp");
w.setLong("mTimestamp", 1234567890);

var rate = w.getFloat("mRate");
w.setFloat("mRate", 0.5);

var price = w.getDouble("mPrice");
w.setDouble("mPrice", 99.99);

// 同理: getShort/setShort, getByte/setByte, getChar/setChar

// 获取类名
Jx.log(w.getClassName()); // "class com.example.app.User"
```

### 在 Hook 中结合使用

```js
Jx.use("com.example.app.Activity").after("onCreate", ["android.os.Bundle"], function(param) {
    var activity = Jx.wrap(param.thisObject);
    var title = activity.call("getTitle");
    Jx.log("Activity 标题: " + title);
    activity.call("setTitle", "被 Hook 了!");
});
```

---

## 3. `Jx.ext` — 扩展工具集

内置的常用 Android 工具函数，同时也是用户自定义工具的注册点。

### 内置工具

#### `Jx.ext.toast(context, text, duration?)`
弹出 Toast。

```js
// 短 Toast（默认）
Jx.ext.toast(activity, "Hello!");

// 长 Toast
Jx.ext.toast(activity, "长时间显示", 1);
```

#### `Jx.ext.getApplication()`
获取当前应用的 Application 对象。

```js
var app = Jx.ext.getApplication();
Jx.log("包名: " + Jx.ext.getPackageName(app));
```

#### `Jx.ext.getPackageName(context)`
获取包名。

```js
var pkg = Jx.ext.getPackageName(activity);
```

#### `Jx.ext.getSharedPrefs(context, name, mode?)`
获取 SharedPreferences 对象。

```js
var sp = Jx.ext.getSharedPrefs(context, "app_config");
```

#### `Jx.ext.getPrefString(prefs, key, defaultValue?)`
#### `Jx.ext.getPrefInt(prefs, key, defaultValue?)`
#### `Jx.ext.getPrefBool(prefs, key, defaultValue?)`
读取 SharedPreferences 中的值。

```js
var sp = Jx.ext.getSharedPrefs(context, "app_config");
var token = Jx.ext.getPrefString(sp, "token", "");
var level = Jx.ext.getPrefInt(sp, "level", 0);
var isVip = Jx.ext.getPrefBool(sp, "is_vip", false);
```

#### `Jx.ext.getSystemProp(key)`
读取系统属性。

```js
var buildType = Jx.ext.getSystemProp("ro.build.type");
```

#### `Jx.ext.getBuild(fieldName)`
读取 `android.os.Build` 的字段。

```js
var model = Jx.ext.getBuild("MODEL");
var brand = Jx.ext.getBuild("BRAND");
var sdk = Jx.ext.getBuild("VERSION.SDK_INT");
```

#### `Jx.ext.startActivity(context, className)`
启动一个 Activity。

```js
Jx.ext.startActivity(activity, "com.example.app.SettingsActivity");
```

#### `Jx.ext.stackTrace(tag?)`
打印当前调用栈到 Xposed 日志，用于追踪方法调用来源。

```js
Jx.use("com.example.app.Net").before("request", ["java.lang.String"], function(param) {
    Jx.log("请求 URL: " + param.getArg(0));
    Jx.ext.stackTrace("Net.request"); // 打印谁调用了这个方法
});
```

### 自定义扩展

你可以在脚本中往 `Jx.ext` 注册自己的工具函数：

```js
// 注册自定义工具
Jx.ext.getVersionName = function(context) {
    var pm = Jx.callMethod(context, "getPackageManager", [], []);
    var pkg = Jx.ext.getPackageName(context);
    var info = Jx.callMethod(pm, "getPackageInfo",
        ["java.lang.String", "int"], [pkg, 0]
    );
    return Jx.getObjectField(info, "versionName");
};

// 使用
Jx.use("android.app.Activity").after("onCreate", ["android.os.Bundle"], function(param) {
    var version = Jx.ext.getVersionName(param.thisObject);
    Jx.log("应用版本: " + version);
});
```

---

# 三、完整示例

## 示例 1：Hook Activity 弹 Toast

```js
Jx.use("android.app.Activity").after("onCreate", ["android.os.Bundle"], function(param) {
    Jx.ext.toast(param.thisObject, "JsXposed Hook 成功!");
});
```

## 示例 2：绕过 Root 检测

```js
Jx.use("com.example.app.Security").returnConst("isRooted", [], false);
Jx.use("com.example.app.Security").returnConst("checkSu", [], false);
Jx.use("com.example.app.Security").returnConst("detectMagisk", [], false);
```

## 示例 3：修改 VIP 状态

```js
Jx.use("com.example.app.UserManager").replace("isVip", [], function(param) {
    return true;
});

// 或者更简单
Jx.use("com.example.app.UserManager").returnConst("isVip", [], true);
```

## 示例 4：拦截网络请求并打印参数

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

## 示例 5：Hook 构造函数，修改初始值

```js
Jx.use("com.example.app.AppConfig").afterConstructor([], function(param) {
    var config = Jx.wrap(param.thisObject);
    config.setBool("adEnabled", false);
    config.setField("apiUrl", "https://my-server.com/api");
    Jx.log("AppConfig 已被修改");
});
```

## 示例 6：读取应用的 SharedPreferences

```js
Jx.use("android.app.Activity").after("onCreate", ["android.os.Bundle"], function(param) {
    var activity = param.thisObject;
    var sp = Jx.ext.getSharedPrefs(activity, "user_data");
    var token = Jx.ext.getPrefString(sp, "access_token", "无");
    Jx.log("Token: " + token);
});
```

## 示例 7：修改方法参数

```js
Jx.use("com.example.app.Api").before("request",
    ["java.lang.String", "java.lang.String"],
    function(param) {
        // 把第一个参数（URL）替换掉
        param.setArg(0, "https://my-proxy.com/api");
        Jx.log("URL 已被替换");
    }
);
```

## 示例 8：综合实战 — 去广告 + 解锁 + 日志追踪

```js
var app = Jx.use("com.example.app");

// 1. 去广告
Jx.use("com.example.app.AdManager").returnConst("shouldShowAd", [], false);
Jx.use("com.example.app.AdManager").returnConst("loadAd", [], null);

// 2. 解锁会员
Jx.use("com.example.app.UserManager").returnConst("isPremium", [], true);
Jx.use("com.example.app.UserManager").returnConst("getVipLevel", [], 10);

// 3. 追踪关键方法调用
Jx.use("com.example.app.PayManager").before("pay",
    ["java.lang.String", "int"],
    function(param) {
        Jx.log("===== 支付请求 =====");
        Jx.log("商品ID: " + param.getArg(0));
        Jx.log("金额: " + param.getArg(1));
        Jx.ext.stackTrace("PayManager.pay");
    }
);
```
