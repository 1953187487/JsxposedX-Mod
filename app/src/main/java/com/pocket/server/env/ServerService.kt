package com.pocket.server.env

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.IBinder

class ServerService : Service() {

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startForeground(1001, buildNotification())
        return START_STICKY
    }

    private fun buildNotification(): Notification {
        val id = "pocket_server"
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (android.os.Build.VERSION.SDK_INT >= 26) {
            nm.createNotificationChannel(
                NotificationChannel(id, "服务器运行状态", NotificationManager.IMPORTANCE_LOW)
            )
        }
        val b = if (android.os.Build.VERSION.SDK_INT >= 26) {
            Notification.Builder(this, id)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }
        b.setContentTitle("口袋服务器运行中")
            .setContentText("服务器功能正在运行，可在应用内停止")
            .setSmallIcon(android.R.drawable.stat_notify_sync_noanim)
            .setOngoing(true)
        return b.build()
    }
}
