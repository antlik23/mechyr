import { createI18n } from '@inlang/paraglide-js-adapter-sveltekit';
import * as runtime from '$paraglide/runtime.js';
import { goto } from '$app/navigation';
import { availableLanguageTags, languageTag } from '$paraglide/runtime.js';

export type Language = (typeof availableLanguageTags)[number];

export const i18n = createI18n(runtime, {
  prefixDefaultLanguage: 'always',
  defaultLanguageTag: 'cs',
});

// until this fix: https://inlang.com/m/dxnzrydw/library-inlang-paraglideJsAdapterSvelteKit#issues-on-vercel
export const localizeRoute = (path: string, targetLanguageTag?: runtime.AvailableLanguageTag) => {
  const baseRoute = i18n.route(path);
  const lang = targetLanguageTag ? targetLanguageTag : languageTag();
  return `/` + lang + baseRoute;
};

export const switchLanguage = (path: string, lang: Language) => {
  const baseRoute = i18n.route(path);
  goto(i18n.resolveRoute(baseRoute, lang));
};
