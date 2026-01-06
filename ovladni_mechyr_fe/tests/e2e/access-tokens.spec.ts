import { test, expect } from '$tests/e2e/fixtures';
import { expireAccessToken } from '$tests/e2e/utils';

test.describe('should not redirect on expired access token', () => {
  test('page with one request', async ({ restrictedPage: { page } }) => {
    await expireAccessToken(page);
    const requestPromise = page.waitForRequest(/\/api\/v1\/refresh$/);
    await page.reload();
    await requestPromise;

    await expect(page.getByRole('heading', { level: 1 })).toBeVisible();
  });
});
