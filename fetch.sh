#!/data/data/com.termux/files/usr/bin/bash

mkdir -p libs lib

# Base Download URL
URL="https://repo1.maven.org/maven2/com/badlogicgames/gdx"

# Versions (modify as needed)
#
# Note: some older gdx versions around 1.9 uses androidx
# which makes dependency resolution more complicated
# It is recommended to use newer versions which is lighter.
#
# Note: I assume box2d, bullet & freetype always have the same version
# as the base libgdx, they probably get updated at the same time
# or so it seems, so I use GDX_VERSION for them rather than
# defining BOX2D_VERSION etc. But correct me if I'm wrong.
GDX_VERSION="1.11.0" # gdx
JNIGEN_VERSION="2.3.1" # gdx-jnigen-loader
AI_VERSION="1.8.2" # gdx-ai
CONTROLLERS_VERSION="1.9.13" # gdx-controllers

# Fetch a .jar file and place it in libs/
function fetch() {
  TARGET="$URL/$1/$2/$1-$2.jar"
  echo -e "Downloading: \x1b[33m$1-$2.jar\x1b[0m"
  wget -nc $TARGET -O "libs/$1-$2.jar"
}

# Native files are distributed inside a .jar file
# We need to extract the .so files out of it and place it
# in our corresponding lib/ folder for use in android.
function native() {
  echo -e "Downloading: \x1b[33m$1-platform-$2-natives-$3.jar\x1b[0m"

  # Make sure the folder for the architecture exists.
  mkdir -p "lib/$3"

  # Temporary folder to store the .jar.
  # Make sure .temp doesn't exist, we need it to be clean.
  rm -rf .temp
  mkdir .temp

  # Download the file
  wget "$URL/$1-platform/$2/$1-platform-$2-natives-$3.jar" -O .temp/lib.jar

  # Unzip the jar inside the temporary directory.
  unzip -d .temp .temp/lib.jar

  # Move the .so file into the lib folder within the
  # corresponding architecture's folder
  mv .temp/*.so "lib/$3"

  # Delete the temporary directory
  rm -rf .temp
}

### ---------- Definitions ---------- ###
# All libraries are declared below.
#
# Feel free to remove any architectures you don't want to support
# For example phones normally don't have x86/64 and they are mostly
# used in emulators, you may remove them to save some space.
# arm64 devices can also run armeabi-v7a so that architecture
# should be the bare minimum you need to support.
#
# Simply comment or remove the lines you don't want.
# You can change the versions with the variables on top of the file.

# Base libGDX jar
fetch "gdx" $GDX_VERSION

# native libraries.
native "gdx" $GDX_VERSION "armeabi-v7a"
native "gdx" $GDX_VERSION "arm64-v8a"
native "gdx" $GDX_VERSION "x86_64"
native "gdx" $GDX_VERSION "x86"

# jnigen-loader (Required to load the native .so files)
fetch "gdx-jnigen-loader" $JNIGEN_VERSION

# Android backend
fetch "gdx-backend-android" $GDX_VERSION

### ----- Optional Dependencies ----- ###
# From here on, the dependencies are commented out by default.
# Uncomment them by removing the single '#' characters
# if you would like to use them in your project.

### --- gdx-ai --- ###
# fetch "gdx-ai" $AI_VERSION

### --- Box2D Physics --- ###
# fetch "gdx-box2d" $GDX_VERSION
#
# native "gdx-box2d" $GDX_VERSION "armeabi-v7a"
# native "gdx-box2d" $GDX_VERSION "arm64-v8a"
# native "gdx-box2d" $GDX_VERSION "x86_64"
# native "gdx-box2d" $GDX_VERSION "x86"

### --- gdx-controllers --- ###
# fetch "gdx-controllers" $CONTROLLERS_VERSION
# fetch "gdx-controllers-android" $CONTROLLERS_VERSION

### --- Bullet 3D Physics --- ###
# fetch "gdx-bullet" $GDX_VERSION
#
# native "gdx-bullet" $GDX_VERSION "armeabi-v7a"
# native "gdx-bullet" $GDX_VERSION "arm64-v8a"
# native "gdx-bullet" $GDX_VERSION "x86_64"
# native "gdx-bullet" $GDX_VERSION "x86"

### --- Freetype --- ###
# fetch "gdx-freetype" $GDX_VERSION
#
# native "gdx-freetype" $GDX_VERSION "armeabi-v7a"
# native "gdx-freetype" $GDX_VERSION "arm64-v8a"
# native "gdx-freetype" $GDX_VERSION "x86_64"
# native "gdx-freetype" $GDX_VERSION "x86"

# TODO: Potentially support desktop too. Fetch desktop libraries.
