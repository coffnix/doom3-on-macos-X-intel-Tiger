# Doom 3 Mac Intel Tiger No-CD Launcher

A simple GDB-based launcher that bypasses the **physical DVD verification** performed by the original Aspyr launcher for **Doom 3 1.3.1 Rev A** on **Mac OS X 10.4 Tiger (Intel)**.

This launcher **does not remove the game's copy protection** or modify any game files. It simply forces the built-in DVD verification routine to succeed, allowing the original executable to continue loading.

**Important:** the original Doom 3 DVD image **must still be mounted**, since the game may access data directly from the mounted disc image during startup.

## Features

- No binary patching required
- Original executable remains untouched
- Uses Apple GDB
- Works with the original Aspyr Universal Binary
- Requires the original DVD image to be mounted

## Requirements

- Mac OS X 10.4 Tiger (Intel)
- Apple GDB
- Original **Doom 3 for Macintosh** DVD image mounted
- **Doom 3 1.3.1 Rev A** update installed (https://www.moddb.com/downloads/doom-3-131-macos-intel-powerpc)

## Getting the game

### 1. Original DVD image

Download the original Doom 3 Macintosh DVD image from:

https://archive.org/details/Doom_3_for_Macintosh_-_See_ReadMe_Id_Software/

Mount the image before launching the game.

### 2. Serial number

A valid Doom 3 serial number is required during installation.

You will need to obtain one yourself.

### 3. Intel update

Install the **doom3mac1.3.1reva.dmg** update, which contains the Universal Binary required to run on Intel Macs.

You will need to locate this update yourself.

## Mount the DVD image

Before running `start.sh`, mount the original Doom 3 DVD image:

```bash
hdiutil attach "Doom 3 for Macintosh DVD.toast"
```

After the image is mounted, start the launcher:

```bash
chmod +x start.sh
./start.sh
```

## Usage

```bash
chmod +x start.sh
./start.sh
```

## How it works

During startup, the Aspyr launcher performs a DVD verification.

Internally it executes logic equivalent to:

```cpp
if (!checkDVD()) {
    Sys_Quit();
}
```

`start.sh` launches the original executable through GDB and changes the return value of the DVD verification routine from `0` (failure) to `1` (success), allowing the launcher to continue normally.

No executable files are modified.

## Legal

This project does **not** contain:

- Doom 3 game files
- executable patches
- serial numbers
- copyrighted assets

It only provides a launcher script that starts the original game executable through GDB.
