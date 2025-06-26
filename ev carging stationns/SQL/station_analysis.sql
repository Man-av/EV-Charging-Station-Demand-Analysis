DROP TABLE IF EXISTS ev_data;

CREATE TABLE ev_data (
    year REAL,
    month_name TEXT,
    date DATE,
    state TEXT,
    vehicle_class TEXT,
    vehicle_category TEXT,
    vehicle_type TEXT,
    ev_count REAL,
    sl_no INT,
    population REAL,
    percent TEXT,
    male REAL,
    female REAL,
    difference_mf REAL,
    sex_ratio REAL,
    rural REAL,
    urban REAL,
    area_km2 REAL,
    density_per_km2 REAL,
    ev_per_1000 REAL
);

DROP TABLE IF EXISTS charging_stations_staging;

CREATE TABLE charging_stations_staging (
    name TEXT,
    state TEXT,
    city TEXT,
    address TEXT,
    latitude TEXT,
    longitude TEXT,
    type TEXT
);

DROP TABLE IF EXISTS charging_stations;

CREATE TABLE charging_stations (
    name TEXT,
    state TEXT,
    city TEXT,
    address TEXT,
    latitude REAL,
    longitude REAL,
    type TEXT
);

select * from charging_stations_staging;

--Top 10 States by EV per 1000 People
SELECT 
    state, 
    ROUND(AVG(ev_per_1000)::numeric, 2) AS avg_ev_per_1000
FROM 
    ev_data
GROUP BY 
    state
ORDER BY 
    avg_ev_per_1000 DESC
LIMIT 10;


--Total EVs vs Total Stations by State
WITH ev_totals AS (
    SELECT 
        state, 
        SUM(ev_count) AS total_evs
    FROM 
        ev_data
    GROUP BY 
        state
),
station_totals AS (
    SELECT 
        state, 
        COUNT(*) AS station_count
    FROM 
        charging_stations_staging
    GROUP BY 
        state
)
SELECT 
    e.state,
    e.total_evs,
    COALESCE(s.station_count, 0) AS station_count,
    ROUND(e.total_evs::DECIMAL / NULLIF(s.station_count, 0), 2) AS evs_per_station
FROM 
    ev_totals e
LEFT JOIN 
    station_totals s 
ON 
    e.state = s.state
ORDER BY 
    evs_per_station DESC NULLS LAST;

--States with EVs but No Charging Stations\
SELECT 
    e.state, 
    SUM(e.ev_count) AS total_evs
FROM 
    ev_data e
LEFT JOIN 
    charging_stations_staging c 
ON 
    e.state = c.state
WHERE 
    c.state IS NULL
GROUP BY 
    e.state
ORDER BY 
    total_evs DESC;

--Most Common EV Vehicle Types
SELECT 
    vehicle_type, 
    SUM(ev_count) AS total
FROM 
    ev_data
GROUP BY 
    vehicle_type
ORDER BY 
    total DESC;

--top 10 cities with most charging stations
SELECT 
    city, 
    state, 
    COUNT(*) AS station_count
FROM 
    charging_stations_staging
GROUP BY 
    city, state
ORDER BY 
    station_count DESC
LIMIT 10;





