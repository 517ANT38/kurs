CREATE INDEX car_driver_id_idx ON parking.car (driver_id);
DROP INDEX car_driver_id_idx;

CREATE INDEX parking_zone_parent_zone_id_idx ON parking.parking_zone (parent_zone_id);

CREATE INDEX parking_spot_status_id_idx ON parking.parking_spot (status_id);
CREATE INDEX parking_spot_type_id_idx ON parking.parking_spot (type_id);
CREATE INDEX parking_spot_zone_id_idx ON parking.parking_spot (zone_id);
CREATE UNIQUE INDEX parking_spot_number ON parking.parking_spot (spot_number);
CREATE INDEX parking_spot_last_modified_date ON parking.parking_spot(last_modified_date)

DROP INDEX parking_spot_number;
INSERT INTO parking_spot (status_id, type_id, zone_id, last_modified_date) 
SELECT status_id, type_id, zone_id, last_modified_date FROM parking_spot ps

DELETE FROM parking_spot WHERE spot_id > 1000;

ANALYZE parking_spot;

DROP INDEX fio_idx ON parking.security_guard (fio);

DROP INDEX security_guard_lead_idx ON parking.security_guard (security_guard_lead);

CREATE INDEX reservation_car_id_idx ON parking.reservation (car_id );
CREATE INDEX reservation_start_time_idx ON parking.reservation (start_time);
CREATE INDEX reservation_end_time_idx ON parking.reservation (end_time);
CREATE INDEX ON parking.reservation(start_time,end_time);
SELECT * FROM reservation ORDER BY start_time;

CREATE INDEX ON parking.driver(last_name);
CREATE INDEX ON parking.driver(last_name,first_name);

INSERT INTO reservation (
   
    parking_spot_id,
    car_id,
    start_time,
    end_time
  )
SELECT 
r.reservation_id,
    r.parking_spot_id,
    r.car_id,
    r.start_time,
    r.end_time
FROM reservation r;

ANALYZE reservation;
DELETE FROM reservation WHERE reservation_id > 1620;


SELECT * FROM driver;


SELECT * FROM parking_spot_type;