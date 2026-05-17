# demka — BRD + User Stories v1.2

> **demka** · simple minimalistic markdown slides pitch
> Version 1.2 · May 2026 · Status: **Ready for High-Fidelity Design**

---

## Document Info

| Field | Value |
|---|---|
| Project Name | demka |
| Tagline | Simple minimalistic markdown slides pitch |
| Type | New public web application |
| Deployment | GitHub Pages (static, free, no backend) |
| Version | 1.2 |
| Date | May 2026 |
| Status | **Ready for High-Fidelity Design** |
| Changed from v1.1 | Visual identity brief added (colour palette, node design, typography scale) |

---

## 1. Executive Summary

**demka** is a free, minimalist, single-page web app that lets anyone write a presentation in Markdown and deliver it as a spatially-animated slideshow — directly in the browser. There is no login, no install, no configuration, and no server. Users open the app on GitHub Pages, write or paste Markdown, and present.

The core interaction model is a **spatial canvas**: the entire Markdown document is parsed into a node tree and laid out on an infinite horizontal canvas — like a CI/CD pipeline read left to right. When presenting, the camera pans and zooms between nodes (Prezi-style), keeping the audience focused on one node at a time while conveying structure through movement. Bullet points within a node animate in sequentially. The entire app ships as a single static `index.html`.

---

## 2. Business Objectives

- **BO-001:** Provide a zero-friction presentation tool — a user must be able to go from opening the app to a live slideshow in under 60 seconds.
- **BO-002:** Be entirely free and publicly accessible via GitHub Pages with no usage limits or account requirements.
- **BO-003:** Keep the feature surface minimal and intentional — demka does one thing and does it well.
- **BO-004:** Be deployable as a single static `index.html` with no build pipeline required to use or self-host.
- **BO-005:** Produce visually polished output suitable for professional pitches, demos, and tech talks.

---

## 3. Scope

### 3.1 In Scope

- Markdown text editor (left pane, always visible)
- Live slide preview (right pane, always visible — split-pane layout)
- Markdown-to-node-tree parser (headings + bullet nesting → spatial hierarchy)
- Spatial canvas renderer: all nodes laid out horizontally left-to-right
- Camera pan + zoom transitions between nodes (Prezi-style, ≤ 400 ms)
- Progressive bullet reveal per node (one bullet at a time on advance)
- Keyboard navigation: arrow keys + spacebar follow tree depth-first
- Click navigation: click any node on canvas to fly to it
- Fullscreen / presentation mode (only current node visible, rest off-screen)
- Slide counter (bottom-right)
- LocalStorage persistence (survives page refresh)
- Pre-loaded example presentation on first open
- Single static `index.html` deployable to GitHub Pages
- **Typography:** Fixel (MacPaw open-source variable font) throughout
- **Theme:** Light (default, v1.0 only)

### 3.2 Out of Scope (v1.0)

- User accounts, authentication, or cloud sync
- Custom themes or CSS editor / dark mode
- Export to PDF or PPTX
- Collaborative editing
- Speaker notes / presenter view
- Image upload or hosting
- Mobile touch gesture support
- Multiple transition styles or animation configurability
- Minimap or canvas overview during presentation

> ⚠️ **Assumption:** No backend, database, or server-side logic is required. All state lives in the browser.

> ⚠️ **Assumption:** The primary user is a developer, designer, or technical presenter comfortable writing Markdown.

---

## 4. Stakeholders & Users

| Stakeholder | Role | Interest |
|---|---|---|
| Product Owner | Builder / decision-maker | Defines scope, approves delivery |
| Technical Presenter | Primary end user | Write slides fast, present with spatial flow |
| Open Source Community | Contributors / self-hosters | Fork, extend, deploy their own instance |
| GitHub Pages | Deployment platform | Static file hosting, free tier |

### User Persona

**Alex, Developer / Tech Lead**
- Writes docs, notes, and READMEs in Markdown daily
- Needs to present at standups, all-hands, and meetups
- Frustrated by PowerPoint overhead for quick internal pitches
- Wants to paste Markdown, press F, and present with a spatial flow that mirrors how they think

---

## 5. Business Requirements

| ID | Requirement | Priority | Notes |
|---|---|---|---|
| **BR-001** | The app must accept raw Markdown and render it as a spatially-animated slideshow with no build step, server, or install. | Must Have | Pure static HTML/JS/CSS |
| **BR-002** | The app must parse Markdown into a node tree: `# H1` = root node, `## H2` = child of H1, `### H3` = child of H2; unordered bullet = child node, nested bullet = child of bullet. | Must Have | Full heading + bullet hierarchy |
| **BR-003** | All nodes must be laid out on a horizontal canvas left-to-right (pipeline layout). Child nodes branch below their parent. | Must Have | |
| **BR-004** | When presenting, the camera must pan and zoom to focus on the current node (Prezi-style). Only the current node is visible; all others are off-screen. | Must Have | Transition ≤ 400 ms, ≥ 60 fps |
| **BR-005** | Bullet points within a node must animate in one at a time, revealed by user advance action. | Must Have | |
| **BR-006** | Keyboard navigation (arrow keys + spacebar) must traverse nodes depth-first following the tree structure. | Must Have | |
| **BR-007** | Click navigation must allow the user to click any node on the canvas to fly the camera to it instantly. | Must Have | |
| **BR-008** | The app must support a fullscreen presentation mode. | Must Have | Via browser Fullscreen API |
| **BR-009** | The app must render standard Markdown: headings, bold, italic, inline code, code blocks, and lists. | Must Have | |
| **BR-010** | The app must deploy as a single `index.html` to GitHub Pages with no build pipeline. | Must Have | Core deployment constraint |
| **BR-011** | The app must use Fixel (MacPaw variable font) as the sole typeface throughout editor and slides. | Must Have | Load from MacPaw CDN or bundle |
| **BR-012** | On first open, the app must display a pre-loaded example presentation that demonstrates the spatial canvas in action. | Must Have | Shows the app working immediately |
| **BR-013** | The app must persist the user's Markdown in `localStorage` so it survives page refresh. | Should Have | |
| **BR-014** | A slide counter (e.g. `4 / 12`) must be shown at the bottom-right during presentation. | Should Have | |
| **BR-015** | The split-pane layout (editor left, live preview right) must update the preview within 300 ms of typing (debounced). | Should Have | |

---

## 6. Design Decisions (Locked)

| Decision | Choice | Notes |
|---|---|---|
| **Layout** | Split-pane: editor left, live preview right — always visible | Both panels visible at all times on desktop |
| **Theme** | Light | Default for v1.0; dark mode deferred |
| **Slide transition** | Camera pan + zoom (Prezi-style) on a spatial canvas | Not a swap — camera moves through 2D space |
| **Canvas layout** | Horizontal pipeline, left to right | Children branch below parent nodes |
| **Bullet animation** | Sequential reveal on advance (style TBD by designer: fade-up recommended) | One bullet per keypress |
| **Navigation** | Keyboard (depth-first) + click to jump | Both active simultaneously |
| **Audience view** | Only current node visible during presentation | All other nodes off-screen |
| **Slide counter** | Bottom-right | Visible in presentation mode |
| **Typography** | Fixel by MacPaw (variable font) | Used in both editor and slides |
| **Empty / first-open state** | Pre-loaded example presentation | Demonstrates spatial canvas immediately |

---

## 7. Screens & States

This is the complete set of UI states the designer needs to cover:

| # | Screen / State | Description |
|---|---|---|
| **S-01** | **App — First Open** | Split-pane loaded with pre-built example Markdown. Left: editor with example content. Right: spatial canvas preview showing the example node tree. |
| **S-02** | **App — Editing** | User is typing in the left editor. Right pane shows live canvas updating in real time. Current node is highlighted. |
| **S-03** | **App — Canvas Preview (edit mode)** | Right pane showing the full node tree laid out horizontally. Nodes connected by pipeline lines. Current node subtly highlighted. |
| **S-04** | **Presentation Mode — Node Focus** | Fullscreen. Camera zoomed in on current node. Only this node visible. Slide counter bottom-right. |
| **S-05** | **Presentation Mode — Camera Transition** | Fullscreen. Camera mid-pan/zoom between two nodes. Intermediate state (≤ 400 ms). |
| **S-06** | **Presentation Mode — Bullet Reveal** | Fullscreen. On a node with bullets, some bullets visible, one just animating in. |
| **S-07** | **Presentation Mode — Enter / Exit** | Transition into and out of fullscreen (editor disappears / reappears). |
| **S-08** | **Empty State** | User has cleared all content. Canvas shows a placeholder prompt: "Start typing Markdown in the editor." |

---

## 8. Interaction & Animation Specs

### Camera Transition (node-to-node)
- **Type:** Pan + zoom on a 2D CSS/canvas transform
- **Duration:** 200–400 ms
- **Easing:** Ease-in-out (smooth deceleration)
- **Trigger:** Spacebar / right arrow (next depth-first node) or click on any node
- **During transition:** Input is queued, not dropped

### Bullet Reveal
- **Type:** Fade-up (bullet translates up ~8px and fades from 0→1 opacity) — designer to refine
- **Duration:** 150–200 ms per bullet
- **Trigger:** Spacebar / right arrow when current node has unrevealed bullets
- **Back-navigation:** All bullets immediately visible on re-entry

### Canvas Layout
- **Direction:** Left to right (root → children → grandchildren)
- **Child positioning:** Below parent, connected by a horizontal line (pipeline style)
- **Node spacing:** Generous — nodes should not feel cramped
- **Node shape:** Rounded rectangle (designer to define exact radius, padding, border)

### Node Hierarchy → Canvas Mapping

```
# H1          →  Root node (large)
## H2         →  Child of H1 (medium), branching right + below
### H3        →  Child of H2 (medium)
- bullet      →  Child node of the slide it belongs to (small)
  - nested    →  Child of bullet node
    - deeper  →  Child of nested node
```

### Typography (Fixel)
- **Font:** Fixel by MacPaw (variable font, load from `https://fixel.macpaw.com` or bundle)
- **Headings:** Fixel Display or Fixel, weight 700–800
- **Body / bullets:** Fixel Text or Fixel, weight 400
- **Editor:** Fixel Text, weight 400, monospace fallback for code blocks
- **All sizes, line-heights, and spacing:** Designer's decision

---

## 9. Assumptions & Dependencies

- **A-001:** All JavaScript (including Markdown parser) and CSS are inlined or bundled into `index.html`. No runtime CDN dependencies except optionally Fixel font.
- **A-002:** Markdown parser: `marked.js` or `markdown-it` bundled into the file (developer choice).
- **A-003:** Spatial canvas is implemented with CSS 2D transforms (`transform: translate + scale`) rather than WebGL or Canvas API, for simplicity and static-file compatibility.
- **A-004:** Desktop browsers are the primary target (Chrome, Firefox, Safari, Edge). Mobile is deferred.
- **A-005:** Fixel font licensing allows free use and bundling in an open-source project — confirm before bundling.
- **D-001:** GitHub Pages free tier for public repositories — no cost risk.
- **D-002:** No external API calls at runtime. App is fully self-contained.

---

## 10. Constraints

| Type | Constraint |
|---|---|
| **Deployment** | Single static `index.html` on GitHub Pages — no Node.js, no server, no build step for end users |
| **Performance** | Initial page load ≤ 2 s; camera transitions ≥ 60 fps on a modern laptop |
| **Simplicity** | No feature not directly in service of writing or presenting slides |
| **Licensing** | MIT or equivalent open-source license |
| **Bundle size** | Total `index.html` (including inlined JS/CSS, excluding font) ≤ 200 KB |

---

## 11. Success Metrics

- A user can open the app and be presenting a live spatial slideshow in under 60 seconds.
- All Must Have requirements (BR-001 through BR-012) pass acceptance testing.
- The app works correctly in Chrome, Firefox, and Safari without modification.
- Camera transitions run at ≥ 60 fps with no visible stutter on a modern laptop.
- The app is deployable to GitHub Pages by pushing a single `index.html`.

---

## 12. Open Issues & Risks

| ID | Issue / Risk | Owner | Status |
|---|---|---|---|
| **R-001** | Markdown parser choice: `marked.js` vs `markdown-it` — bundle size vs extensibility trade-off. | Developer | Open |
| **R-002** | Deep nesting (5+ levels) may produce very wide or cluttered canvas layouts — define a max nesting depth for v1.0. | PO | Open |
| **R-003** | `localStorage` 5 MB limit may be hit with very large presentations. | Developer | Low risk — monitor |
| **R-004** | Fixel font bundle size impact on the 200 KB limit — may need to subset or load async. | Developer | Open |
| **R-005** | CSS 2D transform camera approach may have limits at very large canvases — validate early. | Developer | Open |

---
---

# demka — User Stories v1.1

> Version 1.1 · May 2026 · All design decisions resolved

---

## EPIC-01: Markdown Parsing & Node Tree

*Goal: The app correctly parses Markdown into a spatial node hierarchy.*

---

### US-001 · Enter Markdown content

As a **presenter**,
I want to **type or paste Markdown into the left editor pane**,
So that **I can author my spatial presentation without leaving the app**.

**Acceptance Criteria:**
- Given the app is open, when I type in the editor, then my text is accepted without lag and the right pane updates within 300 ms.
- Given I paste a large block of Markdown (500+ lines), when the paste fires, then all content appears and no data is lost.
- Given I have existing content and refresh the page, when the page reloads, then my Markdown is restored from `localStorage`.

**Priority:** Must Have · **Estimate:** S

---

### US-002 · Parse Markdown into a node tree

As a **presenter**,
I want the app to **automatically parse my Markdown headings and bullet nesting into a spatial node hierarchy**,
So that **the structure of my document maps directly to the canvas layout**.

**Acceptance Criteria:**
- Given my Markdown has `# H1`, `## H2`, and `### H3`, when parsed, then H1 is the root node, H2 is a child of H1, H3 is a child of H2.
- Given a bullet list under a heading, when parsed, then each bullet becomes a child node of that heading node.
- Given a nested bullet (`  - child`), when parsed, then it becomes a child node of its parent bullet node.
- Given Markdown with no headings and only bullets, when parsed, then bullets form a flat left-to-right pipeline of nodes.

**Priority:** Must Have · **Estimate:** M

---

### US-003 · Render Markdown formatting within nodes

As a **presenter**,
I want **standard Markdown formatting to render correctly inside each node**,
So that **bold, italic, code, and lists display as intended**.

**Acceptance Criteria:**
- Given a node contains `**bold**`, `*italic*`, and `` `code` ``, when rendered, then each formats correctly using Fixel font.
- Given a node contains a fenced code block, when rendered, then it displays as a styled monospaced block.
- Given a node contains `# H1` through `### H3`, when rendered, then heading sizes are visually distinct.

**Priority:** Must Have · **Estimate:** S

---

## EPIC-02: Spatial Canvas

*Goal: The node tree is laid out on a horizontal 2D canvas and the camera navigates between nodes.*

---

### US-004 · Render node tree on spatial canvas

As a **presenter**,
I want to **see my Markdown rendered as a node tree on a horizontal canvas in the right pane**,
So that **I can see the structure of my presentation at a glance while editing**.

**Acceptance Criteria:**
- Given my Markdown has a 3-level hierarchy, when the canvas renders, then nodes are laid out left-to-right with children branching below their parents.
- Given the canvas is in the right pane, when I type in the left editor, then the canvas updates within 300 ms.
- Given nodes are connected in a pipeline, when rendered, then connecting lines between parent and child nodes are visible.
- Given the current node during editing, when shown on canvas, then it is subtly highlighted to show position.

**Priority:** Must Have · **Estimate:** L

---

### US-005 · Camera pan and zoom between nodes

As a **presenter**,
I want the **camera to pan and zoom smoothly to each node as I navigate**,
So that **transitions feel spatial and intentional, like moving through a mindmap**.

**Acceptance Criteria:**
- Given I advance to the next node, when the transition plays, then the camera pans and zooms to fill the viewport with the target node in ≤ 400 ms.
- Given the transition uses ease-in-out easing, when observed, then it decelerates smoothly without jarring.
- Given the transition is running, when I press a navigation key again, then the action is queued and the animation completes cleanly.
- Given the transition completes, when measured on a modern laptop, then it runs at ≥ 60 fps.

**Priority:** Must Have · **Estimate:** L

> ⚠️ **Assumption:** Camera transitions are implemented using CSS 2D transforms (`translate` + `scale`) on a single canvas container element.

---

### US-006 · Keyboard navigation (depth-first)

As a **presenter**,
I want to **navigate between nodes using arrow keys and spacebar in depth-first order**,
So that **the keyboard follows the natural reading flow of my presentation**.

**Acceptance Criteria:**
- Given the presentation is active, when I press the right arrow or spacebar (with all bullets revealed), then the camera moves to the next depth-first node.
- Given the presentation is active, when I press the left arrow, then the camera moves to the previous depth-first node with all bullets visible.
- Given I am on the first node, when I press left, then nothing happens.
- Given I am on the last node with all bullets revealed, when I press right, then nothing happens.

**Priority:** Must Have · **Estimate:** M

---

### US-007 · Click to jump to any node

As a **presenter**,
I want to **click any visible node on the canvas to fly the camera directly to it**,
So that **I can jump to any part of my presentation instantly without stepping through**.

**Acceptance Criteria:**
- Given the canvas is visible (edit mode or presentation overview), when I click a node, then the camera pans and zooms to that node within 400 ms.
- Given I click a node that is not the immediate next node, when the camera moves, then it travels the correct path (not a warp/jump).
- Given I click the currently active node, when clicked, then nothing happens.

**Priority:** Must Have · **Estimate:** M

---

## EPIC-03: Bullet Reveal & Presentation Mode

*Goal: Bullets animate in sequentially; fullscreen presentation hides everything except the current node.*

---

### US-008 · Progressive bullet reveal

As a **presenter**,
I want **bullet points within a node to appear one at a time as I advance**,
So that **I can control the flow of information and keep my audience focused**.

**Acceptance Criteria:**
- Given a node has N bullets, when I first land on it, then only the first bullet is visible.
- Given hidden bullets remain on the current node, when I press the advance key, then the next bullet animates in (not a node change).
- Given all bullets are revealed, when I press the advance key, then the camera moves to the next node.
- Given I navigate back to a visited node, when it appears, then all its bullets are immediately visible.
- Given a node has no bullets (headings or paragraphs only), when I land on it, then all content is immediately visible and the next advance moves to the next node.

**Priority:** Must Have · **Estimate:** M

---

### US-009 · Fullscreen presentation mode

As a **presenter**,
I want to **enter fullscreen so my slide fills the entire screen with no editor or browser chrome**,
So that **my audience sees only the current node**.

**Acceptance Criteria:**
- Given the app is open, when I click the **Present** button or press `F`, then the browser enters fullscreen and the editor pane is hidden.
- Given fullscreen is active, when I press `Escape`, then the app exits fullscreen and the split-pane editor returns.
- Given fullscreen is active, when I navigate, then keyboard and click navigation continue to work exactly as in normal mode.
- Given fullscreen is active, when a node is focused, then only that node is visible — all other nodes are off-screen.

**Priority:** Must Have · **Estimate:** S

---

### US-010 · Slide counter

As a **presenter**,
I want to **see the current node index and total nodes (e.g. `4 / 12`) in the bottom-right corner**,
So that **I know how far through the presentation I am**.

**Acceptance Criteria:**
- Given I am on node 4 of 12, when the node is focused, then the counter shows `4 / 12` at the bottom-right.
- Given fullscreen is active, when the counter is shown, then it does not obstruct the node content.
- Given I advance to the next node, when the camera completes its transition, then the counter updates to reflect the new position.

**Priority:** Should Have · **Estimate:** XS

---

## EPIC-04: Deployment & First-Open Experience

*Goal: demka ships as a single file and makes an immediate impression on first open.*

---

### US-011 · Single-file static deployment

As an **open source user / self-hoster**,
I want **demka to be a single `index.html` I can open locally or push to GitHub Pages**,
So that **I can use and host it for free with zero infrastructure**.

**Acceptance Criteria:**
- Given the `index.html` is opened via `file://`, when the app loads, then it is fully functional with no network requests required (font load may be async).
- Given the file is pushed to a public GitHub repo with Pages enabled, when the Pages URL is visited, then the app loads and works completely.
- Given the total file size of `index.html`, when measured (excluding font), then it is under 200 KB.

**Priority:** Must Have · **Estimate:** M

---

### US-012 · Pre-loaded example presentation

As a **first-time user**,
I want to **see a working example presentation when I open the app for the first time**,
So that **I immediately understand how demka works and what Markdown syntax to use**.

**Acceptance Criteria:**
- Given I open the app for the first time (no `localStorage` data), when the app loads, then the editor contains a pre-written example Markdown and the canvas shows its node tree.
- Given the example presentation is loaded, when I press Present, then I can immediately experience the spatial camera transitions.
- Given the example Markdown, when read, then it demonstrates: `# H1`, `## H2`, bullet nesting, bold, italic, and a code block.
- Given I have previously saved my own Markdown in `localStorage`, when I open the app, then my content is restored (example is not shown).

**Priority:** Must Have · **Estimate:** S

---

## Definition of Ready / Done

### Definition of Ready (per story)
- [ ] Written in As a / I want / So that format
- [ ] Has at least 2 acceptance criteria
- [ ] Dependencies identified
- [ ] Approved by PO

### Definition of Done (per story)
- [ ] All acceptance criteria pass
- [ ] Works in Chrome, Firefox, and Safari
- [ ] Camera transitions run at ≥ 60 fps
- [ ] No external network requests at runtime (except optional font)
- [ ] PO sign-off received

---

---
---

# demka — Visual Identity Brief v1.0

> Added in v1.2 · May 2026
> Status: **Locked — ready for hi-fi design**

---

## 1. Design Direction

Calm, minimal, editorial. The UI should feel like a well-designed notebook — quiet and unobtrusive so the content of the slides takes centre stage. No gradients, no shadows, no decoration for its own sake. Every element earns its place.

**Keywords:** calm · warm · minimal · typographic · focused

---

## 2. Colour Palette

### Core

| Role | Name | Hex | Usage |
|---|---|---|---|
| **Background** | Warm Stone | `#dbdad7` | App background, canvas background, editor background |
| **Surface** | White Stone | `#eeedea` | Node cards, editor pane surface, input fields |
| **Surface Raised** | Soft White | `#f5f4f1` | Hover states on nodes, tooltips |
| **Text Primary** | Near Black | `#1a1a18` | All body text, headings, editor content |
| **Text Secondary** | Dark Grey | `#5a5a56` | Metadata, labels, slide counter, placeholder text |
| **Text Muted** | Mid Grey | `#9a9a95` | Disabled states, de-emphasised content, connector lines |

### Accent & State

| Role | Name | Hex | Usage |
|---|---|---|---|
| **Active Node Border** | Charcoal | `#2e2e2a` | Border on currently focused node |
| **Connector Lines** | Warm Grey | `#b8b7b3` | Pipeline lines between nodes on canvas |
| **Visited Node** | Stone | `#c8c7c3` | Nodes already passed in presentation |
| **Cursor / Caret** | Near Black | `#1a1a18` | Editor cursor |
| **Selection** | Muted Warm | `#cccbc7` | Text selection highlight in editor |

### Do Not Use
- No pure white (`#ffffff`) — use `#f5f4f1` instead
- No pure black (`#000000`) — use `#1a1a18` instead
- No saturated colours in v1.0 — the palette is fully achromatic warm

> ⚠️ **Assumption:** A single accent colour (e.g. a muted warm blue or terracotta) may be introduced in v1.1 for interactive affordances like the Present button. Deferred for now — keep v1.0 fully greyscale-warm.

---

## 3. Node Visual Spec

| Property | Value |
|---|---|
| **Shape** | Rounded rectangle |
| **Border radius** | 6–8 px (designer to refine) |
| **Border** | 1 px solid `#b8b7b3` (default), 1.5 px solid `#2e2e2a` (active) |
| **Background** | `#eeedea` (Surface) |
| **Shadow** | None — flat design |
| **Padding** | 16–24 px (designer to define) |
| **Min width** | ~200 px — enough for a short heading |
| **Max width** | ~480 px — prevents nodes from becoming unreadably wide |

### Node States

| State | Visual Treatment |
|---|---|
| **Default** | Surface bg `#eeedea`, border `#b8b7b3`, text `#1a1a18` |
| **Active (current)** | Surface bg `#f5f4f1`, border 1.5 px `#2e2e2a`, subtle lift (no shadow — use border weight) |
| **Visited** | Surface bg `#dbdad7` (same as background — recedes), border `#c8c7c3`, text `#5a5a56` |
| **Hover (click nav)** | Border `#2e2e2a`, cursor pointer |

---

## 4. Typography Scale (Fixel)

**Font:** [Fixel](https://fixel.macpaw.com) by MacPaw — variable font, load from MacPaw CDN or bundle subset.

### Slide / Node Content

| Element | Weight | Size (desktop) | Line height |
|---|---|---|---|
| `# H1` — Root node title | 800 (ExtraBold) | 36–40 px | 1.15 |
| `## H2` — Section node title | 700 (Bold) | 26–30 px | 1.2 |
| `### H3` — Sub-section title | 600 (SemiBold) | 20–22 px | 1.25 |
| Body / paragraph text | 400 (Regular) | 16–18 px | 1.6 |
| Bullet items | 400 (Regular) | 16–18 px | 1.5 |
| `inline code` | 400, monospace fallback | 14–16 px | 1.5 |
| Code block | 400, monospace fallback | 13–14 px | 1.6 |

### UI Chrome

| Element | Weight | Size | Colour |
|---|---|---|---|
| Slide counter (`4 / 12`) | 400 | 13 px | `#9a9a95` |
| Editor placeholder text | 400, italic | 15 px | `#9a9a95` |
| Button labels | 500 (Medium) | 14 px | `#1a1a18` |
| Node connector labels (if any) | 400 | 11 px | `#9a9a95` |

> ⚠️ **Assumption:** Fixel is used for all text including the editor pane. Code blocks fall back to `ui-monospace, 'Cascadia Code', monospace` since Fixel is not a monospace font.

---

## 5. Spacing & Layout

| Property | Value |
|---|---|
| **Split-pane divider** | 1 px solid `#b8b7b3` |
| **Editor pane width** | 35–40% of viewport (designer to adjust) |
| **Canvas pane width** | 60–65% of viewport |
| **Node gap (horizontal)** | 48–64 px between sibling nodes |
| **Node gap (vertical)** | 40–56 px between parent and child |
| **Canvas padding** | 48 px on all sides (so nodes don't sit flush to edges) |
| **Fullscreen slide padding** | 80–120 px (generous whitespace around node content) |

---

## 6. Motion & Feel

The UI should feel **calm and deliberate** — nothing snappy or bouncy.

| Property | Value |
|---|---|
| **Camera transition easing** | `cubic-bezier(0.4, 0, 0.2, 1)` — ease-in-out, smooth deceleration |
| **Camera transition duration** | 300 ms (default), 400 ms (long distance pan) |
| **Bullet reveal easing** | `ease-out` |
| **Bullet reveal duration** | 160 ms |
| **Bullet reveal motion** | Translate Y +6px → 0, opacity 0 → 1 (subtle fade-up) |
| **Node hover transition** | Border colour change, 120 ms ease |
| **Overall feel** | No bounces, no spring physics, no overshoots — calm and precise |

---

## 7. What the Designer Should Deliver

For wireframes:
- [ ] S-01: App — First Open (split-pane, example loaded)
- [ ] S-02: App — Editing (typing, canvas updating)
- [ ] S-03: Canvas Preview in edit mode (node tree, connectors, active node)
- [ ] S-04: Presentation — Node Focus (fullscreen, single node, counter)
- [ ] S-05: Presentation — Camera Transition (mid-pan state)
- [ ] S-06: Presentation — Bullet Reveal (partial reveal state)
- [ ] S-07: Enter / Exit Fullscreen transition
- [ ] S-08: Empty State

For hi-fi (using this brief):
- [ ] Apply colour palette to all 8 screens
- [ ] Apply Fixel typography scale
- [ ] Define final node dimensions and spacing
- [ ] Design the Present button and any minimal UI chrome
- [ ] Validate readability of `#1a1a18` on `#dbdad7` background (contrast check)

---

*demka — BRD + User Stories v1.2 — Updated May 2026*
*Visual identity brief added. Ready for high-fidelity design.*