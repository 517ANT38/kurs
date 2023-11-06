

CREATE SCHEMA  parking;

ALTER DATABASE autoparking SET search_path = parking, public

-- Создание таблицы "Водитель"
CREATE TABLE parking.driver (
  driver_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  middle_name VARCHAR(50),
  phone VARCHAR(50) NOT NULL UNIQUE check(phone similar to '[0-9]{11}'),
  email VARCHAR(50) check(email like '%_@_%_.__%')  
);

-- Создание таблицы "Авто"
CREATE TABLE parking.car (
  car_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  driver_id INT REFERENCES driver(driver_id),
  brand VARCHAR(50) NOT NULL,
  model VARCHAR(50) NOT NULL,
  license_plate VARCHAR(10) UNIQUE NOT NULL,
  color VARCHAR(20) NOT NULL
);

-- Создание таблицы "Статус парковочного места"
CREATE TABLE parking.parking_spot_status (
  status_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  status_name VARCHAR(20) NOT NULL
);

-- Создание таблицы "Тип парковочного места"
CREATE TABLE parking.parking_spot_type (
  type_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  type_name VARCHAR(20) NOT NULL,
  price DECIMAL(10,2) NOT NULL

);
-- Создание таблицы "Зона парковочного места"
CREATE TABLE parking.parking_zone (
  zone_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  zone_name VARCHAR(50) NOT NULL UNIQUE,
  parent_zone_id INT REFERENCES parking_zone(zone_id),
  FOREIGN KEY (parent_zone_id) REFERENCES parking_zone(zone_id)
);



-- Создание таблицы "Парковочное место"
CREATE TABLE parking.parking_spot (
  spot_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  spot_number VARCHAR(50) NOT NULL DEFAULT uuid_generate_v1(),
  status_id INT NOT NULL,
  type_id INT  NOT NULL,
  zone_id INT  NOT NULL REFERENCES parking_zone(zone_id),
  last_modified_date TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY (status_id) REFERENCES parking_spot_status (status_id),
  FOREIGN KEY (type_id) REFERENCES parking_spot_type (type_id),
  FOREIGN KEY (zone_id) REFERENCES parking_zone (zone_id)
);

-- Создание таблицы "Бронирование"
CREATE TABLE parking.reservation (
  reservation_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  parking_spot_id INT REFERENCES parking_spot(spot_id),
  car_id INT NOT NULL REFERENCES car(car_id),
  start_time TIMESTAMP NOT NULL DEFAULT NOW(),
  end_time TIMESTAMP NOT NULL DEFAULT NOW() + INTERVAL '1 HOUR',
  CONSTRAINT valid_reservation CHECK (end_time > start_time)
);


CREATE TABLE parking.security_guard (
    guard_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fio fio NOT NULL,
    contact_info contact_info UNIQUE NOT NULL,
    zone_id INT REFERENCES parking.parking_zone(zone_id),
    security_guard_lead INT REFERENCES parking.security_guard(guard_id)
);


CREATE OR REPLACE FUNCTION update_status_on_insert_spot()
RETURNS trigger
AS
$$
BEGIN
  UPDATE parking_spot SET status_id = 2 WHERE spot_id = NEW.parking_spot_id;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER add_reservation_update_parking_spot
AFTER INSERT ON reservation
FOR EACH ROW EXECUTE FUNCTION update_status_on_insert_spot();

SELECT * FROM parking_spot ps 
JOIN parking_spot_status pst ON ps.status_id = pst.status_id
WHERE spot_id = 28;
INSERT INTO reservation(parking_spot_id,car_id) VALUES (28,19);
SELECT * FROM parking_spot ps 
JOIN parking_spot_status pst ON ps.status_id = pst.status_id
WHERE spot_id = 28;

UPDATE parking_spot SET status_id = 1  WHERE spot_id = 28;



CREATE OR REPLACE FUNCTION update_last_modified_date()
RETURNS TRIGGER AS $$
  BEGIN
  NEW.last_modified_date = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_upd_parking_spot_last_modified_date 
BEFORE UPDATE ON parking.parking_spot 
FOR EACH ROW EXECUTE FUNCTION update_last_modified_date(); 