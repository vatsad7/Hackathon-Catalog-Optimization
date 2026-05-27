# System Architecture
## Walmart AI Autopilot — Technical Design

---

## 1. High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           WALMART SELLER CENTER                             │
│                                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │
│  │  Assortment  │  │   Listing    │  │     SEO      │  │   Success    │   │
│  │    Growth    │  │   Quality    │  │  Marketing   │  │     Hub      │   │
│  │     Tab      │  │     Tab      │  │     Tab      │  │     Tab      │   │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘   │
│         └─────────────────┴─────────────────┴─────────────────┘           │
│                                      │                                      │
│                          Walmart Marketplace API                            │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         AI AUTOPILOT LAYER                                  │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                      SIGNAL INGESTION SERVICE                       │   │
│  │  Polls APIs on schedule · Normalizes data · Stores to PostgreSQL    │   │
│  └────────────────────────────────┬────────────────────────────────────┘   │
│                                   │                                         │
│  ┌────────────────────────────────▼────────────────────────────────────┐   │
│  │                        ORCHESTRATOR AGENT                           │   │
│  │  LangGraph state machine · Priority scoring · Task dispatch         │   │
│  └──────┬──────────┬──────────────┬──────────────┬────────────────────┘   │
│         │          │              │              │                          │
│    ┌────▼───┐ ┌────▼────┐ ┌──────▼─────┐ ┌─────▼──────┐                  │
│    │Catalog │ │  SEO &  │ │ Inventory  │ │ Marketing  │                  │
│    │ Audit  │ │ Content │ │   Agent    │ │   Agent    │                  │
│    │ Agent  │ │  Agent  │ │            │ │            │                  │
│    └────┬───┘ └────┬────┘ └──────┬─────┘ └─────┬──────┘                  │
│         └──────────┴──────────────┴─────────────┘                          │
│                                   │                                         │
│  ┌────────────────────────────────▼────────────────────────────────────┐   │
│  │                    RISK GATE & REVIEW QUEUE                         │   │
│  │  Low → auto-apply   Medium → digest   High → Review Tray            │   │
│  └────────────────────────────────┬────────────────────────────────────┘   │
│                                   │                                         │
│  ┌────────────────────────────────▼────────────────────────────────────┐   │
│  │                     REVIEW & PUBLISH AGENT                          │   │
│  │  Diff generation · Confidence scoring · Seller approval gate        │   │
│  └────────────────────────────────┬────────────────────────────────────┘   │
│                                   │                                         │
└───────────────────────────────────┼─────────────────────────────────────────┘
                                    │ (write-back via API after approval)
                                    ▼
                      Walmart Item Management API
```

---

## 2. Technology Stack

### 2.1 Agent Framework

| Component | Technology | Rationale |
|-----------|------------|-----------|
| Agent orchestration | **LangGraph** | Stateful multi-agent graphs; built-in cycle management; human-in-the-loop native |
| Agent runtime | **Python 3.11** | Best ecosystem for LangGraph + Anthropic SDK |
| LLM — content generation | **Claude Sonnet (claude-sonnet-4-6)** | Best-in-class for long-form content, follows brand guidelines accurately |
| LLM — classification/triage | **Claude Haiku** | Fast and cheap for categorization tasks (issue classification, risk scoring) |
| Structured output | **Pydantic models** | Type-safe agent outputs; validates before any write operation |

### 2.2 Data Layer

| Component | Technology | Purpose |
|-----------|------------|---------|
| Primary database | **PostgreSQL 16** | Catalog state, issue tracking, action history |
| Task queue | **Redis + Celery** | Async agent jobs; retry logic; scheduled runs |
| Vector store | **Pinecone** | Keyword embeddings for semantic similarity; competitor listing comparison |
| Cache | **Redis** | API response caching (Walmart API has strict rate limits) |
| File storage | **S3** | Agent outputs, diff snapshots, brand guidelines |

### 2.3 API Layer

| Component | Technology | Purpose |
|-----------|------------|---------|
| Backend API | **FastAPI** | High-performance; async; OpenAPI auto-docs |
| Auth | **OAuth 2.0 + JWT** | Matches Walmart's own auth model |
| WebSocket | **FastAPI WebSocket** | Live activity feed on dashboard |
| Job scheduler | **Celery Beat** | Weekly agent run scheduling |

### 2.4 Frontend

| Component | Technology | Purpose |
|-----------|------------|---------|
| Framework | **React 18 + TypeScript** | Embedded as a Seller Center App |
| State management | **Zustand** | Lightweight; no Redux overhead for this scope |
| UI components | **Walmart Design System** | Native look/feel; access via Seller Center App SDK |
| Real-time updates | **WebSocket + React Query** | Live activity feed, agent status tiles |

---

## 3. Agent Architecture Details

### 3.1 Signal Ingestion Service

**Not an agent — runs as a scheduled service (Celery Beat)**

```python
class SignalIngestionService:
    """Polls Walmart APIs and normalizes into AgentContext objects"""

    async def run(self, seller_id: str) -> IngestionResult:
        tasks = await asyncio.gather(
            self.fetch_assortment_growth(seller_id),
            self.fetch_listing_quality(seller_id),
            self.fetch_seo_suggestions(seller_id),
            self.fetch_success_hub(seller_id),
        )
        return self.normalize_and_store(tasks)
```

**Output schema:**
```python
class ItemSignal(BaseModel):
    item_id: str
    sku: str
    name: str
    is_customer_favorite: bool
    lqs_score: float
    lqs_components: LQSBreakdown
    issue_count: int
    issues: list[ItemIssue]
    seo_suggestion: Optional[SEOSuggestion]
    success_hub_actions: list[SuccessHubAction]
    gmv_30d: float
    demand_rank: Optional[int]
    last_updated: datetime
```

### 3.2 Orchestrator Agent

**LangGraph state machine — the brain**

```python
class OrchestratorState(TypedDict):
    seller_id: str
    signals: list[ItemSignal]
    priority_queue: list[PrioritizedItem]
    agent_tasks: dict[str, list[AgentTask]]
    completed_actions: list[CompletedAction]
    review_queue: list[ReviewItem]

def score_item(signal: ItemSignal) -> float:
    """Priority score: higher = act sooner"""
    cf_weight = 2.0 if signal.is_customer_favorite else 1.0
    issue_weight = min(signal.issue_count / 10, 3.0)  # cap at 3x
    gmv_weight = math.log1p(signal.gmv_30d) / 10
    lqs_gap = (100 - signal.lqs_score) / 100
    return cf_weight * issue_weight * gmv_weight * lqs_gap
```

**Dispatch logic:**
```
For each issue in item.issues:
  → content/seo issues → SEO & Content Agent
  → inventory/fulfillment → Inventory Agent
  → program eligibility → Marketing Agent
  → image gaps → Catalog Audit Agent (flag only)
  → pricing gaps → Pricing Agent (route, don't act)
```

### 3.3 SEO & Content Agent

**Three-tier content generation strategy:**

```
Tier 1 — Accept Walmart Suggestion (Low complexity, Low risk)
  Condition: Walmart has a pending SEO suggestion + seller set action to Low risk
  Action: Accept via API, log to feed
  LLM calls: 0 (pure API action)

Tier 2 — Enhance Walmart Suggestion (Medium complexity)
  Condition: Item is Customer Favorite + Walmart suggestion exists
  Action: Use Walmart suggestion as base, enrich with brand guidelines + keywords
  LLM calls: 1 (Claude Sonnet)
  Prompt: enhance_seo_suggestion(base, brand_guidelines, top_keywords)

Tier 3 — Full Content Generation (High complexity, for new items)
  Condition: New item being added from Assortment recommendations
  Action: Generate title, description, bullets from scratch
  LLM calls: 2-3 (outline → draft → review)
  Prompt: generate_listing(product_knowledge, brand_guidelines, keyword_data)
```

**Content validation before any output:**
```python
class ContentValidator:
    def validate(self, content: ListingContent) -> ValidationResult:
        checks = [
            self.check_title_length(content.title, max=75),
            self.check_keyword_density(content.description),
            self.check_brand_voice(content, brand_guidelines),
            self.check_walmart_policy(content),  # no competitor mentions, etc.
            self.check_prohibited_claims(content),
        ]
        return ValidationResult(passed=all(checks), failures=[c for c in checks if not c.passed])
```

### 3.4 Catalog Audit Agent

**Issue classifier — runs Claude Haiku for speed**

```python
ISSUE_CATEGORIES = {
    "content_gap": ["missing_title_keywords", "short_description", "missing_bullets", "no_brand_story"],
    "attribute_gap": ["missing_required_attrs", "wrong_category", "missing_model_number"],
    "image_gap": ["too_few_images", "no_lifestyle_shot", "no_detail_shot", "no_white_bg_main"],
    "review_gap": ["no_reviews", "low_rating", "few_reviews"],
    "stock_issue": ["out_of_stock", "low_inventory", "not_published"],
    "pricing_gap": ["not_buy_box", "above_external_price"],  # → route to Pricing Agent
}

async def classify_item(item: ItemSignal) -> ClassificationResult:
    """Uses Claude Haiku to classify each issue into categories"""
    prompt = f"Classify these {len(item.issues)} issues for item '{item.name}'..."
    # Fast, cheap classification
    result = await haiku.complete(prompt, response_model=ClassificationResult)
    return result
```

### 3.5 Inventory & Fulfillment Agent

**Rule-based + LLM reasoning hybrid**

```python
class InventoryAgent:
    async def process(self, item: ItemSignal, success_hub: SuccessHubData) -> list[InventoryAction]:
        actions = []

        # Rule-based (no LLM needed)
        if item.is_out_of_stock and item.is_customer_favorite:
            actions.append(RestockAlert(priority="CRITICAL", item=item))

        if item.not_on_wfs and item.is_customer_favorite:
            roi = self.estimate_wfs_roi(item)
            actions.append(WFSEnrollmentDraft(item=item, estimated_roi=roi))

        # LLM reasoning for complex cases
        if item.shipping_score < 80:
            reasoning = await claude.reason_shipping_gap(item, brand_context)
            actions.append(ShippingRecommendation(item=item, reasoning=reasoning))

        return actions
```

### 3.6 Review & Publish Agent

**The trust layer — never bypassed**

```python
class ReviewItem(BaseModel):
    item: ItemSignal
    proposed_changes: list[ProposedChange]
    risk_level: RiskLevel
    confidence: float  # 0.0 - 1.0
    agent_reasoning: str
    diff: DiffSnapshot  # before/after for each field

class PublishAction:
    async def publish(self, review_item: ReviewItem, seller_approved: bool) -> PublishResult:
        if not seller_approved:
            raise ValueError("Cannot publish without seller approval for high-risk items")

        # Validate one final time before write
        validation = await self.validator.validate(review_item.proposed_changes)
        if not validation.passed:
            return PublishResult(success=False, reason=validation.failures)

        # Write to Walmart API
        result = await walmart_api.update_item(
            item_id=review_item.item.item_id,
            changes=review_item.proposed_changes
        )
        await self.log_action(review_item, result)
        return result
```

---

## 4. Risk Gate Implementation

```python
class RiskGate:
    """Determines fate of each proposed action based on seller's guardrail config"""

    def __init__(self, seller_guardrails: SellerGuardrails):
        self.guardrails = seller_guardrails

    def route(self, action: ProposedAction) -> ActionFate:
        risk_level = self.guardrails.get_risk(action.action_type)
        auto_apply = self.guardrails.get_auto_apply(action.action_type)

        if risk_level == RiskLevel.LOW and auto_apply:
            return ActionFate.AUTO_APPLY

        elif risk_level == RiskLevel.MEDIUM and auto_apply:
            return ActionFate.AUTO_APPLY_WITH_DIGEST

        else:  # HIGH risk or auto_apply=False
            return ActionFate.QUEUE_FOR_REVIEW

    async def process_batch(self, actions: list[ProposedAction]) -> RoutingResult:
        auto_apply = [a for a in actions if self.route(a) == ActionFate.AUTO_APPLY]
        auto_digest = [a for a in actions if self.route(a) == ActionFate.AUTO_APPLY_WITH_DIGEST]
        review_queue = [a for a in actions if self.route(a) == ActionFate.QUEUE_FOR_REVIEW]

        # Execute auto-apply immediately
        await self.execute_batch(auto_apply)

        # Stage digest items (execute + include in weekly summary)
        await self.execute_batch(auto_digest)
        await self.queue_for_digest(auto_digest)

        # Stage review items (do NOT execute)
        await self.stage_for_review(review_queue)

        return RoutingResult(
            auto_applied=len(auto_apply),
            auto_digest=len(auto_digest),
            awaiting_review=len(review_queue)
        )
```

---

## 5. Data Model

See `DATA_MODEL.md` for full schema. Key tables:

```sql
-- Core catalog state
CREATE TABLE catalog_items (
    id UUID PRIMARY KEY,
    seller_id VARCHAR NOT NULL,
    item_id VARCHAR NOT NULL,       -- Walmart Item ID
    sku VARCHAR NOT NULL,
    name TEXT,
    is_customer_favorite BOOLEAN,
    lqs_score DECIMAL(5,2),
    issue_count INT,
    gmv_30d DECIMAL(12,2),
    last_signal_at TIMESTAMP,
    UNIQUE(seller_id, item_id)
);

-- Agent action log
CREATE TABLE agent_actions (
    id UUID PRIMARY KEY,
    seller_id VARCHAR NOT NULL,
    item_id VARCHAR NOT NULL,
    action_type VARCHAR NOT NULL,
    risk_level VARCHAR NOT NULL,
    fate VARCHAR NOT NULL,           -- auto_apply | review | rejected
    proposed_changes JSONB,
    confidence DECIMAL(3,2),
    agent_reasoning TEXT,
    seller_decision VARCHAR,         -- approved | rejected | null
    decided_at TIMESTAMP,
    published_at TIMESTAMP,
    gmv_before DECIMAL(12,2),
    gmv_after DECIMAL(12,2),         -- populated 30 days after publish
    created_at TIMESTAMP DEFAULT NOW()
);

-- Seller guardrails config
CREATE TABLE seller_guardrails (
    seller_id VARCHAR NOT NULL,
    action_type VARCHAR NOT NULL,
    risk_level VARCHAR NOT NULL DEFAULT 'high',
    auto_apply BOOLEAN NOT NULL DEFAULT FALSE,
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (seller_id, action_type)
);
```

---

## 6. API Integration Points

### 6.1 Walmart APIs Used

| API | Method | Purpose | Rate Limit |
|-----|--------|---------|------------|
| `GET /v3/assortment/recommendations` | Read | Pull demand signals | 100/min |
| `GET /v3/items/lqs` | Read | Fetch LQS scores + issues | 60/min |
| `GET /v3/seo/suggestions` | Read | Fetch pending SEO suggestions | 60/min |
| `PUT /v3/items/{itemId}` | Write | Apply content changes | 20/sec |
| `POST /v3/seo/suggestions/accept` | Write | Accept SEO suggestions | 20/sec |
| `POST /v3/items/wfs-enrollment` | Write | Enroll items in WFS | 10/min |
| `GET /v3/analytics/sales` | Read | Fetch GMV data | 30/min |
| Webhook: `ASSORTMENT_GROWTH_NEW_RECOMMENDATIONS` | Event | New demand signals | N/A |

### 6.2 Rate Limit Strategy

```python
class WalmartAPIClient:
    """Rate-limit aware client with exponential backoff"""

    LIMITS = {
        "item_write": RateLimit(requests=20, period=1),    # 20/sec
        "item_read": RateLimit(requests=60, period=60),    # 60/min
        "analytics": RateLimit(requests=30, period=60),    # 30/min
    }

    async def update_item(self, item_id: str, changes: dict) -> APIResult:
        await self.rate_limiter.acquire("item_write")
        try:
            return await self._put(f"/v3/items/{item_id}", changes)
        except RateLimitError:
            await asyncio.sleep(self.backoff())
            return await self.update_item(item_id, changes)  # retry
```

---

## 7. Deployment Architecture

```
Production:
  ┌──────────────────────────────────────────┐
  │  Kubernetes Cluster (AWS EKS)            │
  │                                          │
  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  │
  │  │  API    │  │ Worker  │  │Scheduler│  │
  │  │ Service │  │  Pool   │  │ Service │  │
  │  │(FastAPI)│  │(Celery) │  │  (Beat) │  │
  │  └────┬────┘  └────┬────┘  └────┬────┘  │
  │       └────────────┴────────────┘        │
  │                    │                     │
  │  ┌─────────────────▼──────────────────┐  │
  │  │         Redis (ElastiCache)        │  │
  │  └─────────────────┬──────────────────┘  │
  │                    │                     │
  │  ┌─────────────────▼──────────────────┐  │
  │  │       PostgreSQL (RDS)             │  │
  │  └────────────────────────────────────┘  │
  └──────────────────────────────────────────┘
```

---

*Architecture Owner: Engineering Lead*
*Last updated: May 27, 2026*
