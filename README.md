# libGDX on Termux
This is a simple game written in Java using libGDX for Android with the intention to be built from Android using [Termux](https://termux.com)

## Features
- The game is based on the [libgdx wiki Drop example](https://libgdx.com/wiki/start/a-simple-game).
- An ExceptionHandler is provided so crashes will write the stacktrace in a file within `/sdcard` this makes debugging easier when you don't have a computer to access logcat.
- Game is fullscreen, including an additional value that also covers the notch area on Android 9+ (see `res/values-v28`)

## Getting Started
The first step is to install a few tools we are gonna need
```sh
$ pkg install git ecj dx apksigner aapt unzip openjdk-17
```
Then clone this repository
```sh
$ git clone https://github.com/ravener/libgdx-termux
$ cd libgdx-termux
```
First we need to fetch the gdx libraries, this only needs to be done once:
```sh
$ ./fetch.sh
```

There are a few more tools you can use with libgdx (e.g Box2D) those are optional but you can edit the script and uncomment those lines if you desire those libraries for your project.

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

Now you will see huge improvements in the compile time when using `build.sh`

### Updating
When updating the gdx libraries start by deleting the lib folders
```sh
$ rm -rf lib/ libs/
```
> **Note:** If you added your own `.jar` files, take care to backup them or just manually delete the gdx libraries only.

edit `fetch.sh` and bump any versions you want and run `./fetch.sh`

also run `./predex.sh` again for caching the dex files.

## The Notch
The notch area or also known as the display cutout is supported by default in this template, the game will be full screen to cover the notch area.

This is meant to give you a starter on how to do it but you may not want it for your game, for example if you are heavily relying on the screen borders, on some phones with rounded edges the corners can hide some parts of what you render.

If you would like to disable it and let android render your screen below the notch area simply remove the `res/values-v28/styles.xml` file.

## The Exception Handler
The template comes with an `ExceptionHandler.java` which is applied in `AndroidLauncher.java` it replaces the default uncaught exception handler to redirect the error to a text file within `/sdcard` this allows you to easily go to your file manager and open the log file to read the crash if you don't have access to a computer to view logcat.

Please note that in order for this to work, storage permissions are required.

Starting from Android 6+ apps must request storage permissions via a dialog which has not been implemented here because it's just an example debugging tool and not really meant to be published in the end. So you will need to go to the app's settings and manually grant the `Storage` permission to make use of this.

## Moving Forward
This project is supposed to act like a starter template to get you running quickly, now it's up to you what you do with it, add more libraries, assets, resources and get creative.

The scripts are fully commented to help you modify it as you see fit.

Feel free to contribute any useful changes to the scripts or the project layout.

### TODO
Some additional things I'd like to work on:

- [ ] Desktop support. Create `.jar` files runnable on desktop too.
- [ ] Ant file. Allow the option for users to use `ant` if they wish

## Credits
Game is based on the [example from libGDX wiki](https://libgdx.com/wiki/start/a-simple-game) and I do not own the assets provided.

Assets credits:

  * water drop sound by junggle, see <http://www.freesound.org/people/junggle/sounds/30341/>
  * rain by acclivity, see <http://www.freesound.org/people/acclivity/sounds/28283/>
  * droplet sprite by mvdv, see <https://www.box.com/s/peqrdkwjl6guhpm48nit>
  * bucket sprite by mvdv, see <https://www.box.com/s/605bvdlwuqubtutbyf4x>
