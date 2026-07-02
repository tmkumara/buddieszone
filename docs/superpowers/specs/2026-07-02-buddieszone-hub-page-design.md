# buddieszone.lk Hub Page — Design

## Purpose

Replace the current placeholder page at `buddieszone.lk` with a real static
landing/hub page that welcomes visitors and routes them to Buddies' live
products. Today that's just Craft (`craft.buddieszone.lk`); Tech
(`tech.buddieszone.lk`) doesn't exist yet and is shown as coming soon.

Mail server setup for the domain and the Tech app itself are explicitly
out of scope for this project — future work.

## Content & Layout

- **Hero**: logo (animated swoosh/glow, SVG), "BUDDIES" wordmark, tagline
  "Your Vision, Our Mission"
- **Cards** (two):
  - **Craft** — live, links to `https://craft.buddieszone.lk`
  - **Tech** — disabled state, "Coming Soon" badge, not clickable
- **Footer**: phone (078-3085081), email (hello.buddieslk@gmail.com)
- **Motion**: scroll-triggered fade/slide-in as cards and footer enter the
  viewport; subtle animated accent lines/dots in the background, echoing
  the current placeholder's decorative curve/dots. Built using the
  `frontend-design` skill for visual polish.

## Visual Style

Dark background, gold accent color (matching the existing
`#f5a623`-ish tone used across the Craft OMS dashboard and current
placeholder), "BUDDIES" wordmark and P-swoosh icon logo. Logo source
asset: `buddiesicon-removebg.png` (transparent background, from
`giftbox-oms/public/`), copied into this repo's `assets/`.

## Tech Stack

Plain static HTML/CSS/JS. No framework, no build step.

## Repo Structure

```
index.html          — markup
styles.css           — all styling, animations
assets/
  buddies-icon.png   — transparent logo
deploy.sh            — server-side: git pull + nginx reload
```

## Repo Rename

GitHub repo renamed from `buddies-core` to `buddieszone`
(`github.com/tmkumara/buddies-core` → `github.com/tmkumara/buddieszone`),
with the local `origin` remote URL updated to match. This is a change to
a shared external resource (GitHub) and will be confirmed with the user
immediately before execution.

## Deployment

- Repo cloned to `/opt/buddieszone` on the VPS (alongside the other
  `/opt` projects: `giftbox-oms`, `signals`, etc.)
- The `buddieszone.lk` nginx server block is changed from its current
  inline `return 200 '<html>...'` block to `root /opt/buddieszone;`,
  serving the static files directly instead of returning inline HTML.
  The `craft.buddieszone.lk` server block (proxying to `127.0.0.1:3000`)
  is untouched.
- Updates ship via `git pull` on the server; `deploy.sh` wraps `git pull`
  + an nginx reload for convenience.

## Out of Scope

- Mail server setup for the domain
- The `tech.buddieszone.lk` application itself (the Tech card just
  links nowhere / shows "Coming Soon" until that app exists)
