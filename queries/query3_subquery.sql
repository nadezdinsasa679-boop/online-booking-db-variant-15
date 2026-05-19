SELECT 
    vaccine_name AS Вакцина,
    expiration_date AS Срок_годности,
    DATEDIFF(expiration_date, CURDATE()) AS Дней_до_истечения
FROM vaccines
WHERE expiration_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY);
