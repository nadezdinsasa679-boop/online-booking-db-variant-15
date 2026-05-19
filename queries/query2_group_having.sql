SELECT 
    v.vaccine_name AS Вакцина,
    v.stock_quantity AS Остаток,
    COUNT(a.appointment_id) AS Записей
FROM vaccines v
LEFT JOIN appointments a ON v.vaccine_id = a.vaccine_id AND a.status = 'запланировано'
GROUP BY v.vaccine_id
HAVING v.stock_quantity < 25
ORDER BY Записей DESC;
