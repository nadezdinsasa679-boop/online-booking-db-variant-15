DROP TABLE IF EXISTS adverse_reactions;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS parental_consent;
DROP TABLE IF EXISTS vaccines;
DROP TABLE IF EXISTS clients;

CREATE DATABASE IF NOT EXISTS medical_center_vaccination_variant15
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE medical_center_vaccination_variant15;

CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    patronymic VARCHAR(50),
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    birth_date DATE NOT NULL,
    CHECK (birth_date <= CURDATE() - INTERVAL 18 YEAR)
);

CREATE TABLE parental_consent (
    consent_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    parent_full_name VARCHAR(150) NOT NULL,
    parent_phone VARCHAR(20) NOT NULL,
    consent_date DATE NOT NULL,
    consent_document_url VARCHAR(255),
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY unique_client_consent (client_id)
);

CREATE TABLE vaccines (
    vaccine_id INT AUTO_INCREMENT PRIMARY KEY,
    vaccine_name VARCHAR(100) NOT NULL UNIQUE,
    vaccine_type ENUM('инактивированная', 'живая', 'мРНК', 'векторная') NOT NULL,
    manufacturer VARCHAR(100) NOT NULL,
    doses_per_package INT NOT NULL CHECK (doses_per_package BETWEEN 1 AND 100),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    expiration_date DATE NOT NULL,
    CHECK (expiration_date > CURDATE())
);

CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    vaccine_id INT NOT NULL,
    appointment_datetime DATETIME NOT NULL,
    status ENUM('запланировано', 'проведено', 'отменено') DEFAULT 'запланировано',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (vaccine_id) REFERENCES vaccines(vaccine_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE KEY unique_vaccine_slot (vaccine_id, appointment_datetime),
    CHECK (appointment_datetime > NOW())
);

CREATE TABLE adverse_reactions (
    reaction_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    reaction_date DATE NOT NULL,
    reaction_description TEXT NOT NULL,
    severity ENUM('лёгкая', 'средняя', 'тяжёлая') DEFAULT 'лёгкая',
    required_hospitalization BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX idx_appointments_datetime ON appointments(appointment_datetime);
CREATE INDEX idx_appointments_client ON appointments(client_id);
CREATE INDEX idx_vaccines_expiration ON vaccines(expiration_date);
CREATE INDEX idx_vaccines_stock ON vaccines(stock_quantity);

INSERT INTO clients (last_name, first_name, patronymic, phone, email, birth_date) VALUES
('Иванов', 'Иван', 'Иванович', '+79123456789', 'ivanov@example.com', '1985-05-15'),
('Петрова', 'Мария', 'Сергеевна', '+79224567890', 'petrova@example.com', '1992-11-23'),
('Сидоров', 'Алексей', 'Владимирович', '+79335678901', 'sidorov@example.com', '1978-03-02'),
('Козлова', 'Елена', 'Анатольевна', '+79446789012', 'kozlovae@example.com', '2000-07-19'),
('Морозов', 'Дмитрий', 'Павлович', '+79557890123', 'morozov@example.com', '1995-12-01'),
('Васильева', 'Анна', 'Игоревна', '+79668901234', 'vasilyeva@example.com', '2010-04-10');

INSERT INTO parental_consent (client_id, parent_full_name, parent_phone, consent_date, consent_document_url) VALUES
(6, 'Васильева Ирина Петровна', '+79668901235', '2026-05-01', '/docs/consent_6.pdf');

INSERT INTO vaccines (vaccine_name, vaccine_type, manufacturer, doses_per_package, stock_quantity, expiration_date) VALUES
('Гам-КОВИД-Вак', 'векторная', 'НИЦЭМ им. Гамалеи', 10, 50, '2026-12-31'),
('Спутник Лайт', 'векторная', 'НИЦЭМ им. Гамалеи', 5, 30, '2026-10-15'),
('ЭпиВакКорона', 'инактивированная', 'Федеральный научный центр Вектор', 1, 20, '2026-06-10'),
('КовиВак', 'инактивированная', 'Федеральный научный центр', 2, 15, '2027-01-20'),
('Comirnaty', 'мРНК', 'Pfizer/BioNTech', 195, 100, '2026-08-01');

INSERT INTO appointments (client_id, vaccine_id, appointment_datetime, status) VALUES
(1, 1, '2026-06-15 10:00:00', 'запланировано'),
(2, 2, '2026-06-16 11:30:00', 'запланировано'),
(3, 3, '2026-06-10 09:00:00', 'запланировано'),
(4, 4, '2026-06-20 14:00:00', 'запланировано'),
(5, 5, '2026-06-25 12:15:00', 'запланировано'),
(6, 1, '2026-07-01 15:00:00', 'запланировано');

INSERT INTO adverse_reactions (appointment_id, reaction_date, reaction_description, severity, required_hospitalization) VALUES
(2, '2026-05-20', 'Повышение температуры до 38.5, головная боль', 'средняя', FALSE),
(4, '2026-05-22', 'Покраснение в месте инъекции', 'лёгкая', FALSE);
