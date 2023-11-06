CREATE OR REPLACE PROCEDURE parking.get_driver_info(
    IN driver_id INT,
    OUT first_name VARCHAR(50),
    OUT last_name VARCHAR(50),
    OUT middle_name VARCHAR(50),
    OUT phone VARCHAR(50),
    OUT email VARCHAR(50)
) AS $$
BEGIN
    SELECT d.first_name, d.last_name, d.middle_name, d.phone, d.email
    INTO first_name, last_name, middle_name, phone, email
    FROM parking.driver d
    WHERE d.driver_id = driver_id;
END;
$$ LANGUAGE plpgsql;

CALL parking.get_driver_info(10,NULL,NULL,NULL,NULL,NULL);


CREATE OR REPLACE PROCEDURE parking.update_status_parking_slot(
   IN parking_spot_id  INT,
   IN st_new VARCHAR(50),
   OUT st_old VARCHAR(50) 
)
AS $$
DECLARE
    status_id_new INT;
    status_id_old INT;
BEGIN
    SELECT ps.status_id FROM parking.parking_spot_status ps 
    WHERE ps.status_name = st_new INTO status_id_new;
    
    SELECT ps.status_id FROM parking.parking_spot ps
    WHERE ps.spot_id = parking_spot_id INTO status_id_old;
    
    UPDATE parking.parking_spot SET status_id = status_id_new 
    WHERE spot_id = parking_spot_id;

    SELECT ps.status_name FROM parking.parking_spot_status ps 
    WHERE ps.status_id = status_id_old INTO st_old;
END;    
$$ LANGUAGE plpgsql;

CALL  parking.update_status_parking_slot(10,'FREE',NULL);

CREATE OR REPLACE PROCEDURE parking.create_parking_spot(
    IN st_name VARCHAR,
    IN t_name VARCHAR,
    IN z_name VARCHAR,
    OUT count_spot_after_add INT
)
AS
$$
DECLARE
    z_id INT;
    st_id INT;
    t_id INT;
BEGIN
    z_id := (SELECT zone_id FROM parking_zone WHERE z_name = zone_name);
    st_id := (SELECT status_id FROM parking.parking_spot_status WHERE status_name = st_name);
    t_id := (SELECT type_id FROM parking.parking_spot_type WHERE type_name = t_name);
    
    INSERT INTO parking.parking_spot(status_id,zone_id,type_id)
    VALUES(st_id,z_id,t_id);

    SELECT count(*) FROM parking.parking_spot INTO count_spot_after_add;
END;
$$ LANGUAGE plpgsql;


CALL create_parking_spot('FREE','VIP','D3W8E9',NULL);

DELETE FROM parking_spot WHERE spot_id > 1000;



CREATE OR REPLACE FUNCTION get_drivers()
RETURNS refcursor AS
$$
DECLARE
    driver_cursor refcursor;
BEGIN
    OPEN driver_cursor FOR
        SELECT * FROM parking.driver;
    RETURN driver_cursor;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_driver_cars()
RETURNS TABLE (
    driver_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    middle_name VARCHAR(50),
    phone VARCHAR(50),
    email VARCHAR(50),
    car_id INT,
    brand VARCHAR(50),
    model VARCHAR(50),
    license_plate VARCHAR(10),
    color VARCHAR(20)
) AS $$
BEGIN
RETURN QUERY
SELECT
    d.driver_id,
    d.first_name,
    d.last_name,
    d.middle_name,
    d.phone,
    d.email,
    c.car_id,
    c.brand,
    c.model,
    c.license_plate,
    c.color
FROM
parking.driver d
LEFT JOIN parking.car c ON d.driver_id = c.driver_id;
END;
$$ STABLE LANGUAGE plpgsql;

SELECT * FROM get_driver_cars();


DO $$
DECLARE     
    driver_row record;
    drs refcursor;
    s1 INT := 0;
    s2 INT := 0;
    s3 INT := 0;
BEGIN
    drs := get_drivers();    
    LOOP
        FETCH drs INTO driver_row;   
        EXIT WHEN NOT FOUND;
        IF driver_row.phone LIKE '7%' THEN
            s1 := s1 + 1;
        ELSIF driver_row.phone LIKE '9%' THEN
            s2 := s2 + 1;
        ELSE 
            s3 := s3 + 1;
        END IF;   
        
    END LOOP;
    RAISE NOTICE 'На 7 всего номеров: %, На 8 всего номеров: %, Всех остальных: %', s1, s2, s3; 
    CLOSE drs;
END;
$$;


DO $$
DECLARE
    rec record; 
    c int := 0;
    drs refcursor;
BEGIN
    drs := get_drivers(); 
    LOOP
        FETCH drs INTO rec;   
        EXIT WHEN NOT FOUND;
        if rec.email is null THEN 
            c := c + 1;
        END IF;
    END LOOP;
    RAISE NOTICE 'нет почты у человек в количестве: %', c;
    CLOSE drs;
END;
$$;