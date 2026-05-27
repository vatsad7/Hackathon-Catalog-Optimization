# 🤖 Walmart Seller Center — AI Autopilot

> An agentic framework that turns Walmart Seller Center into a semi-autonomous catalog optimization engine — maximizing GMV while minimizing the time sellers spend on manual catalog work.

---

## Overview

Walmart Seller Center today requires sellers to manually act on hundreds of optimization signals across Assortment Growth, Listing Quality, SEO Marketing, and Success Hub. For a catalog of 300+ items, this is a full-time job.

**AI Autopilot** embeds a multi-agent framework directly inside Seller Center. Agents run on a schedule, automatically handle low/medium-risk actions, and surface high-risk changes for a single human approval step — keeping the seller in control without burdening them.

---

## The Three Pillars

| Pillar | Owner | Status |
|--------|-------|--------|
| **Assortment Growth** | This repo | ✅ Spec complete |
| **Catalog Optimization & Marketing** | This repo | ✅ Spec complete |
| **Pricing Agent** | Separate team | 🔗 Integration spec only |

---

## Repository Structure

```
walmart-ai-autopilot/
│
├── README.md                          ← You are here
│
├── docs/
│   ├── PRD.md                         ← Full Product Requirements Document
│   ├── ARCHITECTURE.md                ← System architecture & agent design
│   ├── AGENTS.md                      ← Individual agent specifications
│   ├── GUARDRAILS.md                  ← Risk classification system
│   ├── DATA_MODEL.md                  ← Data schemas & API contracts
│   ├── ROADMAP.md                     ← Phased implementation plan
│   └── DECISIONS.md                   ← Key design decisions & rationale
│
├── prototype/
│   └── seller_center_ai.html          ← Interactive UI prototype (open in browser)
│
└── research/
    ├── seller_center_overview.md      ← Walmart Seller Center deep dive
    └── ui_analysis.md                 ← UI analysis from actual screenshots
```

---

## Quick Start — Prototype

Open `prototype/seller_center_ai.html` in any browser. No server needed.

**Key flows to explore:**
1. **Dashboard** — See agents running, activity log, KPI impact
2. **Guardrails** (`⚙ Guardrails` button) — Configure what agents do automatically
3. **Catalog Queue** — 311 items, filtered by status
4. **Review Flow** — Click any yellow item → see before/after diff → Approve or Reject

---

## Core Design Principles

1. **Autopilot, not co-pilot** — Agents act autonomously; sellers review exceptions, not every action
2. **Risk-gated** — Sellers define what's Low/Medium/High risk; agents respect those guardrails
3. **Lives in Seller Center** — Not a separate app; embedded as a native section in the Growth tab
4. **Agents talk to each other** — Assortment signals feed Catalog agent; output is always a ready-to-publish listing
5. **Business impact is north star** — Every agent action is tied to projected GMV uplift
6. **Less is more for MVP** — Nail the core loop before adding complexity

---

## Success Metrics

| Metric |
|--------|------------------|--------------------|
| Listing Quality Score | 
| Time on catalog management | 
| GMV from AI-driven actions |
| Items at "Excellent" LQS |
| SEO suggestion acceptance rate | 

---

## Team

| Area | Owner |
|------|-------|
| Assortment Growth Agent | This team |
| Catalog Optimization Agent | This team |
| Sourcing & Negotiation Agent | Teammate A |
| Pricing Agent | Teammate B |

---

*Last updated: May 2026*
