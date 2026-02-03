# Testování emailů na localhostu

## Nastavení

Letter Opener Web je již nakonfigurován v projektu pro testování emailů během vývoje.

### Konfigurace

- **Gem:** `letter_opener`, `letter_opener_web` a `dotenv-rails` (již nainstalováno)
- **Route:** `/letter_opener` (dostupné pouze v development)
- **ENV proměnné v `.env`:**
  - `MAIL_DELIVERIES=true` - zapne posílání emailů
  - `FRONTEND_URL=http://localhost:5173` - URL frontendu pro odkazy v emailech
- `.env` soubor je automaticky načítán pomocí `dotenv-rails` gemu

## Jak používat

### 1. Zobrazit odeslané emaily

Otevři prohlížeč a přejdi na:

```
http://localhost:3000/letter_opener
```

Zde uvidíš všechny emaily odeslané během běhu Rails serveru.

### 2. Odeslat testovací emaily

#### Poslat všechny typy emailů najednou:

```bash
cd ovladni_mechyr_be
MAIL_DELIVERIES=true bundle exec rails test:emails
```

To odešle všech 8 typů emailů:
1. Welcome email (po registraci)
2. Request assignment (žádost o přiřazení k doktorovi)
3. Approve email (schválení pacienta)
4. Reject email (odmítnutí pacienta)
5. First appointment scheduled (stanovení termínu první návštěvy)
6. First appointment updated (změna termínu první návštěvy)
7. Second appointment scheduled (stanovení termínu druhé návštěvy)
8. Second appointment updated (změna termínu druhé návštěvy)

#### Poslat jeden konkrétní email:

```bash
cd ovladni_mechyr_be
MAIL_DELIVERIES=true bundle exec rails "test:email[welcome]"
```

Dostupné typy:
- `welcome` - uvítací email
- `request` - žádost o přiřazení
- `approve` - schválení pacienta
- `reject` - odmítnutí pacienta

### 3. Testování při běžném vývoji

Když Rails server běží s `MAIL_DELIVERIES=true` v `.env`, všechny emaily odeslané aplikací se automaticky zobrazí v Letter Opener Web UI.

**Příklad:**
1. Registruj nového uživatele přes frontend
2. Otevři `http://localhost:3000/letter_opener`
3. Uvidíš uvítací email

## Restart Rails serveru

Po instalaci `dotenv-rails` gemu se `.env` soubor načítá automaticky při startu serveru. Pokud změníš `.env` soubor, je třeba restartovat Rails server:

```bash
# Zastav server (Ctrl+C nebo pkill)
pkill -f "puma.*ovladni_mechyr_be"
# Spusť znovu
bundle exec rails s
```

## Poznámky

- Emaily jsou uloženy pouze v paměti během běhu serveru
- Po restartu serveru se historie emailů smaže
- V Docker containeru je mail delivery automaticky vypnutý (viz `config/environments/development.rb:45-48`)
- V produkci se používá SMTP server nakonfigurovaný v `credentials`

## Troubleshooting

### Emaily se neposílají

Zkontroluj:
1. `MAIL_DELIVERIES=true` je v `.env` souboru
2. Rails server byl restartován po změně `.env` nebo po instalaci `dotenv-rails` gemu
3. Nejsi v Docker containeru
4. `dotenv-rails` gem je nainstalovaný (viz `Gemfile`)

### Letter Opener Web nefunguje

Zkontroluj:
1. Rails server běží
2. Jsi v development prostředí
3. Route `/letter_opener` je přístupná: `curl http://localhost:3000/letter_opener`

## Opravené bugy

### Bug: `NoMethodError: undefined method 'first_name' for Patient`

**Problém:** V `UserMailer` se používalo `patient.first_name` a `patient.last_name`, ale Patient model má pouze `full_name`.

**Oprava:** Změněno na `patient.full_name` ve všech 4 metodách:
- `first_appointment_scheduled_email` (řádek 39)
- `first_appointment_updated_email` (řádek 51)
- `second_appointment_scheduled_email` (řádek 64)
- `second_appointment_updated_email` (řádek 75)

**Soubor:** `ovladni_mechyr_be/app/mailers/user_mailer.rb`

### Bug: Confirmation emails se neposílaly při registraci

**Problém:** Rails nenačítal `.env` soubor automaticky, takže `MAIL_DELIVERIES=true` se nenastavovalo a Devise confirmation emaily se přeskakovali s hláškou "Skipped delivery of mail as `perform_deliveries` is false".

**Oprava:** 
1. Přidán `dotenv-rails` gem do `Gemfile` (development a test skupiny)
2. Po instalaci gemu se `.env` soubor načítá automaticky při startu Rails serveru
3. Restart Rails serveru po instalaci gemu

**Soubory:** 
- `ovladni_mechyr_be/Gemfile` (přidán gem `dotenv-rails`)
- `ovladni_mechyr_be/.env` (obsahuje `MAIL_DELIVERIES=true`)

**Ověření:**
```bash
bundle exec rails runner "puts Rails.configuration.action_mailer.perform_deliveries"
# Mělo by vypsat: true
```

### Bug: Odkazy v confirmation emailech byly relativní místo absolutní

**Problém:** Confirmation email obsahoval relativní odkaz `/cs/confirmation?token=...` místo absolutní URL `http://localhost:5173/cs/confirmation?token=...`. V Letter Opener Web se to zobrazovalo jako `file:///cs/confirmation?...`, což nefungovalo.

**Příčina:** Email template používal `Rails.application.credentials[:fe_url]`, který nebyl nastavený v development prostředí (je prázdný).

**Oprava:**
1. Přidána ENV proměnná `FRONTEND_URL=http://localhost:5173` do `.env` souboru
2. Upraven email template, aby použil `ENV.fetch('FRONTEND_URL', Rails.application.credentials[:fe_url])`
3. V development má přednost `FRONTEND_URL` z `.env`, v produkci se použije `fe_url` z credentials

**Soubory:**
- `ovladni_mechyr_be/.env` (přidán `FRONTEND_URL=http://localhost:5173`)
- `ovladni_mechyr_be/app/views/devise/mailer/confirmation_instructions.html.erb` (řádek 133)

**Ověření:**
```bash
bundle exec rails runner "puts ENV['FRONTEND_URL']"
# Mělo by vypsat: http://localhost:5173
```
