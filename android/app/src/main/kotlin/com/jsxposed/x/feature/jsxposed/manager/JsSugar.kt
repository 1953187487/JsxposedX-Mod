package com.jsxposed.xmod.feature.jsxposed.manager

/**
 * JS 语法糖，简化常用操作
 */
object JsSugar {
    val CODE = """
        (function() {

            // ========== Jx.use(className) 类代理 ==========
            Jx.use = function(className) {
                return {
                    _class: className,
                    _lastHookResult: null,
                    _hookResults: [],

                    _recordHookResult: function(result) {
                        this._lastHookResult = result;
                        this._hookResults.push(result);
                        return this;
                    },
                    getLastHookResult: function() {
                        return this._lastHookResult;
                    },
                    getHookResults: function() {
                        return this._hookResults.slice();
                    },
                    clearHookResults: function() {
                        this._lastHookResult = null;
                        this._hookResults = [];
                        return this;
                    },

                    // 静态方法调用
                    call: function(methodName) {
                        var values = Array.prototype.slice.call(arguments, 1);
                        return Jx.callStaticMethod(this._class, methodName, [], values);
                    },
                    callTyped: function(methodName, types, values) {
                        return Jx.callStaticMethod(this._class, methodName, types, values);
                    },

                    // 静态字段
                    getField: function(fieldName) {
                        return Jx.getStaticObjectField(this._class, fieldName);
                    },
                    setField: function(fieldName, value) {
                        return Jx.setStaticObjectField(this._class, fieldName, value);
                    },

                    // 实例化
                    newInstance: function() {
                        var values = Array.prototype.slice.call(arguments);
                        return Jx.newInstance(this._class, [], values);
                    },
                    newInstanceTyped: function(types, values) {
                        return Jx.newInstance(this._class, types, values);
                    },
                    
                    // Hook: 完整形式
                    hook: function(methodName, paramTypes, callbacks) {
                        return this._recordHookResult(
                            Jx.hookMethod(this._class, methodName, paramTypes, callbacks)
                        );
                    },
                    hookConstructor: function(paramTypes, callbacks) {
                        return this._recordHookResult(
                            Jx.hookConstructor(this._class, paramTypes, callbacks)
                        );
                    },
                    hookAllMethods: function(methodName, callbacks) {
                        return this._recordHookResult(
                            Jx.hookAllMethods(this._class, methodName, callbacks)
                        );
                    },
                    hookAllConstructors: function(callbacks) {
                        return this._recordHookResult(
                            Jx.hookAllConstructors(this._class, callbacks)
                        );
                    },

                    // Hook: 简写 - 只传 before
                    before: function(methodName, paramTypes, fn) {
                        return this._recordHookResult(
                            Jx.hookMethod(this._class, methodName, paramTypes, { before: fn })
                        );
                    },
                    // Hook: 简写 - 只传 after
                    after: function(methodName, paramTypes, fn) {
                        return this._recordHookResult(
                            Jx.hookMethod(this._class, methodName, paramTypes, { after: fn })
                        );
                    },
                    // Hook: 替换方法返回值
                    replace: function(methodName, paramTypes, fn) {
                        return this._recordHookResult(
                            Jx.hookMethod(this._class, methodName, paramTypes, {
                                before: function(param) {
                                    param.setResult(fn(param));
                                }
                            })
                        );
                    },
                    // Hook: 直接固定返回值
                    returnConst: function(methodName, paramTypes, value) {
                        return this._recordHookResult(
                            Jx.hookMethod(this._class, methodName, paramTypes, {
                                before: function(param) {
                                    param.setResult(value);
                                }
                            })
                        );
                    },
                    // Hook 构造函数简写
                    beforeConstructor: function(paramTypes, fn) {
                        return this._recordHookResult(
                            Jx.hookConstructor(this._class, paramTypes, { before: fn })
                        );
                    },
                    afterConstructor: function(paramTypes, fn) {
                        return this._recordHookResult(
                            Jx.hookConstructor(this._class, paramTypes, { after: fn })
                        );
                    },

                    // 静态基本类型字段
                    getStaticInt: function(fieldName) {
                        return Jx.getStaticIntField(this._class, fieldName);
                    },
                    setStaticInt: function(fieldName, value) {
                        return Jx.setStaticIntField(this._class, fieldName, value);
                    },
                    getStaticBool: function(fieldName) {
                        return Jx.getStaticBooleanField(this._class, fieldName);
                    },
                    setStaticBool: function(fieldName, value) {
                        return Jx.setStaticBooleanField(this._class, fieldName, value);
                    },
                    getStaticLong: function(fieldName) {
                        return Jx.getStaticLongField(this._class, fieldName);
                    },
                    setStaticLong: function(fieldName, value) {
                        return Jx.setStaticLongField(this._class, fieldName, value);
                    },
                    getStaticFloat: function(fieldName) {
                        return Jx.getStaticFloatField(this._class, fieldName);
                    },
                    setStaticFloat: function(fieldName, value) {
                        return Jx.setStaticFloatField(this._class, fieldName, value);
                    },
                    getStaticDouble: function(fieldName) {
                        return Jx.getStaticDoubleField(this._class, fieldName);
                    },
                    setStaticDouble: function(fieldName, value) {
                        return Jx.setStaticDoubleField(this._class, fieldName, value);
                    }
                };
            };

            // ========== Jx.wrap(obj) 实例代理 ==========
            Jx.wrap = function(obj) {
                return {
                    _obj: obj,
                    call: function(methodName) {
                        var values = Array.prototype.slice.call(arguments, 1);
                        return Jx.callMethod(this._obj, methodName, [], values);
                    },
                    callTyped: function(methodName, types, values) {
                        return Jx.callMethod(this._obj, methodName, types, values);
                    },
                    getField: function(fieldName) {
                        return Jx.getObjectField(this._obj, fieldName);
                    },
                    setField: function(fieldName, value) {
                        return Jx.setObjectField(this._obj, fieldName, value);
                    },
                    getInt: function(fieldName) {
                        return Jx.getIntField(this._obj, fieldName);
                    },
                    setInt: function(fieldName, value) {
                        return Jx.setIntField(this._obj, fieldName, value);
                    },
                    getBool: function(fieldName) {
                        return Jx.getBooleanField(this._obj, fieldName);
                    },
                    setBool: function(fieldName, value) {
                        return Jx.setBooleanField(this._obj, fieldName, value);
                    },
                    // 获取对象的类名
                    getClassName: function() {
                        return Jx.callMethod(this._obj, "getClass", [], []).toString();
                    },
                    getLong: function(fieldName) {
                        return Jx.getLongField(this._obj, fieldName);
                    },
                    setLong: function(fieldName, value) {
                        return Jx.setLongField(this._obj, fieldName, value);
                    },
                    getFloat: function(fieldName) {
                        return Jx.getFloatField(this._obj, fieldName);
                    },
                    setFloat: function(fieldName, value) {
                        return Jx.setFloatField(this._obj, fieldName, value);
                    },
                    getDouble: function(fieldName) {
                        return Jx.getDoubleField(this._obj, fieldName);
                    },
                    setDouble: function(fieldName, value) {
                        return Jx.setDoubleField(this._obj, fieldName, value);
                    },
                    getShort: function(fieldName) {
                        return Jx.getShortField(this._obj, fieldName);
                    },
                    setShort: function(fieldName, value) {
                        return Jx.setShortField(this._obj, fieldName, value);
                    },
                    getByte: function(fieldName) {
                        return Jx.getByteField(this._obj, fieldName);
                    },
                    setByte: function(fieldName, value) {
                        return Jx.setByteField(this._obj, fieldName, value);
                    },
                    getChar: function(fieldName) {
                        return Jx.getCharField(this._obj, fieldName);
                    },
                    setChar: function(fieldName, value) {
                        return Jx.setCharField(this._obj, fieldName, value);
                    }
                };
            };

            // ========== Jx.ext 可扩展工具命名空间 ==========
            Jx.ext = {};

            // Toast
            Jx.ext.toast = function(context, text, duration) {
                var t = Jx.callStaticMethod(
                    "android.widget.Toast", "makeText",
                    ["android.content.Context", "java.lang.CharSequence", "int"],
                    [context, String(text), duration || 0]
                );
                Jx.callMethod(t, "show", [], []);
            };

            // 获取 Application Context
            Jx.ext.getApplication = function() {
                return Jx.use("android.app.ActivityThread").call("currentApplication");
            };

            // 获取包名
            Jx.ext.getPackageName = function(context) {
                return Jx.callMethod(context, "getPackageName", [], []);
            };

            // 获取 SharedPreferences
            Jx.ext.getSharedPrefs = function(context, name, mode) {
                return Jx.callMethod(context, "getSharedPreferences",
                    ["java.lang.String", "int"],
                    [name, mode || 0]
                );
            };

            // 读取 SP 值
            Jx.ext.getPrefString = function(prefs, key, defaultValue) {
                return Jx.callMethod(prefs, "getString",
                    ["java.lang.String", "java.lang.String"],
                    [key, defaultValue || ""]
                );
            };
            Jx.ext.getPrefInt = function(prefs, key, defaultValue) {
                return Jx.callMethod(prefs, "getInt",
                    ["java.lang.String", "int"],
                    [key, defaultValue || 0]
                );
            };
            Jx.ext.getPrefBool = function(prefs, key, defaultValue) {
                return Jx.callMethod(prefs, "getBoolean",
                    ["java.lang.String", "boolean"],
                    [key, defaultValue || false]
                );
            };

            // 获取系统属性
            Jx.ext.getSystemProp = function(key) {
                return Jx.use("android.os.SystemProperties").callTyped("get",
                    ["java.lang.String"], [key]
                );
            };

            // 获取 Build 信息（支持嵌套字段如 VERSION.SDK_INT）
            Jx.ext.getBuild = function(fieldName) {
                var parts = fieldName.split(".");
                if (parts.length === 1) {
                    return Jx.use("android.os.Build").getField(fieldName);
                }
                var cls = "android.os.Build$" + parts[0];
                return Jx.use(cls).getField(parts[1]);
            };

            // 开启 Activity
            Jx.ext.startActivity = function(context, className) {
                var intent = Jx.use("android.content.Intent").newInstanceTyped(
                    ["android.content.Context", "java.lang.Class"],
                    [context, Jx.loadClass(className)]
                );
                Jx.callMethod(context, "startActivity",
                    ["android.content.Intent"], [intent]
                );
            };

            // 打印调用栈
            Jx.ext.stackTrace = function(tag) {
                var trace = Jx.use("android.util.Log").callTyped(
                    "getStackTraceString",
                    ["java.lang.Throwable"],
                    [Jx.use("java.lang.Throwable").newInstance()]
                );
                Jx.log((tag ? "[" + tag + "] " : "") + trace);
            };

            return "Jx Sugar Ready";
        })();
    """.trimIndent()
}
