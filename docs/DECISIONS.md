# Design Decisions & Rationale
## Key choices made and why

This document captures the important design decisions made during the brainstorm and spec phases, including context and trade-offs considered.

---

## DD-001: Autopilot (not Co-pilot)

**Decision:** Default to autopilot mode — agents act, sellers review exceptions — rather than co-pilot mode where every suggestion requires human confirmation.

**Context:** We asked: *"On a scale of 1–5 for autonomy, what do you want?"* Answer: **3–4** — automates low to medium risk, floats high risk to seller.

**Rationale:**
- The co-pilot model (every suggestion needs approval) replicates the exact problem we're solving: too much manual work
- Sellers with 300+ items can't review 200 suggestions/week even if they wanted to
- Trust is built through transparency (Activity Feed) and reversibility (revert system), not through pre-approval gates
- Low-risk auto-actions (accepting Walmart's own SEO suggestions) have essentially zero downside

**Trade-off:** A seller who doesn't trust AI at all will be uncomfortable with auto-apply. Mitigation: onboarding flow that explains the system, and defaults that are conservative enough to build trust first.

---

## DD-002: Lives Inside Seller Center (Not a Separate App)

**Decision:** AI Autopilot is a section within the Seller Center Growth tab, not a standalone product.

**Context:** Options considered: (a) standalone web app, (b) Slack bot, (c) Chrome extension overlay, (d) native Seller Center section.

**Rationale:**
- Sellers are already in Seller Center daily — reducing context switching is critical for adoption
- A Slack bot lacks the visual richness needed for diff views and catalog tables
- A Chrome extension adds friction and maintenance burden
- Seller Center has an App Store / SDK for embedding third-party sections natively
- Native placement signals "Walmart endorsement" which builds seller trust

**Trade-off:** Shipping velocity may be slower if we need Walmart's App Store approval process. Mitigation: build as a standalone prototype first; integrate as a Seller Center App in Phase 3.

---

## DD-003: Seller Defines Risk Guardrails (Not Walmart, Not Us)

**Decision:** Sellers configure their own risk thresholds; the system ships with safe defaults.

**Context:** Who should define what's "safe to automate"?

**Rationale:**
- Brands like Dyson have strong brand voice requirements; a generic "safe" threshold would be too conservative for Walker Gearks and too aggressive for Dyson
- Seller-defined guardrails creates ownership and trust ("I chose this")
- Safe defaults ensure new sellers get value without needing to configure anything
- Guardrails that evolve over time (trust-building through approval patterns) is more powerful than a static configuration

**Trade-off:** More complexity in onboarding. Mitigation: defaults are well-chosen; guardrails config is optional but surfaced prominently after first week.

---

## DD-004: Agents Talk to Each Other (Not Independent Pipelines)

**Decision:** Agents share context through a structured state object; Assortment Agent output feeds Catalog Agent directly.

**Context:** Option was to build independent pipelines that a human connects.

**Rationale:**
- The product vision is a "ready to publish" listing when a new item is added — this requires agents to hand off seamlessly
- Independent pipelines mean a seller has to manually connect: "new item recommended → go draft the listing → now optimize it" — that's the manual work we're eliminating
- LangGraph's stateful graph model makes agent-to-agent communication clean and traceable

**Trade-off:** More complex state management; harder to debug when things go wrong. Mitigation: comprehensive logging of all inter-agent communication to Activity Feed.

---

## DD-005: Business Impact Is North Star (Not Credits)

**Decision:** Every agent decision is prioritized by projected GMV impact. Walmart's credit system ($200/month) is a secondary consideration.

**Context:** Walmart's Success Hub has a gamification layer: $20 credits per accepted suggestion, max $200/month. Should agents optimize for credit accrual?

**Rationale:**
- Credits cap at $200/month — an irrelevant number for a seller with $3.79M/month GMV
- Optimizing for credits could perversely push agents toward low-GMV high-credit actions
- The seller's north star is explicitly GMV and time saved (from our brainstorm)
- That said: the agent should still accrue credits as a side effect of taking the right actions

**Trade-off:** We leave some credits on the table if high-credit actions are low-GMV. Acceptable trade-off.

---

## DD-006: Claude for Content, Haiku for Classification

**Decision:** Use Claude Sonnet (claude-sonnet-4-6) for content generation; Claude Haiku for classification and triage tasks.

**Rationale:**
- Content generation (titles, descriptions) requires nuance, brand voice awareness, and long-form quality → Sonnet
- Issue classification, risk scoring, keyword extraction are fast, high-volume, pattern-matching tasks → Haiku (5-10x cheaper, 3-5x faster)
- Claude specifically chosen over alternatives because: (a) best-in-class instruction following for brand guidelines, (b) longest context window for processing full catalogs, (c) Anthropic's data privacy commitments align with brand sensitivity requirements

---

## DD-007: MVP Scope — Less Is More

**Decision:** Phase 1-2 MVP intentionally excludes competitor intelligence, image generation, multi-platform sync, and several other features.

**Context:** Full feature set is valuable. But adoption of AI tools is notoriously fragile — too many features = overwhelm = non-use.

**Rationale:**
- The core loop (signal → agent action → review → publish → GMV) must be proven before adding complexity
- Each additional feature adds surface area for bugs and seller confusion
- Walmart's own AI features (SEO Marketing tab) have 0% adoption despite being simple — complexity is not the problem; trust and workflow fit are
- We can always add features; we can't un-confuse a seller who abandoned the tool in week 1

**Trade-off:** Competitive features that other tools might offer (competitor pricing overlays, etc.) are delayed. Acceptable for MVP phase.

---

## DD-008: Human-in-the-Loop is Mandatory for High Risk

**Decision:** High-risk actions NEVER publish without explicit seller approval. This is a hard system constraint, not a default.

**Rationale:**
- One bad auto-publish (wrong product image, off-brand description) destroys the trust needed for the system to work at all
- The cost of a missed auto-apply (seller has to click Approve) is low
- The cost of an unintended auto-publish is potentially catastrophic (brand damage, wrong pricing, incorrect product description leading to returns)
- This constraint also protects against prompt injection and adversarial inputs

**Implementation:** The `PublishAction.publish()` method raises an exception if `seller_approved=False` for any high-risk item. There is no override.

---

*Document Owner: Product + Engineering*
*Last updated: May 27, 2026*
