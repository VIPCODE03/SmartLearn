package com.zent.smartlearn.smart_learn;

import android.os.Build;

import org.json.JSONObject;

import java.util.Map;

public class Flashcard {
    public String front;
    public String back;

    public Flashcard(String front, String back) {
        this.front = front;
        this.back = back;
    }

    public String toJson() {
        return "{"
                + "\"front\":\"" + escape(front) + "\","
                + "\"back\":\"" + escape(back) + "\""
                + "}";
    }

    private String escape(String value) {
        return value.replace("\"", "\\\""); // Escape dấu "
    }

    public static Flashcard fromJson(String json) {
        try {
            JSONObject obj = new JSONObject(json);
            String front = obj.optString("front", "");
            String back = obj.optString("back", "");
            return new Flashcard(front, back);
        } catch (Exception e) {
            e.printStackTrace();
            return new Flashcard("", "");
        }
    }
}
