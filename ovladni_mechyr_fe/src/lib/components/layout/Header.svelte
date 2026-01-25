<script lang="ts">
  import { page } from '$app/stores';
  import { route } from '$lib/ROUTES';
  import euFinancingImageLink from '$lib/assets/images/eu-financing.png';
  import Button from '$lib/components/common/Button.svelte';
  import Logo from '$lib/components/common/Logo.svelte';
  import { buttonVariants } from '$lib/components/ui/button';
  import * as DropdownMenu from '$lib/components/ui/dropdown-menu';
  import { currentUser, logout } from '$lib/components/user/data';
  import { localizeRoute } from '$lib/i18n';
  import { cn } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import { CircleUserIcon, LogOutIcon, MenuIcon, UserPenIcon } from 'lucide-svelte';
  import { mediaQuery } from 'svelte-legos';
  import type { StoresValues } from 'svelte/store';

  export let context: 'public' | 'restricted';
  export let isMobileMenuOpen: boolean;

  const isLargeScreen = mediaQuery('(min-width: 640px)');

  $: linkUrl = determineLinkUrl(context, $currentUser);

  function determineLinkUrl(
    newContext: typeof context,
    newCurrentUser: StoresValues<typeof currentUser>
  ) {
    switch (true) {
      case newContext === 'public':
        return localizeRoute(route('/'));
      case newCurrentUser.isPatient:
        return localizeRoute(route('/dashboard'));
      case newCurrentUser.isDoctor:
        return localizeRoute(route('/patients/approved'));
      case newCurrentUser.isAdmin:
        return localizeRoute(route('/doctors'));
    }

    return '';
  }

  function handleMenuButtonClick() {
    isMobileMenuOpen = !isMobileMenuOpen;
  }
</script>

<header class="flex h-14 items-center gap-2 border-b bg-muted/40 px-4 py-2 sm:gap-4">
  <Logo class="w-24" {linkUrl} />

  <img alt="Spolufinancováno Evropskou unií" height="30" src={euFinancingImageLink} width="116" />

  <div class="ml-auto">
    {#if context === 'public'}
      {@const isLoginPage = $page.url.pathname === localizeRoute(route('/login'))}

      {#if $isLargeScreen}
        <div class="flex items-center gap-4">
          {#if isLoginPage}
            <Button href={localizeRoute(route('/'))}>
              {m.homePage()}
            </Button>
          {/if}

          {#if !isLoginPage}
            <Button href={localizeRoute(route('/login'))}>
              {m.logIn()}
            </Button>
          {/if}
        </div>
      {:else}
        <DropdownMenu.Root preventScroll={false}>
          <DropdownMenu.Trigger
            class={cn(
              buttonVariants({ variant: 'secondary', size: 'icon' }),
              'rounded-full bg-blue-light-50 text-blue-dark-900 hover:bg-blue-light-100'
            )}
            data-testid="header-menu-dropdown"
          >
            <MenuIcon class="size-4" />
          </DropdownMenu.Trigger>
          <DropdownMenu.Content data-testid="header-menu-dropdown-menu" sideOffset={8}>
            <DropdownMenu.Group>
              {#if isLoginPage}
                <DropdownMenu.Item
                  class="cursor-pointer gap-2 font-medium"
                  href={localizeRoute(route('/'))}
                >
                  {m.homePage()}
                </DropdownMenu.Item>
              {/if}

              {#if !isLoginPage}
                <DropdownMenu.Item
                  class="cursor-pointer gap-2 font-medium"
                  href={localizeRoute(route('/login'))}
                >
                  {m.logIn()}
                </DropdownMenu.Item>
              {/if}
            </DropdownMenu.Group>
          </DropdownMenu.Content>
        </DropdownMenu.Root>
      {/if}
    {:else if context === 'restricted' && $isLargeScreen}
      <div class="flex items-center gap-4">
        {#if $currentUser.isPatient}
          <div><strong>ID</strong>: {$currentUser.patient_public_id}</div>
        {/if}
        <DropdownMenu.Root preventScroll={false}>
          <DropdownMenu.Trigger
            class={cn(
              buttonVariants({ variant: 'secondary', size: 'icon' }),
              'rounded-full bg-blue-light-50 text-blue-dark-900 hover:bg-blue-light-100'
            )}
            data-testid="header-user-dropdown"
          >
            <CircleUserIcon class="size-4" />
          </DropdownMenu.Trigger>
          <DropdownMenu.Content data-testid="header-user-dropdown-menu" sideOffset={8}>
            <DropdownMenu.Group>
              {#if $currentUser.isDoctor}
                <DropdownMenu.Item
                  class="cursor-pointer gap-2 font-medium"
                  href={localizeRoute(route('/users/[userId]', { userId: $currentUser.id }))}
                >
                  <UserPenIcon class="size-4 shrink-0" />
                  {m.myAccount()}
                </DropdownMenu.Item>

                <DropdownMenu.Separator />
              {/if}

              <DropdownMenu.Item
                class="cursor-pointer gap-2 font-medium"
                data-testid="header-user-dropdown-logout"
                on:click={() => logout()}
              >
                <LogOutIcon class="size-4 shrink-0" />
                {m.logout()}
              </DropdownMenu.Item>
            </DropdownMenu.Group>
          </DropdownMenu.Content>
        </DropdownMenu.Root>
      </div>
    {/if}
  </div>

  {#if context === 'restricted'}
    <Button
      class="-order-1 lg:hidden"
      size="icon"
      variant="outline"
      on:click={handleMenuButtonClick}
    >
      <MenuIcon />
    </Button>
  {/if}
</header>
