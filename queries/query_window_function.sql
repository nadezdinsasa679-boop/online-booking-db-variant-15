SELECT 
    vaccine_name AS Вакцина,
    manufacturer AS Производитель,
    expiration_date AS Срок_годности,
    stock_quantity AS Остаток,
    ROW_NUMBER() OVER (ORDER BY expiration_date) AS Ранг_по_сроку
FROM vaccines
WHERE expiration_date >= CURDATE();
