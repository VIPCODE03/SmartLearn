package com.zent.smartlearn.smart_learn;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Build;
import android.util.Log;
import android.view.View;
import android.widget.RemoteViews;

import com.zent.smartlearn.smart_learn.widget.FlashcardWidgetManage;
import com.zent.smartlearn.smart_learn.widget.WidgetContants;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Random;

public class FlashcardWidgetProvider extends AppWidgetProvider {
    private static final String ACTION_FLIP = "com.zent.ACTION_FLIP";
    private static final String ACTION_NEXT = "com.zent.ACTION_NEXT";
    private static final String ACTION_PREV = "com.zent.ACTION_PREV";

    @Override
    public void onReceive(Context context, Intent intent) {
        super.onReceive(context, intent);
        List<Flashcard> list = getCardList(context);
        int index = FlashcardWidgetManage.getIndex(context);;
        boolean showingFront = FlashcardWidgetManage.getShowingFront(context);

        switch (Objects.requireNonNull(intent.getAction())) {
            case ACTION_NEXT:
                if (!list.isEmpty()) {
                    index = (index + 1) % list.size();
                    FlashcardWidgetManage.updateCurrent(context ,index, true);
                }
                break;
            case ACTION_PREV:
                if (!list.isEmpty()) {
                    index = (index - 1 + list.size()) % list.size();
                    FlashcardWidgetManage.updateCurrent(context ,index, true);
                }
                break;
            case ACTION_FLIP:
                FlashcardWidgetManage.updateCurrent(context ,index, !showingFront);
                break;
        }

        AppWidgetManager manager = AppWidgetManager.getInstance(context);
        ComponentName thisWidget = new ComponentName(context, FlashcardWidgetProvider.class);
        int[] ids = manager.getAppWidgetIds(thisWidget);
        onUpdate(context, manager, ids);
    }

    @Override
    public void onUpdate(Context context, AppWidgetManager manager, int[] appWidgetIds) {
        for (int widgetId : appWidgetIds) {
            updateAppWidget(context, manager, widgetId);
        }
    }

    static void updateAppWidget(Context context, AppWidgetManager manager, int widgetId) {
        SharedPreferences prefs = context.getSharedPreferences(WidgetContants.PREFS_NAME, Context.MODE_PRIVATE);
        List<Flashcard> list = getCardList(context);
        int index = prefs.getInt(WidgetContants.PREF_INDEX, 0);
        boolean isFront = prefs.getBoolean(WidgetContants.PREF_SHOWING_FRONT, true);

        String front = list.isEmpty() ? "No data" : list.get(index).front;
        String back = list.isEmpty() ? "" : list.get(index).back;

        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.flashcard_layout);

        views.setTextViewText(R.id.tv_card_front, front);
        views.setTextViewText(R.id.tv_card_back, back);
        views.setViewVisibility(R.id.card_front_layout, isFront ? View.VISIBLE : View.GONE);
        views.setViewVisibility(R.id.card_back_layout, isFront ? View.GONE : View.VISIBLE);
        views.setTextViewText(R.id.tv_total, (index + 1) + " / " + list.size());

        views.setOnClickPendingIntent(R.id.view_flipper, getPI(context, ACTION_FLIP));
        views.setOnClickPendingIntent(R.id.btn_next, getPI(context, ACTION_NEXT));
        views.setOnClickPendingIntent(R.id.btn_prev, getPI(context, ACTION_PREV));

        views.setOnClickPendingIntent(R.id.btnOpen, open(context, widgetId));
        manager.updateAppWidget(widgetId, views);
    }

    private static PendingIntent getPI(Context ctx, String action) {
        Intent i = new Intent(ctx, FlashcardWidgetProvider.class);
        i.setAction(action);
        return PendingIntent.getBroadcast(ctx, action.hashCode(), i,
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
    }

    private static List<Flashcard> getCardList(Context context) {
        String id = FlashcardWidgetManage.getCurrentCardSet(context);
        Log.d("FlashcardWidgetProvider", "getCardList: " + id);
        FlashCardSet flashCardSet = FlashcardWidgetManage.getCardSet(context, id);
        if(flashCardSet == null)
            return new ArrayList<>();
        return flashCardSet.getCards();
    }

    private static PendingIntent open(Context context, int widgetId) {
        // 1. Tạo Intent để mở MainActivity
        Intent openAppIntent = new Intent(context, MainActivity.class);
        openAppIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
        openAppIntent.setAction(Intent.ACTION_VIEW);
        openAppIntent.setData(Uri.parse("smartlearn://edit"));

        // 2. Tạo PendingIntent cho Activity
        int pendingIntentFlags;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            pendingIntentFlags = PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE;
        } else {
            pendingIntentFlags = PendingIntent.FLAG_UPDATE_CURRENT;
        }
        // Tạo PendingIntent với một requestCode duy nhất (widgetId)
        return PendingIntent.getActivity(
                context,
                widgetId, // requestCode
                openAppIntent,
                pendingIntentFlags
        );
    }
}
