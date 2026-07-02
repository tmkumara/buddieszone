# buddieszone.lk Hub Page Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a static, animated hub page for buddieszone.lk that links to craft.buddieszone.lk and shows tech.buddieszone.lk as coming soon, plus the deploy artifacts and repo rename needed to ship it.

**Architecture:** Plain static HTML/CSS/JS, no build step. `index.html` holds structure, `styles.css` holds all styling and CSS animations, `script.js` holds a small IntersectionObserver for scroll reveal. Deployment is a manual runbook (VPS access is not available from this session) plus a `deploy.sh` the user runs on the server for future updates.

**Tech Stack:** HTML5, CSS3 (custom properties, keyframe animations, inline SVG), vanilla JS (IntersectionObserver). GitHub CLI (`gh`) for the repo rename.

## Global Constraints

- No framework, no build step — plain static HTML/CSS/JS only (per spec Tech Stack).
- Color palette: `--bg: #0b0b0b`, `--bg-elevated: #161616`, `--gold: #E8B923`, `--gold-bright: #F7C948`, `--text: #F5F5F0`, `--text-muted: #9A958C`, `--border: rgba(232, 185, 35, 0.25)` (dark background, gold accents, per spec Visual Style).
- Craft card links to `https://craft.buddieszone.lk` (live).
- Tech card is disabled — no `href`, shows a "Coming Soon" badge (per spec Content & Layout).
- Footer shows exactly: phone `078-3085081`, email `hello.buddieslk@gmail.com` (per spec Content & Layout).
- Logo source: `D:\Test\personal\giftbox-oms\public\buddiesicon-removebg.png` (transparent background, per spec Visual Style).
- Mail server setup and the tech.buddieszone.lk app itself are out of scope (per spec Out of Scope).
- VPS deployment commands are documented as a manual runbook, not executed automatically — no verified SSH access from this session.
- GitHub repo rename (`buddies-core` → `buddieszone`) requires explicit user confirmation immediately before execution (per spec Repo Rename).

---

### Task 1: Scaffold repo structure and HTML skeleton

**Files:**
- Create: `index.html`
- Create: `styles.css` (minimal reset only — full styling added in Task 2)
- Create: `assets/buddies-icon.png` (copied from `giftbox-oms/public/buddiesicon-removebg.png`)

**Interfaces:**
- Produces: DOM hooks later tasks depend on — `#cards` and `#footer` sections both carry a `reveal` class for Task 3's scroll-reveal CSS/JS to target; `.hero-glow` div is the mount point for Task 4's SVG glow ring; `.card--live` / `.card--disabled` are the two card variants Task 2 styles.

- [ ] **Step 1: Copy the logo asset**

```bash
mkdir -p assets
cp "/d/Test/personal/giftbox-oms/public/buddiesicon-removebg.png" "assets/buddies-icon.png"
```

- [ ] **Step 2: Write `index.html`**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Buddies Zone</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <main>
    <svg class="bg-accent" viewBox="0 0 1000 600" aria-hidden="true" preserveAspectRatio="xMidYMid slice">
      <path class="bg-accent-curve" d="M -50 500 Q 300 350 650 450 T 1050 300"></path>
      <circle class="bg-accent-dot" cx="120" cy="120" r="4"></circle>
      <circle class="bg-accent-dot bg-accent-dot--delay1" cx="850" cy="180" r="3"></circle>
      <circle class="bg-accent-dot bg-accent-dot--delay2" cx="700" cy="480" r="5"></circle>
      <circle class="bg-accent-dot bg-accent-dot--delay3" cx="180" cy="420" r="3"></circle>
    </svg>

    <section class="hero">
      <div class="hero-glow" aria-hidden="true">
        <svg viewBox="0 0 200 200" class="glow-ring">
          <circle cx="100" cy="100" r="70" class="glow-ring-circle"></circle>
        </svg>
      </div>
      <img src="assets/buddies-icon.png" alt="Buddies" class="hero-logo">
      <h1 class="hero-title">BUDDIES</h1>
      <p class="hero-tagline">Your Vision, Our Mission</p>
    </section>

    <section class="cards reveal" id="cards">
      <a class="card card--live" href="https://craft.buddieszone.lk" target="_blank" rel="noopener">
        <h2 class="card-title">Craft</h2>
        <p class="card-desc">Order management for Buddies Craft</p>
        <span class="card-cta">Enter &rarr;</span>
      </a>

      <div class="card card--disabled" aria-disabled="true">
        <span class="card-badge">Coming Soon</span>
        <h2 class="card-title">Tech</h2>
        <p class="card-desc">Buddies Tech, launching soon</p>
      </div>
    </section>

    <footer class="footer reveal" id="footer">
      <a class="footer-contact" href="tel:0783085081">078-3085081</a>
      <span class="footer-sep" aria-hidden="true">&middot;</span>
      <a class="footer-contact" href="mailto:hello.buddieslk@gmail.com">hello.buddieslk@gmail.com</a>
    </footer>
  </main>

  <script src="script.js"></script>
</body>
</html>
```

- [ ] **Step 3: Write minimal `styles.css` reset**

```css
* { box-sizing: border-box; margin: 0; padding: 0; }

body {
  min-height: 100vh;
  font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
}
```

- [ ] **Step 4: Create empty `script.js` placeholder for Task 3**

```js
// scroll reveal added in Task 3
```

- [ ] **Step 5: Verify structure with grep checks**

```bash
test -f assets/buddies-icon.png && echo "logo present"
grep -c 'href="https://craft.buddieszone.lk"' index.html
grep -c 'Coming Soon' index.html
grep -c 'aria-disabled="true"' index.html
grep -c 'hello.buddieslk@gmail.com' index.html
grep -A3 'card card--disabled' index.html | grep -c 'href='
```

Expected: `logo present`, three `1`s for the first three greps, and the final grep returns `0` (no `href` inside the disabled card block — confirms it isn't clickable).

- [ ] **Step 6: Commit**

```bash
git add index.html styles.css script.js assets/buddies-icon.png
git commit -m "Scaffold buddieszone.lk hub page structure"
```

---

### Task 2: Base theme, layout, and card styling

**Files:**
- Modify: `styles.css`

**Interfaces:**
- Consumes: DOM structure and class names from Task 1 (`.hero`, `.hero-logo`, `.hero-title`, `.hero-tagline`, `#cards`, `.card`, `.card--live`, `.card--disabled`, `.card-title`, `.card-desc`, `.card-cta`, `.card-badge`, `#footer`, `.footer-contact`, `.footer-sep`).
- Produces: `--bg`, `--bg-elevated`, `--gold`, `--gold-bright`, `--text`, `--text-muted`, `--border` CSS custom properties that Task 3's SVG/animation styles reuse.

- [ ] **Step 0: Invoke the `frontend-design` skill**

Before writing styles, invoke the `frontend-design` skill for guidance
on typography pairing, spacing rhythm, and polish choices, and apply its
recommendations to the concrete values in Steps 1-4 below (font choices,
spacing scale, hover/transition feel).

- [ ] **Step 1: Add theme variables and base styles to `styles.css`**

```css
:root {
  --bg: #0b0b0b;
  --bg-elevated: #161616;
  --gold: #E8B923;
  --gold-bright: #F7C948;
  --text: #F5F5F0;
  --text-muted: #9A958C;
  --border: rgba(232, 185, 35, 0.25);
}

body {
  background: var(--bg);
  color: var(--text);
  display: flex;
  flex-direction: column;
  overflow-x: hidden;
}

main {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 4rem 1.5rem 2rem;
  gap: 3rem;
  position: relative;
}
```

- [ ] **Step 2: Style the hero**

```css
.hero {
  position: relative;
  z-index: 1;
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.hero-logo {
  width: 140px;
  height: auto;
  position: relative;
  z-index: 1;
}

.hero-title {
  font-size: 2.5rem;
  letter-spacing: 0.35em;
  color: var(--gold-bright);
  font-weight: 700;
}

.hero-tagline {
  color: var(--text-muted);
  font-style: italic;
  letter-spacing: 0.05em;
}
```

- [ ] **Step 3: Style the cards**

```css
.cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 1.5rem;
  width: 100%;
  max-width: 640px;
  position: relative;
  z-index: 1;
}

.card {
  background: var(--bg-elevated);
  border: 1px solid var(--border);
  border-radius: 12px;
  padding: 2rem 1.5rem;
  text-decoration: none;
  color: var(--text);
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  position: relative;
  transition: transform 0.25s ease, border-color 0.25s ease;
}

.card--live:hover {
  transform: translateY(-4px);
  border-color: var(--gold);
}

.card--disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.card-title {
  color: var(--gold-bright);
  font-size: 1.4rem;
}

.card-desc {
  color: var(--text-muted);
  font-size: 0.9rem;
}

.card-cta {
  margin-top: auto;
  color: var(--gold);
  font-weight: 600;
}

.card-badge {
  position: absolute;
  top: 1rem;
  right: 1rem;
  font-size: 0.7rem;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  background: rgba(232, 185, 35, 0.15);
  color: var(--gold);
  padding: 0.25rem 0.6rem;
  border-radius: 999px;
}
```

- [ ] **Step 4: Style the footer**

```css
.footer {
  position: relative;
  z-index: 1;
  text-align: center;
  padding: 1.5rem;
  color: var(--text-muted);
  font-size: 0.85rem;
}

.footer-contact {
  color: var(--text-muted);
  text-decoration: none;
}

.footer-contact:hover {
  color: var(--gold);
}

.footer-sep {
  margin: 0 0.5rem;
}
```

- [ ] **Step 5: Manual verification in browser**

```bash
start index.html
```

Confirm visually:
- Dark background, gold "BUDDIES" title, italic tagline under the logo
- Two cards side by side (stacking on narrow widths): Craft looks clickable/live, Tech is dimmed with a "Coming Soon" badge and no pointer cursor
- Footer shows phone and email, both underlined-on-hover in gold
- Hovering the Craft card lifts it slightly and its border turns gold

- [ ] **Step 6: Commit**

```bash
git add styles.css
git commit -m "Add dark/gold theme and layout styling"
```

---

### Task 3: SVG glow and background accent animation

**Files:**
- Modify: `styles.css`

**Interfaces:**
- Consumes: `.hero-glow`, `.glow-ring`, `.glow-ring-circle`, `.bg-accent`, `.bg-accent-curve`, `.bg-accent-dot` markup from Task 1; `--gold`, `--border` variables from Task 2.
- Produces: nothing consumed by later tasks (purely visual).

- [ ] **Step 1: Add background accent SVG styling**

```css
.bg-accent {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
  pointer-events: none;
}

.bg-accent-curve {
  fill: none;
  stroke: var(--border);
  stroke-width: 1;
}

.bg-accent-dot {
  fill: var(--gold);
  animation: dot-pulse 3s ease-in-out infinite;
}

.bg-accent-dot--delay1 { animation-delay: 0.6s; }
.bg-accent-dot--delay2 { animation-delay: 1.2s; }
.bg-accent-dot--delay3 { animation-delay: 1.8s; }

@keyframes dot-pulse {
  0%, 100% { opacity: 0.3; }
  50% { opacity: 1; }
}
```

- [ ] **Step 2: Add hero glow ring styling**

```css
.hero-glow {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 220px;
  height: 220px;
  z-index: 0;
}

.glow-ring {
  width: 100%;
  height: 100%;
  animation: ring-rotate 12s linear infinite;
}

.glow-ring-circle {
  fill: none;
  stroke: var(--gold);
  stroke-width: 1;
  stroke-dasharray: 8 14;
  opacity: 0.5;
}

@keyframes ring-rotate {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}
```

- [ ] **Step 3: Manual verification in browser**

```bash
start index.html
```

Confirm visually:
- A faint dashed gold ring slowly rotates behind the logo
- Four small gold dots scattered across the background pulse in and out on staggered timing
- A faint curved line is visible in the background, consistent with the dots (decorative, not distracting from the cards/text)

- [ ] **Step 4: Commit**

```bash
git add styles.css
git commit -m "Add SVG glow ring and background accent animation"
```

---

### Task 4: Scroll-triggered reveal animation

**Files:**
- Modify: `styles.css`
- Modify: `script.js`

**Interfaces:**
- Consumes: `.reveal` class on `#cards` and `#footer` from Task 1.
- Produces: nothing consumed by later tasks.

- [ ] **Step 1: Add reveal CSS states**

```css
.reveal {
  opacity: 0;
  transform: translateY(24px);
  transition: opacity 0.6s ease, transform 0.6s ease;
}

.reveal.is-visible {
  opacity: 1;
  transform: translateY(0);
}
```

- [ ] **Step 2: Replace `script.js` with the IntersectionObserver reveal logic**

```js
const revealEls = document.querySelectorAll('.reveal');

const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.classList.add('is-visible');
      observer.unobserve(entry.target);
    }
  });
}, { threshold: 0.2 });

revealEls.forEach((el) => observer.observe(el));
```

- [ ] **Step 3: Verify script wiring**

```bash
grep -c 'IntersectionObserver' script.js
grep -c 'script.js' index.html
```

Expected: both return `1`.

- [ ] **Step 4: Manual verification in browser**

```bash
start index.html
```

Confirm visually: resize the browser window short enough that the cards/footer start below the fold, then scroll down — the cards section and footer should fade and slide up into place the first time they enter the viewport (not on every scroll past them).

- [ ] **Step 5: Commit**

```bash
git add styles.css script.js
git commit -m "Add scroll-triggered reveal animation for cards and footer"
```

---

### Task 5: Deploy artifacts and manual runbook

**Files:**
- Create: `deploy.sh`
- Create: `deploy/nginx-buddieszone.conf`
- Create: `RUNBOOK.md`

**Interfaces:**
- Consumes: nothing from earlier tasks (standalone deployment docs/scripts).
- Produces: nothing consumed by later tasks.

- [ ] **Step 1: Write `deploy.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail
cd /opt/buddieszone
git pull origin main
sudo nginx -t
sudo systemctl reload nginx
echo "buddieszone.lk deployed."
```

- [ ] **Step 2: Make it executable**

```bash
chmod +x deploy.sh
```

- [ ] **Step 3: Write the nginx server block reference**

```bash
mkdir -p deploy
```

```nginx
# deploy/nginx-buddieszone.conf
# Replaces the buddieszone.lk server blocks in
# /etc/nginx/sites-enabled/buddiescraft on the VPS.
# Leave the craft.buddieszone.lk server block untouched.

server {
    listen 443 ssl;
    server_name buddieszone.lk www.buddieszone.lk;

    ssl_certificate /etc/letsencrypt/live/buddieszone.lk/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/buddieszone.lk/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    root /opt/buddieszone;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}

server {
    listen 80;
    server_name buddieszone.lk www.buddieszone.lk;
    return 301 https://buddieszone.lk$request_uri;
}
```

- [ ] **Step 4: Write `RUNBOOK.md`**

```markdown
# Deploying buddieszone.lk

Run these steps yourself over SSH on the VPS (no automated access from
the assistant session that built this).

1. SSH into the VPS.
2. Clone the repo:
   ```
   cd /opt
   git clone https://github.com/tmkumara/buddieszone.git buddieszone
   ```
3. Open `/etc/nginx/sites-enabled/buddiescraft` and replace the two
   `buddieszone.lk` / `www.buddieszone.lk` server blocks (the ones with
   the inline `return 200 '<html>...'` placeholder) with the contents
   of `deploy/nginx-buddieszone.conf` from this repo. Leave the
   `craft.buddieszone.lk` server block untouched.
4. Test and reload nginx:
   ```
   sudo nginx -t
   sudo systemctl reload nginx
   ```
5. Visit https://buddieszone.lk and confirm the new hub page is live.
6. For future updates, pull the latest content and reload:
   ```
   cd /opt/buddieszone
   bash deploy.sh
   ```
```

- [ ] **Step 5: Verify files exist and script is executable**

```bash
test -x deploy.sh && echo "deploy.sh executable"
test -f deploy/nginx-buddieszone.conf && echo "nginx config present"
test -f RUNBOOK.md && echo "runbook present"
```

Expected: all three echo lines print.

- [ ] **Step 6: Commit**

```bash
git add deploy.sh deploy/nginx-buddieszone.conf RUNBOOK.md
git commit -m "Add deploy script, nginx config reference, and runbook"
```

---

### Task 6: Rename GitHub repo and update local remote

**Files:**
- None (external GitHub state + local git config only)

**Interfaces:**
- Consumes: nothing.
- Produces: nothing (terminal task).

The GitHub CLI (`gh`) is not installed in this environment (checked via
both Bash and PowerShell), so the rename itself is a manual web UI step
rather than a command this session can run directly.

- [ ] **Step 1: Stop and get explicit user confirmation**

This renames a shared GitHub resource (`tmkumara/buddies-core` →
`tmkumara/buddieszone`). Do not proceed past this step without the user
confirming in this session, even though the design was already approved.

- [ ] **Step 2: Rename the repo on GitHub (manual, user performs this)**

Go to `https://github.com/tmkumara/buddies-core/settings`, find the
"Repository name" field, change it to `buddieszone`, and click Rename.
Confirm with the user that this step is done before continuing.

- [ ] **Step 3: Update the local origin remote**

```bash
git remote set-url origin https://github.com/tmkumara/buddieszone.git
```

- [ ] **Step 4: Verify**

```bash
git remote -v
```

Expected: both `fetch` and `push` lines show
`https://github.com/tmkumara/buddieszone.git`.

- [ ] **Step 5: Push all local commits under the new remote**

```bash
git push -u origin main
```

---

## After This Plan

Everything through Task 5 is self-contained and locally testable. Task 6
touches shared/external state and should only run once the user has
confirmed in-session. Actual VPS deployment (cloning the repo, swapping
the nginx config, reloading nginx) is documented in `RUNBOOK.md` and is
run by the user manually — not part of this plan's automated tasks.
