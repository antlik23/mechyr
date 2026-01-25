<script lang="ts">
  import { Toaster as Sonner, type ToasterProps as SonnerProps } from 'svelte-sonner';

  type $$Props = SonnerProps;
</script>

<Sonner
  class="toaster group"
  closeButton={true}
  position="top-center"
  richColors={true}
  toastOptions={{
    classes: {
      toast:
        'group toast group-[.toaster:not([data-rich-colors="true"])]:bg-background group-[.toaster:not([data-rich-colors="true"])]:text-foreground group-[.toaster:not([data-rich-colors="true"])]:border-border group-[.toaster]:shadow-lg',
      description: 'group-[.toast]:text-muted-foreground',
      actionButton:
        'group-[.toast]:data-[button]:bg-primary group-[.toast]:data-[button]:text-primary-foreground group-[.toast]:data-[button]:transition-colors group-[.toast]:data-[button]:hover:bg-primary/90',
      cancelButton: 'group-[.toast]:bg-muted group-[.toast]:text-muted-foreground',
      closeButton: 'bg-background',
    },
  }}
  {...$$restProps}
/>
