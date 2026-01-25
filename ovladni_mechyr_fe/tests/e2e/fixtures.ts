import type { CurrentUser } from '$lib/components/user/types';
import { test as base, expect, type Page } from '@playwright/test';
import 'dotenv/config';

declare const process: {
  env: {
    TEST_USER_EMAIL: string;
    TEST_USER_PASSWORD: string;
  };
};

type Fixtures = {
  logOutAfterTest: boolean;
  restrictedPage: { page: Page; userData: CurrentUser };
};

export const test = base.extend<Fixtures>({
  logOutAfterTest: [true, { option: true }],
  restrictedPage: async ({ page, logOutAfterTest }, use) => {
    const errors: Error[] = [];

    page.on('pageerror', (error) => {
      errors.push(error);
    });

    await page.goto('/login');
    await expect(page).toHaveURL('/en/login');
    await page.getByPlaceholder('Enter your email').fill(process.env.TEST_USER_EMAIL);
    await page.getByPlaceholder('Enter your password').fill(process.env.TEST_USER_PASSWORD);
    await page.getByRole('button', { name: 'Login' }).click();
    await expect(page.getByRole('status')).toBeVisible();
    const headerUserDropdownButton = page.getByTestId('header-user-dropdown');
    await expect(headerUserDropdownButton).toBeVisible();

    const userData: CurrentUser = await page.evaluate(() =>
      JSON.parse(localStorage.getItem('user') ?? '')
    );

    await use({ page, userData });

    if (logOutAfterTest) {
      await headerUserDropdownButton.click();
      await page.getByTestId('header-user-dropdown-logout').click();
      await expect(page).toHaveURL('/en/login');
      await expect(page.getByRole('status').first()).toBeVisible();
    }

    expect(errors).toHaveLength(0);
  },
});

export { expect };
