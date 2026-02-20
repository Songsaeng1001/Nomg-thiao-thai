-- =========================================
-- RESET DATABASE
-- =========================================

DROP TABLE IF EXISTS trip_activity CASCADE;
DROP TABLE IF EXISTS trip_day CASCADE;
DROP TABLE IF EXISTS trip CASCADE;
DROP TABLE IF EXISTS place CASCADE;
DROP TABLE IF EXISTS category CASCADE;
DROP TABLE IF EXISTS district CASCADE;
DROP TABLE IF EXISTS province CASCADE;
DROP TABLE IF EXISTS region CASCADE;
DROP TABLE IF EXISTS budget_level CASCADE;

-- =========================================
-- CREATE TABLES
-- =========================================

CREATE TABLE region (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(100) NOT NULL
);

CREATE TABLE province (
    province_id SERIAL PRIMARY KEY,
    region_id INT REFERENCES region(region_id) ON DELETE CASCADE,
    province_name VARCHAR(100) NOT NULL
);

CREATE TABLE district (
    district_id SERIAL PRIMARY KEY,
    province_id INT REFERENCES province(province_id) ON DELETE CASCADE,
    district_name VARCHAR(100) NOT NULL
);

CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE budget_level (
    budget_level_id SERIAL PRIMARY KEY,
    level_name VARCHAR(50),
    min_budget INT,
    max_budget INT
);

CREATE TABLE place (
    place_id SERIAL PRIMARY KEY,
    district_id INT REFERENCES district(district_id),
    category_id INT REFERENCES category(category_id),
    budget_level_id INT REFERENCES budget_level(budget_level_id),
    place_name VARCHAR(200),
    avg_spend INT,
    rating DECIMAL(2,1)
);

CREATE TABLE trip (
    trip_id SERIAL PRIMARY KEY,
    province_id INT REFERENCES province(province_id),
    total_days INT,
    total_budget INT,
    travel_style VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE trip_day (
    trip_day_id SERIAL PRIMARY KEY,
    trip_id INT REFERENCES trip(trip_id) ON DELETE CASCADE,
    day_number INT
);

CREATE TABLE trip_activity (
    trip_activity_id SERIAL PRIMARY KEY,
    trip_day_id INT REFERENCES trip_day(trip_day_id) ON DELETE CASCADE,
    place_id INT REFERENCES place(place_id),
    order_index INT
);

-- =========================================
-- INSERT DATA
-- =========================================

INSERT INTO region (region_name) VALUES ('ภาคเหนือ');

INSERT INTO province (region_id, province_name) VALUES
(1,'เชียงใหม่'),
(1,'เชียงราย'),
(1,'ลำปาง'),
(1,'ลำพูน'),
(1,'แพร่'),
(1,'น่าน'),
(1,'พะเยา'),
(1,'แม่ฮ่องสอน'),
(1,'อุตรดิตถ์');

INSERT INTO category (category_name) VALUES
('ธรรมชาติ'),
('วัด'),
('ของกิน'),
('คาเฟ่'),
('อุทยาน');

INSERT INTO budget_level (level_name,min_budget,max_budget) VALUES
('ประหยัด',0,150),
('กลาง',151,400),
('พรีเมียม',401,10000);


INSERT INTO district (province_id, district_name)
VALUES
((SELECT province_id FROM province WHERE province_name='เชียงใหม่'),'เมืองเชียงใหม่'),
((SELECT province_id FROM province WHERE province_name='เชียงราย'),'เมืองเชียงราย'),
((SELECT province_id FROM province WHERE province_name='ลำปาง'),'เมืองลำปาง'),
((SELECT province_id FROM province WHERE province_name='ลำพูน'),'เมืองลำพูน'),
((SELECT province_id FROM province WHERE province_name='แพร่'),'เมืองแพร่'),
((SELECT province_id FROM province WHERE province_name='น่าน'),'เมืองน่าน'),
((SELECT province_id FROM province WHERE province_name='พะเยา'),'เมืองพะเยา'),
((SELECT province_id FROM province WHERE province_name='แม่ฮ่องสอน'),'เมืองแม่ฮ่องสอน'),
((SELECT province_id FROM province WHERE province_name='อุตรดิตถ์'),'เมืองอุตรดิตถ์');

INSERT INTO place (district_id, category_id, budget_level_id, place_name, avg_spend, rating) VALUES
((SELECT district_id FROM district WHERE district_name='เมืองเชียงใหม่'),1,1,'ดอยสุเทพ',50,4.8),
((SELECT district_id FROM district WHERE district_name='เมืองเชียงใหม่'),2,1,'วัดพระธาตุดอยสุเทพ',50,4.9),
((SELECT district_id FROM district WHERE district_name='เมืองเชียงใหม่'),2,1,'วัดอุโมงค์',20,4.7),
((SELECT district_id FROM district WHERE district_name='เมืองเชียงใหม่'),3,1,'ข้าวซอยลำดวน',120,4.7),
((SELECT district_id FROM district WHERE district_name='เมืองเชียงใหม่'),4,2,'Graph Cafe',180,4.6),
((SELECT district_id FROM district WHERE district_name='เมืองเชียงใหม่'),4,3,'Roast8ry',350,4.8),
((SELECT district_id FROM district WHERE district_name='เมืองเชียงใหม่'),1,2,'ม่อนแจ่ม',200,4.6),
((SELECT district_id FROM district WHERE district_name='เมืองเชียงใหม่'),5,3,'อุทยานแห่งชาติดอยอินทนนท์',500,4.9),
((SELECT district_id FROM district WHERE district_name='เมืองเชียงใหม่'),3,2,'เฮือนม่วนใจ๋',300,4.6),
((SELECT district_id FROM district WHERE district_name='เมืองเชียงใหม่'),1,1,'อ่างแก้ว มช.',0,4.5);

INSERT INTO place VALUES
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองเชียงราย'),2,1,'วัดร่องขุ่น',50,4.8),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองเชียงราย'),2,1,'วัดร่องเสือเต้น',50,4.7),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองเชียงราย'),1,2,'ภูชี้ฟ้า',200,4.8),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองเชียงราย'),1,2,'ดอยตุง',150,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองเชียงราย'),5,3,'อุทยานแห่งชาติขุนน้ำเงา',400,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองเชียงราย'),3,1,'ข้าวซอยป้าอ้วน',120,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองเชียงราย'),4,2,'ชีวิตธรรมดา Cafe',200,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองเชียงราย'),1,1,'สิงห์ปาร์ค',100,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองเชียงราย'),3,2,'ร้านหลู้ลำ',300,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองเชียงราย'),1,1,'ดอยแม่สลอง',100,4.6);

INSERT INTO place VALUES
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำปาง'),2,1,'วัดพระธาตุลำปางหลวง',50,4.8),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำปาง'),1,1,'กาดกองต้า',0,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำปาง'),1,2,'อุทยานแห่งชาติแจ้ซ้อน',200,4.7),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำปาง'),1,2,'น้ำตกแจ้ซ้อน',100,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำปาง'),3,1,'ข้าวมันไก่ประตูชัย',100,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำปาง'),4,2,'The Riverside Cafe',200,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำปาง'),1,1,'สะพานรัษฎาภิเศก',0,4.4),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำปาง'),2,1,'วัดพระแก้วดอนเต้า',50,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำปาง'),5,2,'อุทยานแห่งชาติดอยขุนตาล',300,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำปาง'),3,2,'ร้านก๋วยเตี๋ยวเรือ',120,4.4);

INSERT INTO place VALUES
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำพูน'),2,1,'วัดพระธาตุหริภุญชัย',50,4.8),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำพูน'),1,1,'สะพานท่าขาม',0,4.4),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำพูน'),1,2,'อุทยานแห่งชาติแม่ปิง',200,4.7),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำพูน'),3,1,'ลาบลำพูน',120,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำพูน'),4,2,'Cafe Amazon ลำพูน',150,4.3),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำพูน'),1,1,'กู่ช้างกู่ม้า',0,4.4),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำพูน'),2,1,'วัดจามเทวี',20,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำพูน'),3,2,'ขนมจีนน้ำเงี้ยว',100,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำพูน'),1,2,'ดอยขุนตาล',150,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองลำพูน'),4,2,'Lamphun Coffee',180,4.4);

INSERT INTO place VALUES
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแพร่'),1,1,'แพะเมืองผี',100,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแพร่'),2,1,'วัดพระธาตุช่อแฮ',50,4.7),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแพร่'),3,1,'ข้าวซอยเจ๊เล็ก',120,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแพร่'),4,2,'Hug Cafe',180,4.4),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแพร่'),1,2,'อุทยานแห่งชาติเวียงโกศัย',200,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแพร่'),1,1,'บ้านวงศ์บุรี',0,4.4),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแพร่'),2,1,'วัดจอมสวรรค์',20,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแพร่'),3,2,'ร้านข้าวต้มโต้รุ่ง',150,4.4),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแพร่'),4,2,'Phrae Coffee',160,4.3),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแพร่'),1,1,'ถ้ำผานางคอย',50,4.3);

INSERT INTO place VALUES
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองน่าน'),2,1,'วัดภูมินทร์',50,4.8),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองน่าน'),2,1,'วัดพระธาตุแช่แห้ง',50,4.7),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองน่าน'),1,2,'ดอยเสมอดาว',200,4.8),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองน่าน'),5,3,'อุทยานแห่งชาติดอยภูคา',400,4.8),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองน่าน'),3,1,'ข้าวซอยต้นน้ำ',120,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองน่าน'),4,2,'Erabica Coffee',180,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองน่าน'),1,1,'ถนนคนเดินน่าน',0,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองน่าน'),1,2,'ดอยสกาด',150,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองน่าน'),3,2,'ร้านเฮือนฮอม',300,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองน่าน'),1,1,'สะปัน',100,4.7);

INSERT INTO place VALUES
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองพะเยา'),1,1,'กว๊านพะเยา',0,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองพะเยา'),2,1,'วัดศรีโคมคำ',20,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองพะเยา'),1,2,'ภูลังกา',200,4.7),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองพะเยา'),5,2,'อุทยานแห่งชาติภูลังกา',250,4.7),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองพะเยา'),3,1,'ข้าวซอยพะเยา',100,4.4),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองพะเยา'),4,2,'Phayao Cafe',160,4.3),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองพะเยา'),1,1,'ถนนคนเดินพะเยา',0,4.4),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองพะเยา'),2,1,'วัดอนาลโย',50,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองพะเยา'),3,2,'ร้านอาหารริมกว๊าน',250,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองพะเยา'),1,1,'ดอยหนอก',100,4.5);

INSERT INTO place VALUES
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแม่ฮ่องสอน'),1,2,'ปาย',200,4.7),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแม่ฮ่องสอน'),1,2,'ปางอุ๋ง',200,4.8),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแม่ฮ่องสอน'),2,1,'วัดพระธาตุดอยกองมู',50,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแม่ฮ่องสอน'),5,2,'อุทยานแห่งชาติถ้ำปลา',150,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแม่ฮ่องสอน'),3,1,'ข้าวซอยปาย',120,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแม่ฮ่องสอน'),4,2,'Coffee in Love',180,4.4),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแม่ฮ่องสอน'),1,1,'ถนนคนเดินปาย',0,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแม่ฮ่องสอน'),1,2,'สะพานซูตองเป้',100,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแม่ฮ่องสอน'),3,2,'ร้านบ้านต้นไม้',250,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองแม่ฮ่องสอน'),1,2,'หมู่บ้านรักไทย',200,4.7);

INSERT INTO place VALUES
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองอุตรดิตถ์'),1,2,'ภูสอยดาว',300,4.8),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองอุตรดิตถ์'),5,2,'อุทยานแห่งชาติลำน้ำน่าน',200,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองอุตรดิตถ์'),2,1,'วัดพระบรมธาตุทุ่งยั้ง',50,4.6),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองอุตรดิตถ์'),3,1,'ข้าวซอยเมืองลับแล',120,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองอุตรดิตถ์'),4,2,'Cafe Utt',150,4.3),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองอุตรดิตถ์'),1,1,'ตลาดลับแล',0,4.4),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองอุตรดิตถ์'),1,2,'ดอยภูสอยดาว',200,4.7),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองอุตรดิตถ์'),2,1,'วัดทุ่งยั้ง',20,4.4),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองอุตรดิตถ์'),3,2,'ร้านอาหารลับแล',250,4.5),
(DEFAULT,(SELECT district_id FROM district WHERE district_name='เมืองอุตรดิตถ์'),1,1,'น้ำตกแม่พูล',100,4.5);