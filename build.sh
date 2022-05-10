#!/data/data/com.termux/files/usr/bin/sh -e
# Build APK on Termux script by ravener
# https://github.com/ravener
now=`date +%Y%m%d%s`

# Create some directories
if [ ! -d "./bin" ]; then
  mkdir ./bin
fi

if [ ! -d "./assets" ]; then
  mkdir ./assets
fi

if [ ! -d "./res" ]; then
  mkdir ./res
fi

if [ ! -d "/sdcard/APKs" ]; then
  mkdir /sdcard/APKs
fi

echo "[aapt] Generating R.java"
# So first we generate R.java which allows us to access our
# resources from ./res
aapt package -v -f \
             -M ./AndroidManifest.xml \
             -I $PREFIX/share/java/android.jar \
             -J src/main/java \
             -S res \
             -m

echo "[ecj] Compiling Java classes"

# Compile all files from src/main/java
# Output to ./obj
# Include the android sdk jar alongside all .jar files from ./libs
ecj -d ./obj -classpath "$HOME/../usr/share/java/android.jar:$(echo libs/*.jar | tr ' ' ':')" \
	     -sourcepath ./src/main/java $(find src -type f -name "*.java")

echo "[dx] Java classes to .dex"

# We allow an optional optimization here.
# If libs/dex exists, it contains already dexed jar files
# Which dx can just combine quickly, otherwise we have to compile
# the jar files which can be slow.
# For this we provide the script `predex.sh`
# Which will precompile all your .jar files
# It is highly recommended to do so as it
# improves compile time by a lot
if [ -d "./libs/dex" ]; then
  dx --dex --num-threads=4 --verbose \
    --output=./bin/game.apk ./obj ./libs/dex
else
  dx --dex --num-threads=4 --verbose \
    --output=./bin/game.apk ./obj ./libs/*.jar
fi

echo "[aapt] Package the apk"
# A very important message to script hackers:
# This could've been run earlier to make the apk then
# place the dex files into it which is the traditional way
# other "how to make apk from cli" tutorials would show
# I, here, created the apk from the dx command first
# Reason is because dx will forward other files too!
# This is very important, even our libgdx jar contains some files,
# dx automatically added them to our apk, so now we use aapt
# with -f flag to overwrite existing apk and just package
# our resources, assets and AndroidManifest.xml
aapt package -v -f \
             -M ./AndroidManifest.xml \
             -S ./res \
             -A ./assets \
             -u -F bin/game.apk


# Add native libraries.
# Check if the architecture directory exists then add all .so files

if [ -d "./lib/armeabi" ]; then
  aapt add -f bin/game.apk lib/armeabi/*.so
fi

if [ -d "./lib/armeabi-v7a" ]; then
  aapt add -f bin/game.apk lib/armeabi-v7a/*.so
fi

if [ -d "./lib/arm64-v8a" ]; then
  aapt add -f bin/game.apk lib/arm64-v8a/*.so
fi

if [ -d "./lib/x86_64" ]; then
  aapt add -f bin/game.apk lib/x86_64/*.so
fi

if [ -d "./lib/x86" ]; then
  aapt add -f bin/game.apk lib/x86/*.so
fi

cd bin
echo "[zipalign] Zip Aligning the APK"
zipalign -f -v 4 game.apk game.aligned.apk

echo "Sign step2.apk"
apksigner sign --ks ../game.keystore --ks-pass "pass:android" game.aligned.apk

chmod 644 game.apk

# Attempt to copy the apk into sdcard for easy installation.
echo "APK ready, attempting to copy to /sdcard for easy installation."
cp game.aligned.apk /sdcard/APKs/game$now.apk
echo "Copied to /sdcard/APKs/game$now.apk"
echo "You can install game$now.apk from /sdcard/APKs/"
