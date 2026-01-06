import { expect, test } from 'vitest';
import { getDuration } from '$lib/utils';

test('should round up to full minute', () => {
  expect(getDuration(0)).toStrictEqual({ hours: 0, minutes: 1, seconds: 0 });

  expect(getDuration(47)).toStrictEqual({ hours: 0, minutes: 1, seconds: 0 });

  expect(getDuration(167)).toStrictEqual({ hours: 0, minutes: 3, seconds: 0 });

  expect(getDuration(3223)).toStrictEqual({ hours: 0, minutes: 54, seconds: 0 });

  expect(getDuration(4400)).toStrictEqual({ hours: 1, minutes: 14, seconds: 0 });
});

test('should not round up to full minute based on options', () => {
  const options = { roundUpSeconds: false };

  expect(getDuration(0, options)).toStrictEqual({ hours: 0, minutes: 0, seconds: 0 });

  expect(getDuration(47, options)).toStrictEqual({ hours: 0, minutes: 0, seconds: 47 });

  expect(getDuration(167, options)).toStrictEqual({ hours: 0, minutes: 2, seconds: 47 });

  expect(getDuration(3223, options)).toStrictEqual({ hours: 0, minutes: 53, seconds: 43 });

  expect(getDuration(4400, options)).toStrictEqual({ hours: 1, minutes: 13, seconds: 20 });
});

test('should roll over to new hour when rounding up', () => {
  expect(getDuration(3555)).toStrictEqual({ hours: 1, minutes: 0, seconds: 0 });

  expect(getDuration(7141)).toStrictEqual({ hours: 2, minutes: 0, seconds: 0 });
});
