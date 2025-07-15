package com.zent.smartlearn.smart_learn;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class FlashCardSet {
    private final String id;
    private final String name;
    private final List<Flashcard> cards;

    public FlashCardSet(String id, String name, List<Flashcard> cards) {
        this.id = id;
        this.name = name;
        this.cards = cards;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public List<Flashcard> getCards() {
        return cards;
    }

    public String toJson() {
        StringBuilder json = new StringBuilder();
        json.append("{");

        json.append("\"id\":\"").append(escape(id)).append("\",");
        json.append("\"name\":\"").append(escape(name)).append("\",");

        json.append("\"cards\":[");
        for (int i = 0; i < cards.size(); i++) {
            json.append(cards.get(i).toJson());
            if (i < cards.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");

        json.append("}");
        return json.toString();
    }

    private String escape(String value) {
        return value.replace("\"", "\\\"");
    }

    public static FlashCardSet fromJson(String json) {
        try {
            JSONObject obj = new JSONObject(json);

            String id = obj.optString("id", "");
            String name = obj.optString("name", "");

            List<Flashcard> cards = new ArrayList<>();
            JSONArray cardArray = obj.optJSONArray("cards");
            if (cardArray != null) {
                for (int i = 0; i < cardArray.length(); i++) {
                    JSONObject cardObj = cardArray.optJSONObject(i);
                    if (cardObj != null) {
                        String front = cardObj.optString("front", "");
                        String back = cardObj.optString("back", "");
                        cards.add(new Flashcard(front, back));
                    }
                }
            }

            return new FlashCardSet(id, name, cards);
        } catch (Exception e) {
            e.printStackTrace();
            return new FlashCardSet("", "", new ArrayList<>());
        }
    }
}
