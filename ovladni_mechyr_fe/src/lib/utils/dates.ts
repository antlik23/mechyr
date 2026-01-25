import { parseTime, parseDateTime } from '@internationalized/date';
import { trimEnd } from 'es-toolkit';

export function ensureLeadingZero(value: number, maxLength = 2) {
  return value.toString().padStart(maxLength, '0');
}

export function getDateString(date: string) {
  const localDate = new Date(date);
  const year = ensureLeadingZero(localDate.getFullYear());
  const month = ensureLeadingZero(localDate.getMonth() + 1);
  const day = ensureLeadingZero(localDate.getDate());

  return `${year}-${month}-${day}`;
}

export function getTimeString(date: string) {
  const localDate = new Date(date);
  const hours = ensureLeadingZero(localDate.getHours());
  const minutes = ensureLeadingZero(localDate.getMinutes());
  const seconds = ensureLeadingZero(localDate.getSeconds());

  return `${hours}:${minutes}:${seconds}`;
}

export function getTimeValues(time: string): Record<'hour' | 'minute', number | undefined> {
  time = trimEnd(time, 'Z');

  let hour: number | undefined;
  let minute: number | undefined;
  try {
    ({ hour, minute } = parseTime(time));
  } catch {
    ({ hour, minute } = parseDateTime(time));
  }

  return {
    hour,
    minute,
  };
}

export function formatTime(time: ReturnType<typeof getTimeValues>) {
  if (time.hour === undefined || time.minute === undefined) return '';

  const hour = ensureLeadingZero(time.hour);
  const minute = ensureLeadingZero(time.minute);

  return `${hour}:${minute}:00`;
}
