# Glucose Metric Calculator

This Ruby on Rails application calculates and displays glucose metrics based on continuous glucose monitoring data for a member. The dashboard shows metrics for the last 7 days and the current calendar month, with comparisons to the prior period.

## Metrics Implemented

- **Average Glucose (mg/dL)**
- **Time Above Range** (% of readings > 180 mg/dL)
- **Time Below Range** (% of readings < 70 mg/dL)
- Metrics are calculated for:
  - The **last 7 days** (local time)
  - The **current calendar month** (local time)
- **Change from the prior period** is shown for each metric, or `"N/A"` if unavailable.

## Assumptions

- The database contains only one member with `member_id = 1`.
- To view the dashboard, navigate to `http://localhost:3000/members/<member_id>/dashboard`
- `tested_at` is stored in **UTC**, and `tz_offset` represents the member’s local timezone offset in the format `"±HH:MM"`.
- Metrics are calculated based on the member’s **local time**, by converting each `tested_at` timestamp using `getlocal(tz_offset)`.

## Future Improvements

If given more time, I would:

- Add **unit tests** to validate metric calculation logic, timezone conversion logic, and handling of missing data
- Add **support for member ID input** to allow members or coaches to view specific dashboards.
- Implement **authentication** to ensure that only authorized users can view dashboards.
- Build support for **multiple members**, including navigation UI.
- Metrics are recalculated every tiem the dashboard is loaded. I'd look into **caching metircs** temporarily so that repeated visits to the dashboard don't repeat the same work.
- Reduce data filtering in Ruby: Because each glucose reading has its own time zone offset, filtering is currently done in Ruby after loading all records. I’d explore ways to reduce data filtering in Ruby to limit the amount of data pulled from the database first, before applying local time filtering.
