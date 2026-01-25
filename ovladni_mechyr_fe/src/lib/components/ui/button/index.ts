import Root from './button.svelte';
import { tv, type VariantProps } from 'tailwind-variants';
import type { Button as ButtonPrimitive } from 'bits-ui';

const buttonVariants = tv({
  base: 'ring-offset-background focus-visible:ring-ring inline-flex items-center justify-center min-w-fit rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50',
  variants: {
    variant: {
      default:
        'bg-primary text-primary-foreground hover:text-secondary hover:outline hover:outline-secondary',
      destructive: 'bg-destructive text-destructive-foreground hover:bg-destructive/90',
      outline:
        'border-primary bg-background text-primary hover:outline hover:outline-secondary hover:text-accent-foreground border',
      secondary: 'bg-secondary text-secondary-foreground hover:bg-secondary/80',
      ghost: 'hover:outline hover:outline-secondary/30 hover:text-primary',
      link: 'text-primary underline-offset-4 hover:underline',
      input:
        'border border-input bg-background placeholder:text-muted-foreground aria-[invalid]:border-destructive',
      none: '',
    },
    size: {
      default: 'min-h-10 px-4 py-2',
      sm: 'min-h-9 rounded-md px-3',
      lg: 'min-h-11 rounded-md px-8',
      icon: 'h-10 w-10',
      iconSm: 'h-9 w-9',
      iconXs: 'h-8 w-8',
      icon2xs: 'h-7 w-7',
      none: '',
    },
  },
  defaultVariants: {
    variant: 'default',
    size: 'default',
  },
  compoundVariants: [
    {
      variant: 'input',
      size: 'default',
      class: 'px-3',
    },
  ],
});

type Variant = VariantProps<typeof buttonVariants>['variant'];
type Size = VariantProps<typeof buttonVariants>['size'];

type Props = ButtonPrimitive.Props & {
  variant?: Variant;
  size?: Size;
};

type Events = ButtonPrimitive.Events;

export {
  Root,
  type Props,
  type Events,
  //
  Root as Button,
  type Props as ButtonProps,
  type Events as ButtonEvents,
  buttonVariants,
};
