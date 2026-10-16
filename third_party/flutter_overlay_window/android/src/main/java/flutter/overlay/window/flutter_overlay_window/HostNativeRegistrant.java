package flutter.overlay.window.flutter_overlay_window;

import android.content.Context;
import android.util.Log;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

import io.flutter.plugin.common.BinaryMessenger;

final class HostNativeRegistrant {
    private static final String TAG = "HostNativeRegistrant";
    private static final String HOST_NATIVE_PROVIDER = "com.jsxposed.x.NativeProvider";

    private HostNativeRegistrant() {
    }

    static void registerAll(Context context, BinaryMessenger messenger) {
        try {
            Class<?> providerClass = Class.forName(HOST_NATIVE_PROVIDER);
            Field instanceField = providerClass.getField("INSTANCE");
            Object instance = instanceField.get(null);
            Method registerAllMethod = providerClass.getMethod(
                    "registerAll",
                    Context.class,
                    BinaryMessenger.class
            );
            registerAllMethod.invoke(instance, context, messenger);
            Log.d(TAG, "Host NativeProvider registered on overlay engine");
        } catch (ClassNotFoundException e) {
            Log.w(TAG, "Host NativeProvider not found, skip overlay native registration");
        } catch (Exception e) {
            Log.e(TAG, "Failed to register host NativeProvider", e);
        }
    }
}
