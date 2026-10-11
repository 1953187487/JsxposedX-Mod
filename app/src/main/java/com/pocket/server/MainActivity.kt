package com.pocket.server

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.pocket.server.ui.ai.AiFragment
import com.pocket.server.ui.home.HomeFragment
import com.pocket.server.ui.settings.SettingsFragment
import com.pocket.server.util.Prefs

class MainActivity : AppCompatActivity() {

    val themes = intArrayOf(
        R.style.Theme_PocketServer,
        R.style.Theme_PocketServer_Blue,
        R.style.Theme_PocketServer_Teal,
        R.style.Theme_PocketServer_Green,
        R.style.Theme_PocketServer_Orange,
        R.style.Theme_PocketServer_Red,
        R.style.Theme_PocketServer_Pink,
        R.style.Theme_PocketServer_Indigo
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
