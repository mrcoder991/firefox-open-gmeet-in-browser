const select = document.getElementById("browser-select");
const status = document.getElementById("status");

browser.storage.local.get("selectedBrowser").then(({ selectedBrowser }) => {
  if (selectedBrowser) {
    select.value = selectedBrowser;
  }
});

select.addEventListener("change", () => {
  const chosen = select.value;
  browser.storage.local.set({ selectedBrowser: chosen }).then(() => {
    status.textContent = `Saved — Meet links will open in ${chosen}`;
    setTimeout(() => {
      status.textContent = "";
    }, 2000);
  });
});
