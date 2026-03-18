const NATIVE_APP = "open_in_browser";
const DEFAULT_BROWSER = "Helium";

const processingTabs = new Set();

async function redirectMeetTab(tabId, url) {
  if (processingTabs.has(tabId)) return;
  processingTabs.add(tabId);

  console.log(`[OpenMeetIn] Detected Meet URL: ${url}`);

  try {
    const { selectedBrowser } = await browser.storage.local.get("selectedBrowser");
    const targetBrowser = selectedBrowser || DEFAULT_BROWSER;
    console.log(`[OpenMeetIn] Sending to native host, browser=${targetBrowser}`);

    const response = await browser.runtime.sendNativeMessage(NATIVE_APP, {
      url: url,
      browser: targetBrowser,
    });

    console.log("[OpenMeetIn] Native host response:", JSON.stringify(response));

    if (response && response.status === "ok") {
      try {
        await browser.tabs.remove(tabId);
        console.log("[OpenMeetIn] Tab closed");
      } catch (e) {
        console.warn("[OpenMeetIn] Could not close tab:", e.message);
      }
    } else {
      console.error("[OpenMeetIn] Native host returned error:", response);
    }
  } catch (err) {
    console.error("[OpenMeetIn] Failed:", err.message, err);
  } finally {
    processingTabs.delete(tabId);
  }
}

browser.webNavigation.onBeforeNavigate.addListener(
  (details) => {
    if (details.frameId !== 0) return;
    redirectMeetTab(details.tabId, details.url);
  },
  { url: [{ hostEquals: "meet.google.com" }] }
);

browser.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
  if (changeInfo.url && changeInfo.url.includes("meet.google.com/")) {
    redirectMeetTab(tabId, changeInfo.url);
  }
});
