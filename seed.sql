-- =====================================================
-- NONG THIAO THAI - COMPLETE SEED SCRIPT (FINAL)
-- 6 Regions | 77 Provinces | 154 Places (2 per province)
-- =====================================================

-- =========================
-- DROP TABLES (SAFE RESET)
-- =========================
DROP TABLE IF EXISTS trip_places CASCADE;
DROP TABLE IF EXISTS trip_days CASCADE;
DROP TABLE IF EXISTS trips CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS place_categories CASCADE;
DROP TABLE IF EXISTS places CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS provinces CASCADE;
DROP TABLE IF EXISTS regions CASCADE;

-- =========================
-- CREATE TABLES
-- =========================

CREATE TABLE regions (
    id SERIAL PRIMARY KEY,
    name_th VARCHAR(100) NOT NULL,
    name_en VARCHAR(100)
);

CREATE TABLE provinces (
    id SERIAL PRIMARY KEY,
    region_id INT REFERENCES regions(id),
    name_th VARCHAR(100) NOT NULL,
    name_en VARCHAR(100),
    is_popular BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name_th VARCHAR(100) NOT NULL,
    name_en VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE places (
    id SERIAL PRIMARY KEY,
    province_id INT REFERENCES provinces(id) ON DELETE CASCADE,
    name_th VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    description TEXT,
    latitude DECIMAL(10,6),
    longitude DECIMAL(10,6),
    average_cost INT DEFAULT 0,
    rating DECIMAL(2,1),
    city_type VARCHAR(20) CHECK (city_type IN ('main','secondary')),
    image_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE place_categories (
    place_id INT REFERENCES places(id) ON DELETE CASCADE,
    category_id INT REFERENCES categories(id) ON DELETE CASCADE,
    PRIMARY KEY (place_id, category_id)
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    line_user_id VARCHAR(100) UNIQUE,
    display_name VARCHAR(150),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE trips (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    province_id INT REFERENCES provinces(id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    budget INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE trip_days (
    id SERIAL PRIMARY KEY,
    trip_id INT REFERENCES trips(id) ON DELETE CASCADE,
    day_number INT NOT NULL,
    trip_date DATE NOT NULL
);

CREATE TABLE trip_places (
    id SERIAL PRIMARY KEY,
    trip_day_id INT REFERENCES trip_days(id) ON DELETE CASCADE,
    place_id INT REFERENCES places(id),
    visit_order INT NOT NULL
);

-- =========================
-- INSERT REGIONS
-- =========================

INSERT INTO regions (name_th,name_en) VALUES
('ภาคเหนือ','Northern'),
('ภาคเหนือตอนล่าง','Lower Northern'),
('ภาคตะวันออกเฉียงเหนือ','Northeastern'),
('ภาคกลาง','Central'),
('ภาคตะวันออก','Eastern'),
('ภาคตะวันตก','Western'),
('ภาคใต้','Southern');



-- =========================
-- INSERT 77 PROVINCES
-- =========================

INSERT INTO provinces (region_id,name_th,name_en,is_popular) VALUES

-- ======================
-- 1️⃣ ภาคเหนือ (9)
-- ======================
(1,'เชียงใหม่','Chiang Mai',true),
(1,'เชียงราย','Chiang Rai',true),
(1,'แม่ฮ่องสอน','Mae Hong Son',false),
(1,'พะเยา','Phayao',false),
(1,'ลำพูน','Lamphun',false),
(1,'ลำปาง','Lampang',false),
(1,'แพร่','Phrae',false),
(1,'น่าน','Nan',false),
(1,'อุตรดิตถ์','Uttaradit',false),

-- ======================
-- 2️⃣ ภาคเหนือตอนล่าง (8)
-- ======================
(2,'พิษณุโลก','Phitsanulok',false),
(2,'พิจิตร','Phichit',false),
(2,'เพชรบูรณ์','Phetchabun',false),
(2,'สุโขทัย','Sukhothai',false),
(2,'กำแพงเพชร','Kamphaeng Phet',false),
(2,'นครสวรรค์','Nakhon Sawan',false),
(2,'อุทัยธานี','Uthai Thani',false),

-- ======================
-- 3️⃣ ภาคอีสาน (20)
-- ======================
(3,'กาฬสินธุ์','Kalasin',false),
(3,'ขอนแก่น','Khon Kaen',true),
(3,'ชัยภูมิ','Chaiyaphum',false),
(3,'นครพนม','Nakhon Phanom',false),
(3,'นครราชสีมา','Nakhon Ratchasima',true),
(3,'บึงกาฬ','Bueng Kan',false),
(3,'บุรีรัมย์','Buriram',false),
(3,'มหาสารคาม','Maha Sarakham',false),
(3,'มุกดาหาร','Mukdahan',false),
(3,'ยโสธร','Yasothon',false),
(3,'ร้อยเอ็ด','Roi Et',false),
(3,'ศรีสะเกษ','Sisaket',false),
(3,'สกลนคร','Sakon Nakhon',false),
(3,'สุรินทร์','Surin',false),
(3,'หนองคาย','Nong Khai',false),
(3,'หนองบัวลำภู','Nong Bua Lamphu',false),
(3,'อำนาจเจริญ','Amnat Charoen',false),
(3,'อุดรธานี','Udon Thani',true),
(3,'อุบลราชธานี','Ubon Ratchathani',true),
(3,'เลย','Loei',false),

-- ======================
-- 4️⃣ ภาคกลาง (18)
-- ======================
(4,'กรุงเทพมหานคร','Bangkok',true),
(4,'พระนครศรีอยุธยา','Ayutthaya',true),
(4,'ลพบุรี','Lopburi',false),
(4,'สระบุรี','Saraburi',false),
(4,'สุพรรณบุรี','Suphanburi',false),
(4,'นครปฐม','Nakhon Pathom',false),
(4,'นนทบุรี','Nonthaburi',false),
(4,'ปทุมธานี','Pathum Thani',false),
(4,'สมุทรปราการ','Samut Prakan',false),
(4,'สมุทรสาคร','Samut Sakhon',false),
(4,'สมุทรสงคราม','Samut Songkhram',false),
(4,'อ่างทอง','Ang Thong',false),
(4,'ชัยนาท','Chai Nat',false),
(4,'สิงห์บุรี','Sing Buri',false),
(4,'นครนายก','Nakhon Nayok',false),

-- ======================
-- 5️⃣ ภาคตะวันออก (7)
-- ======================
(5,'ฉะเชิงเทรา','Chachoengsao',false),
(5,'จันทบุรี','Chanthaburi',false),
(5,'ชลบุรี','Chonburi',true),
(5,'ปราจีนบุรี','Prachinburi',false),
(5,'ระยอง','Rayong',true),
(5,'สระแก้ว','Sa Kaeo',false),
(5,'ตราด','Trat',false),

-- ======================
-- 6️⃣ ภาคตะวันตก (5)
-- ======================
(6,'กาญจนบุรี','Kanchanaburi',true),
(6,'ราชบุรี','Ratchaburi',false),
(6,'เพชรบุรี','Phetchaburi',false),
(6,'ประจวบคีรีขันธ์','Prachuap Khiri Khan',true),
(6,'ตาก','Tak',false),

-- ======================
-- 7️⃣ ภาคใต้ (14)
-- ======================
(7,'ชุมพร','Chumphon',false),
(7,'ระนอง','Ranong',false),
(7,'สุราษฎร์ธานี','Surat Thani',true),
(7,'นครศรีธรรมราช','Nakhon Si Thammarat',false),
(7,'กระบี่','Krabi',true),
(7,'พังงา','Phang Nga',false),
(7,'ภูเก็ต','Phuket',true),
(7,'พัทลุง','Phatthalung',false),
(7,'ตรัง','Trang',false),
(7,'ปัตตานี','Pattani',false),
(7,'สงขลา','Songkhla',false),
(7,'สตูล','Satun',false),
(7,'นราธิวาส','Narathiwat',false),
(7,'ยะลา','Yala',false);

-- =========================
-- INSERT CATEGORIES
-- =========================

INSERT INTO categories (name_th,name_en) VALUES
('ธรรมชาติ','Nature'),
('วัด','Temple'),
('คาเฟ่','Cafe'),
('ชายหาด','Beach'),
('ของกิน','Food');

-- =========================
-- AUTO GENERATE 2 PLACES PER PROVINCE
-- =========================

INSERT INTO places
(province_id,name_th,description,latitude,longitude,average_cost,rating,city_type)
SELECT
    id,
    name_th || ' แลนด์มาร์กหลัก',
    'สถานที่ท่องเที่ยวสำคัญของจังหวัด ' || name_th,
    13 + (id*0.05),
    100 + (id*0.05),
    50,
    4.5,
    'main'
FROM provinces;

INSERT INTO places
(province_id,name_th,description,latitude,longitude,average_cost,rating,city_type)
SELECT
    id,
    name_th || ' จุดเช็คอินยอดนิยม',
    'จุดท่องเที่ยวยอดนิยมของจังหวัด ' || name_th,
    13.5 + (id*0.05),
    100.5 + (id*0.05),
    30,
    4.3,
    'secondary'
FROM provinces;


-- =========================
-- END OF FILE
-- =========================
