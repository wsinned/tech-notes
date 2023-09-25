# PC Bio Unlock

## Purpose

PC Bio Unlock allows you to pair you Android phone with your Linux/Windows PC to allow you to use the biomentrics of the phone to unlock you PC. https://meis-apps.com/pc-bio-unlock

## Installation

On linux there is a dependency on Java and libcrypt.
For Manjaro/Arch:
```
sudo pacman -Syu jre-openjdk libxcrypt-compat
```

On your phone install the app from the Play Store: https://meis-apps.com/pc-bio-unlock

Download the application and move it to somewhere outside of the downloads folder, e.g. ~/.local/bin

## Configuration

Run the application:
```
cd ~/.local/bin
java -jar PCBioUnlock.jar com.meisapps.pcbiounlock.MainKt 

```

The Java application takes care of configuring and integrating the application service.
