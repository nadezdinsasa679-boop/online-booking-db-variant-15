SELECT 
    c.last_name AS Фамилия,
    c.first_name AS Имя,
    v.vaccine_name AS Вакцина,
    DATE(a.appointment_datetime) AS Дата_записи,
    a.status AS Статус,
    COALESCE(ar.reaction_description, 'Нет реакций') AS Реакция
FROM appointments a
JOIN clients c ON a.client_id = c.client_id
JOIN vaccines v ON a.vaccine_id = v.vaccine_id
LEFT JOIN adverse_reactions ar ON a.appointment_id = ar.appointment_id
ORDER BY a.appointment_datetime;
