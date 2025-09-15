package com.murlodin.easy_upload

import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import java.io.File
import java.io.FileInputStream
import java.net.HttpURLConnection
import java.net.URL

class FileUploadService : Service() {

    override fun onBind(p0: Intent?): IBinder? {
        return null;
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val filePath = intent?.getStringExtra(FILE_PATH_KEY)
        val uploadUrl = intent?.getStringExtra(UPLOAD_URL_KEY)


        if (filePath == null || uploadUrl == null) {
            stopSelf()
            return START_NOT_STICKY
        }


        val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        val channel = android.app.NotificationChannel(
            NOTIFICATION_CHANNEL_ID_KEY,
            "File Upload",
            NotificationManager.IMPORTANCE_LOW
        )
        notificationManager.createNotificationChannel(channel)

        // 2. Создай builder
        val builder = NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID_KEY)
            .setContentTitle("File Upload")
            .setContentText("Starting upload...")
            .setSmallIcon(android.R.drawable.stat_sys_upload)
            .setProgress(10, 0, false)

        startForeground(1, builder.build())

        Thread {
            try {
                val file = File(filePath)
                val url = URL(uploadUrl)
                val connection = url.openConnection() as HttpURLConnection
                connection.doOutput = true
                connection.requestMethod = "POST"
                connection.setRequestProperty("Content-Type", "application/octet-stream")
                connection.setRequestProperty("Connection", "Keep-Alive")

                val outputStream = connection.outputStream
                val inputStream = FileInputStream(file)

                val buffer = ByteArray(4096)
                var bytesRead: Int
                var totalBytesRead = 0
                val totalSize = file.length().toInt()

                while (inputStream.read(buffer).also { bytesRead = it } != -1) {
                    outputStream.write(buffer, 0, bytesRead)
                    totalBytesRead += bytesRead

                    val progress = (totalBytesRead * 100 / totalSize).coerceIn(0, 100)

                    builder.setProgress(100, progress, false)
                        .setContentText("Progress: $progress%")
                    notificationManager.notify(1, builder.build())
                }

                inputStream.close()
                outputStream.flush()
                outputStream.close()

                val responseCode = connection.responseCode

                builder.setContentText("Upload complete")
                    .setProgress(0, 0, false)
                notificationManager.notify(1, builder.build())
                stopForeground(STOP_FOREGROUND_DETACH)

            } catch (e: Exception) {
                builder.setContentText("Upload failed")
                    .setProgress(0, 0, false)
                notificationManager.notify(1, builder.build())
            } finally {
                stopSelf()
            }
        }.start()

        return START_STICKY
    }

    override fun stopService(name: Intent?): Boolean {
        return super.stopService(name)
    }

}
