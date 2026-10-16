# Jx / Fx Hook API 速查

> **硬性规则（速记）**
> 1. 只用本文件列出的 API，禁止原生 `XposedHelpers` / `XposedBridge` / `Java.use(` / `Java.perform(`。
> 2. Xposed 回调只有 `param`：`function(param)`；Frida 是 `function(args, thisObj)`。**两者不通用**。
> 3. 参数类型数组必传，无参写 `[]`。
> 4. 每个回调都包 try-catch；出错用 `Jx.logException(e)` 或 `console.log(e)`。
> 5. Frida 的 `after` 只有返回 **truthy** 才会替换返回值；要返回 `false` 用 `returnConst` 或 `replace`。
> 6. Frida 脚本不要手写 `Java.perform`，加载器已自动包裹。
> 7. `[tradition]` 是文件名前缀，由保存时自动添加，**不要写进代码**。

# Xposed Hook API (Jx)

## 基础 API
Jx.log(msg) / Jx.logException(msg) — 日志输出
Jx.findClass(className) → bool — 检查类是否存在
Jx.loadClass(className) → wrappedClass — 加载类对象
Jx.newInstance(className, paramTypes[], paramValues[]) → obj — 创建实例
Jx.callMethod(obj, method, paramTypes[], paramValues[]) → result — 调用实例方法
Jx.callStaticMethod(className, method, paramTypes[], paramValues[]) → result — 调用静态方法

## 字段读写
实例: Jx.get/setObjectField(obj, name) | Jx.get/setIntField | BooleanField | LongField | FloatField | DoubleField
静态: Jx.get/setStaticObjectField(className, name) | 同上所有基本类型
附加: Jx.setExtra(obj, key, val) / Jx.getExtra(obj, key) / Jx.removeExtra(obj, key)

## Hook
Jx.hookMethod(className, method, paramTypes[], {before(param), after(param)}) → hookId
Jx.hookConstructor(className, paramTypes[], {before, after}) → hookId
Jx.hookAllMethods(className, method, {before, after}) → hookId[]
Jx.hookAllConstructors(className, {before, after}) → hookId[]
Jx.unhook(hookId) — 移除 Hook
Jx.invokeOriginal(param.method, param.thisObject, args[]) — 调用原始方法

param 对象: thisObject | method | argsLength | getArg(i) | setArg(i, val) | getResult() | setResult(val) | hasThrowable() | getThrowable() | setThrowable(msg)

## 语法糖 Jx.use(className)
var cls = Jx.use("com.example.Foo");
cls.call(method, ...args) / cls.callTyped(method, types[], values[])
cls.getField(name) / cls.setField(name, val) / cls.getStaticInt(name) / cls.setStaticBool(name, val)
cls.newInstance(...args) / cls.newInstanceTyped(types[], values[])
cls.hook(method, types[], {before(param), after(param)})
cls.before(method, types[], fn(param)) / cls.after(method, types[], fn(param))
cls.replace(method, types[], fn(param)) → return 新返回值
cls.returnConst(method, types[], value) — 一行固定返回值
cls.hookConstructor(types[], {before, after}) / cls.beforeConstructor / cls.afterConstructor
cls.hookAllMethods(method, {before, after}) / cls.hookAllConstructors({before, after})
以上 Hook 注册方法支持链式调用
cls.getLastHookResult() / cls.getHookResults() / cls.clearHookResults()

示例:
```js
Jx.use("com.example.app.Security").returnConst("isRooted", [], false);
Jx.use("com.example.app.UserManager").before("login", ["java.lang.String", "java.lang.String"], function(param) {
    Jx.log("用户: " + param.getArg(0));
});
```

## Jx.wrap(obj) — 实例代理
var w = Jx.wrap(javaObj);
w.call(method, ...args) / w.getField(name) / w.setField(name, val)
w.getInt(name) / w.setBool(name, val) / w.getLong / w.getFloat / w.getDouble
w.getClassName()

## Jx.ext — 扩展工具
Jx.ext.toast(ctx, text, duration?) / Jx.ext.getApplication() / Jx.ext.getPackageName(ctx)
Jx.ext.getSharedPrefs(ctx, name) → sp / Jx.ext.getPrefString(sp, key, def) / getPrefInt / getPrefBool
Jx.ext.getSystemProp(key) / Jx.ext.getBuild(field) / Jx.ext.startActivity(ctx, className)
Jx.ext.stackTrace(tag?) — 打印调用栈

## 类内省
Jx.getMethods(className) → string[] / Jx.getFields(className) → string[]
Jx.getConstructors(className) → string[] / Jx.getSuperclass(className) → string
Jx.getInterfaces(className) → string[] / Jx.instanceOf(obj, className) → bool

---

# Frida Hook API (Fx)

## Frida 原生 API
Java.perform(fn) — 进入 Java VM 上下文（脚本中**无需手写**，加载器已自动包裹）
Java.use(className) → wrapper / Java.choose(className, {onMatch, onComplete}) — 枚举堆实例
Java.cast(obj, klass) / Java.enumerateLoadedClasses({onMatch, onComplete})
Java.enumerateClassLoaders({onMatch, onComplete}) / Java.scheduleOnMainThread(fn)
Interceptor.attach(addr, {onEnter(args), onLeave(retval)}) / Interceptor.replace(addr, NativeCallback)
Module.findExportByName(module, name) / Module.findBaseAddress(module)
Module.enumerateExports(module) / Module.enumerateImports(module) / Module.load(path)
Memory.alloc(size) / Memory.allocUtf8String(str) / Memory.readUtf8String(addr) / Memory.writeUtf8String(addr, str)
Memory.readByteArray(addr, len) / Memory.writeByteArray(addr, bytes) / Memory.scan(addr, size, pattern, {onMatch, onComplete})
Process.enumerateModules() / Process.enumerateThreads() / Process.getCurrentThreadId() / Process.arch / Process.platform

## 语法糖 Fx.use(className)
var cls = Fx.use("com.example.Foo");
cls.call(method, ...args) / cls.getField(name) / cls.setField(name, val) / cls.newInstance(...args)
cls.hook(method, types[], {before(args, thisObj), after(ret, args, thisObj)})
cls.before(method, types[], fn(args, thisObj)) / cls.after(method, types[], fn(ret, args, thisObj))
cls.replace(method, types[], fn(args, thisObj)) → return 新返回值
cls.returnConst(method, types[], value)
cls.hookConstructor(types[], {before, after}) / cls.hookAll(method, {before, after})

注意: Fx 的 hook 回调参数是 (args, thisObj)，不是 param 对象。与 Jx 不同。

示例:
```js
Fx.use("com.example.app.Security").returnConst("isRooted", [], false);
Fx.use("com.example.app.UserManager").before("login", ["java.lang.String", "java.lang.String"],
    function(args, thisObj) { console.log("用户: " + args[0]); }
);
```

## Fx.wrap(obj) — 实例代理
var w = Fx.wrap(javaObj);
w.call(method, ...args) / w.getField(name) / w.setField(name, val) / w.getClassName() / w.cast(className)

## Fx.ext — 扩展工具
Fx.ext.toJava(jsValue) → Java 包装类型（Boolean/Integer/String）
Fx.ext.toast(text, duration?) / Fx.ext.getApplication() / Fx.ext.getPackageName()
Fx.ext.getSharedPrefs(name) → sp / Fx.ext.getPrefString(sp, key, def) / getPrefInt / getPrefBool
Fx.ext.getSystemProp(key) / Fx.ext.getBuild(field) / Fx.ext.startActivity(className)
Fx.ext.stackTrace(tag?)

## Fx.hookNative(moduleName, exportName, {onEnter(args), onLeave(retval)})
## Fx.java.choose / cast / enumerateLoadedClasses / enumerateClassLoaders / scheduleOnMainThread
## Fx.module.findExport / findBase / enumerateExports / enumerateImports / load
## Fx.interceptor.attach / replace
## Fx.memory.alloc / allocUtf8 / readUtf8 / writeUtf8 / readBytes / writeBytes / scan

---

# Jx 与 Fx 关键差异
| | Jx (Xposed) | Fx (Frida) |
|---|---|---|
| Hook 回调 | param 对象: param.getArg(0), param.setResult(val) | 直接参数: function(args, thisObj), return 修改返回值 |
| 字段读写 | 按类型: Jx.getIntField(obj, name) | 统一: Fx.wrap(obj).getField(name) |
| 日志 | Jx.log() → Xposed 日志 | console.log() → Logcat |
| 运行时机 | 应用启动时自动加载 | 需要 attach 到进程 |
| Native Hook | 不支持 | Fx.hookNative() / Interceptor.attach() |
| 内存操作 | 不支持 | Fx.memory.* / Memory.* |
