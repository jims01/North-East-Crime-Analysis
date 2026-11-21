# Crime in the North East: Rates per 1,000 Residents

Which areas of the North East have the highest levels of crime? This project combines police.uk street-level crime data with Census 2021 population figures to compare crime **rates** (not just counts) across the region's 12 local authorities, and presents the results in a Power BI dashboard.

![Dashboard](images/dashboard.png)

## Key findings
- **Highest rate:** Middlesbrough (172.8 crimes per 1,000 residents), followed by Hartlepool (149.2) and Stockton-on-Tees (132.7). **Lowest:** Northumberland (60.7), followed by North Tyneside (73.5) and Gateshead (77.3).
- **The four highest-rate authorities are all in the Tees Valley** (Middlesbrough, Hartlepool, Stockton-on-Tees, Redcar and Cleveland), all covered by Cleveland Police.
- **Year-on-year change, Oct–Dec 2025 vs Oct–Dec 2024 (excluding ASB):** the largest increases were in Stockton-on-Tees (+11.1%), Redcar and Cleveland (+8.9%), Hartlepool (+6.8%) and Middlesbrough (+6.0%). Crime fell in Sunderland (−0.6%), Newcastle upon Tyne (−2.8%) and South Tyneside (−3.3%).
- Across the 12 authorities the overall rate is **98.2 crimes per 1,000 residents** (October 2025 to September 2026, all crime types except anti-social behaviour).

## Data
| Source | What it provides |
|---|---|
| [police.uk street-level crime data](https://data.police.uk/) | Crimes recorded by Northumbria, Durham and Cleveland police forces, Sep 2024 – Sep 2026 (684,661 rows loaded) |
| ONS Census 2021, table TS001 (via Nomis) | Resident population for 1,682 LSOAs across the 12 North East local authorities |

Both datasets are published under the Open Government Licence.

## Tools
SQL Server, Python (pandas), Power BI (DAX)

## Method
1. **Load:** imported the monthly police.uk files into a staging table (`Crime_staging`), then into `CrimesDB`.
2. **Clean:**
   - Dropped Longitude, Latitude and Context, which weren't needed for an area-level comparison
   - Converted `Month` to a proper date type in pandas
   - Found **16 duplicate Crime IDs** and built a deduplicated view (`vw_crime_clean`) that keeps the first-loaded copy, leaving the raw data untouched (684,645 unique crimes)
3. **Link to population:** extracted the local authority from each LSOA name, loaded Census population into `population_staging`, and joined the two.
4. **Model:** built reporting views, `vw_crime_monthly` (4,190 rows) and `vw_population_la`, and loaded them into Power BI with a one-to-many relationship.
5. **Measure:** wrote DAX measures for crimes per 1,000 residents and year-on-year % change, then checked them against the SQL results. They matched, with and without ASB.

## Decisions and limitations
- **Northumbria data gap:** Northumbria Police records drop sharply in January–February 2026 and look incomplete (visible in the trend chart). To avoid distorting the change figures, the year-on-year comparison uses **Oct–Dec 2025 vs Oct–Dec 2024** only (three months). Rates for the six Northumbria Police authorities may be understated for any period that includes Jan–Feb 2026.
- **ASB excluded from headline figures:** anti-social behaviour is recorded differently from other crime types, so headline rates exclude it unless selected in the crime-type filter.
- **Unmatched records:** 6,252 of 684,645 crimes (0.9%) fall outside the 12 authorities or have no recorded location, so they are excluded from area rates.
- **Rates use resident population,** so areas with large visitor or night-time populations, such as city centres, may look higher than their residents' experience of crime.
- **Short comparison window:** a three-month year-on-year change is sensitive to seasonal and recording differences, so treat it as indicative, not a trend.

## Repository structure
```
sql/        # table creation, cleaning, and views
python/     # pandas scripts (date conversion, loading)
powerbi/    # .pbix file and DAX measures
images/     # dashboard screenshot
```
<!-- adjust to match your repo -->

## Possible extensions
- LSOA-level map using boundary files, to show variation within each authority
- Compare rates with deprivation data
