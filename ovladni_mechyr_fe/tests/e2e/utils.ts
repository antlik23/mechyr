import type { CurrentUser } from '$lib/components/user/types';
import { expect, type Page } from '@playwright/test';

const localStorageKey = 'user-data';

function extractPersistedUser() {
  const user = localStorage.getItem(localStorageKey);
  expect(user).not.toBeNull();

  const userData: CurrentUser = JSON.parse(String(user));

  return userData;
}

function savePersistedUser(userData: CurrentUser) {
  localStorage.setItem(localStorageKey, JSON.stringify(userData));
}

export async function expireAccessToken(page: Page) {
  await page.evaluate(() => {
    const userData = extractPersistedUser();

    userData.access_token = userData.access_token.slice(1);

    savePersistedUser(userData);
  });
}

export async function expireRefreshToken(page: Page) {
  await page.evaluate(() => {
    const userData = extractPersistedUser();

    userData.refresh_token = userData.refresh_token.slice(1);

    savePersistedUser(userData);
  });
}
