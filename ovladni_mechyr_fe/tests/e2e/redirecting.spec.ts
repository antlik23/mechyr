import { test, expect } from '@playwright/test';

test.describe('redirect from root to login', () => {
  const defaultLanguageTag = 'en';
  test('should redirect to default language login', async ({ page }) => {
    await page.goto('/');
    await expect(page).toHaveURL(`/${defaultLanguageTag}/login`);
    await page.goto(`/${defaultLanguageTag}`);
    await expect(page).toHaveURL(`/${defaultLanguageTag}/login`);
  });
});
