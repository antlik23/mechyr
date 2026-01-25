<script lang="ts">
  import { page } from '$app/stores';
  import Button from '$lib/components/common/Button.svelte';
  import { currentUser, logout } from '$lib/components/user/data';
  import { menuLinks } from '$lib/stores/menuLinks';
  import { cn } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import { LogOutIcon, MailIcon, PhoneIcon } from 'lucide-svelte';
  import { mediaQuery } from 'svelte-legos';
  import type { HTMLAttributes } from 'svelte/elements';
  import Icon from '../wrappers/Icon.svelte';

  let className: HTMLAttributes<HTMLDivElement>['class'] = undefined;
  export { className as class };
  export let isMobileMenuOpen: boolean;

  const isLargeScreen = mediaQuery('(min-width: 640px)');

  function handleMenuLinkClick() {
    isMobileMenuOpen = false;
  }
</script>

<aside
  class={cn(
    'flex flex-col border-r px-4 py-2 transition-transform',
    // Responsiveness.
    'absolute left-0 top-0 z-30 h-full w-4/5 -translate-x-full bg-background sm:w-1/2 md:w-2/5 lg:static lg:z-auto lg:h-auto lg:w-auto lg:translate-x-0 lg:bg-muted/40',
    // Before.
    'before:absolute before:inset-0 before:bg-muted/40 before:lg:hidden',
    isMobileMenuOpen && 'translate-x-0',
    className
  )}
>
  <nav class="z-10 flex-grow lg:z-auto">
    {#if !$isLargeScreen && $currentUser.isPatient}
      <div class="mb-4"><strong>ID</strong>: {$currentUser.patient_public_id}</div>
    {/if}
    <ul class="sticky top-0">
      {#each $menuLinks as menuLink}
        {@const isActive = $page.url.pathname.startsWith(menuLink.link)}

        <li>
          <Button
            class={cn(
              'relative justify-start gap-3',
              isActive &&
                'text-primary before:absolute before:bottom-0 before:left-0 before:top-0 before:block before:w-1 before:bg-accent',
              !isActive && 'text-blue-light-800 hover:text-primary'
            )}
            href={menuLink.link}
            prependIcon={menuLink.icon}
            prependIconProps={{ class: 'size-4 [&_svg]:size-[inherit]' }}
            variant="none"
            on:click={handleMenuLinkClick}
          >
            {menuLink.text}
          </Button>
        </li>
      {/each}

      {#if !$isLargeScreen}
        <li>
          <Button
            class="justify-start gap-3 text-blue-light-800 hover:bg-blue-light-50"
            prependIcon={LogOutIcon}
            prependIconProps={{ class: 'size-4 [&_svg]:size-[inherit]' }}
            variant="none"
            on:click={() => logout()}
          >
            {m.logout()}
          </Button>
        </li>
      {/if}
    </ul>
  </nav>

  <div class="sticky bottom-0 pb-4">
    <h3 class="text-md mb-1 font-semibold text-primary">Helpdesk</h3>

    <a
      class="flex items-center gap-2 text-sm transition-colors hover:text-primary"
      href="tel:+420770171533"
    >
      <Icon icon={PhoneIcon} size="20" />
      +420 770 171 533
    </a>

    <a
      class="flex items-center gap-2 text-sm transition-colors hover:text-primary"
      href="mailto:podpora.nsc@uzis.cz"
    >
      <Icon icon={MailIcon} size="20" />
      podpora.nsc@uzis.cz
    </a>
  </div>
</aside>
