package android.content.res;

import android.util.DisplayMetrics;

import de.robv.android.xposed.callbacks.XC_LayoutInflated;

public class XResources extends Resources {

	public XResources(AssetManager assets, DisplayMetrics metrics, Configuration config) {
		super(assets, metrics, config);
	}

	public static void setPackageNameForResDir(String packageName, String resDir) {
	}

	public static void init(Object resourcesKey) {
	}

	public static void unhookLayout(String resDir, int id, XC_LayoutInflated callback) {
	}

	public void initObject(String resDir) {
	}

	public boolean isFirstLoad() {
		return false;
	}

	public String getPackageName() {
		return null;
	}

	public static class XTypedArray extends TypedArray {

		public void initObject(XResources res) {
		}
	}

	public static class ResourceNames {
		public String type;
		public String entry;
		public int id;
	}
}
