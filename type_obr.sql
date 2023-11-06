CREATE TYPE address AS (
    street VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(10)
);

ALTER TABLE parking.driver
ADD COLUMN address address ;

DO 
$$
DECLARE
    x record;
    cur refcursor;
    i INT := 0;
BEGIN
    OPEN cur FOR SELECT * FROM parking.driver
        FOR UPDATE;
    LOOP
        FETCH cur INTO x;
        EXIT WHEN NOT FOUND;
        UPDATE parking.driver 
        SET address = ROW(
            'Saratovsk'::varchar || i::varchar, 
            'Saratov',
            'Rossia',
            '41004'::varchar || i::varchar
        )
        WHERE  CURRENT OF cur;
        i := i + 1;
    END LOOP;
    CLOSE cur;
END;
$$;


DROP FUNCTION find_drivers_by_address(address)

CREATE OR REPLACE FUNCTION find_drivers_by_address(address_param address) RETURNS TABLE (
    driver_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(50)
) AS $$
BEGIN
    RETURN QUERY
        SELECT d.driver_id, d.first_name, d.last_name, d.phone
        FROM parking.driver d
        WHERE d.address = address_param;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM find_drivers_by_address(ROW(
            'Saratovsk0',  
            'Saratov',
            'Rossia',
            '410040'
        ));


CREATE TYPE contact_info AS (
    phone VARCHAR(50),
    email VARCHAR(50)    
);

CREATE TYPE fio AS (
    first_name VARCHAR(50),
    last_name VARCHAR(50), 
    middle_name VARCHAR(50)
);

CREATE TABLE parking.security_guard (
    guard_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fio fio NOT NULL,
    contact_info contact_info UNIQUE NOT NULL,
    zone_id INT REFERENCES parking.parking_zone(zone_id),
    security_guard_lead INT REFERENCES parking.security_guard(guard_id)
);

CREATE OR REPLACE FUNCTION add_security_guard(
    p_fio fio,
    p_contact_info contact_info,
    p_zone_id INT
) RETURNS INT AS $$
DECLARE
    id INT;
BEGIN
    INSERT INTO parking.security_guard(fio, contact_info, zone_id)
    VALUES (p_fio, p_contact_info, p_zone_id)
    RETURNING guard_id INTO id;    
    RETURN id;
END;
$$ LANGUAGE plpgsql;

DO
$$
DECLARE
    id INT;
    res record;
BEGIN
    SELECT add_security_guard(('Anton','Ant','AntAnt'),('32767823823','anton@amail.com'),4) 
    INTO id;
    SELECT * FROM security_guard s WHERE s.guard_id = id INTO res;
    RAISE NOTICE '%', res;
END;
$$;

DELETE FROM security_guard WHERE guard_id =43;


CREATE FUNCTION update_security_guard(
    p_guard_id INT,
    p_fio fio,
    p_contact_info contact_info,
    p_zone_id INT
) RETURNS VOID AS $$
BEGIN
    UPDATE parking.security_guard
    SET fio = p_fio,
        contact_info = p_contact_info,
        zone_id = p_zone_id
    WHERE guard_id = p_guard_id;
END;
$$ LANGUAGE plpgsql;

DO
$$
DECLARE
    res record;
BEGIN
    PERFORM update_security_guard(44,('Anton','Ant','AntTT'),('67676777222','anton@gmail.com'),3); 
    SELECT * FROM security_guard s WHERE s.guard_id = 44 INTO res;
    RAISE NOTICE '%', res;
END;
$$;


CREATE PROCEDURE get_security_guard(
    p_guard_id INT,
    OUT p_fio fio,
    OUT p_contact_info contact_info,
    OUT p_zone_id INT
) AS $$
DECLARE 
    res security_guard;
BEGIN
    SELECT *
    INTO res
    FROM parking.security_guard
    WHERE guard_id = p_guard_id;
    p_fio := res.fio;
    p_contact_info := res.contact_info;
    p_zone_id := res.zone_id;
END;
$$ LANGUAGE plpgsql;


CALL get_security_guard(44,NULL,NULL,NULL);
