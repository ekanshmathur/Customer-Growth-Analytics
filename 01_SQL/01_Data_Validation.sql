USE CustomerGrowthAnalytics;
GO
-----------------------------------------------------------
-- DATABASE WAS CREATED SUCCESSFULLY.
-- CHECKING IF ALL THE TABLES ARE SHOWING CORRECT NUMBERS OF ROWS AND NOTHING IS MISSED:

SELECT 'October 2019' AS MONTH,
	COUNT(*) AS Total_Rows,
	MIN(event_time) AS First_Event,
	MAX(event_time) AS Last_event
FROM events_oct2019

UNION ALL

SELECT 'November 2019',
	COUNT(*) AS Total_Rows,
	MIN(event_time) AS First_Event,
	MAX(event_time) AS Last_event
FROM events_nov2019

UNION ALL

SELECT 'December 2019',
	COUNT(*) AS Total_Rows,
	MIN(event_time) AS First_Event,
	MAX(event_time) AS Last_event
FROM events_dec2019

UNION ALL

SELECT 'January 2020',
	COUNT(*) AS Total_Rows,
	MIN(event_time) AS First_Event,
	MAX(event_time) AS Last_event
FROM events_jan2020

UNION ALL

SELECT 'February 2020',
	COUNT(*) AS Total_Rows,
	MIN(event_time) AS First_Event,
	MAX(event_time) AS Last_event
FROM events_feb2020

-------------------------------------------------------------------------
-- Final Check:

SELECT
	TABLE_NAME,
	COLUMN_NAME,
	DATA_TYPE,
	CHARACTER_MAXIMUM_LENGTH,
	IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN (
	'events_oct2019',
	'events_nov2019',
	'events_dec2019',
	'events_jan2020',
	'events_feb2020'
)

ORDER BY TABLE_NAME, ORDINAL_POSITION;
