-- Confirm table exists and sample data
SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_name = 'german_rent_data';


SELECT * FROM german_rent_data LIMIT 5;




-- 1a. Add rent_per_m2 (if not exists)
ALTER TABLE german_rent_data
  ADD COLUMN IF NOT EXISTS rent_per_m2 numeric;


UPDATE german_rent_data
SET rent_per_m2 = NULLIF(totalrent, 0) / NULLIF(livingspace, 0)
WHERE livingspace IS NOT NULL AND totalrent IS NOT NULL;


-- 1b. Add clean PLZ and ensure it's text (useful for joining)
ALTER TABLE german_rent_data
  ADD COLUMN IF NOT EXISTS plz_text text;


UPDATE german_rent_data
SET plz_text = CAST(geo_plz AS text)
WHERE geo_plz IS NOT NULL;


-- 1c. Add a cleaned city/state column (lowercase, trimmed)
ALTER TABLE german_rent_data
  ADD COLUMN IF NOT EXISTS regio1_clean text;


UPDATE german_rent_data
SET regio1_clean = trim(regio1)
WHERE regio1 IS NOT NULL;



-- Count total rows and missing
SELECT COUNT(*) AS total_rows,
       COUNT(totalrent) AS non_null_totalrent,
       COUNT(livingspace) AS non_null_livingspace
FROM german_rent_data;


-- Average and median rent by state (regio1_clean)
SELECT regio1_clean AS state,
       COUNT(*) AS listings,
       ROUND(AVG(totalrent)::numeric, 2) AS avg_rent,
       ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY totalrent)::numeric, 2) AS median_rent,
       ROUND(STDDEV_SAMP(totalrent)::numeric, 2) AS sd_rent
FROM german_rent_data
WHERE totalrent IS NOT NULL
GROUP BY regio1_clean
ORDER BY avg_rent DESC
LIMIT 50;



-- View: state summary
CREATE OR REPLACE VIEW vw_state_rent_summary AS
SELECT
  regio1_clean AS state,
  COUNT(*) AS listings,
  ROUND(AVG(totalrent)::numeric, 2) AS avg_rent,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY totalrent)::numeric, 2) AS median_rent,
  ROUND(AVG(rent_per_m2)::numeric, 2) AS avg_rent_per_m2
FROM german_rent_data
WHERE totalrent IS NOT NULL AND livingspace IS NOT NULL
GROUP BY regio1_clean
ORDER BY avg_rent DESC;


-- View: key metrics for dashboard (KPI)
CREATE OR REPLACE VIEW vw_kpis AS
SELECT
  COUNT(*) FILTER (WHERE totalrent IS NOT NULL) AS total_listings,
  ROUND(AVG(totalrent)::numeric, 2) AS overall_avg_rent,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY totalrent)::numeric, 2) AS overall_median_rent,
  ROUND(AVG(rent_per_m2)::numeric, 2) AS overall_avg_rent_per_m2
FROM german_rent_data;



-- Top 20 most expensive states (by average rent)
SELECT state, avg_rent, listings
FROM vw_state_rent_summary
ORDER BY avg_rent DESC
LIMIT 20;


-- Rent distribution summary (by number of rooms)
SELECT norooms, COUNT(*) AS listings,
       ROUND(AVG(totalrent)::numeric,2) AS avg_rent
FROM german_rent_data
WHERE totalrent IS NOT NULL
GROUP BY norooms
ORDER BY norooms;


-- Price trend
SELECT date_trunc('month', to_date(date, 'MonYY'))::date AS month, 
       ROUND(AVG(totalrent)::numeric,2) AS avg_rent
FROM german_rent_data
WHERE date IS NOT NULL 
GROUP BY month
ORDER BY month;



CREATE INDEX IF NOT EXISTS idx_german_rent_regio1 ON german_rent_data (regio1_clean);
CREATE INDEX IF NOT EXISTS idx_german_rent_plz ON german_rent_data (plz_text);
CREATE INDEX IF NOT EXISTS idx_german_rent_totalrent ON german_rent_data (totalrent);
