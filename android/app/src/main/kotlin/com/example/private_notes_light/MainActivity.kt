package com.example.private_notes_light

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity(){
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // This single line hides the app content in "Recents"
        // AND prevents screenshots (bonus security).
        window.setFlags(LayoutParams.FLAG_SECURE, LayoutParams.FLAG_SECURE)
    }
}
