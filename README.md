# Open Meet In... — Firefox / Zen Extension

A Firefox Browser extension that automatically redirects Google Meet links to a browser of your choice (Helium, Zen, Arc, Brave, Chrome, or Safari).

When you open any `meet.google.com` link in Firefox, it opens in your selected browser instead and closes the Firefox tab.

Also works with Firefox since Firefox is Firefox-based.

## Requirements

- macOS (Not tested on Windows or Linux, Contributions are welcome)
- Firefox Browser
- Python 3

## Setup

### 1. Install the native messaging host

```bash
./install.sh
```

This registers a small helper script that Firefox uses to launch URLs in external browsers.

### 2. Load the extension in Firefox Browser

1. Open Firefox and navigate to `about:debugging#/runtime/this-firefox`
2. Click **Load Temporary Add-on...**
3. Select `extension/manifest.json` from this project

### 3. Pick your browser

Click the extension icon in the toolbar and select your preferred browser from the dropdown.

## How it works

1. The extension monitors navigation events for `meet.google.com`
2. When a Meet link is detected, it sends the URL to a native messaging host (a Bash script)
3. The native host launches the URL using macOS `open -a "BrowserName" <url>`
4. The extension closes the tab

## Supported browsers

| Name           | macOS app name     |
|----------------|--------------------|
| Helium         | `Helium`           |
| Zen            | `Zen`              |
| Arc            | `Arc`              |
| Brave Browser  | `Brave Browser`    |
| Google Chrome  | `Google Chrome`    |
| Safari         | `Safari`           |

Any other browser Not tested but should work.

## Uninstall

Remove the native messaging host manifest:

```bash
rm ~/Library/Application\ Support/Mozilla/NativeMessagingHosts/open_in_browser.json
```

Then remove the extension from `about:addons` in Zen.
