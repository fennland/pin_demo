package com.example.pin_demo

import io.flutter.embedding.android.FlutterActivity


import com.baidu.mapapi.SDKInitializer

class MainActivity: FlutterActivity() {
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        SDKInitializer.setAgreePrivacy(applicationContext, true)
        SDKInitializer.initialize(applicationContext)

    }

}
