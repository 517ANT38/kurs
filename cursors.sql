DO $$
DECLARE
    cur refcursor;
    rec record;
BEGIN
    OPEN cur FOR SELECT * FROM parking.parking_spot_type
        FOR UPDATE;
    LOOP
        FETCH cur INTO rec;
        EXIT WHEN NOT FOUND;
        UPDATE parking.parking_spot_type SET price = price / 2 WHERE CURRENT OF cur;
    END LOOP;
    CLOSE cur;
END;
$$;
SELECT * FROM parking_spot_type;
DO $$
DECLARE     
    driver_row record;
    driver_cursor CURSOR FOR SELECT * FROM parking.driver;
    s1 INT := 0;
    s2 INT := 0;
    s3 INT := 0;
BEGIN
    OPEN driver_cursor;    
    LOOP
        FETCH driver_cursor INTO driver_row;   
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
    CLOSE driver_cursor;
END;
$$;


DO $$
DECLARE
    cur CURSOR(d1 DATE, d2 DATE) FOR SELECT * FROM reservation WHERE start_time >= d1 AND end_time <= d2;
    r record;
    s1 INT := 0;
    s2 INT := 0;
    s3 INT := 0;
    so1 INT := 0;
    so2 INT := 0;
BEGIN
    OPEN cur('2023-09-01','2023-11-15');
    LOOP
        FETCH cur INTO r;   
        EXIT WHEN NOT FOUND;
        IF r.end_time > '2023-10-29' THEN
            IF r.start_time < '2023-09-28' THEN
                s1 := s1 + 1;
            ELSIF r.start_time > '2023-10-01' AND r.start_time < '2023-10-28' THEN
                s2 := s2 + 1;
            ELSE 
                s3 := s3 + 1;
            END IF;   
            so1 := so1 + 1;
        ELSE so2 := so2 + 1;
        END IF;        
    END LOOP;
    RAISE NOTICE 'end_time > 2023-10-29 в количестве: %', so1;
    RAISE NOTICE 'end_time <= 2023-10-29 в количестве: %', so2;
    RAISE NOTICE 'start_time < 2023-09-28 в количестве: %', s1;
    RAISE NOTICE 'start_time > 2023-10-01 AND start_time < 2023-10-28 в количестве: %', s2;
    RAISE NOTICE 'остальные start_time в количестве: %', s3;


END;
$$;

DO $$
DECLARE
    cur refcursor;
    rec record;
    rspot record;
BEGIN
    OPEN cur FOR SELECT * FROM parking.reservation
        FOR UPDATE;
    LOOP
        FETCH cur INTO rec;
        EXIT WHEN NOT FOUND;
        
        IF rec.start_time >= rec.end_time THEN
            rspot := (SELECT * FROM parking.parking_spot WHERE spot_id = rec.parking_spot_id);
            IF  rspot.status_id = 2 THEN  
                UPDATE parking.parking_spot SET status_id = 3 WHERE spot_id = rspot.spot_id; 
                UPDATE parking.reservation SET end_time = end_time + INTERVAL '1 hour' WHERE CURRENT OF cur;
            ELSIF  rspot.status_id = 3 THEN
                UPDATE parking.parking_spot SET status_id = 1 WHERE spot_id = rspot.spot_id;
            END IF;
        END IF;
    END LOOP;
    CLOSE cur;
END;
$$;


DO $$
DECLARE
    rec record; 
    c int := 0;
BEGIN
    FOR rec IN (SELECT * FROM driver) LOOP
        if rec.email is null THEN 
            c := c + 1;
        END IF;
    END LOOP;
    RAISE NOTICE 'нет почты у человек в количестве: %', c;
END;
$$;

SELECT ps.spot_number, ps.status_id, ps.last_modified_date FROM reservation r 
JOIN parking_spot ps 
ON r.parking_spot_id = ps.spot_id
WHERE end_time <= NOW() - INTERVAL '12 hour';