package com.zent.smartlearn.smart_learn;

import android.appwidget.AppWidgetManager;
import android.content.ComponentName;
import android.content.Intent;
import android.util.Log;
import androidx.annotation.NonNull;
import com.zent.smartlearn.smart_learn.widget.FlashcardWidgetManage;
import com.zent.smartlearn.smart_learn.widget.WidgetContants;
import org.json.JSONObject;
import java.util.Map;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), WidgetContants.CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals(WidgetContants.UPDATE) || call.method.equals(WidgetContants.REMOVE)) {
                        Object args = call.arguments;

                        if (args instanceof Map) {
                            try {
                                JSONObject jsonObject = new JSONObject((Map<?, ?>) args);
                                String jsonString = jsonObject.toString();
                                FlashCardSet flashCardSet = FlashCardSet.fromJson(jsonString);
                                if (call.method.equals(WidgetContants.REMOVE)) {
                                    FlashcardWidgetManage.removeCardSet(this, flashCardSet.getId());
                                } else {
                                    FlashcardWidgetManage.saveCardSet(this, flashCardSet);
                                }

                                FlashcardWidgetManage.updateCurrent(this, 0, true);
                                FlashcardWidgetManage.updateCardSetCurrent(this, flashCardSet.getId());

                                Log.d("FlashCardSet", "Received set: " + flashCardSet.getName() + ", cards: " + flashCardSet.getCards().size());

                            } catch (Exception e) {
                                e.printStackTrace();
                                result.error("PARSING_ERROR", "Failed to parse FlashCardSet", null);
                                return;
                            }
                        } else {
                            result.error("INVALID_DATA", "Expected a Map<String, Object>", null);
                            return;
                        }

                        AppWidgetManager mgr = AppWidgetManager.getInstance(getApplicationContext());
                        ComponentName widget = new ComponentName(getApplicationContext(), FlashcardWidgetProvider.class);
                        mgr.notifyAppWidgetViewDataChanged(mgr.getAppWidgetIds(widget), R.id.view_flipper);

                        Intent intent = new Intent(this, FlashcardWidgetProvider.class);
                        intent.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
                        intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, mgr.getAppWidgetIds(widget));
                        sendBroadcast(intent);

                        result.success(null);
                        return;
                    }
                    result.notImplemented();
                });
    }
}
