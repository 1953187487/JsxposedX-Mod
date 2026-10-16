# Frida API 文档

Frida 是一个强大的动态插桩工具，JsXposed_X 集成了 Frida 并提供了 `Fx` 语法糖，让你用更简洁的方式编写 Frida Hook 脚本。

---

# 零、脚本编写规范（生成脚本前必读）

以下为硬性要求。违反任意一条，脚本都无法正常运行或被校验拒绝。

## 0.1 只用本文档列出的 `Fx.*` API

禁止出现原生 Frida API（校验会直接拒绝）：

| 禁止写法 | 正确写法 |
|---|---|
| `Java.perform(function(){...})` | 不写。引擎加载脚本时已自动包在 `Java.perform` 内 |
| `Java.use("com.a.B")` | `Fx.use("com.a.B")` |
| `Java.use(cls).m.overload(...).implementation = fn` | `Fx.use(cls).hook("m", [...], {...})` |
| `Java.cast(obj, Java.use(cls))` | `Fx.wrap(obj).cast(cls)` |

本文档中查不到的 API 一律视为不存在。

## 0.2 脚本顶层直接写语句

**不要**自己包 `Java.perform`，也不要等待延迟执行。加载器已把脚本整体置于 Java 上下文中：

```javascript
// 正确：顶层直接写
Fx.use("com.example.Target").hook("checkVip", [], {
  after: function(retval, args, thisObj) {
    try {
      return true;
    } catch (e) {
      console.log("[Fx] 异常: " + e);
    }
  }
});
```

## 0.3 Hook 回调签名是 `(args, thisObj)`，不是 `param`

`Fx` 与 `Jx` 不同：**没有** `param` 对象，参数按形参传入：

| 回调 | 签名 | 说明 |
|---|---|---|
| `before` | `function(args, thisObj)` | `args` 是参数数组，可用 `args[0] = x` 改参 |
| `after` | `function(retval, args, thisObj)` | `retval` 是原返回值 |
| `replace` | `function(args, thisObj)` | `return` 值即方法返回值，原方法不再执行 |

```javascript
Fx.use("com.example.Target").hook("checkVip", [], {
  before: function(args, thisObj) { console.log("[Fx] 调用，参数: " + args[0]); },
  after:  function(retval, args, thisObj) { console.log("[Fx] 返回: " + retval); }
});
```

## 0.4 `after` 返回假值不会生效

`after` 的返回值只有在**真值**（truthy）时才会替换原返回值：

```javascript
// 想改成 true —— 可以
after: function(retval, args, thisObj) { return true; }

// 想改成 false —— 这样写无效！false 是假值，会保留原返回值
after: function(retval, args, thisObj) { return false; }   // 错误

// 正确做法一：用 returnConst
Fx.use(cls).returnConst("isVip", [], false);

// 正确做法二：用 replace
Fx.use(cls).replace("isVip", [], function(args, thisObj) { return false; });
```

## 0.5 参数类型数组必传

第二个参数是 Java 参数类型数组，无参方法传 `[]`：

```javascript
Fx.use(cls).hook("isVip", [], { ... });                             // 无参
Fx.use(cls).hook("setFlag", ["int", "java.lang.String"], { ... });  // (int, String)
```

只传 `[]` 时匹配该方法的第一个重载；方法有多个重载且需精确匹配时，必须写全类型。

## 0.6 每个回调都要 try-catch

```javascript
after: function(retval, args, thisObj) {
  try {
    console.log("[Fx] 原返回值: " + retval);
  } catch (e) {
    console.log("[Fx] 异常: " + e);
  }
}
```

## 0.7 日志统一用 `console.log` / `Fx.log`

日志 tag 为 `JsxposedX-Frida`，在脚本日志面板中可见。

## 0.8 最小可用骨架

```javascript
// 目标：让 com.example.Target#checkVip() 恒返回 true
Fx.use("com.example.Target").hook("checkVip", [], {
  before: function(args, thisObj) {
    console.log("[Fx] checkVip 被调用");
  },
  after: function(retval, args, thisObj) {
    try {
      console.log("[Fx] 原返回值: " + retval);
      return true;
    } catch (e) {
      console.log("[Fx] 异常: " + e);
    }
  }
});
```

一行固定返回值可用简写：

```javascript
Fx.use("com.example.Target").returnConst("checkVip", [], true);
```

---

# 一、Frida 原生 API

这些是 Frida 的核心 API，功能强大且灵活。

---

## 1. Java API

### `Java.perform(fn)`
在 Java 虚拟机上下文中执行代码。所有 Java 相关操作都必须在此回调中进行。

```js
Java.perform(function() {
    console.log("Java VM 已就绪");
    var Activity = Java.use("android.app.Activity");
});
```

### `Java.use(className)`
获取指定类的包装器，用于调用静态方法、Hook 方法等。

```js
Java.perform(function() {
    var Toast = Java.use("android.widget.Toast");
    var String = Java.use("java.lang.String");
});
```

### `Java.choose(className, callbacks)`
枚举堆中所有指定类的实例。

```js
Java.perform(function() {
    Java.choose("com.example.app.User", {
        onMatch: function(instance) {
            console.log("找到实例: " + instance.toString());
        },
        onComplete: function() {
            console.log("枚举完成");
        }
    });
});
```

### `Java.cast(obj, klass)`
将对象转换为指定类型。

```js
Java.perform(function() {
    var obj = getSomeObject();
    var Activity = Java.use("android.app.Activity");
    var activity = Java.cast(obj, Activity);
});
```

### `Java.enumerateLoadedClasses(callbacks)`
枚举所有已加载的类。

```js
Java.perform(function() {
    Java.enumerateLoadedClasses({
        onMatch: function(className) {
            if (className.indexOf("com.example") !== -1) {
                console.log("找到类: " + className);
            }
        },
        onComplete: function() {}
    });
});
```

### `Java.enumerateClassLoaders(callbacks)`
枚举所有类加载器。

```js
Java.perform(function() {
    Java.enumerateClassLoaders({
        onMatch: function(loader) {
            console.log("类加载器: " + loader);
        },
        onComplete: function() {}
    });
});
```

### `Java.scheduleOnMainThread(fn)`
在主线程执行代码。

```js
Java.perform(function() {
    Java.scheduleOnMainThread(function() {
        console.log("运行在主线程");
    });
});
```

---

## 2. Interceptor API

### `Interceptor.attach(target, callbacks)`
附加拦截器到指定地址。

```js
var addr = Module.findExportByName("libc.so", "open");
Interceptor.attach(addr, {
    onEnter: function(args) {
        console.log("open() 被调用");
        console.log("路径: " + Memory.readUtf8String(args[0]));
    },
    onLeave: function(retval) {
        console.log("返回值: " + retval);
    }
});
```

### `Interceptor.replace(target, replacement)`
替换函数实现。

```js
var addr = Module.findExportByName("libc.so", "strlen");
Interceptor.replace(addr, new NativeCallback(function(str) {
    console.log("strlen 被调用");
    return 0;
}, 'int', ['pointer']));
```

---

## 3. Module API

### `Module.findExportByName(moduleName, exportName)`
查找模块的导出函数地址。

```js
var openAddr = Module.findExportByName("libc.so", "open");
var mallocAddr = Module.findExportByName(null, "malloc"); // null = 所有模块
```

### `Module.findBaseAddress(moduleName)`
获取模块的基地址。

```js
var base = Module.findBaseAddress("libnative.so");
console.log("基地址: " + base);
```

### `Module.enumerateExports(moduleName)`
枚举模块的所有导出函数。

```js
var exports = Module.enumerateExports("libc.so");
exports.forEach(function(exp) {
    console.log(exp.name + " @ " + exp.address);
});
```

### `Module.enumerateImports(moduleName)`
枚举模块的所有导入函数。

```js
var imports = Module.enumerateImports("libnative.so");
imports.forEach(function(imp) {
    console.log(imp.name + " from " + imp.module);
});
```

### `Module.load(path)`
加载指定路径的模块。

```js
var mod = Module.load("/data/local/tmp/test.so");
```

---

## 4. Memory API

### `Memory.alloc(size)`
分配内存。

```js
var buf = Memory.alloc(1024);
```

### `Memory.allocUtf8String(str)`
分配 UTF-8 字符串。

```js
var str = Memory.allocUtf8String("Hello Frida");
```

### `Memory.readUtf8String(address, length?)`
读取 UTF-8 字符串。

```js
var str = Memory.readUtf8String(ptr);
var str2 = Memory.readUtf8String(ptr, 100); // 最多读 100 字节
```

### `Memory.writeUtf8String(address, str)`
写入 UTF-8 字符串。

```js
Memory.writeUtf8String(ptr, "New String");
```

### `Memory.readByteArray(address, length)`
读取字节数组。

```js
var bytes = Memory.readByteArray(ptr, 16);
console.log(hexdump(bytes));
```

### `Memory.writeByteArray(address, bytes)`
写入字节数组。

```js
Memory.writeByteArray(ptr, [0x90, 0x90, 0x90, 0x90]);
```

### `Memory.scan(address, size, pattern, callbacks)`
扫描内存匹配模式。

```js
Memory.scan(base, 0x1000, "48 8b ?? ?? 00 00 00", {
    onMatch: function(address, size) {
        console.log("找到匹配: " + address);
    },
    onComplete: function() {}
});
```

---

## 5. Process API

### `Process.enumerateModules()`
枚举所有已加载的模块。

```js
var modules = Process.enumerateModules();
modules.forEach(function(mod) {
    console.log(mod.name + " @ " + mod.base);
});
```

### `Process.enumerateThreads()`
枚举所有线程。

```js
var threads = Process.enumerateThreads();
threads.forEach(function(thread) {
    console.log("线程 ID: " + thread.id);
});
```

### `Process.getCurrentThreadId()`
获取当前线程 ID。

```js
var tid = Process.getCurrentThreadId();
console.log("当前线程: " + tid);
```

### `Process.arch`
获取架构（arm、arm64、ia32、x64）。

```js
console.log("架构: " + Process.arch);
```

### `Process.platform`
获取平台（linux、darwin、windows）。

```js
console.log("平台: " + Process.platform);
```

---

## 6. console API

### `console.log(message)`
输出日志（tag: `JsxposedX-Frida`）。

```js
console.log("这是一条日志");
console.log("用户名:", username, "年龄:", age);
```

### `console.warn(message)`
输出警告日志。

```js
console.warn("这是一条警告");
```

### `console.error(message)`
输出错误日志。

```js
console.error("这是一条错误");
```

---

# 二、Fx 语法糖 API

`Fx` 是 JsXposed_X 提供的语法糖，简化常用 Frida 操作。所有 API 都挂载在全局对象 `Fx` 上。

---

## 1. `Fx.use(className)` — 类代理

对一个类的所有操作都可以链式调用。

当前支持链式返回的 Hook 相关方法有：

- `hook(...)`
- `before(...)`
- `after(...)`
- `replace(...)`
- `returnConst(...)`
- `hookConstructor(...)`
- `hookAll(...)`

这意味着你可以连续在同一个类代理上挂多个 Hook，例如：

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

注意：`call(...)`、`getField(...)`、`newInstance(...)` 这类方法返回的是调用结果，不用于链式 Hook。

### 调用静态方法

```js
var cls = Fx.use("com.example.app.Utils");
cls.call("staticMethod", arg1, arg2);
```

### 读写静态字段

```js
var cls = Fx.use("com.example.app.Config");
var url = cls.getField("API_URL");
cls.setField("API_URL", "https://new.com");
```

### 创建实例

```js
var cls = Fx.use("com.example.app.User");
var user = cls.newInstance("张三", 18);
```

### Hook 方法

```js
var cls = Fx.use("com.example.app.UserManager");

// 完整形式
cls.hook("login", ["java.lang.String", "java.lang.String"], {
    before: function(args, thisObj) {
        console.log("登录前: " + args[0]);
    },
    after: function(ret, args, thisObj) {
        console.log("登录后: " + ret);
    }
});

// 简写：只关心 before
cls.before("login", ["java.lang.String", "java.lang.String"], function(args, thisObj) {
    console.log("用户名: " + args[0]);
});

// 简写：只关心 after
cls.after("login", ["java.lang.String", "java.lang.String"], function(ret, args, thisObj) {
    console.log("返回值: " + ret);
});

// 替换方法逻辑
cls.replace("isVip", [], function(args, thisObj) {
    return true; // 所有人都是 VIP
});

// 固定返回值
cls.returnConst("isVip", [], true);
cls.returnConst("checkRoot", [], false);
```

### Hook 构造函数

```js
var cls = Fx.use("com.example.app.User");

cls.hookConstructor(["java.lang.String", "int"], {
    before: function(args, thisObj) {
        console.log("即将创建 User");
    },
    after: function(args, thisObj) {
        console.log("User 创建完成");
    }
});
```

### Hook 所有重载

```js
var cls = Fx.use("com.example.app.Net");

// Hook 所有名为 request 的方法
cls.hookAll("request", {
    before: function(args, thisObj) {
        console.log("request 被调用");
    }
});
```

---

## 2. `Fx.wrap(obj)` — 实例代理

对一个已有的 Java 对象进行便捷操作。

```js
var w = Fx.wrap(someJavaObject);

// 调用方法
var name = w.call("getName");
w.call("setAge", 25);

// 读写字段
var count = w.getField("mCount");
w.setField("mCount", 100);

// 获取类名
console.log(w.getClassName());

// 类型转换
var activity = w.cast("android.app.Activity");
```

---

## 3. `Fx.ext` — 扩展工具集

内置的常用 Android 工具函数。

### `Fx.ext.toJava(value)`
将 JavaScript 类型转换为 Java 包装类型。

```js
// 布尔值转换
var javaTrue = Fx.ext.toJava(true);  // 返回 java.lang.Boolean
cls.returnConst("getVip", [], Fx.ext.toJava(true));

// 数字转换
var javaInt = Fx.ext.toJava(123);     // 返回 java.lang.Integer
var javaDouble = Fx.ext.toJava(3.14); // 返回 java.lang.Double

// 字符串转换
var javaStr = Fx.ext.toJava("hello"); // 返回 java.lang.String

// null/undefined 返回 null
var javaNull = Fx.ext.toJava(null);   // 返回 null
```

**使用场景：**
- 当 Hook 方法返回 Java 包装类型（如 `Boolean`、`Integer`）时，需要使用此方法转换
- 避免 `NullPointerException` 等类型转换错误

### `Fx.ext.toast(text, duration?)`
弹出 Toast。

```js
Fx.ext.toast("Hello Frida!");
Fx.ext.toast("长时间显示", 1);
```

### `Fx.ext.getApplication()`
获取 Application 对象。

```js
var app = Fx.ext.getApplication();
```

### `Fx.ext.getPackageName()`
获取包名。

```js
var pkg = Fx.ext.getPackageName();
console.log("包名: " + pkg);
```

### `Fx.ext.getSharedPrefs(name, mode?)`
获取 SharedPreferences。

```js
var sp = Fx.ext.getSharedPrefs("app_config");
```

### `Fx.ext.getPrefString(prefs, key, def?)`
### `Fx.ext.getPrefInt(prefs, key, def?)`
### `Fx.ext.getPrefBool(prefs, key, def?)`
读取 SharedPreferences 值。

```js
var sp = Fx.ext.getSharedPrefs("app_config");
var token = Fx.ext.getPrefString(sp, "token", "");
var level = Fx.ext.getPrefInt(sp, "level", 0);
var isVip = Fx.ext.getPrefBool(sp, "is_vip", false);
```

### `Fx.ext.getSystemProp(key)`
读取系统属性。

```js
var buildType = Fx.ext.getSystemProp("ro.build.type");
```

### `Fx.ext.getBuild(fieldName)`
读取 Build 信息。

```js
var model = Fx.ext.getBuild("MODEL");
var brand = Fx.ext.getBuild("BRAND");
var sdk = Fx.ext.getBuild("VERSION.SDK_INT");
```

### `Fx.ext.startActivity(className)`
启动 Activity。

```js
Fx.ext.startActivity("com.example.app.MainActivity");
```

### `Fx.ext.stackTrace(tag?)`
打印调用栈。

```js
Fx.ext.stackTrace("MyTag");
```

---

## 4. `Fx.hookNative(moduleName, exportName, callbacks)` — Native Hook

快捷 Native Hook 封装。

```js
Fx.hookNative("libc.so", "open", {
    onEnter: function(args) {
        console.log("open: " + Memory.readUtf8String(args[0]));
    },
    onLeave: function(retval) {
        console.log("返回: " + retval);
    }
});
```

---

## 5. `Fx.java.*` — Java API 快捷方法

### `Fx.java.choose(className, callbacks)`
枚举实例。

```js
Fx.java.choose("com.example.app.User", {
    onMatch: function(instance) {
        console.log("找到: " + instance);
    },
    onComplete: function() {}
});
```

### `Fx.java.cast(obj, className)`
类型转换。

```js
var activity = Fx.java.cast(obj, "android.app.Activity");
```

### `Fx.java.enumerateLoadedClasses(callbacks)`
枚举已加载类。

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
枚举类加载器。

```js
Fx.java.enumerateClassLoaders({
    onMatch: function(loader) {
        console.log(loader);
    },
    onComplete: function() {}
});
```

### `Fx.java.scheduleOnMainThread(fn)`
主线程执行。

```js
Fx.java.scheduleOnMainThread(function() {
    console.log("主线程");
});
```

---

## 6. `Fx.module.*` — Module API 快捷方法

### `Fx.module.findExport(moduleName, exportName)`
查找导出函数。

```js
var addr = Fx.module.findExport("libc.so", "open");
```

### `Fx.module.findBase(moduleName)`
查找模块基址。

```js
var base = Fx.module.findBase("libnative.so");
```

### `Fx.module.enumerateExports(moduleName)`
枚举导出。

```js
var exports = Fx.module.enumerateExports("libc.so");
```

### `Fx.module.enumerateImports(moduleName)`
枚举导入。

```js
var imports = Fx.module.enumerateImports("libnative.so");
```

### `Fx.module.load(path)`
加载模块。

```js
Fx.module.load("/data/local/tmp/test.so");
```

---

## 7. `Fx.interceptor.*` — Interceptor API 快捷方法

### `Fx.interceptor.attach(target, callbacks)`
附加拦截器。

```js
var addr = Fx.module.findExport("libc.so", "open");
Fx.interceptor.attach(addr, {
    onEnter: function(args) {
        console.log("open 被调用");
    }
});
```

### `Fx.interceptor.replace(target, replacement)`
替换函数。

```js
var addr = Fx.module.findExport("libc.so", "strlen");
Fx.interceptor.replace(addr, new NativeCallback(function(str) {
    return 0;
}, 'int', ['pointer']));
```

---

## 8. `Fx.memory.*` — Memory API 快捷方法

### `Fx.memory.alloc(size)`
分配内存。

```js
var buf = Fx.memory.alloc(1024);
```

### `Fx.memory.allocUtf8(str)`
分配 UTF-8 字符串。

```js
var str = Fx.memory.allocUtf8("Hello");
```

### `Fx.memory.readUtf8(address, length?)`
读取 UTF-8 字符串。

```js
var str = Fx.memory.readUtf8(ptr);
```

### `Fx.memory.writeUtf8(address, str)`
写入 UTF-8 字符串。

```js
Fx.memory.writeUtf8(ptr, "New String");
```

### `Fx.memory.readBytes(address, length)`
读取字节数组。

```js
var bytes = Fx.memory.readBytes(ptr, 16);
```

### `Fx.memory.writeBytes(address, bytes)`
写入字节数组。

```js
Fx.memory.writeBytes(ptr, [0x90, 0x90]);
```

### `Fx.memory.scan(address, size, pattern, callbacks)`
扫描内存。

```js
Fx.memory.scan(base, 0x1000, "48 8b ?? ??", {
    onMatch: function(address, size) {
        console.log("找到: " + address);
    },
    onComplete: function() {}
});
```

---

## 9. `Fx.process.*` — Process API 快捷方法

### `Fx.process.enumerateModules()`
枚举模块。

```js
var modules = Fx.process.enumerateModules();
modules.forEach(function(mod) {
    console.log(mod.name);
});
```

### `Fx.process.enumerateThreads()`
枚举线程。

```js
var threads = Fx.process.enumerateThreads();
```

### `Fx.process.getCurrentThreadId()`
获取当前线程 ID。

```js
var tid = Fx.process.getCurrentThreadId();
```

---

## 10. `Fx.log(message)` / `Fx.logError(message)` — 日志

统一日志输出（tag: `JsxposedX-Frida`）。

```js
Fx.log("这是一条日志");
Fx.logError("这是一条错误");
```

---

# 三、完整示例

## 示例 1：Hook Activity 弹 Toast

```js
Fx.use("android.app.Activity").after("onCreate", ["android.os.Bundle"], function(ret, args, thisObj) {
    Fx.ext.toast("Frida Hook 成功!");
});
```

## 示例 2：绕过 Root 检测

```js
Fx.use("com.example.app.Security").returnConst("isRooted", [], false);
Fx.use("com.example.app.Security").returnConst("checkSu", [], false);
```

## 示例 3：修改 VIP 状态

```js
Fx.use("com.example.app.UserManager").returnConst("isVip", [], true);
```

## 示例 4：拦截网络请求

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

## 示例 5：枚举所有 Activity 实例

```js
Fx.java.choose("android.app.Activity", {
    onMatch: function(activity) {
        var w = Fx.wrap(activity);
        var title = w.call("getTitle");
        console.log("Activity: " + title);
    },
    onComplete: function() {
        console.log("枚举完成");
    }
});
```

## 示例 6：Native Hook

```js
Fx.hookNative("libc.so", "open", {
    onEnter: function(args) {
        var path = Memory.readUtf8String(args[0]);
        if (path.indexOf("/data") !== -1) {
            console.log("打开文件: " + path);
        }
    }
});
```

## 示例 7：内存扫描

```js
var base = Fx.module.findBase("libnative.so");
Fx.memory.scan(base, 0x10000, "48 8b 05 ?? ?? ?? ??", {
    onMatch: function(address, size) {
        console.log("找到模式: " + address);
    },
    onComplete: function() {
        console.log("扫描完成");
    }
});
```

## 示例 8：综合实战 — 去广告 + 解锁

```js
// 1. 去广告
Fx.use("com.example.app.AdManager").returnConst("shouldShowAd", [], false);

// 2. 解锁会员
Fx.use("com.example.app.UserManager").returnConst("isPremium", [], true);

// 3. 追踪支付
Fx.use("com.example.app.PayManager").before("pay",
    ["java.lang.String", "int"],
    function(args, thisObj) {
        console.log("===== 支付请求 =====");
        console.log("商品ID: " + args[0]);
        console.log("金额: " + args[1]);
        Fx.ext.stackTrace("PayManager.pay");
    }
);
```
