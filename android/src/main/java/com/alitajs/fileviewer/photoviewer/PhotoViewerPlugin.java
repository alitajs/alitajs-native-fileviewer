package com.alitajs.fileviewer.photoviewer;

import android.util.Log;
import androidx.appcompat.app.AppCompatActivity;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.alitajs.fileviewer.photoviewer.Notifications.MyRunnable;
import com.alitajs.fileviewer.photoviewer.Notifications.NotificationCenter;

@CapacitorPlugin(name = "PhotoViewer")
public class PhotoViewerPlugin extends Plugin {

    private static final String TAG = "CapacitorPhotoViewer";

    private PhotoViewer implementation;
    private RetHandler rHandler = new RetHandler();

    @Override
    public void load() {
        implementation = new PhotoViewer(getContext(), getBridge());
    }

    @PluginMethod
    public void echo(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", implementation.echo(value));
        call.resolve(ret);
    }

    @PluginMethod
    public void show(PluginCall call) {
        final AppCompatActivity activity = this.getActivity();
        if (!call.getData().has("images")) {
            String msg = "Show: Must provide an image list";
            rHandler.retResult(call, false, msg);
            return;
        }
        JSArray images = call.getArray("images");
        if (images.length() == 0) {
            String msg = "Show: Must provide a non-empty list of image";
            rHandler.retResult(call, false, msg);
            return;
        }
        JSObject options = new JSObject();
        if (call.getData().has("options")) {
            options = call.getObject("options");
        }
        String mode = "one";
        if (call.getData().has("mode")) {
            mode = call.getString("mode");
        }
        Integer startFrom = 0;
        if (call.getData().has("startFrom")) {
            startFrom = call.getInt("startFrom");
        }

        try {
            JSObject finalOptions = options;
            String finalMode = mode;
            Integer finalStartFrom = startFrom;
            AddObserversToNotificationCenter();

            bridge
                .getActivity()
                .runOnUiThread(
                    () -> {
                        try {
                            implementation.show(images, finalMode, finalStartFrom, finalOptions);
                            rHandler.retResult(call, true, null);
                            return;
                        } catch (Exception e) {
                            rHandler.retResult(call, false, e.getMessage());
                        }
                    }
                );
        } catch (Exception e) {
            String msg = "Show: " + e.getMessage();
            rHandler.retResult(call, false, msg);
            return;
        }
    }

    private void AddObserversToNotificationCenter() {
        NotificationCenter
            .defaultCenter()
            .addMethodForNotification(
                "photoviewerExit",
                new MyRunnable() {
                    @Override
                    public void run() {
                        JSObject data = new JSObject();
                        data.put("result", this.getInfo().get("result"));
                        data.put("imageIndex", this.getInfo().get("imageIndex"));
                        data.put("message", this.getInfo().get("message"));
                        NotificationCenter.defaultCenter().removeAllNotifications();
                        notifyListeners("jeepCapPhotoViewerExit", data);
                        return;
                    }
                }
            );
    }
}
