const { existsSync, rmSync } = require('node:fs');
const puppeteer = require('puppeteer');

const NCA_LAYER_HOMEPAGE = 'https://ncl.pki.gov.kz/eng/';
const NCA_LAYER_TEXT = 'NCALayer for Linux';
const NCA_LAYER_XPATH = `//*[contains(text(),'${NCA_LAYER_TEXT}')]`;
const NCA_LAYER_ARCHIVE_PATH = 'ncalayer.zip';

const TIMEOUT = 60 * 60 * 1000; // 1 hour.
const FILE_POLL_TIMEOUT = 10 * 1000; // 10 seconds.

(async () => {
  const browser = await puppeteer.launch({
    executablePath: '/usr/bin/chromium',
    headless: false,
    args: [
      '--enable-features=UseOzonePlatform',
      '--ozone-platform=wayland',
      '--disable-dev-shm-usage',
      '--disabled-setupid-sandbox',
      '--no-sandbox',
      '--start-maximized',
    ],
    defaultViewport: null,
    timeout: TIMEOUT,
    protocolTimeout: TIMEOUT,
  });
  const page = await browser.newPage();

  const pageOptions = { timeout: TIMEOUT, waitUntil: 'domcontentloaded' };
  await page.goto(NCA_LAYER_HOMEPAGE, pageOptions);

  // Removing NCA layer zip.
  rmSync(NCA_LAYER_ARCHIVE_PATH, { force: true });

  // Downloading file to current directory.
  const client = await page.target().createCDPSession();
  await client.send('Page.setDownloadBehavior', {
    behavior: 'allow',
    downloadPath: process.env.PWD
  });

  // Clicking on button to download NCALayer.
  const button = await page.waitForXPath(NCA_LAYER_XPATH, { timeout: TIMEOUT });
  await button.click();

  // Waiting until file will be downloaded.
  await new Promise((resolve) => {
    const interval = setInterval(() => {
      if (existsSync(NCA_LAYER_ARCHIVE_PATH)) {
        clearInterval(interval);
        resolve();
      }
    }, FILE_POLL_TIMEOUT);
  });
  await browser.close();
})();
