package com.ravener.gdx;

import android.os.Bundle;

import com.badlogic.gdx.backends.android.AndroidApplication;
import com.badlogic.gdx.backends.android.AndroidApplicationConfiguration;

public class AndroidLauncher extends AndroidApplication {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    if (!(Thread.getDefaultUncaughtExceptionHandler() instanceof ExceptionHandler)) {
      Thread.setDefaultUncaughtExceptionHandler(new ExceptionHandler("/sdcard"));
    }

    AndroidApplicationConfiguration config = new AndroidApplicationConfiguration();
    config.useAccelerometer = false;
    config.useCompass = false;
    config.useImmersiveMode = true;
    initialize(new Drop(), config);
  }
}
