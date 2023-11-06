-- Аналитическое представление "Количество водителей по бренду авто и цвету машины"
CREATE VIEW parking.drivers_by_car_brand_and_color AS
SELECT c.brand, c.color, COUNT(d.driver_id) AS driver_count
FROM parking.car c
JOIN parking.driver d ON c.driver_id = d.driver_id
GROUP BY ROLLUP(c.brand, c.color);

SELECT * FROM drivers_by_car_brand_and_color

-- Аналитическое представление "Итоговая выручка за три месяца по парковочным местам"
CREATE OR REPLACE VIEW parking.total_sum_price_by_parking_spot AS
SELECT 
    (CASE WHEN GROUPING(ps.spot_number) = 1 THEN 'TOTAL_SUM'::varchar(50)
         ELSE ps.spot_number END) AS spot_number, 
    round(sum(pt.price*EXTRACT(EPOCH FROM (r.end_time - r.start_time))/3600),2) AS total_sum_price
FROM parking.parking_spot ps 
JOIN parking.parking_spot_type pt ON ps.type_id = pt.type_id
JOIN reservation r ON r.parking_spot_id = ps.spot_id 
WHERE r.start_time >= NOW() - INTERVAL '2 month' AND r.end_time <= NOW()
GROUP BY CUBE(ps.spot_number);

SELECT * FROM total_sum_price_by_parking_spot;

DROP VIEW total_sum_price_by_parking_spot

-- Аналитическое представление "Количество свободных и забронированных парковочных мест по типу и зоне"

CREATE VIEW parking.parking_spot_count_by_type_and_zone AS
SELECT 
    (CASE WHEN GROUPING(pst.type_name) = 1 THEN 'RESULT_FOR_ZONE'::VARCHAR(50) 
        ELSE pst.type_name END) as type_name,
    (CASE WHEN GROUPING(pzone.zone_name) = 1 THEN 'RESULT_FOR_TYPE'::VARCHAR(50) 
        ELSE pzone.zone_name END) as zone_name,  
    COUNT(*) AS spot_count, 
    SUM(CASE WHEN ps.status_id = 1 THEN 1 ELSE 0 END) AS free_spots,
    SUM(CASE WHEN ps.status_id = 2 THEN 1 ELSE 0 END) AS reserved_spots
FROM parking.parking_spot ps
JOIN parking.parking_spot_type pst ON ps.type_id = pst.type_id
JOIN parking.parking_zone pzone ON ps.zone_id = pzone.zone_id
GROUP BY GROUPING SETS ((pst.type_name, pzone.zone_name), pst.type_name, pzone.zone_name);

SELECT * FROM reservations_by_start_time;
-- Аналитическое представление "Количество бронирований по дате и времени"

CREATE VIEW parking.reservations_by_start_time AS
SELECT DATE(start_time) AS reservation_date, 
       EXTRACT(HOUR FROM start_time) AS reservation_hour,
       COUNT(*) AS reservation_count
FROM parking.reservation
GROUP BY ROLLUP(reservation_date, reservation_hour);



CREATE OR REPLACE VIEW parking.parking_zone_hierarchy AS
WITH RECURSIVE all_zones AS (
  SELECT zone_id, zone_name, parent_zone_id, 1 AS level
  FROM parking.parking_zone
  WHERE parent_zone_id IS NULL
  UNION ALL
  SELECT z.zone_id, z.zone_name, z.parent_zone_id, az.level + 1 AS level
  FROM parking.parking_zone z
  JOIN all_zones az ON z.parent_zone_id = az.zone_id
)
SELECT zone_id, zone_name, parent_zone_id, level
FROM all_zones;

CREATE OR REPLACE VIEW total_number_reservations_foreach_driver_durability
AS
SELECT 
    reservation_id, 
    driver.driver_id, 
    start_time, 
    end_time, 
    COUNT(*) OVER ww  AS total_reservations,
    AVG(end_time - start_time) OVER ww AS average_duration 
FROM parking.reservation 
JOIN parking.car 
ON reservation.car_id = car.car_id 
JOIN parking.driver 
ON car.driver_id = driver.driver_id
WINDOW ww AS (PARTITION BY driver.driver_id);

CREATE OR REPLACE VIEW drivers_number_reserved_parking_spaces_foreach_month
AS
SELECT
d.first_name,
d.last_name,
EXTRACT(MONTH FROM r.start_time) AS month,
COUNT(r.reservation_id) OVER (PARTITION BY d.driver_id, EXTRACT(MONTH FROM r.start_time)) AS num_reserved_spots
FROM
parking.driver d
LEFT JOIN
parking.car c ON d.driver_id = c.driver_id
LEFT JOIN
parking.reservation r ON c.car_id = r.car_id

DROP VIEW reservation_rank

CREATE OR REPLACE VIEW reservation_rank
AS
SELECT 
    reservation_id,
    c.car_id,
    c.model,
    c.brand,
    c.color,
    start_time, 
    end_time,
    RANK() OVER (ORDER BY start_time) AS r_rank
FROM parking.reservation r
JOIN parking.car c 
ON c.car_id = r.car_id;

SELECT * FROM reservation_rank;

CREATE VIEW spot_bucket
AS
SELECT 
    zone_name, 
    spot_number, 
    NTILE(3) OVER (PARTITION BY ps.zone_id ORDER BY spot_number) AS spt_bucket
FROM parking.parking_spot ps
JOIN parking.parking_zone pz
ON ps.zone_id = pz.zone_id


CREATE VIEW spot_rank
AS
SELECT 
    spot_id, 
    spot_number, 
    rank() OVER (PARTITION BY zone_id, status_id ORDER BY spot_number) AS spt_rank
FROM parking.parking_spot;



SELECT * FROM spot_rank;

CREATE VIEW  parking.car_total_duraction
AS
SELECT 
    c.license_plate, 
    SUM(EXTRACT(HOUR FROM r.end_time - r.start_time)) AS total_duration
FROM parking.reservation r
JOIN parking.car c
ON c.car_id = r.car_id
GROUP BY c.license_plate;


SELECT * FROM car_total_duraction;


CREATE OR REPLACE VIEW security_guard_hierarchy AS
WITH RECURSIVE guard_hierarchy AS (
    SELECT guard_id, fio, contact_info, zone_id, security_guard_lead, 1 AS level
    FROM parking.security_guard
    WHERE security_guard_lead IS NULL
    UNION ALL

    SELECT sg.guard_id, sg.fio, sg.contact_info, sg.zone_id, sg.security_guard_lead, gh.level + 1
    FROM guard_hierarchy gh
    JOIN parking.security_guard sg ON sg.security_guard_lead = gh.guard_id
)
SELECT guard_id, fio, contact_info, zone_id, security_guard_lead, level
FROM guard_hierarchy;

CREATE VIEW parking.security_guard_hierarchy AS
WITH RECURSIVE guard_hierarchy AS (
    SELECT
        guard_id,
        fio,
        contact_info,
        zone_id,
        security_guard_lead,
        0 AS level
    FROM
        parking.security_guard
    WHERE
        security_guard_lead IS NULL
    UNION ALL
    SELECT
        sg.guard_id,
        sg.fio,
        sg.contact_info,
        sg.zone_id,
        sg.security_guard_lead,
        gh.level + 1
    FROM
        parking.security_guard AS sg
    JOIN
        guard_hierarchy AS gh ON sg.security_guard_lead = gh.guard_id
)
SELECT
    gh.guard_id,
    gh.fio,
    gh.contact_info,
    gh.zone_id,
    gh.security_guard_lead,
    gh.level,
    pz.zone_name AS zone_name,
    slf.fio AS security_guard_lead_fio
FROM
    guard_hierarchy AS gh
LEFT JOIN
    parking.parking_zone AS pz ON gh.zone_id = pz.zone_id
LEFT JOIN
    parking.security_guard AS slf ON gh.security_guard_lead = slf.guard_id;

SELECT * FROM security_guard_hierarchy
