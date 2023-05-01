# Zapp

A menu bar application that decodes QR codes from the screen.

![screenshot_cn](https://raw.githubusercontent.com/liopoos/Zapp/master/Screenshots/screenshot_cn.png)

## System Requirements

macOS 11 or later.

## Installation

#### Install from Releases

- Download the DMG file from Releases
- Drag the .app file into the Application folder

##### Signature issue ⚠️

Zapp is open source software and is safe, but due to Apple's strict inspection mechanism, you may encounter warning interception when opening it.

If you cannot open it, please refer to the Apple manual [Open a Mac app from an unidentified developer](https://support.apple.com/en-us/guide/mac-help/mh40616/mac), or perform local code signing.

**Local code signing for macOS**

Install Command Line Tools:

```bash
xcode-select --install
```

Open the terminal and execute:

```bash
sudo codesign --force --deep --sign - /Applications/Zapp.app/
```

"replacing existing signature" indicates successful local signing.

#### Build it yourself

1. Clone this project:

```bash
git clone https://github.com/liopoos/Zapp.git
```

1. Open `Zapp.xcworkspace` with Xcode and build it yourself.

## Usage

Zapp is a menu bar application, so you need to click the menu bar icon button to operate it. Zapp currently provides three ways to decode QR codes:

| Method              | Shortcut | Description                                                  |
| ------------------- | -------- | ------------------------------------------------------------ |
| From screen capture | ⌘+X      | Capture the screen QR code through the system screenshot application |
| From clipboard      | ⌘+C      | Decode the image from the clipboard                          |
| From iPhone or iPad | ⌘+Q      | Use the "Continuity Camera" API to call the camera of the iPhone or iPad under the same iCloud to take a photo |

#### Security

Zapp saves the decoded content locally and the application itself does not perform any network connection.

## Todo

- [ ]  Support exporting history records

## License

©MIT
