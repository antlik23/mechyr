import type { ComponentType, SvelteComponent } from 'svelte';
import type { SVGAttributes } from 'svelte/elements';

export type SvgIcon = ComponentType<SvelteComponent<SVGAttributes<SVGSVGElement>>>;
