package com.kotobati.awjiz.nightmode.widget


import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import com.kotobati.awjiz.nightmode.Command
import com.kotobati.awjiz.nightmode.Config.filterIsOn
import com.kotobati.awjiz.nightmode.helper.Logger


class SwitchAppWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        Log.i("onUpdate()")

        for (i in appWidgetIds.indices) {
            val appWidgetId = appWidgetIds[i]

            val toggleIntent = Intent(context, SwitchAppWidgetProvider::class.java)
            toggleIntent.action = ACTION_TOGGLE
            // TODO val togglePendingIntent = PendingIntent.getBroadcast(context, 0, toggleIntent, 0)

            // TODO  val views = RemoteViews(context.packageName, R.layout.appwidget_switch)
            // TODO views.setOnClickPendingIntent(R.id.widget_pause_play_button, togglePendingIntent)

            // TODO appWidgetManager.updateAppWidget(appWidgetId, views)
            // TODO updateImage(context, filterIsOn)
        }
    }

    override fun onReceive(ctx: Context, intent: Intent) {
        if (intent.action == ACTION_TOGGLE) {
            Command.toggle(!filterIsOn)
        } else if (intent.action == ACTION_UPDATE) {
            updateImage(ctx, intent.getBooleanExtra(EXTRA_POWER, false))
        } else {
            super.onReceive(ctx, intent)
        }
    }

    internal fun updateImage(context: Context, filterIsOn: Boolean) {
//        Log.i("Updating image! filterIsOn: $filterIsOn")
//        val views = RemoteViews(context.packageName, R.layout.appwidget_switch)
//        val appWidgetManager = AppWidgetManager.getInstance(context)
//        val appWidgetComponent = ComponentName(context, SwitchAppWidgetProvider::class.java.name)
//        val drawable = if (filterIsOn) R.drawable.ic_stop else R.drawable.ic_play
//
//        views.setInt(R.id.widget_pause_play_button, "setImageResource", drawable)
//        appWidgetManager.updateAppWidget(appWidgetComponent, views)
    }

    companion object : Logger() {
        const val ACTION_TOGGLE = "com.kotobati.awjiz.action.APPWIDGET_TOGGLE"
        const val ACTION_UPDATE = "com.kotobati.awjiz.action.APPWIDGET_UPDATE"
        const val EXTRA_POWER = "com.kotobati.awjiz.action.APPWIDGET_EXTRA_POWER"
    }
}
