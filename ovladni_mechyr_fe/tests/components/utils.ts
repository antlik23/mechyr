import type { ComponentEvents, SvelteComponent_1 } from 'svelte';

export type RemoveNonSpecificKeys<TObject> = {
  [Key in keyof TObject as string extends Key ? never : Key]: TObject[Key];
};

export type ComponentEventKeys<TComponent extends SvelteComponent_1> = keyof RemoveNonSpecificKeys<
  ComponentEvents<TComponent>
>;
