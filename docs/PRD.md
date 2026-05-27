# Product Requirements Document
## Walmart Seller Center — AI Autopilot

**Version:** 1.0  
**Date:** May 2026  
**Status:** Draft — Ready for Engineering Review  

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Problem Statement](#2-problem-statement)
3. [Product Vision](#3-product-vision)
4. [User Personas](#4-user-personas)
5. [Jobs To Be Done](#5-jobs-to-be-done)
6. [Solution Overview](#6-solution-overview)
7. [Feature Requirements](#7-feature-requirements)
8. [Non-Requirements (MVP)](#8-non-requirements-mvp)
9. [User Experience Requirements](#9-user-experience-requirements)
10. [Success Metrics](#10-success-metrics)
11. [Dependencies & Constraints](#11-dependencies--constraints)
12. [Open Questions](#12-open-questions)

---

## 1. Executive Summary

Walmart Seller Center surfaces dozens of optimization signals daily — Assortment Growth recommendations, Listing Quality issues, SEO suggestions, Success Hub bulk actions — but requires sellers to manually act on all of them. For a seller with 300+ items, this is a 10–15 hour/week job that most sellers simply don't do, leaving significant GMV on the table.

**AI Autopilot** is a multi-agent system embedded natively in Seller Center that:
- Runs on a weekly (or on-demand) schedule
- Automatically handles low/medium-risk optimizations without seller intervention
- Surfaces only high-risk changes for a single approval step
- Tracks GMV impact and time saved

The result: sellers who engage with AI Autopilot should see a **15–25% GMV lift** and spend **less than 2 hours/week** on catalog management vs. the current 14+ hours.

---

## 2. Problem Statement

### 2.1 What Walmart Seller Center Does Well

Walmart has built excellent signal aggregation into Seller Center. The platform already identifies:
- Which items are underperforming (Listing Quality tab — item-level issues)
- What content should be improved (SEO Marketing tab — AI title/description suggestions)
- What items to add to the catalog (Assortment Growth — Customer Favorites)
- What operational actions to take (Success Hub — bulk action cards)

### 2.2 The Gap: Signal → Action

Despite these signals, adoption is extremely low:
- **SEO Marketing tab:** 30 AI suggestions available for Dyson. Accepted: 0
- **Success Hub:** 90 accepted suggestions, but $0 in tracked sales from them (Walker Gearks case)
- **Listing Quality:** 36 items rated "Poor" generating only $88K GMV vs. 121 "Excellent" items generating $2.9M — a 33x per-item difference — yet fixes are not being applied

### 2.3 Root Cause Analysis

| Problem | Evidence |
|---------|----------|
| **Time** | 311 items × avg 10 issues = 3,110 individual fixes needed |
| **Trust** | Sellers don't trust AI suggestions they can't verify quickly |
| **Fragmentation** | Signals live across 4+ tabs; no unified action surface |
| **Risk perception** | Every action feels high-stakes without a risk framework |
| **No feedback loop** | Seller can't see before/after GMV impact of a fix |

### 2.4 Opportunity Size

Using Dyson's actual data as a proxy:
- Moving 36 "Poor" items to "Good" → $754K GMV potential (from Poor's $2,451/item avg to Good's $4,900/item avg)
- Moving 36 "Poor" items all the way to "Excellent" → $2.9M GMV potential
- 15% SEO lift (Walmart's own data) on 30 items × avg GMV = significant upside
- 72 Customer Favorites not yet on WFS = delivery badge + LQS shipping score improvement

---

## 3. Product Vision

**12-month vision:**

> *"A seller with 300 items opens Seller Center once a week, sees 3–5 items that need their attention, approves or rejects them in 10 minutes, and watches their GMV grow — without ever manually updating a title, description, or keyword."*

**What changes:**
- Seller Center's Growth tab gains an "AI Autopilot" section — natively embedded, not a separate tool
- Agents run on a weekly cadence (configurable), pulling all available signals
- The seller's primary interaction shifts from *doing* to *approving*
- Every approval/rejection teaches the agent the seller's preferences over time

**What doesn't change:**
- Seller retains full control — nothing publishes without going through the risk guardrail they've set
- The Seller Center UI remains the source of truth
- Pricing decisions remain with the Pricing Agent (separate team)

---

## 4. User Personas

### 4.1 Primary: The Brand Manager (Large Seller)

**Profile:** Works at a brand like Dyson. Manages 300+ SKUs across Walmart. Has brand guidelines, existing product photography, and copy teams.

**Pain:** Catalog management is a full-time job their team isn't staffed for. They accept Walmart's suggestions manually when they remember to, which is rarely.

**Goal:** "I want my catalog to always be in top shape without thinking about it. Alert me only when something needs my brand judgment."

**Risk tolerance:** Low for brand voice/imagery (High risk tier), Medium for SEO/keywords, Low for operational actions.

### 4.2 Secondary: The Mid-Market Seller (Growth Seller)

**Profile:** Walker Gearks Good-type seller. 48% listing quality, $0 from 90 accepted suggestions. Smaller team, less brand infrastructure.

**Pain:** They've tried to engage but the current tools don't close the loop — accepting suggestions doesn't feel connected to outcomes.

**Goal:** "Just tell me what to do and show me that it worked."

**Risk tolerance:** Higher — willing to let the agent do more, faster, because the downside of inaction (poor LQS) is already visible.

### 4.3 Tertiary: The Walmart Account Manager (Internal User)

**Profile:** Manages seller accounts, curates recommendations in the "From your Account Manager" tab.

**Pain:** Manually curating recommendations for hundreds of sellers. No visibility into which suggestions were acted on.

**Goal:** Agents execute on AM recommendations automatically when sellers have pre-approved the action type.

---

## 5. Jobs To Be Done

| # | Job | Current Solution | AI Autopilot Solution |
|---|-----|------------------|-----------------------|
| 1 | Keep item titles and descriptions SEO-optimized | Manual review of SEO Marketing tab | Agent auto-accepts/enhances based on risk level |
| 2 | Ensure all catalog items have complete attributes | Review each "Fix X issues" in LQS | Catalog Audit Agent classifies and fixes in bulk |
| 3 | Know what new items to add to catalog | Review Assortment Growth tab biweekly | Signal Agent pulls recommendations; Assortment Agent drafts listings |
| 4 | Keep top items in stock and on WFS | Check Success Hub > Inventory | Inventory Agent flags out-of-stock Customer Favorites immediately |
| 5 | Enroll items in Flash Deals / Review Accelerator | Manually check program eligibility | Marketing Agent drafts enrollments for approval |
| 6 | Understand impact of optimizations | No before/after tracking | Impact Dashboard shows GMV delta per agent action |

---

## 6. Solution Overview

### 6.1 System Summary

AI Autopilot is a **hierarchical multi-agent system** with:
- 1 Orchestrator Agent (scheduling, prioritization, dispatch)
- 5 Specialist Agents (Signal, Catalog Audit, SEO & Content, Inventory, Marketing)
- 1 Review & Publish Agent (human-in-the-loop gate)
- A seller-configurable **Risk Guardrails** layer that governs autonomy

### 6.2 The Autonomy Spectrum

```
LOW RISK                    MEDIUM RISK                   HIGH RISK
Agent acts                  Agent acts,                   Agent drafts,
automatically               weekly digest                 seller approves

Title updates        WFS enrollment recs        Full listing rewrite
Description enrichment  Attr. additions          Image changes
Missing keyword adds    Shipping settings        New item to catalog
Out-of-stock alerts     Review Accelerator       Flash Deals enrollment
SEO suggestion accept   SEM campaign draft       Pricing changes
```

### 6.3 Weekly Agent Run Flow

```
Step 1: SIGNAL AGENT
  └── Pulls from all 4 Seller Center tabs via API
  └── Normalizes into structured knowledge base
  └── Identifies new opportunities since last run

Step 2: ORCHESTRATOR
  └── Scores all items by: GMV × Issue Count × Customer Favorite Flag
  └── Creates prioritized work queue
  └── Dispatches tasks to specialist agents

Step 3: SPECIALIST AGENTS (parallel execution)
  ├── Catalog Audit Agent → classifies all item issues
  ├── SEO & Content Agent → generates optimized content
  ├── Inventory Agent → flags stock issues, drafts WFS recommendations
  └── Marketing Agent → drafts program enrollments

Step 4: RISK GATE
  └── Low risk → auto-apply, log to activity feed
  └── Medium risk → auto-apply, add to weekly digest
  └── High risk → stage for seller review (no action taken)

Step 5: SELLER REVIEW
  └── Seller sees Review Tray (typically 3–8 items/week)
  └── Approve → publish immediately
  └── Reject → agent won't re-suggest for 7 days
  └── Edit → seller modifies, then approves

Step 6: IMPACT TRACKING
  └── Track GMV before/after per approved action
  └── Update Impact Dashboard
  └── Feed results back to improve agent confidence scoring
```

---

## 7. Feature Requirements

### 7.1 AI Autopilot Dashboard (P0)

**Description:** The main landing page for the AI Autopilot section, embedded in the Seller Center Growth nav.

**Requirements:**
- [ ] Display autopilot ON/OFF toggle — default ON after onboarding
- [ ] Show 4 KPIs: GMV Impact (month), Items Auto-Fixed, Items Awaiting Review, Time Saved
- [ ] Show 5 agent status tiles (Signal, Catalog, SEO/Content, Inventory, Marketing) with live state
- [ ] Show scrolling Activity Feed of recent agent actions with tags (Auto-Applied / In Progress / Needs Review)
- [ ] Show Review Tray of items awaiting seller decision, sorted by GMV impact
- [ ] "Run Now" button to trigger immediate agent run
- [ ] Last run timestamp and next scheduled run

**Acceptance criteria:**
- Dashboard loads in < 2s
- Activity feed shows last 20 agent actions
- Review Tray shows max 10 items (paginated)
- Auto-refresh every 60 seconds when Autopilot is ON

---

### 7.2 Risk Guardrails Configuration (P0)

**Description:** Seller-configurable table defining which actions agents can take automatically.

**Requirements:**
- [ ] Table with columns: Action Type, Risk Level (dropdown), Auto-Apply (toggle), Last Run Result
- [ ] Organized by category: Content & SEO, Images, Inventory, Pricing (view-only), Marketing, Assortment
- [ ] Risk level options: Low / Medium / High
- [ ] Auto-Apply toggle: when High risk selected, auto-apply forced OFF
- [ ] Changes take effect on next agent run (not retroactively)
- [ ] "Reset to defaults" option
- [ ] Show impact preview: "Setting this to Low will auto-apply to ~12 items in your next run"

**Default risk levels:**

| Action | Default Risk |
|--------|-------------|
| SEO title updates | Low |
| Description enrichment | Low |
| Missing attribute additions | Medium |
| Full listing rewrite | High |
| Add images | High |
| Out-of-stock alerts | Low |
| WFS enrollment | Medium |
| Flash Deals enrollment | High |
| New item to catalog | High |

**Acceptance criteria:**
- Changes save instantly (no Save button needed)
- Toast confirmation on each change
- Cannot set pricing actions — those route to Pricing Agent

---

### 7.3 Catalog Optimization Queue (P0)

**Description:** Full list of all catalog items with their optimization status.

**Requirements:**
- [ ] Table with columns: Item (thumbnail + name), SKU, Issues Count, Risk Level, Agent Status, Action
- [ ] Filter chips: All / Needs Review / In Progress / Auto-Fixed / Pending
- [ ] Customer Favorite star indicator on each row
- [ ] Issue count color-coded: Red (20+), Amber (10-19), Green (<10)
- [ ] Clicking a "Needs Review" row opens the Diff View modal
- [ ] "Auto-Fixed" rows show what was changed (expandable)
- [ ] Bulk approve: "Approve all Medium Risk items" option
- [ ] Exportable as CSV

**Acceptance criteria:**
- Table renders 311 items smoothly (virtualized if needed)
- Filter switches in < 200ms
- Approved items move to "Auto-Fixed" bucket immediately

---

### 7.4 Diff View & Approval Modal (P0)

**Description:** The most critical interaction — showing agents' proposed changes before publishing.

**Requirements:**
- [ ] Opens as modal overlay (not full page) for quick dismiss
- [ ] Header: Item name, SKU, issue count, risk level, Customer Favorite flag
- [ ] Metrics row: Total Issues, 30-Day GMV, Agent Confidence %
- [ ] Diff sections (each showing Before / After side by side):
  - Title
  - Description (with word count)
  - Search Keywords (current vs new, new ones highlighted green)
  - Images (flag only — no image rendering)
  - Inventory/Fulfillment (if applicable)
- [ ] Agent Reasoning note at bottom: why the agent made this recommendation
- [ ] Three actions: Approve & Publish | Reject | Edit (opens editable version)
- [ ] Keyboard shortcuts: Enter = Approve, Escape = Skip, ← → to navigate between items
- [ ] Confidence bar per section (visual 0–100%)
- [ ] "Skip for Now" — dismisses without rejecting (agent will re-suggest next cycle)

**Acceptance criteria:**
- Modal opens in < 300ms
- Approve action publishes changes within 5 seconds via Walmart API
- Rejection persists — item won't re-appear in next cycle
- Navigation between items works without closing/reopening modal

---

### 7.5 Impact Dashboard (P1)

**Description:** Tracks the business impact of all AI Autopilot actions.

**Requirements:**
- [ ] GMV impact chart: week-by-week, showing LQS trajectory
- [ ] GMV before/after per approved action (where measurable)
- [ ] Agent action breakdown by type (bar chart)
- [ ] Time saved estimation (based on industry benchmarks: 15 min/item for content, 5 min for operational)
- [ ] "Accepted vs Rejected" ratio over time (to surface if agent needs retraining)
- [ ] Export report as PDF

---

### 7.6 Assortment Growth Integration (P1)

**Description:** The Assortment Agent reads demand signals and queues new items for the catalog.

**Requirements:**
- [ ] Read Assortment Growth API (biweekly recommendations, Customer Favorites)
- [ ] Score each recommendation: demand rank × competitive gap × category fit
- [ ] For High-scoring recommendations: pre-draft the listing (title, description, attributes) using Claude
- [ ] Surface in "New Items to Add" section (separate from optimization queue)
- [ ] Show: Suggested listing draft, competitor pricing, demand trend chart, search keywords
- [ ] Seller approves → item added to catalog in draft state → they complete remaining fields
- [ ] Items already in catalog are removed from suggestions

---

### 7.7 Agent-to-Agent Communication (P1)

**Description:** Agents share context to produce ready-to-publish listings.

**Requirements:**
- [ ] Signal Agent output feeds all other agents (structured JSON per item)
- [ ] Catalog Audit Agent output feeds SEO Agent (issue classification)
- [ ] SEO Agent output feeds Review Agent (pre-packaged diff)
- [ ] Inventory Agent flags route to both Review Tray AND email notification
- [ ] All inter-agent communication logged to Activity Feed
- [ ] Assortment Agent feeds directly into Catalog Agent for new item creation

---

## 8. Non-Requirements (MVP)

The following are explicitly out of scope for MVP to ensure adoption:

- **Pricing Agent** — separate team, integration via routing only
- **Competitor intelligence overlay** — useful but not needed for core loop
- **Image generation / editing** — agents flag image issues, don't generate images
- **Multi-platform sync** — Walmart-only for now (no Amazon/eBay cross-listing)
- **Review response automation** — future phase
- **Wholesale / purchase order automation** — Sourcing Agent (separate team)
- **Mobile app** — web-first
- **Analytics API export** — future phase

---

## 9. User Experience Requirements

### 9.1 Design Principles

1. **Native to Seller Center** — AI Autopilot section looks and feels like existing Seller Center tabs. No jarring design shift.
2. **Scannable, not overwhelming** — Sellers see a tray of 3–8 items/week, not a dashboard full of alerts.
3. **Every action has an undo** — Approved but regret it? Items can be reverted within 24 hours.
4. **Explain the why** — Every agent suggestion includes a one-line reasoning note.
5. **Confidence transparency** — Show % confidence on every suggestion so sellers can calibrate trust.

### 9.2 Key Interaction Patterns

**Primary: Approve/Reject flow**
- Seller opens Review Tray
- Clicks item → Diff Modal opens
- Reads Before/After in 30 seconds
- Hits Approve (or Reject)
- Toast confirms "Published"
- Total time: < 5 minutes for a tray of 8 items

**Secondary: Guardrails tuning**
- After using for 2 weeks, seller wants to give agents more autonomy
- Goes to Guardrails → changes "Full listing rewrite" from High to Medium
- Next week's tray is shorter — agent handled more automatically

**Tertiary: Impact review**
- Monthly: seller checks Impact Dashboard
- Sees GMV delta, LQS trajectory, time saved
- Shares with manager as proof of ROI

---

## 10. Success Metrics

### 10.1 Agent Performance Metrics

| Metric | Definition | Target |
|--------|------------|--------|
| Auto-fix rate | % of flagged items agent handles without human review | > 70% |
| Approval rate | % of human-reviewed suggestions that get approved | > 75% |
| Revert rate | % of approved items that get reverted within 7 days | < 5% |
| Agent confidence accuracy | Correlation between confidence score and approval rate | > 0.8 |
| Run latency | Time from trigger to "ready for review" | < 10 minutes |

### 10.2 Business Metrics

| Metric | Baseline | 90-day Target | 12-month Target |
|--------|----------|---------------|-----------------|
| LQS Score | 76% | 82% | 88%+ |
| Excellent items | 121 (39%) | 160 (51%) | 220 (71%) |
| GMV/item for Poor items | $2,451 | $4,000 | $7,000 |
| Time on catalog management | ~14 hrs/week | 6 hrs/week | < 2 hrs/week |
| SEO suggestion acceptance rate | 0% | 60% | 90%+ |
| Items at risk (out-of-stock CF) | Not tracked | 0 unaddressed | 0 unaddressed |

### 10.3 Adoption Metrics

| Metric | Target |
|--------|--------|
| Sellers who enable Autopilot | 80% within 30 days of launch |
| Weekly active sellers (reviewing tray) | > 60% |
| Guardrails customization | > 40% of sellers adjust defaults |
| "Run Now" manual triggers | < 1/week per seller (means autopilot is working) |

---

## 11. Dependencies & Constraints

### 11.1 External Dependencies

| Dependency | Owner | Risk |
|------------|-------|------|
| Walmart Assortment Growth API | Walmart Developer Platform | Medium — API stability |
| Walmart Listing Quality API | Walmart Developer Platform | Medium |
| Walmart Item Management API (write) | Walmart Developer Platform | High — rate limits |
| SEO Marketing API (accept/reject) | Walmart Developer Platform | Low — exists |
| Claude API (content generation) | Anthropic | Low |
| Walmart Brand Guidelines | Seller/Brand | Medium — may not exist for all sellers |

### 11.2 Technical Constraints

- Walmart API rate limits: 20 requests/second for Item Management API
- LQS Dashboard updates up to 48 hours lag — agents must account for stale data
- New listings may take up to 1 week to appear in LQS
- Assortment recommendations refresh biweekly — no real-time signal

### 11.3 Policy Constraints

- All content changes must comply with Walmart's Content Policy
- Brand guidelines must be explicitly provided by seller before content agents run
- Pricing changes are out of scope — must route to dedicated Pricing Agent

---

## 12. Open Questions

| # | Question | Impact | Owner | Target Resolution |
|---|----------|--------|-------|------------------|
| 1 | What is the exact Walmart API endpoint for bulk-accepting SEO suggestions? | High | Engineering | Sprint 1 |
| 2 | Can we access item-level issue details (not just counts) via API, or only via UI scrape? | High | Engineering | Sprint 1 |
| 3 | How do we handle brand guidelines for sellers who don't have a formal brand guide? | Medium | Product | Sprint 2 |
| 4 | Should agents run every week or let sellers configure the cadence? | Medium | Product | Sprint 1 |
| 5 | What's the revert SLA? If a seller approves a bad change, how fast can it be undone? | High | Engineering | Sprint 2 |
| 6 | Should the Review Tray be a notification (email/push) or only in-app? | Medium | Product | Sprint 2 |
| 7 | Do agents have access to historical GMV data per item, or only last-30-days? | Medium | Data | Sprint 1 |
| 8 | How does the Assortment Agent handle items that are in Dyson's catalog but not submitted to Walmart yet? | Low | Product | Sprint 3 |

---

*Document Owner: Product Team*
*Last updated: May 27, 2026*
