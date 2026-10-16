package com.jsxposed.xmod

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.jsxposed.xmod.ui.ai.AiFragment
import com.jsxposed.xmod.ui.home.HomeFragment
import com.jsxposed.xmod.ui.settings.SettingsFragment
import com.jsxposed.xmod.util.Prefs

class MainActivity : AppCompatActivity() {

    val themes = intArrayOf(
        R.style.Theme_JsxposedXMod,
        R.style.Theme_JsxposedXMod_Blue,
        R.style.Theme_JsxposedXMod_Teal,
        R.style.Theme_JsxposedXMod_Green,
        R.style.Theme_JsxposedXMod_Orange,
        R.style.Theme_JsxposedXMod_Red,
        R.style.Theme_JsxposedXMod_Pink,
        R.style.Theme_JsxposedXMod_Indigo
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        setTheme(themes[Prefs.getInt(this, "theme_index", 0) % themes.size])
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val nav = findViewById<BottomNavigationView>(R.id.bottom_nav)
        nav.setOnItemSelectedListener { item ->
            when (item.itemId) {
                R.id.nav_home -> show(HomeFragment())
                R.id.nav_ai -> show(AiFragment())
                R.id.nav_settings -> show(SettingsFragment())
            }
            true
        }
        if (savedInstanceState == null) nav.selectedItemId = R.id.nav_home
    }

    private fun show(f: Fragment) {
        supportFragmentManager.beginTransaction()
            .replace(R.id.fragment_container, f)
            .commitAllowingStateLoss()
    }

    fun applyTheme(index: Int) {
        Prefs.putInt(this, "theme_index", index % themes.size)
        recreate()
    }
}
