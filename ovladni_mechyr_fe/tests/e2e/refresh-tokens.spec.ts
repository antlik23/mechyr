import { test, expect } from '$tests/e2e/fixtures';
import { expireAccessToken, expireRefreshToken } from '$tests/e2e/utils';

test.use({ logOutAfterTest: false });

test('should redirect to login on expired refresh token', async ({ restrictedPage: { page } }) => {
  await expect(page.getByRole('heading', { level: 1 })).toBeVisible();

  await expireAccessToken(page);
  await expireRefreshToken(page);

  await page.reload();
  await expect(page).toHaveURL('/en/login');
});
