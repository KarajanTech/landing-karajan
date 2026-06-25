# Karajan — landing page

The marketing site for **Karajan**, the vendor-neutral orchestration and decision layer for
heterogeneous autonomous systems. One layer conducting many machines into one mission — explainable,
human-supervised, sovereign.

Built as a fast, static, single-page site: dark-first, hairline-led, one restrained accent, with a
bespoke canvas animation that expresses the orchestration metaphor.

---

## Stack

| Concern    | Choice                                                                 |
| ---------- | ---------------------------------------------------------------------- |
| Framework  | [Astro](https://astro.build) (static output, ~no JS shipped)           |
| Language   | TypeScript (strict)                                                    |
| Styling    | [Tailwind CSS v4](https://tailwindcss.com) via `@tailwindcss/vite`     |
| Tokens     | CSS custom properties in `@theme` — single source, also Tailwind utils |
| Fonts      | Self-hosted variable fonts via `@fontsource-variable` (no 3rd-party)   |
| Animation  | Hand-written 2D `<canvas>` (lazy, reduced-motion-aware)                |
| Formatting | Prettier (+ `prettier-plugin-astro`)                                   |
| Sitemap    | `@astrojs/sitemap`                                                     |

Design tokens are defined once in [`src/styles/global.css`](src/styles/global.css) under `@theme`.
Each token is **both** a CSS custom property (`var(--color-accent)`) **and** a generated Tailwind
utility (`bg-ink`, `text-text-muted`, `border-hairline`). Components never hardcode hex values.

---

## Getting started

Requires Node 18+ (developed on Node 26).

```bash
npm install        # install dependencies
npm run dev        # start the dev server → http://localhost:4321
npm run build      # production build → dist/
npm run preview    # serve the production build locally
npm run check      # astro check (TypeScript + template diagnostics)
npm run format     # format with Prettier
```

---

## Project structure

```
public/                     static assets (favicons, og.png, robots.txt, manifest)
src/
  components/
    Eyebrow.astro           monospace section index ("01 — LABEL")
    Nav.astro               sticky nav, transparent over hero, mobile menu
    Footer.astro            sparse footer
    HeroCanvas.astro        the orchestration animation (lazy, reduced-motion)
    sections/
      Hero.astro            01 — hero
      Problem.astro         02 — the problem
      Layer.astro           03 — the layer (3-tier diagram)
      Capabilities.astro    04 — four pillars
      Architecture.astro    05 — architecture diagram
      Domains.astro         06 — defence-first + roadmap
      Sovereignty.astro     07 — why now / serif pull-quote
      Briefing.astro        08 — request a briefing (form)
  data/
    site.ts                 centralised copy & metadata (i18n-ready)
  layouts/
    Base.astro              <head>, SEO/OG/meta, JSON-LD, scroll-reveal
  styles/
    global.css              design tokens + base + component primitives
  pages/
    index.astro             composes the page
```

Copy that is list-shaped (nav, capabilities, domains) and all metadata live in
[`src/data/site.ts`](src/data/site.ts). Prose paragraphs live in their sections. The strings are
centralised enough that an **ES/EN** split later is a parallel data object, not a rewrite.

---

## Before you launch — replace the placeholders

Everything below is intentionally honest about being an early-stage placeholder. Search the repo for
these and swap in real values:

- **Domain** — set to `https://karajan.io` in [`astro.config.mjs`](astro.config.mjs),
  [`src/data/site.ts`](src/data/site.ts), and [`public/robots.txt`](public/robots.txt). Confirm the
  website domain matches the email domain (`karajan.io`) before launch.
- **Contact email** — `contact@karajan.io`, set in [`src/data/site.ts`](src/data/site.ts).
- **Briefing form → Supabase** — the form writes each request straight to a Supabase (Postgres)
  table via its REST API. One-time setup: in the Supabase dashboard open **SQL Editor**, paste
  [`supabase/schema.sql`](supabase/schema.sql), and **Run** — that creates the `briefing_requests`
  table and a row-level-security policy that lets anonymous visitors _insert only_ (they can't read
  other submissions). The project URL and **public anon key** live in the `<script>` of
  [`src/components/sections/Briefing.astro`](src/components/sections/Briefing.astro); the anon key is
  designed to be public, and your data stays protected by RLS. Read submissions in the dashboard
  under **Table editor → briefing_requests**.
- **Legal links** — `Privacy` / `Imprint` in [`src/components/Footer.astro`](src/components/Footer.astro)
  point to `#`.
- **Social proof** — the hero line _"In conversation with European defence & infrastructure
  operators"_ is an honest framing for an early-stage company. No customer logos, metrics, or
  testimonials are fabricated anywhere on the page. Keep it that way.

### Regenerating the OG image & icons

The social card (`public/og.png`) and favicons were generated from the design tokens. The generation
scripts are not part of the build; the rendered assets are committed in `public/`. To change them,
edit `public/favicon.svg` and re-render (any SVG→PNG tool, e.g. `sharp`).

---

## Accessibility & performance

- Semantic HTML5, a single `<h1>`, ordered headings, skip link, visible focus states, full keyboard
  navigation, labelled form fields with live error/success regions.
- WCAG AA contrast across text/background pairs; the one accent is used sparingly.
- `prefers-reduced-motion` is fully respected — the hero renders a still constellation, scroll
  reveals are disabled, and all transitions collapse.
- No-JS safe: content is never hidden behind JavaScript (reveal animations only _hide_ when JS is
  present and motion is allowed).
- Self-hosted fonts with `font-display: swap`, minimal inlined JS, zero layout shift.

---

## Deploy

Static output in `dist/` — deploy anywhere.

- **Vercel** — import the repo; framework preset **Astro** is auto-detected. No config needed.
- **Netlify** — build command `npm run build`, publish directory `dist`.
- **Any static host** — upload `dist/`.

Set the production domain in `astro.config.mjs` (`site`) so canonical URLs, Open Graph URLs, and the
sitemap resolve correctly.
