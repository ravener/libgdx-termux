# libGDX on Termux
This is a simple game written in Java using libGDX for Android with the intention to be built from Android using [Termux](https://termux.com)

## Features
- The game is based on the [libgdx wiki Drop example](https://libgdx.com/wiki/start/a-simple-game).
- An ExceptionHandler is provided so crashes will write the stacktrace in a file within `/sdcard` this makes debugging easier when you don't have a computer to access logcat.
- Game is fullscreen, including an additional value that also covers the notch area on Android 9+ (see `res/values-v28`)

## Getting Started
The first step is to install a few tools we are gonna need
```sh
$ pkg install git ecj dx apksigner aapt
```
Then clone this repository
```sh
$ git clone https://github.com/ravener/libgdx-termux
$ cd libgdx-termux
```
First we need to fetch the gdx libraries, this only needs to be done once or whenever you want to update them.
```sh
$ ./fetch.sh
```
> **Note:** The script fetches the latest **nightlies**

There are a few more tools you can use with libgdx, e.g box2d those are optional but you can edit the script and uncomment those lines if you desire those libraries for your project.

Next generate a keystore so we can sign the apk, which is required otherwise Android won't allow us to install the apk.
```
keytool -genkeypair -validity 365 -keystore game.keystore -keyalg RSA -keysize 2048
```
Just answer the questions and enter a password and you will be done.

The script assumes the filename to be `game.keystore` and the password to be `android`, edit the `build.sh` script to change as needed.

Now that we have our keystore and all libraries we can proceed to the build:
```sh
$ ./build.sh
```
This will build the apk and also copy it into `/sdcard/APKs` so you can easily install it from your file manager afterwards.

### Bonus Optimization
At first the script compiles the `.jar` files from `./libs` everytime it's invoked, that wastes a lot of time and resources, we can compile them once, store the dex, and when building the main project just combine those cached dex files.

It is possible to optimize this, the script already looks for a special directory called `libs/dex/` which can store cached dex files and if it finds it, it will only include everything from there and ignore the raw jar files.

A script has been provided to predex all the jar files for faster compilation, run that once:
```sh
$ ./predex.sh
```
> **Tip:** You should run this again if you ever run `fetch.sh` again to update the libraries.

Now you will see huge improvements in the compile time when using `build.sh`

## Moving Forward
This project is supposed to act like a starter template to get you running quickly, now it's up to you what you do with it, add more libraries, assets, resources and get creative.

The scripts are fully commented to help you modify it as you see fit.

Feel free to contribute any useful changes to the scripts or the project layout.

## Credits
Game is based on the [example from libGDX wiki](https://libgdx.com/wiki/start/a-simple-game) and I do not own the assets provided.
