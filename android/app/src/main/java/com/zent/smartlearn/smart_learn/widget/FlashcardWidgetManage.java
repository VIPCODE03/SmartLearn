package com.zent.smartlearn.smart_learn.widget;

import android.content.Context;
import android.content.SharedPreferences;

import com.zent.smartlearn.smart_learn.FlashCardSet;

import java.util.ArrayList;
import java.util.List;

public class FlashcardWidgetManage {
    private static final String PREFS_NAME = "FlashcardWidgetPrefs";
    private static final String KEY_PREFIX = "flashcard_";

    private static final String PREF_CURRENT_SET = "current_set";
    private static final String PREF_INDEX = "current_index";
    private static final String PREF_SHOWING_FRONT = "showing_front";

    public static void updateCurrent(Context context, int index, boolean showingFront) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        prefs.edit()
                .putInt(PREF_INDEX, index)
                .putBoolean(PREF_SHOWING_FRONT, showingFront)
                .apply();
    }

    public static int getIndex(Context context) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        return prefs.getInt(PREF_INDEX, 0);
    }

    public static void updateCardSetCurrent(Context context, String id) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        prefs.edit().putString(PREF_CURRENT_SET, KEY_PREFIX + id).apply();
    }

    public static String getCurrentCardSet(Context context) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        return prefs.getString(PREF_CURRENT_SET, null);
    }

    public static boolean getShowingFront(Context context) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        return prefs.getBoolean(PREF_SHOWING_FRONT, true);
    }

    public static void saveCardSet(Context context, FlashCardSet set) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        prefs.edit()
                .putString(KEY_PREFIX + set.getId(), set.toJson())
                .apply();
    }

    public static FlashCardSet getCardSet(Context context, String id) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        String json = prefs.getString(id, null);
        if (json != null) {
            return FlashCardSet.fromJson(json);
        }
        return null;
    }

    public static void removeCardSet(Context context, String id) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        prefs.edit().remove(KEY_PREFIX + id).apply();
    }

    public static List<FlashCardSet> getAllCardSets(Context context) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        List<FlashCardSet> result = new ArrayList<>();

        for (String key : prefs.getAll().keySet()) {
            if (key.startsWith(KEY_PREFIX)) {
                String json = prefs.getString(key, null);
                if (json != null) {
                    FlashCardSet set = FlashCardSet.fromJson(json);
                    result.add(set);
                }
            }
        }

        return result;
    }
}
