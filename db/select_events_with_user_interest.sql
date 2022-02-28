SELECT
	event.event_id, 
	event_name, 
    event_duration,
    event_type,
	DATE_FORMAT(event_dt, '%Y-%m-%d') as event_date_ymd,
    DATE_FORMAT(event_dt, '%b %d (%a)') as event_date,
    DATE_FORMAT(event_dt, '%l:%i %p') as event_time,
    event_location,
    --event_description,
    event_interest,
    CASE
        WHEN EXISTS (SELECT *
                    FROM event_user_registration
                    WHERE event_user_registration.event_id = event.event_id
                    AND event_user_registration.user_id = ?) THEN 1
        ELSE 0
    END AS event_user_interest
FROM 
	event LEFT JOIN (
		SELECT COUNT(*) as event_interest, event_id
		FROM event_user_registration
		GROUP BY event_id
	) as event_user_count on event.event_id = event_user_count.event_id,
    event_location, event_type
WHERE 
	event.event_location_id = event_location.event_location_id
    and event.event_type_id = event_type.event_type_id