import { clsx, type ClassValue } from 'clsx';
import { cubicOut } from 'svelte/easing';
import type { TransitionConfig } from 'svelte/transition';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

type FlyAndScaleParams = {
  y?: number;
  x?: number;
  start?: number;
  duration?: number;
};

export const flyAndScale = (
  node: Element,
  params: FlyAndScaleParams = { y: -8, x: 0, start: 0.95, duration: 150 }
): TransitionConfig => {
  const style = getComputedStyle(node);
  const transform = style.transform === 'none' ? '' : style.transform;

  const scaleConversion = (valueA: number, scaleA: [number, number], scaleB: [number, number]) => {
    const [minA, maxA] = scaleA;
    const [minB, maxB] = scaleB;

    const percentage = (valueA - minA) / (maxA - minA);
    const valueB = percentage * (maxB - minB) + minB;

    return valueB;
  };

  const styleToString = (style: Record<string, number | string | undefined>): string => {
    return Object.keys(style).reduce((str, key) => {
      if (style[key] === undefined) return str;
      return str + `${key}:${style[key]};`;
    }, '');
  };

  return {
    duration: params.duration ?? 200,
    delay: 0,
    css: (t) => {
      const y = scaleConversion(t, [0, 1], [params.y ?? 5, 0]);
      const x = scaleConversion(t, [0, 1], [params.x ?? 0, 0]);
      const scale = scaleConversion(t, [0, 1], [params.start ?? 0.95, 1]);

      return styleToString({
        transform: `${transform} translate3d(${x}px, ${y}px, 0) scale(${scale})`,
        opacity: t,
      });
    },
    easing: cubicOut,
  };
};

export function debounce<T extends (...args: Parameters<T>) => void>(
  this: ThisParameterType<T>,
  fn: T,
  delay = 300
) {
  let timer: ReturnType<typeof setTimeout> | undefined;

  return (...args: Parameters<T>) => {
    clearTimeout(timer);
    timer = setTimeout(() => fn.apply(this, args), delay);
  };
}

export function getMonthsDifferenceBetweenDates(dateFrom: Date, dateTo: Date) {
  return (
    dateTo.getMonth() - dateFrom.getMonth() + 12 * (dateTo.getFullYear() - dateFrom.getFullYear())
  );
}

export function getDuration(
  seconds: number,
  options: { roundUpSeconds: boolean } = { roundUpSeconds: true }
) {
  let durationHours = Math.floor(seconds / 60 / 60);
  let durationMinutes = Math.floor(seconds / 60) - durationHours * 60;
  let durationSeconds = seconds % 60;

  if (options.roundUpSeconds) {
    durationSeconds = 0;
    durationMinutes++;

    if (durationMinutes >= 60) {
      durationMinutes = 0;
      durationHours++;
    }
  }

  return { hours: durationHours, minutes: durationMinutes, seconds: durationSeconds };
}

function fixCzechText(text: string): string {
  return text
    .replace(/(?<=\s|^)([ksvzouiia])\s+(?=\S)/gi, '$1\u00A0')
    .replace(/(?<=\s|^)(po|do|na|od|ke|ve|ze)\s+(?=\S)/gi, '$1\u00A0');
}

export function updateTextNodes() {
  const elements = document.querySelectorAll('p, li');

  elements.forEach((element) => {
    element.childNodes.forEach((node) => {
      if (node.nodeType === Node.TEXT_NODE) {
        const text = node.textContent || '';
        node.textContent = fixCzechText(text);
      }
    });
  });
}
