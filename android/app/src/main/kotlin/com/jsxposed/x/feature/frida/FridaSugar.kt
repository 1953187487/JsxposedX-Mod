package com.jsxposed.xmod.feature.frida

/**
 * Frida JS 语法糖，简化常用 Frida API 操作
 * 提供 Fx 全局对象，类似 Xposed 的 Jx 语法糖
 */
object FridaSugar {
    val CODE = """
            var Fx = {};

            // ========== Fx.use(className) 类代理 ==========
            Fx.use = function(className) {
                var cls = Java.use(className);
                return {
                    _cls: cls,

                    // 调用静态方法
                    call: function(methodName) {
                        var args = Array.prototype.slice.call(arguments, 1);
                        var m = this._cls[methodName];
                        return m.call.apply(m, [this._cls].concat(args));
                    },

                    // 获取/设置静态字段
                    getField: function(fieldName) {
                        return this._cls[fieldName].value;
                    },
                    setField: function(fieldName, value) {
                        this._cls[fieldName].value = value;
                    },

                    // 实例化
                    newInstance: function() {
                        var args = Array.prototype.slice.call(arguments);
                        return this._cls.${"$"}new.apply(this._cls, args);
                    },

                    // Hook 方法（完整形式）
                    hook: function(methodName, overloadTypes, callbacks) {
                        var method = overloadTypes
                            ? this._cls[methodName].overload.apply(this._cls[methodName], overloadTypes)
                            : this._cls[methodName].overloads[0];
                        method.implementation = function() {
                            var args = Array.prototype.slice.call(arguments);
                            if (callbacks.before) callbacks.before(args, this);
                            var ret;
                            if (callbacks.replace) {
                                ret = callbacks.replace(args, this);
                            } else {
                                ret = method.call.apply(method, [this].concat(args));
                            }
                            if (callbacks.after) ret = callbacks.after(ret, args, this) || ret;
                            return Fx._convertReturnValue(ret);
                        };
                        return this;
                    },

                    // Hook 简写：before
                    before: function(methodName, overloadTypes, fn) {
                        this.hook(methodName, overloadTypes, { before: fn });
                        return this;
                    },

                    // Hook 简写：after
                    after: function(methodName, overloadTypes, fn) {
                        this.hook(methodName, overloadTypes, { after: fn });
                        return this;
                    },

                    // Hook 简写：替换返回值
                    replace: function(methodName, overloadTypes, fn) {
                        this.hook(methodName, overloadTypes, { replace: fn });
                        return this;
                    },

                    // Hook 简写：固定返回值
                    returnConst: function(methodName, overloadTypes, value) {
                        this.hook(methodName, overloadTypes, {
                            replace: function() { return value; }
                        });
                        return this;
                    },

                    // Hook 构造函数
                    hookConstructor: function(overloadTypes, callbacks) {
                        var ctor = overloadTypes
                            ? this._cls.${"$"}init.overload.apply(this._cls.${"$"}init, overloadTypes)
                            : this._cls.${"$"}init.overloads[0];
                        ctor.implementation = function() {
                            var args = Array.prototype.slice.call(arguments);
                            if (callbacks.before) callbacks.before(args, this);
                            ctor.call.apply(ctor, [this].concat(args));
                            if (callbacks.after) callbacks.after(args, this);
                        };
                        return this;
                    },

                    // Hook 所有重载
                    hookAll: function(methodName, callbacks) {
                        var overloads = this._cls[methodName].overloads;
                        for (var i = 0; i < overloads.length; i++) {
                            (function(m) {
                                m.implementation = function() {
                                    var args = Array.prototype.slice.call(arguments);
                                    if (callbacks.before) callbacks.before(args, this);
                                    var ret;
                                    if (callbacks.replace) {
                                        ret = callbacks.replace(args, this);
                                    } else {
                                        ret = m.call.apply(m, [this].concat(args));
                                    }
                                    if (callbacks.after) ret = callbacks.after(ret, args, this) || ret;
                                    return Fx._convertReturnValue(ret);
                                };
                            })(overloads[i]);
                        }
                        return this;
                    }
                };
            };

            // ========== Fx.wrap(obj) 实例代理 ==========
            Fx.wrap = function(obj) {
                return {
                    _obj: obj,

                    // 调用实例方法
                    call: function(methodName) {
                        var args = Array.prototype.slice.call(arguments, 1);
                        var m = this._obj[methodName];
                        return m.call.apply(m, [this._obj].concat(args));
                    },

                    // 获取/设置实例字段
                    getField: function(fieldName) {
                        return this._obj[fieldName].value;
                    },
                    setField: function(fieldName, value) {
                        this._obj[fieldName].value = value;
                    },

                    // 获取类名
                    getClassName: function() {
                        return this._obj.${"$"}className;
                    },

                    // 类型转换
                    cast: function(className) {
                        return Fx.wrap(Java.cast(this._obj, Java.use(className)));
                    }
                };
            };

            // ========== Fx.ext 工具命名空间 ==========
            Fx.ext = {};

            // 通用类型转换：自动将 JS 类型转换为 Java 包装类型
            Fx.ext.toJava = function(value) {
                if (value === null || value === undefined) {
                    return null;
                }
                if (typeof value === 'boolean') {
                    return Java.use("java.lang.Boolean").valueOf(value);
                }
                if (typeof value === 'number') {
                    if (Number.isInteger(value)) {
                        return Java.use("java.lang.Integer").valueOf(value);
                    } else {
                        return Java.use("java.lang.Double").valueOf(value);
                    }
                }
                if (typeof value === 'string') {
                    return Java.use("java.lang.String").${"$"}new(value);
                }
                return value;
            };

            // Toast
            Fx.ext.toast = function(text, duration) {
                var ctx = Fx.ext.getApplication();
                var Toast = Java.use("android.widget.Toast");
                var t = Toast.makeText(ctx, Java.use("java.lang.String").${"$"}new(String(text)), duration || 0);
                t.show();
            };

            // 获取 Application Context
            Fx.ext.getApplication = function() {
                var ActivityThread = Java.use("android.app.ActivityThread");
                return ActivityThread.currentApplication();
            };

            // 获取包名
            Fx.ext.getPackageName = function() {
                return Fx.ext.getApplication().getPackageName();
            };

            // 获取 SharedPreferences
            Fx.ext.getSharedPrefs = function(name, mode) {
                var ctx = Fx.ext.getApplication();
                return ctx.getSharedPreferences(name, mode || 0);
            };

            // 读取 SP 值
            Fx.ext.getPrefString = function(prefs, key, def) {
                return prefs.getString(key, def || "");
            };
            Fx.ext.getPrefInt = function(prefs, key, def) {
                return prefs.getInt(key, def || 0);
            };
            Fx.ext.getPrefBool = function(prefs, key, def) {
                return prefs.getBoolean(key, def || false);
            };

            // 获取系统属性
            Fx.ext.getSystemProp = function(key) {
                var SP = Java.use("android.os.SystemProperties");
                return SP.get.overload("java.lang.String").call(SP, key);
            };

            // 获取 Build 信息
            Fx.ext.getBuild = function(fieldName) {
                var parts = fieldName.split(".");
                if (parts.length === 1) {
                    return Java.use("android.os.Build")[fieldName].value;
                }
                var cls = "android.os.Build${'$'}" + parts[0];
                return Java.use(cls)[parts[1]].value;
            };

            // 启动 Activity
            Fx.ext.startActivity = function(className) {
                var ctx = Fx.ext.getApplication();
                var Intent = Java.use("android.content.Intent");
                var intent = Intent.${"$"}new(ctx, Java.use(className).class);
                intent.addFlags(0x10000000);
                ctx.startActivity(intent);
            };

            // 打印调用栈
            Fx.ext.stackTrace = function(tag) {
                var Exception = Java.use("java.lang.Exception");
                var Log = Java.use("android.util.Log");
                var trace = Log.getStackTraceString(Exception.${"$"}new());
                Fx.log((tag ? "[" + tag + "] " : "") + trace);
            };

            // ========== Fx.hookNative 快捷 Native Hook ==========
            Fx.hookNative = function(moduleName, exportName, callbacks) {
                var addr = Module.findExportByName(moduleName, exportName);
                if (!addr) {
                    Fx.log("[Fx] export not found: " + moduleName + "!" + exportName);
                    return null;
                }
                return Interceptor.attach(addr, callbacks);
            };

            // ========== Fx.java 快捷 Java API ==========
            Fx.java = {};
            Fx.java.choose = function(className, callbacks) {
                Java.choose(className, callbacks);
            };
            Fx.java.cast = function(obj, className) {
                return Java.cast(obj, Java.use(className));
            };
            Fx.java.enumerateLoadedClasses = function(callbacks) {
                Java.enumerateLoadedClasses(callbacks);
            };
            Fx.java.enumerateClassLoaders = function(callbacks) {
                Java.enumerateClassLoaders(callbacks);
            };
            Fx.java.scheduleOnMainThread = function(fn) {
                Java.scheduleOnMainThread(fn);
            };

            // ========== Fx.module 快捷 Module API ==========
            Fx.module = {};
            Fx.module.findExport = function(moduleName, exportName) {
                return Module.findExportByName(moduleName, exportName);
            };
            Fx.module.findBase = function(moduleName) {
                return Module.findBaseAddress(moduleName);
            };
            Fx.module.enumerateExports = function(moduleName) {
                return Module.enumerateExports(moduleName);
            };
            Fx.module.enumerateImports = function(moduleName) {
                return Module.enumerateImports(moduleName);
            };
            Fx.module.load = function(path) {
                return Module.load(path);
            };

            // ========== Fx.interceptor 快捷 Interceptor API ==========
            Fx.interceptor = {};
            Fx.interceptor.attach = function(target, callbacks) {
                return Interceptor.attach(target, callbacks);
            };
            Fx.interceptor.replace = function(target, replacement) {
                Interceptor.replace(target, replacement);
            };

            // ========== Fx.memory 快捷 Memory API ==========
            Fx.memory = {};
            Fx.memory.readUtf8 = function(address, length) {
                return Memory.readUtf8String(address, length);
            };
            Fx.memory.readBytes = function(address, length) {
                return Memory.readByteArray(address, length);
            };
            Fx.memory.writeUtf8 = function(address, str) {
                Memory.writeUtf8String(address, str);
            };
            Fx.memory.writeBytes = function(address, bytes) {
                Memory.writeByteArray(address, bytes);
            };
            Fx.memory.alloc = function(size) {
                return Memory.alloc(size);
            };
            Fx.memory.allocUtf8 = function(str) {
                return Memory.allocUtf8String(str);
            };
            Fx.memory.scan = function(address, size, pattern, callbacks) {
                Memory.scan(address, size, pattern, callbacks);
            };

            // ========== Fx.process 快捷 Process API ==========
            Fx.process = {};
            Fx.process.enumerateModules = function() {
                return Process.enumerateModules();
            };
            Fx.process.enumerateThreads = function() {
                return Process.enumerateThreads();
            };
            Fx.process.getCurrentThreadId = function() {
                return Process.getCurrentThreadId();
            };

            // ========== 统一日志：结构化输出 ==========
            var _TAG = "JsxposedX-Frida";
            var _AndroidLog = Java.use("android.util.Log");

            function _encode(value) {
                try { return encodeURIComponent(String(value)); }
                catch (_) { return "<unserializable>"; }
            }

            function _formatValue(value) {
                if (value && value.stack) {
                    return String(value.message || value) + "\\n--STACK--\\n" + String(value.stack);
                }
                if (value !== null && typeof value === "object") {
                    try { return JSON.stringify(value); }
                    catch (_) { return String(value); }
                }
                return String(value);
            }

            Fx._logWithScript = function(scriptName, runId, level, args) {
                var values = Array.prototype.slice.call(args || []);
                var msg = values.map(_formatValue).join(" ");
                var marker = "JXCONSOLE|v2|frida|" + _encode(runId || "") + "|" +
                    _encode(scriptName || "<unknown>") + "|" + level + "|" + _encode(msg);
                var priority = level === "E" ? 6 : (level === "W" ? 5 : (level === "D" ? 3 : 4));
                _AndroidLog.println(priority, _TAG, marker);
            };

            Fx.log = function(msg) {
                Fx._logWithScript(Fx._activeScript || "<unknown>", "", "I", arguments);
            };
            Fx.logError = function(msg) {
                Fx._logWithScript(Fx._activeScript || "<unknown>", "", "E", arguments);
            };

            // 保留全局 console，同时允许生成器为每个脚本绑定脚本名。
            console.log = function() {
                Fx._logWithScript(Fx._activeScript || "<unknown>", "", "I", arguments);
            };
            console.info = console.log;
            console.debug = function() {
                Fx._logWithScript(Fx._activeScript || "<unknown>", "", "D", arguments);
            };
            console.warn = function() {
                Fx._logWithScript(Fx._activeScript || "<unknown>", "", "W", arguments);
            };
            console.error = function() {
                Fx._logWithScript(Fx._activeScript || "<unknown>", "", "E", arguments);
            };

            // ========== 内部工具：自动类型转换 ==========
            Fx._convertReturnValue = function(value) {
                return value;
            };

            // ========== 挂载到全局 ==========
            globalThis.Fx = Fx;
    """.trimIndent()
}
