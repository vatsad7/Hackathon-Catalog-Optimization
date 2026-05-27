# Implementation Roadmap
## Walmart AI Autopilot — Phased Delivery Plan

---

## Philosophy: Ship Early, Learn Fast

Given the rapidly evolving agentic AI landscape, we bias toward **shipping a working MVP in 8 weeks** rather than a perfect system in 6 months. Every phase has clear success metrics that gate the next phase.

---

## Phase 0 — Foundation (Weeks 1–2)

**Goal:** API access confirmed, data flowing, team aligned.

### Engineering
- [ ] Walmart Developer Portal: request API credentials (Analytics & Growth scope + Item Management scope)
- [ ] Confirm which LQS fields are available via API vs. UI-only
- [ ] Set up PostgreSQL schema (see `DATA_MODEL.md`)
- [ ] Set up Redis + Celery worker infrastructure
- [ ] Build Walmart API client with rate limit handling
- [ ] Write Signal Ingestion Service (read-only; no writes yet)
- [ ] Verify: can we read all 311 Dyson items + their LQS scores + SEO suggestions via API?

### Product
- [ ] Finalize default guardrail settings with seller stakeholder
- [ ] Define brand guidelines schema (what fields, what format)
- [ ] Resolve open question #1 (SEO bulk-accept endpoint) and #2 (issue detail API)

### Success criteria
- Signal Ingestion Service running locally, pulling real data for test seller account
- All 4 Seller Center data sources confirmed accessible via API

---

## Phase 1 — MVP: Read + Review (Weeks 3–5)

**Goal:** Seller can see what agents would do. No writes to Seller Center yet.

### Features
- [ ] **AI Autopilot Dashboard** — with simulated/read-only data
- [ ] **Guardrails Configuration** — full UI, saves to DB, no effect yet
- [ ] **Catalog Queue** — shows all items with LQS data, issue classification
- [ ] **Diff View Modal** — shows Before/After for content changes (agent-generated, not yet published)
- [ ] **SEO & Content Agent** — generates optimized titles/descriptions using Claude
- [ ] **Catalog Audit Agent** — classifies issues per item
- [ ] **Risk Gate** — routes all actions correctly per guardrails (but doesn't publish yet)

### What Phase 1 is NOT
- No write-back to Walmart (approve button is disabled / shows "coming in Phase 2")
- No Inventory Agent
- No Marketing Agent
- No Impact Dashboard

### Success criteria
- 5 beta sellers using the read-only dashboard
- Agent generates content for 100 items; seller review of 20 shows > 70% approval intent
- Diff view is understandable to a non-technical seller in < 60 seconds

---

## Phase 2 — MVP: Write (Weeks 6–8)

**Goal:** Seller can approve and publish changes. First real GMV impact.

### Features
- [ ] **Write-back to Walmart API** — Approve button works; publishes via Item Management API
- [ ] **Low-risk auto-apply** — SEO suggestion acceptance runs automatically on schedule
- [ ] **Activity Feed** — real log of agent actions
- [ ] **Inventory Agent** — out-of-stock alerts, WFS enrollment drafts
- [ ] **Review Tray** — full Review Tray with approve/reject/skip
- [ ] **Toast + notifications** — confirmation on approve/reject
- [ ] **Revert system** — 24-hour revert from Activity Feed

### Milestone: First GMV-attributed AI action
- At least one approved content change leads to measurable GMV impact within 30 days

### Success criteria
- End-to-end flow works: agent runs → review tray → approve → published on Walmart.com
- Zero incidents of unintended publishes (wrong item, wrong content)
- At least 10 sellers with ≥ 1 approved action
- Seller NPS > 40 on the approval flow

---

## Phase 3 — Scale (Weeks 9–14)

**Goal:** Full agent coverage. Impact Dashboard. Assortment pipeline.

### Features
- [ ] **Marketing Agent** — Flash Deals, Review Accelerator, SEM campaign drafts
- [ ] **Assortment Growth Agent** — reads demand signals, drafts new item listings
- [ ] **Impact Dashboard** — GMV before/after per action, LQS trajectory chart
- [ ] **Bulk approve** — "Approve all Medium Risk items" in one click
- [ ] **Weekly digest email** — summary of agent actions taken + items needing review
- [ ] **Agent-to-agent communication** — Assortment Agent feeds Catalog Agent
- [ ] **Brand guidelines integration** — seller uploads brand guide; content agent uses it
- [ ] **Confidence calibration** — feedback loop from approval/rejection rates to confidence model

### Success criteria
- LQS score improvement: 76% → 82% for pilot sellers
- Auto-fix rate > 60% (majority of actions require no human involvement)
- Approval rate > 75% for human-reviewed items
- Impact Dashboard shows measurable GMV attribution

---

## Phase 4 — Intelligence (Weeks 15–24)

**Goal:** Agent learns seller preferences. Near-full automation for power sellers.

### Features
- [ ] **Preference learning** — agent learns from approval/rejection patterns; adjusts future confidence thresholds
- [ ] **Proactive risk downgrades** — "You've approved 12/13 content rewrites. Move to auto-apply?" prompts
- [ ] **Competitor intelligence** — surface when competitor listings outperform yours on shared keywords
- [ ] **Seasonal optimization** — agent adjusts keyword strategy based on seasonal demand patterns
- [ ] **Multi-agent coordination dashboard** — visibility into how Assortment, Catalog, Pricing agents interlock
- [ ] **Seller-specific brand voice model** — fine-tuned content generation per brand
- [ ] **API for external tools** — allow third-party Seller Center Apps to read agent output

### Success criteria
- Review Tray < 3 items/week for power sellers
- LQS score 88%+ for sellers who've used the system 6+ months
- Time on catalog management < 2 hrs/week
- GMV attribution > $500K/month for top-10 sellers

---

## Team Structure

| Role | Phase 0-1 | Phase 2-3 | Phase 4 |
|------|-----------|-----------|---------|
| Backend Engineer (agent infra) | 1 | 2 | 2 |
| Backend Engineer (API integration) | 1 | 1 | 1 |
| Frontend Engineer | 1 | 1 | 2 |
| ML/AI Engineer | 1 | 1 | 2 |
| Product Manager | 1 | 1 | 1 |
| Designer | 0.5 | 0.5 | 1 |
| **Total** | **5.5** | **6.5** | **9** |

---

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Walmart API doesn't expose LQS issue details (only counts) | High | High | Build UI scraper fallback for issue classification |
| Content agent generates off-brand copy | Medium | High | Mandatory brand guidelines config gate before Phase 2 |
| Seller loses trust after one bad auto-apply | Medium | High | Revert system in Phase 2; start with Low risk only |
| Walmart changes API contracts | Low | High | Versioned API client; change monitoring |
| Rate limits hit at scale (300+ sellers × 311 items) | Medium | Medium | Staggered run schedules; aggressive caching |
| LLM costs spike with scale | Low | Medium | Claude Haiku for classification; Sonnet only for generation |

---

*Last updated: May 27, 2026*
