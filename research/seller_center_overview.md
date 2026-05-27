# Walmart Seller Center — Comprehensive Overview
*Research compiled for the Assortment Growth Agentic Framework*

---

## 1. What Is Walmart Seller Center?

**Walmart Seller Center** (`seller.walmart.com`) is the centralized command dashboard for all third-party Marketplace sellers on Walmart.com. Every operational and strategic action a seller can take — from listing a product to analyzing performance to growing their catalog — is managed through this portal.

Key facts:
- As of late 2024, Walmart Marketplace has **150,000+ third-party sellers**, growing ~20% YoY.
- Walmart.com draws **120M+ unique monthly visitors**.
- Marketplace grew **27% YoY in Q4 2025**.
- Zero monthly or setup fees — Walmart charges a referral fee per sale.
- Access at `seller.walmart.com` (uses 2FA via email code).

---

## 2. Seller Center — Navigation Structure

Seller Center is organized into **three conceptual pillars**:

### 🟦 SETUP — Build Your Catalog
### 🟨 MANAGE — Run Daily Operations
### 🟩 GROW — Expand & Optimize

---

## 3. Main Tabs & Their Functions

### 📦 CATALOG Tab
The primary workspace for product management.

| Sub-feature | Description |
|---|---|
| **Add Items** | Single item (search existing Walmart catalog OR create new), bulk upload (spreadsheet/API), or match existing listings |
| **Review Catalog** | View all published items, check status, edit details |
| **Unpublished Items Dashboard** | See listing issues requiring attention before going live |
| **Pending Review** | Flagged items, duplicate listings, prohibited items |
| **Listing Issues** | Errors in attributes, images, descriptions |
| **International Orders** | Cross-border order management |

**Item Setup Methods:**
1. **Search & Match** — Match to already-existing Walmart listing (no need to reupload images/brand info)
2. **Create New Item** — Full setup from scratch (GTIN, category, title, description, images, price, shipping weight)
3. **Bulk Spreadsheet Upload** — .xlsx under 5MB; min fields: GTIN, Shipping Weight, Price
4. **Walmart Template** — Full-setup template or "set up by match" template
5. **API Integration** — Developer Portal (Client ID + Client Secret); ideal for large catalogs

---

### 📬 ORDERS Tab
Managing the full order lifecycle.

| Feature | Description |
|---|---|
| Acknowledge Orders | Must check off each incoming order |
| Fulfillment Management | Set up Seller-Fulfilled, WFS (Walmart Fulfillment Services), or 3P provider |
| Returns & Refunds | Process customer returns |
| Disputes | Resolve order disputes |
| Tracking Updates | Update shipment tracking numbers |
| Split Orders | Batch shipping across multiple shipments |

**Fulfillment Options:**
- **Seller-Fulfilled** — Your own US-based fulfillment center, set via Settings > Seller Fulfillment
- **WFS (Walmart Fulfillment Services)** — Walmart warehouses handle pick/pack/ship; unlocks 2-day delivery badge
- **3P Solution Provider** — Partners like Deliverr, ShipBob

---

### 💰 PAYMENTS Tab
Financial management dashboard.

| Feature | Description |
|---|---|
| Payment Statements | Track all Marketplace payments and transactions |
| Transactions Report | Financial performance breakdown |
| Capital Sub-tab | Loan/financing options for business growth (Walmart Marketplace Capital) |
| Marketplace Wallet | Receive and transfer funds |

---

### 📊 PERFORMANCE Tab
Operational health monitoring.

Key metrics tracked:
- **Order Defect Rate** — Percentage of orders with issues
- **On-Time Shipment Rate** — % shipped within promised window
- **Cancellation Rate** — Seller-initiated cancellations
- **Customer Feedback** — Ratings and complaints
- **Refund Rate** — Volume of returns
- **Policy Compliance** — Adherence to Walmart's selling standards

Poor performance leads to listing suppression or account suspension.

---

### 📈 ANALYTICS Tab
Sales intelligence and buyer behavior data.

| Sub-section | What It Does |
|---|---|
| **Sales Reports** (Account + Item level) | GMV, AUR (Average Unit Retail), units sold; visual dashboards with multi-metric comparison |
| **Search Insights Dashboard** | How items are found: top keywords, search traffic, ranking, conversion rate; items with LQS < 50 may be omitted |
| **Consumer Insights** | Purchasing behavior of customers who bought your items |
| **Reports** | Downloadable historical data exports |
| **Conversion Funnel** *(New 2026)* | Visibility → Clicks → Add to Cart → Purchase funnel |
| **Repeat Purchase Tracking** *(New 2026)* | Loyalty and repeat buyer data |
| **Category-Level Benchmarking** *(New 2026)* | Compare your metrics against category averages |

> **2026 Update:** Walmart launched a completely redesigned Analytics dashboard in April 2026 with near real-time metrics (previously 48–72 hr lag), conversion funnel visibility, and repeat purchase tracking.

---

### 🌱 GROWTH Tab ← **Most relevant to your project**
The engine for catalog expansion and listing optimization. This is where **Assortment Growth** lives.

Sub-sections:
1. **Assortment Growth Dashboard** ← (see deep dive below)
2. **Listing Quality Dashboard**
3. **Search Engine Marketing (SEM)** — Google discoverability
4. **Repricer** — Automated competitive pricing
5. **Pro Seller Program** — Badge for top performers
6. **Review Accelerator / Post-Purchase Reviews**
7. **Brand Portal** — Brand management hub
8. **Success Hub** — Expert guidance
9. **Walmart LocalFinds** — Local order routing

---

### 📣 ADVERTISING Tab
Paid visibility tools via **Walmart Connect**.

| Product | Description |
|---|---|
| **Sponsored Products** | CPC ads at item level; Q4 2024 avg ROAS = 3.7x |
| **Sponsored Brands** | Brand banner/header ads |
| **Search Engine Marketing (SEM)** | Google Shopping ads powered by Walmart |
| **Ad Center** | Reporting dashboard; A/B testing, bid management |

---

### ⚙️ SETTINGS Tab
Account configuration: fulfillment centers, shipping templates, tax settings, user permissions, API credentials.

---

### 🛍️ APP STORE
Marketplace of third-party tools (analytics, repricing, listing management, etc.) that integrate with Seller Center.

---

## 4. 🌱 DEEP DIVE: Assortment Growth Dashboard

**Location:** `Seller Center > Growth > Assortment Growth`
**API endpoint for programmatic access available via Walmart Developer Portal**

This is the most strategically important dashboard for your use case. It's Walmart's AI/data-driven recommendation engine for catalog expansion.

---

### 4.1 What It Does
Walmart's Assortment Growth Dashboard uses **customer demand signals and category data** to recommend the most searched, best-selling items ("Customer Favorites") for sellers to add to their catalogs. According to Walmart's own data, **recommended items sell up to 2x faster** than other items.

The tool solves a core seller problem: *"What should I sell next?"*

---

### 4.2 The Three Components

#### A. Assortment Recommendations
*"Discover the most-searched, best-selling items across categories you already sell in."*

- **Personalized** to each seller's existing category/brand footprint
- Highlights items NOT currently available on Walmart.com (first-mover advantage)
- Quick setup feature to add items immediately to catalog
- Variant filtering to focus on relevant SKU opportunities
- Filters: Price range, Category, Brand
- **Bulk download** up to 5,000 item recommendations at once
- Recommendations refresh **biweekly**
- Items added or saved as draft are removed from the list

**Data signals shown per recommendation:**
- External price (competitor platforms — updated monthly)
- Buy Box winning price on Walmart.com
- Item demand score
- Top search keywords driving demand
- Demand trends (weekly/monthly toggle)
- Reason why this product is recommended

#### B. Assortment Explorer
*"View in-demand products and brands, including items in categories you may not already sell in."*

This is the **exploratory/discovery mode** — for sellers looking to enter new categories.

- Browse outside your current category footprint
- Advanced search and filtering
- **Seasonality trends** (weekly/monthly basis) — identify peak selling windows
- **Price trend analysis** — understand price movement over time
- Potential sales rank data
- Competition numbers
- Links to the same product on other marketplaces (Amazon, etc.)

#### C. Workspace Tab *(Newest feature)*
*"Fine-tune your assortment with prioritized action items."*

- Items bookmarked by YOU for acquisition (filter: "Items saved by me")
- Items recommended by your **account manager** (if assigned)
- Combination of new item acquisition AND existing offer optimization
- See which existing catalog offers need improvement
- Actions: List a new item, Update an existing offer, Review recommendations

---

### 4.3 Demand Signals (What Powers the Recommendations)

From the official Walmart Developer Portal documentation, the demand signals used are:

1. **Internal Search** — What Walmart.com users are actively searching
2. **External Search** — Google and other search engines driving product interest
3. **Best Sellers** — Top-performing products by sales volume on Walmart
4. **Trending Items** — Products with rapidly increasing demand curves
5. **Category Data** — Category-level performance benchmarks
6. **Seasonal Patterns** — Historical seasonality overlaid on current demand

---

### 4.4 Assortment Growth API (Developer Portal)
For programmatic access, the Walmart Developer Portal exposes:

| API Endpoint | Function |
|---|---|
| `GET /v3/assortment/recommendations` | Fetch personalized item recommendations |
| `GET /v3/assortment/categorization` | Get category structure |
| `POST /v3/assortment/recommendations/reject` | Remove irrelevant recommendations |
| `GET /v3/assortment/trends` | Pull demand trend data (US only) |
| `POST /v3/assortment/recommendations/onrequest` | Bulk download report (US only) |
| `GET /v3/assortment/variants` | View item variants for recommendations (US only) |

**Notification system:** Walmart sends webhook events when new recommendation sets are generated:
- `ASSORTMENT_GROWTH_NEW_RECOMMENDATIONS` — New general recommendations based on marketplace demand
- `ASSORTMENT_GROWTH_NEW_PARITY_RECOMMENDATIONS` — Items seller doesn't currently offer (assortment gap analysis)

**Auth:** Requires API Client ID + Client Secret with "Analytics & Growth" scope.

---

### 4.5 Incentives Tied to Assortment Growth
Walmart actively incentivizes sellers to act on recommendations:
- **Up to 75% off referral fees** when listing new Customer Favorite items
- Additional fee reductions for 2-Day Delivery or WFS-fulfilled items
- Recommendations refresh biweekly — timing matters for first-mover advantage

---

## 5. Listing Quality Dashboard (Critical for Catalog Optimization Agent)

**Location:** `Seller Center > Growth > Listing Quality`

This is the second most critical dashboard for your Catalog Optimization Agent use case.

### 5.1 The Listing Quality Score (LQS)
A score from **0–100** evaluated at both the catalog level and individual item level.

### 5.2 The Five Components of LQS

| Component | What It Measures |
|---|---|
| **Content Quality** | Title, description, bullet points, attributes completeness and quality |
| **Discoverability** | Keywords, SEO optimization, category placement |
| **Offer Strength** | Price competitiveness (Buy Box), price vs. category |
| **Published & In-Stock** | Item is live and has inventory available |
| **Ratings & Reviews** | Customer star ratings and review volume/recency |

> Items with LQS < 50 may be suppressed from search results and excluded from Search Insights reports.

### 5.3 What the Dashboard Shows
- LQS score breakdown by component, by category, by individual offer
- Rating: Poor / Good / Excellent tier for each component
- **Listing issues** — missing attributes, incorrect categorization
- **Missing keywords** — SEO gaps identified by Walmart
- **Improvement suggestions** — Specific, actionable recommendations
- **Customer Favorites filter** — See LQS specifically for trending/in-demand items
- **Priority tags** — Three tags flagging which listings require immediate attention
- Pre- and post-analytics: see how LQS changes after you make updates
- 12-page Listing Quality Optimization guide embedded in dashboard

### 5.4 Content Quality Score (CQS) — Sub-component
A focused 0–100 score purely on content:
- **Title:** Structure, keyword inclusion, length
- **Description:** Original, keyword-optimized, detailed
- **Images:** Resolution, angles, white background compliance, lifestyle shots
- **Bullet Points / Key Features:** Completeness, specificity
- **Product Attributes:** All required and recommended fields filled
- **Category Accuracy:** Correct sub-category assignment

### 5.5 Item 360
A related view (accessible via the dashboard) that shows a holistic, 360-degree snapshot of any individual item's performance — combining content score, traffic, conversion, reviews, and pricing in one place.

---

## 6. Search Insights Dashboard

**Location:** `Seller Center > Analytics > Search Insights`

Helps sellers understand *how* their items are being found and ranked.

| Data Point | Description |
|---|---|
| Top Keywords | Terms customers use to find your products |
| Search Ranking | Where your item appears in search results |
| Traffic Data | Page views and impressions per item |
| Conversion Rate | What % of viewers purchase |
| Lowest Converting Items | Bottom 500 SKUs by conversion (for optimization priority) |
| Top Selling Items | Top 500 SKUs by units sold |
| Actionable Insights | Specific recommendations to improve search performance |

> Items with LQS < 50 may be omitted from this report.

---

## 7. Consumer Insights

Behavioral data on customers who have purchased from a seller:
- Purchase behavior patterns
- Category affinities
- Repeat purchase likelihood

---

## 8. Pro Seller Program

A **badge/tier program** for top-performing sellers. Benefits include:
- Pro Seller badge on listings (builds buyer trust)
- Higher search ranking preference
- Access to exclusive growth programs

Qualification based on: LQS score, order defect rate, on-time shipping, customer satisfaction metrics.

---

## 9. Repricer

Automated pricing tool:
- Adjusts prices in real-time based on Buy Box competitiveness
- Set margin floor/ceiling thresholds
- Helps win and maintain the Buy Box
- Smart pricing rules by category/SKU

---

## 10. Advertising (Walmart Connect)

| Metric | Data |
|---|---|
| Sponsored Products Q4 2024 avg ROAS | 3.7x |
| Ad types | Sponsored Products, Sponsored Brands, Search Engine Marketing (Google) |
| Targeting | Keyword, category, item-level |
| Reporting | Ad Center dashboard with A/B testing, ROAS by campaign |

---

## 11. Walmart Fulfillment Services (WFS)

Third-party fulfillment by Walmart (like Amazon FBA):
- Sellers ship inventory to Walmart fulfillment centers
- Walmart handles pick, pack, ship, returns
- Unlocks **2-Day Delivery** and **Free Shipping** badges
- Significant LQS boost (shipping speed component)
- Cost: ~competitive with Amazon FBA per-item rates
- Listing items with WFS + recommendation from Assortment Growth = max referral fee discount

---

## 12. Walmart Developer Portal (API Access)

`developer.walmart.com` — Full REST API coverage for:
- Item management (create, update, retire)
- Order management
- Inventory updates
- Pricing
- **Analytics & Growth** (including Assortment Recommendations API)
- Fulfillment
- Returns
- Notifications/Webhooks

Auth: OAuth 2.0, Client ID + Client Secret per API scope.

---

## 13. AI & Smart Tools (2025–2026)

Walmart has been aggressively adding AI-powered features:

| Tool | Function |
|---|---|
| **AI-Powered Listing Tool** | Single and bulk item setup with AI-generated content; reduces time-to-market |
| **Smart Assistant** | 24/7 real-time support chatbot within Seller Center |
| **Biz Mentor** | AI advisor that gives inventory recommendations, listing improvement tips |
| **Repricer AI** | Real-time competitive pricing adjustments |
| **Review Accelerator Program** | Automated post-purchase review requests |
| **SEM Suggestions** | AI-generated Google Shopping ad recommendations |
| **Predictive Demand Forecasting** *(coming 2026)* | Inventory planning intelligence |

---

## 14. Seller Center — Complete Navigation Map

```
seller.walmart.com
│
├── 🏠 Home (Dashboard Overview)
│   └── KPI snapshot, tips, offers, announcements
│
├── 📦 Catalog
│   ├── Add Items (Single / Bulk / Match / API)
│   ├── Manage Items (Review, Edit, Retire)
│   ├── Unpublished Items
│   ├── Pending Review
│   └── Listing Issues
│
├── 📬 Orders
│   ├── Manage Orders
│   ├── Returns & Refunds
│   └── Disputes
│
├── 💰 Payments
│   ├── Statements
│   ├── Transactions
│   └── Capital (Financing)
│
├── 📊 Performance
│   ├── Order Defect Rate
│   ├── Shipping Performance
│   ├── Customer Feedback
│   └── Policy Compliance
│
├── 📈 Analytics
│   ├── Sales Reports (Account & Item)
│   ├── Search Insights
│   ├── Consumer Insights
│   ├── Conversion Funnel [NEW 2026]
│   ├── Repeat Purchase [NEW 2026]
│   ├── Category Benchmarks [NEW 2026]
│   └── Reports (Downloads)
│
├── 🌱 Growth  ← YOUR TARGET AREA
│   ├── Assortment Growth
│   │   ├── Assortment Recommendations (in-category demand)
│   │   ├── Assortment Explorer (cross-category discovery)
│   │   └── Workspace (bookmarks + account manager actions)
│   ├── Listing Quality Dashboard
│   │   ├── LQS Score (0–100)
│   │   ├── Content Quality
│   │   ├── Discoverability
│   │   ├── Offer Strength
│   │   ├── In-Stock Status
│   │   └── Ratings & Reviews
│   ├── Search Insights
│   ├── Repricer
│   ├── Pro Seller Program
│   ├── Review Accelerator
│   ├── Brand Portal
│   ├── Success Hub
│   └── Walmart LocalFinds
│
├── 📣 Advertising
│   ├── Sponsored Products
│   ├── Sponsored Brands
│   └── Search Engine Marketing (Google)
│
├── 🚚 Fulfillment Settings
│   ├── WFS Enrollment
│   ├── Seller-Fulfilled Centers
│   └── Shipping Templates
│
├── ⚙️ Settings
│   ├── Account Info
│   ├── Tax Settings
│   ├── User Permissions
│   └── API Credentials
│
└── 🛍️ App Store (3P integrations)
```

---

## 15. Key Takeaways for Your Agentic Framework

### What the Assortment Growth Tab Gives You:
1. **Demand-ranked item recommendations** personalized to the seller's existing category
2. **External competitor pricing** (Amazon, etc.) per recommended item
3. **Walmart Buy Box winning price** per item
4. **Search keywords** driving demand for each item
5. **Demand trend data** (weekly/monthly) with seasonality
6. **Cross-category discovery** via Assortment Explorer
7. **Competition density** (how many sellers currently offer the item)
8. **Bulk export** of up to 5,000 recommendations at once
9. **Webhook notifications** when new recommendation sets publish
10. **"Not yet on Walmart.com" items** — first-mover catalog gap opportunities

### What the Listing Quality Dashboard Gives You (for Catalog Optimization Agent):
1. Per-item LQS score breakdown across 5 dimensions
2. Missing attributes list per SKU
3. Missing/weak keywords per SKU
4. SEO improvement suggestions (title, description, bullet points)
5. Image quality flags
6. Pricing competitiveness signal
7. Inventory/in-stock signal
8. Review gap identification
9. Priority tagging of which items need attention most urgently
10. Pre/post analytics to measure impact of changes

---

*Sources: Walmart Marketplace official site, Walmart Developer Portal, MarketplaceLearn.Walmart.com, Seller Better Blog, third-party seller tools (SalesDuo, Threecolts, GoAura, GeekSeller, Sellercloud)*
*Last updated: May 2026*
