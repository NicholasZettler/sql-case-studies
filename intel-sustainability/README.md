# Intel Device Repurposing: Sustainability Impact Analysis (SQL)

SQL analysis of Intel's 2024 device-repurposing program to find which devices deliver the most environmental benefit and where the program should focus.

- **Tools:** SQL (`INNER JOIN`, CTEs via `WITH`, `CASE WHEN` bucketing, aggregation, `GROUP BY`)
- **Context:** Portfolio project completed in the Global Career Accelerator, summer 2026
- **Data:** Two joined tables (`intel.device_data`, `intel.impact_data`), a synthetic dataset built by the program to mirror Intel's real data. All figures are illustrative.

---

## Question

Which repurposed devices (by type, age, and region) generate the most energy and CO₂ savings, and how should Intel prioritize its program for maximum impact?

## Data

Two tables joined on `device_id`:

**`intel.device_data`**
- `device_id`, `device_type` (Laptop / Desktop), `model_year`

**`intel.impact_data`**
- `impact_id`, `device_id`, `usage_purpose`, `power_consumption` (W)
- `energy_savings_yr` (kWh saved per device per year vs. a new device)
- `co2_saved_kg_yr` (kg CO₂ saved per device per year)
- `recycling_rate` (%), `region` (North America / Europe / Asia)

Derived fields: `device_age` = 2024 − `model_year`; `device_age_bucket` (newer ≤3, mid-age 4-6, older 6+).

## Analysis

### Task 1: Join and prepare

Joined the two tables, added `device_age`, and bucketed age with `CASE WHEN`. Ordering by `model_year` showed older devices dominate the repurposing pool, which makes sense: people don't repurpose devices still in active use.

### Task 2: Overall impact

```sql
WITH repurposed AS (
    SELECT d.*, i.*,
           2024 - d.model_year AS device_age
    FROM intel.device_data d
    INNER JOIN intel.impact_data i ON d.device_id = i.device_id
)
SELECT COUNT(*)                    AS total_devices,
       AVG(device_age)             AS avg_device_age,
       AVG(energy_savings_yr)      AS avg_energy_savings_kwh,
       SUM(co2_saved_kg_yr) / 1000 AS total_co2_saved_tons
FROM repurposed;
```

| Metric | Result |
|---|---|
| Total devices repurposed (2024) | 601,740 |
| Avg. energy savings per device | 25.7 kWh/year |
| Total CO₂ saved | 6,768 tons/year |

For scale, ~6,768 tons of CO₂ is roughly equal to taking ~471 cars off the road for a year.

### Task 3: Trends by type, age, and region

Aggregated energy and CO₂ savings grouped by `device_type`, then `device_age_bucket`, then `region`.

- **By type:** Laptops and desktops save about the same per unit (~25 kWh). Laptops contribute more in total only because there are roughly twice as many (~400k vs. ~200k). Type is not the lever.
- **By age:** Older devices (6+ years) save the most per unit (~48 kWh, ~0.021 tons CO₂), more than double the newer bucket (~19 kWh, ~0.0083 tons). But newer devices dominate volume (~317k), so the program is concentrated in its least efficient segment.
- **By region:** Energy savings are near-identical across regions (~25.7 kWh), but CO₂ savings differ sharply. Asia saves ~2.4x more CO₂ per device than Europe, because a more fossil-heavy grid means each avoided kWh displaces more CO₂.

## Findings summary

| Dimension | Key finding |
|---|---|
| Type | No per-unit difference; laptop advantage is volume only |
| Age | Older devices save 2.5x the CO₂ per unit vs. newer |
| Age vs. volume | 317k newer devices deliver the lowest per-unit return |
| Region | Same energy savings, but Asia saves 2.4x the CO₂ of Europe |

## Recommendation

Rebalance intake toward older devices and concentrate outreach in Asia. Older devices deliver ~2.5x the per-unit CO₂ savings of newer ones but make up only a small share of volume, and Asia's grid converts each saved kWh into more avoided CO₂. Shifting the mix toward high-yield devices and high-carbon-grid regions raises total impact without needing more devices overall.

## Limitations

- Synthetic dataset for training; conclusions are illustrative, not real Intel results.
- Descriptive analysis only: it shows associations, not causes.
- No cost data, so recommendations optimize for environmental impact alone.
- Scale-up figures (cars, households) are order-of-magnitude comparisons, not precise estimates.
