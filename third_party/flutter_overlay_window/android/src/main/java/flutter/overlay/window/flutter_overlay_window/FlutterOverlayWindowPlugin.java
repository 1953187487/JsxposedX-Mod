package flutter.overlay.window.flutter_overlay_window;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Insets;
import android.graphics.Rect;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.WindowInsets;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import java.util.HashMap;
import java.util.Map;

import io.flutter.FlutterInjector;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.FlutterEngineGroup;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.JSONMessageCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

public class FlutterOverlayWindowPlugin implements
        FlutterPlugin, ActivityAware, BasicMessageChannel.MessageHandler, MethodCallHandler,
        PluginRegistry.ActivityResultListener {

    private MethodChannel channel;
    private Context context;
    private Activity mActivity;
    private BasicMessageChannel<Object> messenger;
    private Result pendingResult;
    final int REQUEST_CODE_FOR_OVERLAY_PERMISSION = 1248;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), OverlayConstants.CHANNEL_TAG);
        channel.setMethodCallHandler(this);

        messenger = new BasicMessageChannel(flutterPluginBinding.getBinaryMessenger(), OverlayConstants.MESSENGER_TAG,
                JSONMessageCodec.INSTANCE);
        messenger.setMessageHandler(this);

        WindowSetup.messenger = messenger;
        WindowSetup.messenger.setMessageHandler(this);
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        pendingResult = result;
        if (call.method.equals("checkPermission")) {
            result.success(checkOverlayPermission());
        } else if (call.method.equals("requestPermission")) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION);
                intent.setData(Uri.parse("package:" + mActivity.getPackageName()));
                mActivity.startActivityForResult(intent, REQUEST_CODE_FOR_OVERLAY_PERMISSION);
            } else {
                result.success(true);
            }
        } else if (call.method.equals("showOverlay")) {
            if (!checkOverlayPermission()) {
                result.error("PERMISSION", "overlay permission is not enabled", null);
                return;
            }
            Integer height = call.argument("height");
            Integer width = call.argument("width");
            String alignment = call.argument("alignment");
            String flag = call.argument("flag");
            String overlayTitle = call.argument("overlayTitle");
            String overlayContent = call.argument("overlayContent");
            String notificationVisibility = call.argument("notificationVisibility");
            boolean enableDrag = call.argument("enableDrag");
            String positionGravity = call.argument("positionGravity");
            Map<String, Integer> startPosition = call.argument("startPosition");
            int startX = startPosition != null ? startPosition.getOrDefault("x", OverlayConstants.DEFAULT_XY) : OverlayConstants.DEFAULT_XY;
            int startY = startPosition != null ? startPosition.getOrDefault("y", OverlayConstants.DEFAULT_XY) : OverlayConstants.DEFAULT_XY;


            WindowSetup.width = width != null ? width : -1;
            WindowSetup.height = height != null ? height : -1;
            WindowSetup.enableDrag = enableDrag;
            WindowSetup.setGravityFromAlignment(alignment != null ? alignment : "center");
            WindowSetup.setFlag(flag != null ? flag : "flagNotFocusable");
            WindowSetup.overlayTitle = overlayTitle;
            WindowSetup.overlayContent = overlayContent == null ? "" : overlayContent;
            WindowSetup.positionGravity = positionGravity;
            WindowSetup.setNotificationVisibility(notificationVisibility);

            final Intent intent = new Intent(context, OverlayService.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            intent.putExtra("startX", startX);
            intent.putExtra("startY", startY);
            context.startService(intent);
            result.success(null);
        } else if (call.method.equals("updateOverlayLayout")) {
            Integer width = call.argument("width");
            Integer height = call.argument("height");
            Integer x = call.argument("x");
            Integer y = call.argument("y");
            Boolean enableDrag = call.argument("enableDrag");
            String flag = call.argument("flag");
            result.success(
                    OverlayService.updateOverlayLayout(
                            width != null ? width : OverlayConstants.MATCH_PARENT,
                            height != null ? height : OverlayConstants.MATCH_PARENT,
                            x,
                            y,
                            enableDrag != null && enableDrag,
                            flag != null ? flag : "defaultFlag"
                    )
            );
        } else if (call.method.equals("isOverlayActive")) {
            result.success(OverlayService.isRunning);
            return;
        } else if (call.method.equals("isOverlayActive")) {
            result.success(OverlayService.isRunning);
            return;
        } else if (call.method.equals("moveOverlay")) {
            int x = call.argument("x");
            int y = call.argument("y");
            result.success(OverlayService.moveOverlay(x, y));
        } else if (call.method.equals("getOverlayPosition")) {
            result.success(OverlayService.getCurrentPosition());
        } else if (call.method.equals("getOverlayViewportMetrics")) {
            result.success(resolveOverlayViewportMetrics());
        } else if (call.method.equals("closeOverlay")) {
            if (OverlayService.isRunning) {
                final Intent i = new Intent(context, OverlayService.class);
                context.stopService(i);
                result.success(true);
            }
            return;
        } else {
            result.notImplemented();
        }

    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        WindowSetup.messenger.setMessageHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        mActivity = binding.getActivity();
        if (FlutterEngineCache.getInstance().get(OverlayConstants.CACHED_TAG) == null) {
            FlutterEngineGroup enn = new FlutterEngineGroup(context);
            DartExecutor.DartEntrypoint dEntry = new DartExecutor.DartEntrypoint(
                    FlutterInjector.instance().flutterLoader().findAppBundlePath(),
                    "overlayMain");
            FlutterEngine engine = enn.createAndRunEngine(context, dEntry);
            HostNativeRegistrant.registerAll(context, engine.getDartExecutor().getBinaryMessenger());
            FlutterEngineCache.getInstance().put(OverlayConstants.CACHED_TAG, engine);
        } else {
            FlutterEngine engine = FlutterEngineCache.getInstance().get(OverlayConstants.CACHED_TAG);
            if (engine != null) {
                HostNativeRegistrant.registerAll(context, engine.getDartExecutor().getBinaryMessenger());
            }
        }
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        this.mActivity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
    }

    @Override
    public void onMessage(@Nullable Object message, @NonNull BasicMessageChannel.Reply reply) {
        BasicMessageChannel overlayMessageChannel = new BasicMessageChannel(
                FlutterEngineCache.getInstance().get(OverlayConstants.CACHED_TAG)
                        .getDartExecutor(),
                OverlayConstants.MESSENGER_TAG, JSONMessageCodec.INSTANCE);
        overlayMessageChannel.send(message, reply);
    }

    private boolean checkOverlayPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            return Settings.canDrawOverlays(context);
        }
        return true;
    }

    private Map<String, Double> resolveOverlayViewportMetrics() {
        final Map<String, Double> serviceMetrics = OverlayService.getViewportMetrics();
        if (serviceMetrics != null) {
            return serviceMetrics;
        }

        final Context metricContext = mActivity != null ? mActivity : context;
        int widthPx = metricContext.getResources().getDisplayMetrics().widthPixels;
        int heightPx = metricContext.getResources().getDisplayMetrics().heightPixels;
        int safeLeftPx = 0;
        int safeTopPx = 0;
        int safeRightPx = 0;
        int safeBottomPx = 0;

        if (mActivity != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            final Rect bounds = mActivity.getWindowManager().getCurrentWindowMetrics().getBounds();
            final Insets insets = mActivity.getWindowManager()
                    .getCurrentWindowMetrics()
                    .getWindowInsets()
                    .getInsetsIgnoringVisibility(WindowInsets.Type.systemBars() | WindowInsets.Type.displayCutout());
            widthPx = bounds.width();
            heightPx = bounds.height();
            safeLeftPx = insets.left;
            safeTopPx = insets.top;
            safeRightPx = insets.right;
            safeBottomPx = insets.bottom;
        } else {
            final WindowManager windowManager =
                    (WindowManager) metricContext.getSystemService(Context.WINDOW_SERVICE);
            if (windowManager != null) {
                final Display display = windowManager.getDefaultDisplay();
                final DisplayMetrics realMetrics = new DisplayMetrics();
                display.getRealMetrics(realMetrics);
                widthPx = realMetrics.widthPixels;
                heightPx = realMetrics.heightPixels;
            }
            safeTopPx = resolveSystemDimensionPx(metricContext, "status_bar_height");
            safeBottomPx = resolveSystemDimensionPx(metricContext, "navigation_bar_height");
        }

        final double density = metricContext.getResources().getDisplayMetrics().density;
        final Map<String, Double> metrics = new HashMap<>();
        metrics.put(OverlayConstants.VIEWPORT_WIDTH, widthPx / density);
        metrics.put(OverlayConstants.VIEWPORT_HEIGHT, heightPx / density);
        metrics.put(OverlayConstants.VIEWPORT_SAFE_LEFT, safeLeftPx / density);
        metrics.put(OverlayConstants.VIEWPORT_SAFE_TOP, safeTopPx / density);
        metrics.put(OverlayConstants.VIEWPORT_SAFE_RIGHT, safeRightPx / density);
        metrics.put(OverlayConstants.VIEWPORT_SAFE_BOTTOM, safeBottomPx / density);
        return metrics;
    }

    private int resolveSystemDimensionPx(Context metricContext, String resourceName) {
        final int resourceId = metricContext.getResources().getIdentifier(
                resourceName,
                "dimen",
                "android"
        );
        if (resourceId == 0) {
            return 0;
        }
        return metricContext.getResources().getDimensionPixelSize(resourceId);
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_CODE_FOR_OVERLAY_PERMISSION) {
            pendingResult.success(checkOverlayPermission());
            return true;
        }
        return false;
    }

}
