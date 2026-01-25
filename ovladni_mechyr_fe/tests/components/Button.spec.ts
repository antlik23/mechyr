import type { ComponentProps } from 'svelte';
import type { SvgIcon } from '$lib/types/SvgIcon';
import type { ComponentEventKeys } from './utils';

import { test, expect } from '@playwright/experimental-ct-svelte';
import Button from '$lib/components/common/Button.svelte';
import PlusIcon from '$lib/assets/icons/plus.svg';

test('should have text and events', async ({ mount }) => {
  let clickHappened = false;
  let keyDownHappened = false;

  const events: Record<ComponentEventKeys<Button>, VoidFunction> = {
    click: () => (clickHappened = true),
    keydown: () => (keyDownHappened = true),
  };

  const component = await mount(Button, {
    on: events,
    slots: { default: 'Button' },
  });

  await expect(component).toContainText('Button');
  await component.click();
  await component.press('Space');
  expect(clickHappened).toBe(true);
  expect(keyDownHappened).toBe(true);
});

test('should have prepend icon', async ({ mount }) => {
  const props: ComponentProps<Button> = {
    prependIcon: PlusIcon as unknown as SvgIcon,
  };

  const component = await mount(Button, { slots: { default: 'Button' }, props });

  await expect(component).toContainText('Button');
  await expect(component.locator('svg')).toBeVisible();
});

test('should have append icon', async ({ mount }) => {
  const props: ComponentProps<Button> = {
    appendIcon: PlusIcon as unknown as SvgIcon,
  };

  const component = await mount(Button, { slots: { default: 'Button' }, props });

  await expect(component).toContainText('Button');
  await expect(component.locator('svg')).toBeVisible();
});

test('should have prepend and append icon', async ({ mount }) => {
  const props: ComponentProps<Button> = {
    prependIcon: PlusIcon as unknown as SvgIcon,
    appendIcon: PlusIcon as unknown as SvgIcon,
  };

  const component = await mount(Button, { slots: { default: 'Button' }, props });

  await expect(component).toContainText('Button');
  await expect(component.locator('svg')).toHaveCount(2);
});

test('should have only icon', async ({ mount, page }) => {
  const props: ComponentProps<Button> = {
    onlyIcon: PlusIcon as unknown as SvgIcon,
  };

  const component = await mount(Button, { slots: { popoverContent: 'Popover text' }, props });

  await expect(component).toBeEmpty();
  await expect(component.locator('svg')).toBeVisible();
  await expect(page.getByText('Popover text')).not.toBeVisible();
  await component.click();
  await expect(page.getByText('Popover text')).toBeVisible();
});
