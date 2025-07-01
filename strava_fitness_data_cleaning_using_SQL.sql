
---------------------------Data Cleaning-------------------------------

SELECT * FROM "dailyActivity_merged";

-- Transform the columns name into lower case

Alter table "dailyActivity_merged" RENAME COLUMN "Id" to "id";
Alter table "dailyActivity_merged" RENAME COLUMN "ActivityDate" to "activity_date";
Alter table "dailyActivity_merged" RENAME COLUMN "TotalSteps" to "total_steps";
Alter table "dailyActivity_merged" RENAME COLUMN "TotalDistance" to "total_distance";
Alter table "dailyActivity_merged" RENAME COLUMN "TrackerDistance" to "tracker_distance";
Alter table "dailyActivity_merged" RENAME COLUMN "LoggedActivitiesDistance" to "logged_activities_distance";
Alter table "dailyActivity_merged" RENAME COLUMN "VeryActiveDistance" to "very_active_distance";
Alter table "dailyActivity_merged" RENAME COLUMN "ModeratelyActiveDistance" to "moderately_active_distance";
Alter table "dailyActivity_merged" RENAME COLUMN "LightActiveDistance" to "light_active_distance";
Alter table "dailyActivity_merged" RENAME COLUMN "SedentaryActiveDistance" to "sedentary_active_distance";
Alter table "dailyActivity_merged" RENAME COLUMN "VeryActiveMinutes" to "very_active_minutes";
Alter table "dailyActivity_merged" RENAME COLUMN "FairlyActiveMinutes" to "fairly_active_minutes";
Alter table "dailyActivity_merged" RENAME COLUMN "LightlyActiveMinutes" to "lightly_active_minutes";
Alter table "dailyActivity_merged" RENAME COLUMN "SedentaryMinutes" to "sedentary_minutes";
Alter table "dailyActivity_merged" RENAME COLUMN "Calories" to "calories";

-- Find duplicate records
SELECT id, activity_date, total_steps, total_distance, tracker_distance, logged_activities_distance, 
very_active_distance, moderately_active_distance, light_active_distance, sedentary_active_distance, 
very_active_minutes, fairly_active_minutes, lightly_active_minutes, sedentary_minutes, calories, Count(*) AS count
FROM "dailyActivity_merged"
GROUP BY id, activity_date, total_steps, total_distance, tracker_distance, logged_activities_distance, 
very_active_distance, moderately_active_distance, light_active_distance, sedentary_active_distance, 
very_active_minutes, fairly_active_minutes, lightly_active_minutes, sedentary_minutes, calories
HAVING COUNT(*)> 1;

--Remove columns  “logged_activities_distance” and “sedentary_active_distance”
Alter table "dailyActivity_merged"
DROP COLUMN logged_activities_distance,
DROP COLUMN sedentary_active_distance;

--Change datatype of activity_date column (from text to date)
Alter table "dailyActivity_merged"
Alter Column activity_date
TYPE DATE
USING TO_DATE(activity_date, 'MM/DD/YYYY');

--Change datatype of total_distance (numeric 10, 2)
ALTER TABLE "dailyActivity_merged"
ALTER COLUMN total_distance
TYPE NUMERIC(10, 2)
USING ROUND(total_distance::numeric, 2);

-----------------------------------------
SELECT * FROM "hourlyCalories_merged";
SELECT * FROM "hourlyIntensities_merged";
SELECT * FROM "hourlySteps_merged";

-- Transform the columns name into lower case of "hourlyCalories_merged" table

Alter table "hourlyCalories_merged" RENAME COLUMN "Id" to "id";
Alter table "hourlyCalories_merged" RENAME COLUMN "ActivityHour" to "activity_hour";
Alter table "hourlyCalories_merged" RENAME COLUMN "Calories" to "calories";

-- Transform the columns name into lower case of "hourlyIntensities_merged" table
Alter table "hourlyIntensities_merged" RENAME COLUMN "Id" to "id";
Alter table "hourlyIntensities_merged" RENAME COLUMN "ActivityHour" to "activity_hour";
Alter table "hourlyIntensities_merged" RENAME COLUMN "TotalIntensity" to "total_intensity";
Alter table "hourlyIntensities_merged" RENAME COLUMN "AverageIntensity" to "average_intensity";

-- Transform the columns name into lower case of "hourlySteps_merged" table
Alter table "hourlySteps_merged" RENAME COLUMN "Id" to "id";
Alter table "hourlySteps_merged" RENAME COLUMN "ActivityHour" to "activity_hour";
Alter table "hourlySteps_merged" RENAME COLUMN "StepTotal" to "step_total";

-- Update table "hourlyCalories_merged" with add the columns "total_intensity" and "average_intensity" from 
--"hourlyIntensities_merged" table
ALTER TABLE "hourlyCalories_merged" ADD COLUMN total_intensity bigint;
ALTER TABLE "hourlyCalories_merged" ADD COLUMN average_intensity double precision;

UPDATE "hourlyCalories_merged" t1
SET total_intensity = t2.total_intensity,
average_intensity = t2.average_intensity
FROM "hourlyIntensities_merged" t2
WHERE t1.id = t2.id 
AND t1.activity_hour = t2.activity_hour;

-- update the datatype of activity_hour column(from text to datetime)

ALTER TABLE "hourlyCalories_merged"
ALTER COLUMN activity_hour 
TYPE TIMESTAMP
USING TO_TIMESTAMP(activity_hour, 'MM/DD/YYYY HH12:MI:SS AM');

-- Find duplicate records
SELECT id, activity_hour, calories, total_intensity, average_intensity, step_total, Count(*) AS count
FROM "hourlyCalories_merged"
GROUP BY id, activity_hour, calories, total_intensity, average_intensity, step_total
HAVING COUNT(*)> 1;

--Change datatype of  average_intensity(numeric 10, 2)
ALTER TABLE "hourlyCalories_merged"
ALTER COLUMN average_intensity
TYPE NUMERIC(10, 2)
USING ROUND(average_intensity::numeric, 2);


-----------------------------------------
SELECT * FROM "minuteCaloriesNarrow_merged";
SELECT * FROM "minuteIntensitiesNarrow_merged";
SELECT * FROM "minuteStepsNarrow_merged";

-- Transform the columns name into lower case of "minuteCaloriesNarrow_merged" table

Alter table "minuteCaloriesNarrow_merged" RENAME COLUMN "Id" to "id";
Alter table "minuteCaloriesNarrow_merged" RENAME COLUMN "ActivityMinute" to "activity_minute";
Alter table "minuteCaloriesNarrow_merged" RENAME COLUMN "Calories" to "calories";

-- Transform the columns name into lower case of "minuteIntensitiesNarrow_merged" table

Alter table "minuteIntensitiesNarrow_merged" RENAME COLUMN "Id" to "id";
Alter table "minuteIntensitiesNarrow_merged" RENAME COLUMN "ActivityMinute" to "activity_minute";
Alter table "minuteIntensitiesNarrow_merged" RENAME COLUMN "Intensity" to "intensity";

-- Transform the columns name into lower case of "minuteStepsNarrow_merged" table

Alter table "minuteStepsNarrow_merged" RENAME COLUMN "Id" to "id";
Alter table "minuteStepsNarrow_merged" RENAME COLUMN "ActivityMinute" to "activity_minute";
Alter table "minuteStepsNarrow_merged" RENAME COLUMN "Steps" to "steps";

-- Update table "minuteCaloriesNarrow_merged" with add the columns "intensity" from 
--"minuteIntensitiesNarrow_merged" table
ALTER TABLE "minuteCaloriesNarrow_merged" ADD COLUMN intensity bigint;


UPDATE "minuteCaloriesNarrow_merged" t1
SET intensity = t2.intensity
FROM "minuteIntensitiesNarrow_merged" t2
WHERE t1.id = t2.id 
AND t1.activity_minute = t2.activity_minute;


-- Update table "minuteCaloriesNarrow_merged" with add the columns "steps" from 
--"minuteStepsNarrow_merged" table
ALTER TABLE "minuteCaloriesNarrow_merged" ADD COLUMN steps bigint;


UPDATE "minuteCaloriesNarrow_merged" t1
SET steps = t2.steps
FROM "minuteStepsNarrow_merged" t2
WHERE t1.id = t2.id 
AND t1.activity_minute = t2.activity_minute;

-- update the datatype of activity_minute column(from text to datetime)

ALTER TABLE "minuteCaloriesNarrow_merged"
ALTER COLUMN activity_minute 
TYPE TIMESTAMP
USING TO_TIMESTAMP(activity_minute, 'MM/DD/YYYY HH12:MI:SS AM');

-- Find duplicate records
SELECT id, activity_minute, calories, intensity, steps, Count(*) AS count
FROM "minuteCaloriesNarrow_merged"
GROUP BY id, activity_minute, calories, intensity, steps
HAVING COUNT(*)> 1;

-------------------------------------------------------
SELECT * FROM "heartrate_seconds_merged";

-- Transform the columns name into lower case

Alter table "heartrate_seconds_merged" RENAME COLUMN "Id" to "id";
Alter table "heartrate_seconds_merged" RENAME COLUMN "Time" to "time";
Alter table "heartrate_seconds_merged" RENAME COLUMN "Value" to "value";

-- Find duplicate records
SELECT id, time, value, Count(*) AS count
FROM "heartrate_seconds_merged"
GROUP BY id, time, value
HAVING COUNT(*)> 1;

-- update the datatype of time column(from text to datetime)

ALTER TABLE "heartrate_seconds_merged"
ALTER COLUMN time 
TYPE TIMESTAMP
USING TO_TIMESTAMP(time, 'MM/DD/YYYY HH12:MI:SS AM');

----------------------------------------------------------
SELECT * FROM "sleepDay_merged";

-- Transform the columns name into lower case

Alter table "sleepDay_merged" RENAME COLUMN "Id" to "id";
Alter table "sleepDay_merged" RENAME COLUMN "SleepDay" to "sleep_day";
Alter table "sleepDay_merged" RENAME COLUMN "TotalSleepRecords" to "total_sleep_records";
Alter table "sleepDay_merged" RENAME COLUMN "TotalMinutesAsleep" to "total_minutes_asleep";
Alter table "sleepDay_merged" RENAME COLUMN "TotalTimeInBed" to "total_time_in_bed";

-- Find duplicate records
SELECT id, sleep_day, total_sleep_records, total_minutes_asleep, total_time_in_bed, Count(*) AS count
FROM "sleepDay_merged"
GROUP BY id, sleep_day, total_sleep_records, total_minutes_asleep, total_time_in_bed
HAVING COUNT(*)> 1;

--Delete duplicate records
DELETE FROM "sleepDay_merged"
WHERE id IN (
    SELECT id FROM (
        SELECT id,
               ROW_NUMBER() OVER (PARTITION BY id, sleep_day, total_sleep_records, total_minutes_asleep, total_time_in_bed ORDER BY id) AS rn
        FROM "sleepDay_merged"
    ) sub
    WHERE rn > 1
);

-- update the datatype of sleep_day column(from text to datetime)

ALTER TABLE "sleepDay_merged"
ALTER COLUMN sleep_day 
TYPE TIMESTAMP
USING TO_TIMESTAMP(sleep_day, 'MM/DD/YYYY HH12:MI:SS AM');


----------------------------Insights------------------------------

SELECT * FROM "dailyActivity_merged";

-- Find the daily total steps of each id.
SELECT id, activity_date, total_steps
FROM "dailyActivity_merged"
ORDER BY total_steps desc;

-- Find the daily total distance of each id.
SELECT id, activity_date, total_distance
FROM "dailyActivity_merged"
ORDER BY total_distance desc;

-- Find the daily calories burned of each id.
SELECT id, activity_date, calories
FROM "dailyActivity_merged"
ORDER BY calories desc;


SELECT * FROM "hourlyCalories_merged";

-- Find the hourly total steps of each id.
SELECT id, activity_hour, step_total
FROM "hourlyCalories_merged"
ORDER BY step_total desc;

-- Find active hour of the day
SELECT EXTRACT(HOUR FROM activity_hour) AS hour,
       AVG(step_total) AS avg_steps
FROM "hourlyCalories_merged"
GROUP BY hour
ORDER BY avg_steps DESC;

--Find steps vs calories burned
SELECT step_total, calories
FROM "hourlyCalories_merged"
ORDER BY step_total desc;

--Find daily total steps and total calories
SELECT DATE(activity_hour) AS day,
       SUM(step_total) AS total_steps,
       SUM(calories) AS total_calories
FROM "hourlyCalories_merged"
GROUP BY day
ORDER BY day;

SELECT * FROM "minuteCaloriesNarrow_merged";

--Find the minute with highest intensity
SELECT * FROM "minuteCaloriesNarrow_merged"
ORDER BY intensity DESC
LIMIT 5;

--Compare activity levels among users
SELECT id,
       SUM(steps) AS total_steps,
       SUM(calories) AS total_calories,
       AVG(intensity) AS avg_intensity
FROM "minuteCaloriesNarrow_merged"
GROUP BY id
ORDER BY total_steps DESC;

--Highest Heart Rate per user
SELECT id, MAX(value) AS max_heart_rate
FROM "heartrate_seconds_merged"
GROUP BY id;

--Average daily heart rate per user
SELECT id, DATE(time) as day, ROUND(AVG(value), 2) AS avg_daily_heart_rate
FROM "heartrate_seconds_merged"
GROUP BY id, DATE(time);

--Average sleep duration per user
SELECT id, ROUND(AVG(total_minutes_asleep), 2) AS avg_minutes_asleep,
ROUND(AVG(total_time_in_bed), 2) AS avg_time_in_bed
FROM "sleepDay_merged"
GROUP BY id;

-- Compare Time in bed vs actual sleep
SELECT id, sleep_day,
total_time_in_bed - total_minutes_asleep AS minutes_awake
FROM "sleepDay_merged"
ORDER BY minutes_awake DESC;


