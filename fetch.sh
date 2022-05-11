#!/data/data/com.termux/files/usr/bin/bash

# Jar dependencies
if [ ! -d "./libs" ]; then
  echo "Created ./libs"
  mkdir ./libs
fi

# Native .so libraries to be packed in the APK
if [ ! -d "./lib" ]; then
  mkdir ./lib/
  mkdir ./lib/arm64-v8a
  mkdir ./lib/armeabi
  mkdir ./lib/armeabi-v7a
  mkdir ./lib/x86
  mkdir ./lib/x86_64

  echo "Created ./lib/{arm64-v8a,armeabi,armeabi-v7a,x86,x86_64}"
fi

# Base URL where the nightlies distribution is located.
URL="https://libgdx.badlogicgames.com/ci/nightlies/dist"
echo "Base URL: $URL"

# Base libGDX jar file.
echo "Fetching gdx.jar"
wget "$URL/gdx.jar" -O libs/gdx.jar

# Android backend
echo "Fetching gdx-backend-android.jar"
wget "$URL/gdx-backend-android.jar" -O libs/gdx-backend-android.jar

# Native libraries for all architectures
wget "$URL/arm64-v8a/libgdx.so" -O lib/arm64-v8a/libgdx.so
wget "$URL/armeabi-v7a/libgdx.so" -O lib/armeabi-v7a/libgdx.so
wget "$URL/armeabi/libgdx.so" -O lib/armeabi/libgdx.so

# Hint: x86 libraries are 99% of times not needed
# Unless you want to run it in an emulator or something
# So you may wish to comment this to save some apk size
# Though it won't make a huge difference.
wget "$URL/x86_64/libgdx.so" -O lib/x86_64/libgdx.so
wget "$URL/x86/libgdx.so" -O lib/x86/libgdx.so

# Optional extension libraries
# Commented out by default and not required by the sample code
# But you may wish to add this libraries for your own use.

# Additional gdx tools. (Optional)
# Can be used from programs but it can also be invoked on the cli
# Includes some critical tools like the texture packer.
# wget "$URL/extensions/gdx-tools/gdx-tools.jar" -O libs/gdx-tools.jar

# Box2D
# wget "$URL/extensions/gdx-box2d/gdx-box2d.jar" -O libs/gdx-box2d.jar
# Box2D native libraries
# wget "$URL/extensions/gdx-box2d/arm64-v8a/libgdx-box2d.so" -O lib/arm64-v8a/libgdx-box2d.so
# wget "$URL/extensions/gdx-box2d/armeabi/libgdx-box2d.so" -O lib/armeabi/libgdx-box2d.so
# wget "$URL/extensions/gdx-box2d/armeabi-v7a/libgdx-box2d.so" -O lib/armeabi-v7a/libgdx-box2d.so
# wget "$URL/extensions/gdx-box2d/x86_64/libgdx-box2d.so" -O lib/x86_64/libgdx-box2d.so
# wget "$URL/extensions/gdx-box2d/x86/libgdx-box2d.so" -O lib/x86/libgdx-box2d.so

# Bullet
# wget "$URL/extensions/gdx-bullet/gdx-box2d.jar" -O libs/gdx-bullet.jar
# Bullet native libraries
# wget "$URL/extensions/gdx-bullet/arm64-v8a/libgdx-bullet.so" -O lib/arm64-v8a/libgdx-bullet.so
# wget "$URL/extensions/gdx-bullet/armeabi/libgdx-bullet.so" -O lib/armeabi/libgdx-bullet.so
# wget "$URL/extensions/gdx-bullet/armeabi-v7a/libgdx-bullet.so" -O lib/armeabi-v7a/libgdx-bullet.so
# wget "$URL/extensions/gdx-bullet/x86_64/libgdx-bullet.so" -O lib/x86_64/libgdx-bullet.so
# wget "$URL/extensions/gdx-bullet/x86/libgdx-bullet.so" -O lib/x86/libgdx-bullet.so

# Freetype
# wget "$URL/extensions/gdx-freetype/gdx-freetype.jar" -O libs/gdx-freetype.jar
# Freetype native libraries
# wget "$URL/extensions/gdx-freetype/arm64-v8a/libgdx-freetype.so" -O lib/arm64-v8a/libgdx-freetype.so
# wget "$URL/extensions/gdx-freetype/armeabi/libgdx-freetype.so" -O lib/armeabi/libgdx-freetype.so
# wget "$URL/extensions/gdx-freetype/armeabi-v7a/libgdx-freetype.so" -O lib/armeabi-v7a/libgdx-freetype.so
# wget "$URL/extensions/gdx-freetype/x86_64/libgdx-freetype.so" -O lib/x86_64/libgdx-freetype.so
# wget "$URL/extensions/gdx-freetype/x86/libgdx-freetype.so" -O lib/x86/libgdx-freetype.so


