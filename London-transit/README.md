# London Underground Ridership Analysis (SQL)

Exploratory SQL analysis of when, where, and why people ride the London Underground on a typical weekday.

- **Tools:** SQL (aggregation, multi-column `GROUP BY`, `WHERE` filtering, `ORDER BY`)
- **Context:** Case study completed in the Global Career Accelerator, summer 2026
- **Data:** Transport for London (TfL) Rolling Origin and Destination Survey (RODS), used as a training dataset

---

## Question

How do journey volume, timing, and trip purpose vary across the Underground network, and what would that suggest for service planning?

## Data

- 6,295 rows, modeling a typical November weekday
- Columns: `entry_zone` (Zones 1-5), `time_period` (Early, AM Peak, Midday, PM Peak, Evening, Late), `origin_purpose`, `destination_purpose` (Home, Work, Shop, Education, Tourist, Hotel, Other, Unknown), `distance` (5 bands), `daily_journeys`
- `daily_journeys` is a modeled estimate, not a count from a single day of observation

## Analysis

### 1. Overall usage

```sql
SELECT SUM(daily_journeys) AS total_journeys
FROM tfl.rods;
```
**Result:** 4,878,330 journeys on a typical day.

```sql
SELECT entry_zone, SUM(daily_journeys) AS total_journeys
FROM tfl.rods
GROUP BY entry_zone;
```
**Result:** 51.7% of journeys start in Zone 1.

```sql
SELECT time_period, SUM(daily_journeys) AS total_journeys
FROM tfl.rods
GROUP BY time_period
ORDER BY total_journeys DESC;
```
**Result:** PM Peak is the highest-volume period.

### 2. Why people ride

```sql
SELECT origin_purpose, destination_purpose, SUM(daily_journeys) AS total_journeys
FROM tfl.rods
GROUP BY origin_purpose, destination_purpose
ORDER BY total_journeys DESC;
```
**Result:** The two most common origin-destination pairs are Home-to-Work and Work-to-Home, so the network is used mainly for commuting.

### 3. Timing by purpose

```sql
SELECT origin_purpose, time_period, SUM(daily_journeys) AS total_journeys
FROM tfl.rods
GROUP BY origin_purpose, time_period
ORDER BY origin_purpose, total_journeys DESC;
```
**Result:** Trips starting at Home cluster in the AM Peak; trips starting at Work cluster in the PM Peak.

### 4. Purpose by zone

```sql
SELECT entry_zone, origin_purpose, SUM(daily_journeys) AS total_journeys
FROM tfl.rods
GROUP BY entry_zone, origin_purpose
ORDER BY entry_zone, total_journeys DESC;
```
**Result:** Work is the top origin purpose in Zone 1; Home is the top in Zones 2-5. This is consistent with a central business district surrounded by residential areas.

### 5. Tourist travel

```sql
SELECT origin_purpose, destination_purpose, time_period, SUM(daily_journeys) AS total_journeys
FROM tfl.rods
WHERE origin_purpose = 'Tourist' OR destination_purpose = 'Tourist'
GROUP BY origin_purpose, destination_purpose, time_period
ORDER BY total_journeys DESC;
```
**Result:** Tourist trips concentrate at Midday, unlike commuter trips, which concentrate in the AM and PM peaks.

## Findings summary

| Finding | Detail |
|---|---|
| Scale | ~4.9M journeys on a typical weekday |
| Geographic concentration | 51.7% of trips start in Zone 1 |
| Peak demand | PM Peak has the highest volume |
| Dominant use | Home/Work commuting |
| Zone profile | Zone 1 skews work; Zones 2-5 skew home |
| Off-peak demand | Tourist travel peaks at Midday |

## Recommendation

Concentrate service frequency into Zone 1 during the AM and PM commute windows, where demand is highest. Midday capacity in central zones could be tuned separately for tourist demand.

## Limitations

- Figures come from a modeled typical weekday in November, so they may not hold for other seasons or days.
- Distances are grouped into bands, which limits fine-grained trip-length analysis.
- Some trips have unknown or unspecified purposes.
- Descriptive analysis only: it shows association, not cause, and no forecasting was done.
