package me.fennland.pinDemo

import io.flutter.embedding.android.FlutterActivity

import android.os.Bundle
import com.baidu.mapapi.SDKInitializer

class MainActivity: FlutterActivity() {
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        SDKInitializer.setAgreePrivacy(applicationContext, true)
        SDKInitializer.initialize(applicationContext)

    }

}
