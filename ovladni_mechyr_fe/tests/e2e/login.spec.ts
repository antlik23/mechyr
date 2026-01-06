import { test, expect } from './fixtures';

test("should show role's name", async ({
  restrictedPage: {
    page,
    userData: { user },
  },
}) => {
  for (const role of user.roles) {
    if (role === 'admin') {
      await page.getByTestId('header-user-dropdown').click();
      await expect(
        page.getByTestId('header-user-dropdown-menu').filter({ hasText: 'Admin' })
      ).toBeVisible();
      await page.getByTestId('header-user-dropdown').click();
    }
  }
});

test.describe('redirect to default page', () => {
  test('should redirect after login', async ({
    restrictedPage: {
      page,
      userData: { user },
    },
  }) => {
    for (const role of user.roles) {
      if (role === 'admin') {
        await expect(page).toHaveURL('/en/contracts');
      }
    }
  });

  test('should redirect from root', async ({
    restrictedPage: {
      page,
      userData: { user },
    },
  }) => {
    for (const role of user.roles) {
      if (role === 'admin') {
        await page.goto('/');
        await expect(page).toHaveURL('/en/contracts');
      }
    }
  });

  test('should redirect from language tag', async ({
    restrictedPage: {
      page,
      userData: { user },
    },
  }) => {
    for (const role of user.roles) {
      if (role === 'admin') {
        await page.goto('/en');
        await expect(page).toHaveURL('/en/contracts');
      }
    }
  });
});
