package com.jsxposed.xmod.core.bridge.lsposed_native

import android.content.Context
import android.os.ParcelFileDescriptor
import com.jsxposed.xmod.core.bridge.xposed_js_snapshot.XposedScriptSnapshotRepository
import com.jsxposed.xmod.core.utils.log.LogX
import io.github.libxposed.service.XposedService
import io.github.libxposed.service.XposedServiceHelper

class LSPosed(private val context: Context) {

    companion object {
        private const val TAG = "LSPosed"

        @Volatile
        private var xposedService: XposedService? = null

        @Volatile
        private var listenerRegistered = false

        @Synchronized
        fun initService(context: Context) {
            if (listenerRegistered) return

            try {
                XposedServiceHelper.registerListener(object : XposedServiceHelper.OnServiceListener {
                    override fun onServiceBind(service: XposedService) {
                        xposedService = service
                        LogX.d(TAG, "XposedService connected, API=${service.getAPIVersion()}")
                        migrateLocalToRemote(context, service)
                        XposedScriptSnapshotRepository(context).rebuildAllSnapshots()
                    }

                    override fun onServiceDied(service: XposedService) {
                        xposedService = null
                        LogX.w(TAG, "XposedService disconnected")
                    }
                })
                listenerRegistered = true
            } catch (e: Exception) {
                listenerRegistered = false
                LogX.e(TAG, "registerListener failed: ${e.message}")
            }
        }

        private fun migrateLocalToRemote(context: Context, service: XposedService) {
            try {
                val local = context.getSharedPreferences("pinia", Context.MODE_PRIVATE)
                val localMap = local.all
                if (localMap.isEmpty()) return

                val remote = service.getRemotePreferences("pinia")
                val editor = remote.edit()
                for ((key, value) in localMap) {
                    when (value) {
                        is String -> editor.putString(key, value)
                        is Boolean -> editor.putBoolean(key, value)
                        is Int -> editor.putInt(key, value)
                        is Float -> editor.putFloat(key, value)
                        is Long -> editor.putLong(key, value)
                        else -> {}
                    }
                }
                editor.apply()
                LogX.d(TAG, "Migrated local pinia data to RemotePreferences, size=${localMap.size}")
            } catch (e: Exception) {
                LogX.e(TAG, "migrateLocalToRemote failed: ${e.message}")
            }
        }

        fun isServiceConnected(): Boolean = xposedService != null

        fun getRemotePreferences(group: String): android.content.SharedPreferences? {
            return try {
                xposedService?.getRemotePreferences(group)
            } catch (e: Exception) {
                LogX.e(TAG, "getRemotePreferences failed: ${e.message}")
                null
            }
        }

        fun listRemoteFiles(): List<String> {
            return try {
                xposedService?.listRemoteFiles()?.toList() ?: emptyList()
            } catch (e: UnsupportedOperationException) {
                LogX.e(TAG, "listRemoteFiles unsupported: ${e.message}")
                emptyList()
            } catch (e: Exception) {
                LogX.e(TAG, "listRemoteFiles failed: ${e.message}")
                emptyList()
            }
        }

        fun openRemoteFile(name: String): ParcelFileDescriptor? {
            return try {
                xposedService?.openRemoteFile(name)
            } catch (e: UnsupportedOperationException) {
                LogX.e(TAG, "openRemoteFile unsupported: name=$name error=${e.message}")
                null
            } catch (e: Exception) {
                LogX.e(TAG, "openRemoteFile failed: name=$name error=${e.message}")
                null
            }
        }
    }

    fun addScope(packageName: String): Boolean {
        val service = xposedService ?: run {
            LogX.w(TAG, "XposedService not connected, cannot add scope: $packageName")
            return false
        }
        return try {
            if (service.getScope().contains(packageName)) {
                LogX.d(TAG, "Scope already exists: $packageName")
                return true
            }
            service.requestScope(packageName, object : XposedService.OnScopeEventListener {
                override fun onScopeRequestApproved(packageName: String) {
                    LogX.d(TAG, "Scope request approved: $packageName")
                }

                override fun onScopeRequestDenied(packageName: String) {
                    LogX.w(TAG, "Scope request denied: $packageName")
                }

                override fun onScopeRequestFailed(packageName: String, message: String) {
                    LogX.e(TAG, "Scope request failed: $packageName, reason=$message")
                }
            })
            true
        } catch (e: Exception) {
            LogX.e(TAG, "addScope failed: ${e.message}")
            false
        }
    }

    fun removeScope(packageName: String): Boolean {
        val service = xposedService ?: run {
            LogX.w(TAG, "XposedService not connected, cannot remove scope: $packageName")
            return false
        }
        return try {
            val error = service.removeScope(packageName)
            if (error == null) {
                LogX.d(TAG, "removeScope success: $packageName")
                true
            } else {
                LogX.e(TAG, "removeScope failed: $error")
                false
            }
        } catch (e: Exception) {
            LogX.e(TAG, "removeScope failed: ${e.message}")
            false
        }
    }

    fun getScope(): List<String> {
        return try {
            xposedService?.getScope() ?: emptyList()
        } catch (e: Exception) {
            LogX.e(TAG, "getScope failed: ${e.message}")
            emptyList()
        }
    }

    fun isAvailable(): Boolean = xposedService != null
}
