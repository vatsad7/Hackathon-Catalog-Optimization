# Risk Guardrails System
## Specification & Design

---

## Overview

The Risk Guardrails system is the trust layer of AI Autopilot. It gives sellers complete control over the agent's autonomy level — defining exactly which actions can happen automatically vs. which need human review.

This is the most important UX decision in the product: **a seller who doesn't configure guardrails still gets a safe, high-value experience** (sane defaults), while a power seller can tune the system to near-full automation.

---

## Risk Level Definitions

| Level | Agent Behavior | Seller Experience |
|-------|---------------|-------------------|
| 🟢 **Low** | Agent acts autonomously. Change is published. | Logged to Activity Feed. Visible in weekly digest. |
| 🟡 **Medium** | Agent acts autonomously. Change is published. | Included in weekly digest email. Seller can revert within 24 hrs. |
| 🔴 **High** | Agent drafts change. Does NOT publish. | Appears in Review Tray. Seller must approve. |

**Key principle:** The difference between Low and Medium is visibility, not autonomy. Both auto-apply. High is the only level that gates publishing.

---

## Default Guardrail Configuration

These are the out-of-box defaults. Chosen to be safe for first-time sellers while still providing value.

### Content & SEO

| Action | Default Risk | Default Auto-Apply | Rationale |
|--------|-------------|-------------------|-----------|
| Accept Walmart's SEO title suggestion | Low | ON | Walmart's own AI; low risk; 15% avg sales lift |
| Accept Walmart's SEO description suggestion | Low | ON | Same rationale |
| Enrich description with additional keywords | Low | ON | Additive only; no removal of existing content |
| Add missing product attributes | Medium | ON | Schema changes; needs visibility |
| Full listing rewrite (title + desc + bullets) | High | OFF | Brand voice risk; requires seller review |

### Images

| Action | Default Risk | Default Auto-Apply | Rationale |
|--------|-------------|-------------------|-----------|
| Flag missing images (alert only) | Low | ON | Read-only; no change made |
| Add supplemental images from brand assets | High | OFF | Brand integrity risk |
| Replace hero image | High | OFF | High-visibility change; always human-reviewed |

### Inventory & Fulfillment

| Action | Default Risk | Default Auto-Apply | Rationale |
|--------|-------------|-------------------|-----------|
| Out-of-stock alert (notify only) | Low | ON | No action taken; notification only |
| WFS enrollment recommendation | Medium | ON | Operational change; seller gets digest visibility |
| Simplified shipping settings update | Medium | ON | Operational; auto-apply with digest |
| Restock reminder (for WFS sellers) | Low | ON | Notification only |

### Marketing & Programs

| Action | Default Risk | Default Auto-Apply | Rationale |
|--------|-------------|-------------------|-----------|
| SEO Marketing suggestion bulk-accept | Low | ON | See Content & SEO |
| Review Accelerator enrollment | Medium | ON | Program enrollment; auto with digest |
| Flash Deals enrollment | High | OFF | Revenue impact; requires margin review |
| SEM campaign creation | High | OFF | Spend commitment; always reviewed |

### Assortment

| Action | Default Risk | Default Auto-Apply | Rationale |
|--------|-------------|-------------------|-----------|
| Flag new Customer Favorite opportunities | Low | ON | Signal/alert only |
| Draft new listing from Assortment signal | High | OFF | New catalog addition; always reviewed |
| Add item to catalog | High | OFF | Permanent catalog change; always reviewed |

---

## Guardrail Inheritance Rules

1. **High risk cannot be auto-applied** — if a seller sets an action to High risk and turns on auto-apply, the system ignores the auto-apply and treats it as requiring review. UI disables the toggle when High is selected.

2. **Risk level changes are prospective** — changing a guardrail affects the next run, not past actions. Already-queued Review Tray items are not re-routed.

3. **Brand guidelines gate content actions** — if no brand guidelines are configured, the SEO Content Agent drops to a more conservative mode (accept Walmart suggestions only; does not generate enhanced content).

4. **Pricing actions are always routed** — regardless of guardrail setting, pricing changes are routed to the Pricing Agent. This is non-configurable.

---

## Guardrails API Schema

```python
class GuardrailConfig(BaseModel):
    seller_id: str
    action_type: ActionType  # enum of all action types
    risk_level: Literal["low", "medium", "high"]
    auto_apply: bool

    @validator("auto_apply")
    def validate_auto_apply(cls, v, values):
        if values.get("risk_level") == "high" and v:
            raise ValueError("High risk actions cannot be auto-applied")
        return v

class SellerGuardrails(BaseModel):
    seller_id: str
    configs: list[GuardrailConfig]
    updated_at: datetime

    def get_fate(self, action_type: ActionType) -> ActionFate:
        config = next((c for c in self.configs if c.action_type == action_type), None)
        if not config:
            return ActionFate.QUEUE_FOR_REVIEW  # default to safe
        if config.risk_level == "high" or not config.auto_apply:
            return ActionFate.QUEUE_FOR_REVIEW
        if config.risk_level == "medium":
            return ActionFate.AUTO_APPLY_WITH_DIGEST
        return ActionFate.AUTO_APPLY  # low
```

---

## Trust Evolution Over Time

The guardrail system is designed to evolve with the seller's trust in the agent.

**Week 1–2:** Most sellers leave defaults. Agents handle Low risk items. Seller sees ~3-5 items in Review Tray.

**Week 3–4:** Seller has approved 80%+ of Review Tray items. UI prompts: *"You've approved 12 of 13 content rewrites. Want to auto-apply them going forward?"* → One-click to change High → Medium.

**Month 2–3:** Power seller has moved most actions to Low/Medium. Review Tray shrinks to 1-2 items/week (edge cases only).

**Month 6+:** Near-full automation. Seller checks Impact Dashboard monthly, not Review Tray weekly.

---

## Revert System

Even auto-applied changes can be reverted:

| Time since change | Revert method | SLA |
|-------------------|--------------|-----|
| < 24 hours | One-click revert from Activity Feed | Immediate |
| 24 hours – 7 days | Revert from Action History | < 5 minutes |
| > 7 days | Contact support | Manual |

---

*Last updated: May 27, 2026*
