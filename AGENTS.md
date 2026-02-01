# Agent Guidelines for Mechyr Codebase

This document provides coding agents with essential information about the Mechyr monorepo.

## Project Overview

**Mechyr** is a monorepo containing three applications for bladder condition tracking:

- `ovladni_mechyr_be`: Ruby on Rails 7.1 API backend (Ruby 3.2.2)
- `ovladni_mechyr_fe`: SvelteKit 2.9 frontend (TypeScript, Svelte 4.2)
- `ovladni_mechyr_app`: Flutter mobile app (Dart 3.6+)

## Build and Lint Commands

### Frontend (`ovladni_mechyr_fe`)

```bash
# Development
cd ovladni_mechyr_fe
pnpm dev              # Run dev server (parallel: Vite + Svelte Check)
pnpm dev:vite         # Vite dev server only

# Build
pnpm build            # Full build (sequential: Paraglide + Vite)

# Linting & Formatting
pnpm check            # Run all checks (Svelte + ESLint + Prettier)
pnpm check:eslint     # ESLint only
pnpm check:prettier   # Prettier check only
pnpm fix              # Auto-fix all issues
pnpm fix:eslint       # Auto-fix ESLint
pnpm fix:prettier     # Auto-fix Prettier

# Type Generation
pnpm generate:types   # Generate API types from Swagger spec
```

### Backend (`ovladni_mechyr_be`)

```bash
# Development
cd ovladni_mechyr_be
bundle exec rails s   # Start server (port 3000)

# Linting
bundle exec rubocop   # Run RuboCop linter
bundle exec rubocop -a  # Auto-fix issues

# Database
bundle exec rails db:migrate  # Run migrations
bundle exec rails db:seed     # Seed database
```

### Mobile App (`ovladni_mechyr_app`)

```bash
# Development
cd ovladni_mechyr_app
flutter run           # Run on connected device

# Build
flutter build apk     # Build Android APK
flutter build ios     # Build iOS app

# Linting
flutter analyze       # Run Dart analyzer
```

## Code Style Guidelines

### Frontend (TypeScript/Svelte)

#### Import Organization

Organize imports in this order with blank lines between groups:

```typescript
// 1. SvelteKit framework imports
import { goto } from "$app/navigation";

// 2. API and query imports
import { apiClient } from "$lib/api/api";
import { voidingDiaries } from "$lib/api/queries";

// 3. Component imports (alphabetical)
import Button from "$lib/components/ui/button/Button.svelte";
import DatePicker from "$lib/components/form/DatePicker.svelte";

// 4. Namespace imports for UI components
import * as Form from "$lib/components/form";
import * as Card from "$lib/components/ui/card";

// 5. Utility imports
import { route } from "$lib/ROUTES";
import { handleRequest } from "$lib/utils/request";

// 6. i18n imports
import * as m from "$paraglide/messages";

// 7. External library imports
import { onMount } from "svelte";
import { z } from "zod";

// 8. Type imports (last, grouped separately)
import type { PageData } from "./$types";
```

#### Formatting

- **Quotes**: Single quotes (`'`) for strings
- **Semicolons**: Required
- **Indentation**: 2 spaces
- **Line Length**: Max 100 characters
- **Trailing Commas**: ES5 style
- **Component Files**: `PascalCase.svelte` (e.g., `Button.svelte`)
- **Utility Files**: `camelCase.ts` (e.g., `request.ts`)

#### TypeScript Rules

- **Strict Mode**: Always enabled
- **Unused Variables**: Prefix with `_` or `$$` (Svelte reactive)
- **Types**: Prefer `type` over `interface` for object shapes
- **Exports**: Use named exports; avoid default exports except for Svelte components
- **Nullish Coalescing**: Use `??` instead of `||` for null checks

#### Svelte-Specific

- All `<script>` blocks must use `lang="ts"`
- Sort attributes alphabetically (enforced by ESLint)
- Use `$:` for reactive statements
- Component props should have types defined

#### Error Handling

Use the `handleRequest` utility for consistent error handling:

```typescript
await handleRequest(
  async () => {
    const result = await apiClient.POST("/api/v1/resource", { body: data });
    return result;
  },
  {
    successText: m.successMessage(),
    onError: () => console.error("Failed"),
  },
);
```

### Backend (Ruby on Rails)

#### General Style

- **Frozen Literals**: All files start with `# frozen_string_literal: true`
- **Line Length**: Max 180 characters
- **Indentation**: 2 spaces
- **Quotes**: Single quotes preferred
- **Method Length**: Max 100 lines (arrays/hashes/heredocs count as 1)

#### Naming Conventions

- **Files**: `snake_case.rb`
- **Classes**: `PascalCase` (e.g., `VoidingDiary`)
- **Methods**: `snake_case` (e.g., `create_voiding_diary`)
- **Constants**: `UPPER_SNAKE_CASE`
- **Database**: `snake_case` for tables and columns

#### Rails Patterns

- Use **Command Objects** for complex business logic (`app/commands/`)
- Use **Query Objects** for complex database queries (`app/queries/`)
- Use **Service Objects** for external integrations (`app/services/`)
- Controllers should be thin; delegate to commands/services
- Use Jbuilder for JSON responses (avoid `.to_json`)

#### Error Handling

```ruby
# In controllers
def authorize_action(roles:)
  permitted = roles.any? { |role| current_devise_api_user.send("#{role}?") }
  render json: { error: I18n.t('errors.messages.not_found') },
         status: :not_found unless permitted
end

def respond_with_error(error, status = :not_found)
  render json: { error: }, status:
end
```

### Mobile App (Flutter/Dart)

#### Formatting

- **Indentation**: 2 spaces
- **Line Length**: 80 characters (Dart standard)
- **Naming**: `camelCase` for variables, `PascalCase` for classes
- **Files**: `snake_case.dart`
- **Private Members**: Prefix with `_`

#### Architecture

- Use **Provider** for state management with `ChangeNotifier`
- Keep **Service Layer** separate from UI (in `lib/core/services/`)
- Organize by **Features** (`lib/features/`)
- Constants go in `lib/core/constants/`

## Type Safety

### Frontend

- API types are **auto-generated** from Swagger spec via `pnpm generate:types`
- Use `openapi-fetch` for type-safe API calls
- Validate forms with **Zod schemas** and i18n messages
- Use TanStack Query's type inference for queries

### Backend

- Enable **Strong Parameters** in controllers
- Use `# frozen_string_literal: true` for immutability
- Type-check enums with ActiveRecord

### Flutter

- Enable all **flutter_lints** rules
- Avoid `dynamic` types where possible
- Use `final` for immutable variables

## Common Patterns

### API Integration (Frontend)

```typescript
// Define query
export const voidingDiaries = createQueryKeys("voidingDiaries", {
  detail: (id: string) => ({
    queryKey: [id],
    queryFn: async () => {
      const { data } = await apiClient.GET("/api/v1/voiding_diaries/{id}", {
        params: { path: { id } },
      });
      return data;
    },
  }),
});

// Use in component
const query = createQuery(voidingDiaries.detail(diaryId));
```

### Form Validation (Frontend)

```typescript
const schema = z.object({
  date: z.string().date(m.fieldIsRequired()),
  volume: z.number().min(0, m.mustBePositive())
});

const form = superForm(defaults(schema), {
  validators: zodClient(schema),
  onUpdate: async ({ form }) => {
    if (form.valid) {
      await handleRequest(async () => /* submit */);
    }
  }
});
```

## Best Practices

1. **Type Generation**: Regenerate API types after backend Swagger changes
2. **Error Messages**: Use i18n messages (`m.messageName()`)
3. **Authentication**: Never log or expose tokens
4. **Commits**: Use conventional commits (feat:, fix:, refactor:, etc.)
5. **Code Review**: Ensure RuboCop/ESLint passes before committing
