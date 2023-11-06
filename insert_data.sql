INSERT INTO parking.driver (first_name, last_name, middle_name, phone, email)
VALUES ('John', 'Doe', 'Smith', '12345678901', 'johndoe@example.com');

INSERT INTO parking.driver (first_name, last_name, phone)
VALUES ('Jane', 'Smith', '98765432109');

INSERT INTO parking.driver (first_name, last_name, middle_name, phone, email)
VALUES ('Michael', 'Johnson', 'Andrew', '45678901234', 'michaeljohnson@example.com');

INSERT INTO parking.driver (first_name, last_name, phone)
VALUES ('Emily', 'Davis', '76543210987');

INSERT INTO parking.driver (first_name, last_name, middle_name, phone, email)
VALUES ('David', 'Wilson', 'Lee', '23456789012', 'davidwilson@example.com');

INSERT INTO parking.driver (first_name, last_name, phone, email)
VALUES ('Sarah', 'Jackson', '65432109876', 'sarahjackson@example.com');

INSERT INTO parking.driver (first_name, last_name, middle_name, phone)
VALUES ('Daniel', 'Taylor', 'James', '34567890123');

INSERT INTO parking.driver (first_name, last_name, phone, email)
VALUES ('Jessica', 'Anderson', '54321098765', 'jessicaanderson@example.com');

INSERT INTO parking.driver (first_name, last_name, middle_name, phone, email)
VALUES ('Christopher', 'Thomas', 'Matthew', '45678901237', 'christopherthomas@example.com');

INSERT INTO parking.driver (first_name, last_name, phone)
VALUES ('Amanda', 'Harris', '43210987659');

INSERT INTO parking.driver (first_name, last_name, middle_name, phone, email)
VALUES ('Andrew', 'Martin', 'Joseph', '32109876541', 'andrewmartin@example.com');

INSERT INTO parking.driver (first_name, last_name, phone)
VALUES ('Jennifer', 'White', '65432109871');

INSERT INTO parking.driver (first_name, last_name, middle_name, phone, email)
VALUES ('Matthew', 'Lewis', 'Ryan', '21098765432', 'matthewlewis@example.com');

INSERT INTO parking.driver (first_name, last_name, middle_name, phone, email)
VALUES ('Lauren', 'Clark', 'Nicole', '10987654321', 'laurenclark@example.com');

INSERT INTO parking.driver (first_name, last_name, phone)
VALUES ('Justin', 'Walker', '43210987653');

INSERT INTO parking.driver (first_name, last_name, middle_name, phone)
VALUES ('Samantha', 'Allen', 'Michelle', '98765432103');

INSERT INTO parking.driver (first_name, last_name, phone, email)
VALUES ('Austin', 'Young', '76543210983', 'austinyoung@example.com');

INSERT INTO parking.driver (first_name, last_name, middle_name, phone, email)
VALUES ('Anthony', 'Garcia', 'David', '65432111873', 'anthonygarcia@example.com');

INSERT INTO parking.driver (first_name, last_name, middle_name, phone)
VALUES ('Melissa', 'Scott', 'Marie', '54321098163');

INSERT INTO parking.driver (first_name, last_name, phone, email)
VALUES ('Eric', 'Lee', '43210987613', 'ericlee@example.com');


CREATE OR REPLACE FUNCTION public.random_number()
RETURNS VARCHAR
AS
$$
DECLARE
    res VARCHAR := '';
BEGIN
    FOR i IN 1 .. 11 LOOP
        res := res || chr(round(random()*(ascii('9') - ascii('0'))+ ascii('0'))::int);
    END LOOP;
    RETURN res;
END
$$ LANGUAGE plpgsql;

INSERT INTO parking.driver (first_name, last_name, middle_name, phone, email) 
SELECT 
    dr2.first_name || '1',
    dr2.last_name || '1',
    dr2.middle_name || '1',
    public.random_number(),
    dr2.email || '1'
FROM parking.driver dr2;

INSERT INTO parking.driver (first_name, last_name, middle_name, phone, email) 
SELECT 
    dr2.first_name || '2',
    dr2.last_name || '2',
    dr2.middle_name || '2',
    public.random_number(),
    dr2.email || '2'
FROM parking.driver dr2;

DELETE FROM driver WHERE driver_id > 80;

SELECT * FROM parking.car;

TRUNCATE driver  RESTART IDENTITY CASCADE;

INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (1, 'Toyota', 'Camry', 'ABC123', 'Red');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (1, 'Honda', 'Accord', 'DEF456', 'Black');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (2, 'Ford', 'Mustang', 'GHI789', 'Yellow');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (2, 'Chevrolet', 'Cruze', 'JKL012', 'Silver');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (3, 'Nissan', 'Altima', 'MNO345', 'Blue');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (18, 'Subaru', 'Impreza', 'PQR678', 'White');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (4, 'BMW', 'X5', 'STU901', 'Gray');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (17, 'Mercedes-Benz', 'C-Class', 'VWX234', 'Black');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (5, 'Audi', 'A4', 'YZA567', 'Silver');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (16, 'Volvo', 'XC90', 'BCD890', 'Black');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (6, 'Toyota', 'Corolla', 'EFG123', 'Blue');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (15, 'Honda', 'Civic', 'HIJ456', 'White');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (7, 'Ford', 'Escape', 'KLM789', 'Red');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (7, 'Chevrolet', 'Equinox', 'NOP012', 'Silver');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (8, 'Nissan', 'Rogue', 'QRS345', 'Black');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (14, 'Subaru', 'Forester', 'TUV678', 'Gray');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (9, 'BMW', 'X3', 'WXY901', 'White');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (11, 'Mercedes-Benz', 'E-Class', 'ZAB234', 'Black');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (12, 'Audi', 'Q5', 'FGH567', 'Silver');
INSERT INTO parking.car (driver_id, brand, model, license_plate, color) VALUES (13, 'Volvo', 'S60', 'LMN890', 'Red');

CREATE OR REPLACE FUNCTION public.generate_random_plate() 
RETURNS VARCHAR
AS
$$
DECLARE
    res VARCHAR := ''; 
BEGIN
    FOR i IN 1 .. 6 LOOP
        IF i%2 = 0 THEN
            res := res || chr(round(random()*(ascii('9') - ascii('0'))+ ascii('0'))::int);
        ELSE
            res := res || chr(round(random()*(ascii('Z')  - ascii('A'))+ ascii('A'))::int);
        END IF;
    END LOOP;
    RETURN res;
END;
$$ LANGUAGE plpgsql;

INSERT INTO parking.car (driver_id, brand, model, license_plate, color) 
SELECT 
    dr.driver_id, brand || '1',
    model || '1',
    public.generate_random_plate(),
    color  || '1'
FROM parking.car, driver dr;

SELECT * FROM car;

TRUNCATE parking_spot RESTART IDENTITY CASCADE;

alter TABLE car add CONSTRAINT car_driver_id_fkey FOREIGN KEY (driver_id) REFERENCES driver(driver_id);


INSERT INTO parking_spot_status(status_name) VALUES ('booked'), ('free'), ('ready to be released');

SELECT * FROM parking_spot_status;

INSERT INTO parking_spot_type(type_name,price) VALUES ('DISABILITY',0); 

INSERT INTO parking_spot_type(type_name,price) VALUES ('VIP',1200), ('MEDIUM',800), ('MIN',400) RETURNING *;


INSERT INTO parking_zone(zone_name) SELECT generate_random_plate() FROM generate_series(1,10);

INSERT INTO parking_zone(zone_name,parent_zone_id) 
SELECT generate_random_plate(), pz.zone_id FROM parking_zone pz;

SELECT * FROM parking_zone
delete from parking_zone;

INSERT INTO parking_spot (status_id, type_id, zone_id, last_modified_date)
SELECT 
    round(random()*(3 - 1) + 1),
    round(random()*(4 - 1) + 1),
    round(random()*(80 - 41) + 41),
    NOW() + make_interval(0,round(random()-1)::INT,0,-round(random()*14)::INT,-round(random()*i)::INT,0,0)
FROM generate_series(1,1000) g(i)

SELECT * FROM parking_spot;

INSERT INTO reservation (parking_spot_id,car_id,start_time,end_time)
SELECT 
    round(random()*(1000 - 1) + 1),
    round(random()*(1620 - 1) + 1),
    NOW() + make_interval(0,round(random()-1)::INT,0,-round(random()*14+10)::INT,-round(random()*14+10)::INT,0,0),
    NOW() + make_interval(0,0,0,-round(random()*5)::INT,-round(random()*8)::INT,60,0)
FROM generate_series(1,1620);

SELECT * FROM reservation;

DELETE FROM reservation WHERE reservation_id > 1620;

TRUNCATE reservation RESTART IDENTITY;


INSERT INTO parking.security_guard (fio, contact_info, zone_id, security_guard_lead) VALUES
(('John', 'Doe', 'Smith'), ('1234567890', 'johndoe@gmail.com'), 1,NULL),
(('Jane', 'Smith', 'Doe'), ('0987654321', 'janesmith@gmail.com'), 2, NULL),
(('Mike', 'Johnson', 'Smith'), ('5678901234', 'mikejohnson@gmail.com'), 3, 1),
(('Emily', 'Jones', 'Smith'), ('4321098765', 'emilyjones@gmail.com'), 4, 3),
(('David', 'Brown', 'Smith'), ('9876543210', 'davidbrown@gmail.com'), 5, 4),
(('Sarah', 'Taylor', 'Smith'), ('3456789012', 'sarahtaylor@gmail.com'), 1, 5),
(('Matthew', 'Garcia', 'Smith'), ('6789012345', 'matthewgarcia@gmail.com'), 2,1 ),
(('Olivia', 'Martinez', 'Smith'), ('2109876543', 'oliviamartinez@gmail.com'), 3, 3),
(('Christopher', 'Lopez', 'Smith'), ('4567890123', 'christopherlopez@gmail.com'), 4,2),
(('Sophia', 'Hernandez', 'Smith'), ('7890123456', 'sophiahernandez@gmail.com'), 5,1),
(('William', 'Gonzalez', 'Smith'), ('5432109876', 'williamgonzalez@gmail.com'), 1,1),
(('Ava', 'Perez', 'Smith'), ('8901234567', 'avaperez@gmail.com'), 2,2),
(('James', 'Torres', 'Smith'), ('4321567890', 'jamestorres@gmail.com'), 3,3),
(('Mia', 'Rivera', 'Smith'), ('8765432109', 'miarivera@gmail.com'), 4,5),
(('Benjamin', 'Lopez', 'Smith'), ('5432789012', 'benjaminlopez@gmail.com'), 5,6),
(('Charlotte', 'Cruz', 'Smith'), ('2089567123', 'charlottecruz@gmail.com'), 1,7),
(('Daniel', 'Gomez', 'Smith'), ('5432109876', 'danielgomez@gmail.com'), 2,8),
(('Amelia', 'Sanchez', 'Smith'), ('9087213456', 'ameliasanchez@gmail.com'), 3,9),
(('Henry', 'Silva', 'Smith'), ('5435678901', 'henrysilva@gmail.com'), 4,12),
(('Evelyn', 'Castillo', 'Smith'), ('9087123456', 'evelyncastillo@gmail.com'), 5,10),
(('John', 'Doe', 'Smith'), ('123456734340', 'johndoe@gmail.com'), 1,1),
(('Jane', 'Smith', 'Doe'), ('98765432340', 'janesmith@gmail.com'), 2,20),
(('Michael', 'Johnson', 'Brown'), ('553243555555', 'michaeljohnson@gmail.com'), 3,20),
(('Emily', 'Davis', 'Jones'), ('11111113241', 'emilydavis@gmail.com'), 4,20),
(('David', 'Miller', 'Anderson'), ('999342329999', 'davidmiller@gmail.com'), 5,2),
(('Sarah', 'Wilson', 'Taylor'), ('2222222324', 'sarahwilson@gmail.com'), 1,9),
(('Christopher', 'Anderson', 'Thomas'), ('77327777777', 'christopheranderson@gmail.com'), 2,4),
(('Jessica', 'Jackson', 'White'), ('4324444', 'jessicajackson@gmail.com'), 3,5),
(('Matthew', 'Harris', 'Brown'), ('8888832488', 'matthewharris@gmail.com'), 4,6),
(('Ashley', 'Thompson', 'Smith'), ('634266666', 'ashleythompson@gmail.com'), 5,7),
(('Joshua', 'Taylor', 'Johnson'), ('123324231', 'joshuataylor@gmail.com'), 1,8),
(('Amanda', 'Robinson', 'Davis'), ('33423213', 'amandarobinson@gmail.com'), 2,4),
(('Andrew', 'Clark', 'Jackson'), ('4564324564', 'andrewclark@gmail.com'), 3,9),
(('Olivia', 'Walker', 'Harris'), ('783247897', 'oliviawalker@gmail.com'), 4,11),
(('William', 'Lewis', 'Taylor'), ('98765434211', 'williamlewis@gmail.com'), 5,12),
(('Samantha', 'Martin', 'Anderson'), ('78978932497', 'samanthamartin@gmail.com'), 1,15),
(('Joseph', 'Lee', 'Brown'), ('987634211', 'josephlee@gmail.com'), 2,NULL),
(('Lauren', 'Hall', 'Thomas'), ('7893427', 'laurenhall@gmail.com'), 3,7),
(('Benjamin', 'Allen', 'White'), ('9342543211', 'benjaminallen@gmail.com'), 4,19),
(('Ella', 'Young', 'Smith'), ('7893427897', 'ellayoung@gmail.com'), 5,23);


SELECT * FROM security_guard; 


TRUNCATE parking.security_guard RESTART IDENTITY;


BEGIN;

ALTER TABLE parking_zone DROP CONSTRAINT parking_zone_parent_zone_id_fkey1;


COMMIT;



