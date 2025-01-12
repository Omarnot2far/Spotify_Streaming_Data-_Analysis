Select *
from spotify_streaming_data;

--- 1. User Engagement and Retention
-- Problem: How much time do users spend listening to music on each platform?

Select platform, sum(ms_played)/6000 as total_minutes_played
from spotify_streaming_data
GROUP BY platform
order by total_minutes_played desc; 

-- 2. Track Performance
-- Problem: What are the top 10 most-played tracks?
SELECT track_name, artist_name, SUM(ms_played)/60000 AS total_minutes_played
FROM spotify_streaming_data
GROUP BY track_name, artist_name
ORDER BY total_minutes_played DESC
LIMIT 10;

-- 3. Skipping Behavior
-- Problem: What percentage of songs are skipped on shuffle vs. non-shuffle mode?
SELECT 
    shuffle,
    COUNT(*) AS total_tracks,
    SUM(CASE WHEN skipped = TRUE THEN 1 ELSE 0 END) AS skipped_tracks,
	ROUND(SUM(CASE WHEN skipped = TRUE THEN 1 ELSE 0 END)::DECIMAL * 100 / COUNT(*), 2) AS skip_percentage
    FROM spotify_streaming_data
	GROUP BY shuffle;

-- 4. Artist and Album Popularity
-- Problem: Which artist has the highest total playtime?
Select artist_name,
SUM(ms_played)/60000 AS total_minutes_played
from spotify_streaming_data
group by artist_name
ORDER BY total_minutes_played DESC
LIMIT 10;

-- 5. Reasons for Playback
-- Problem: What are the common reasons users start and stop tracks?
Select reason_start, reason_end, COUNT(*) AS occurrences
from spotify_streaming_data
Group By reason_start, reason_end
ORDER BY occurrences DESC
LIMIT 10;

-- 6. Track Completion Rate
-- Problem: How many tracks are played fully without skipping?
SELECT 
    COUNT(*) AS total_tracks,
    SUM(CASE WHEN skipped = FALSE THEN 1 ELSE 0 END) AS not_skipped_tracks,
    ROUND(SUM(CASE WHEN skipped = FALSE THEN 1 ELSE 0 END)::DECIMAL * 100 / COUNT(*), 2) AS completion_rate
FROM spotify_streaming_data;

-- 7. Time-Based Trends
-- Problem: What is the hourly trend for music streaming activity?
SELECT EXTRACT(HOUR FROM ts) AS hour_of_day, SUM(ms_played)/60000 AS total_minutes_played
FROM spotify_streaming_data
GROUP BY EXTRACT(HOUR FROM ts)
ORDER BY hour_of_day;

SELECT EXTRACT(minute FROM ts) AS min_of_day, SUM(ms_played)/60000 AS total_minutes_played
FROM spotify_streaming_data
GROUP BY EXTRACT(minute FROM ts)
ORDER BY min_of_day;

-- 8. Impact of Shuffle Mode
-- Problem: Does shuffle mode increase or decrease total listening time?
SELECT 
    shuffle, 
    SUM(ms_played)/60000 AS total_minutes_played
FROM spotify_streaming_data
GROUP BY shuffle;

-- 9. Track Starting Patterns
-- Problem: Which reasons drive the most track starts?
SELECT reason_start, COUNT(*) AS occurrences
FROM spotify_streaming_data
GROUP BY reason_start
ORDER BY occurrences DESC;

-- 10. Skipped Tracks Analysis
-- Problem: Which tracks have the highest skip rate?
SELECT track_name, artist_name, 
       COUNT(*) AS total_plays, 
       SUM(CASE WHEN skipped = TRUE THEN 1 ELSE 0 END) AS skipped_count,
       ROUND(SUM(CASE WHEN skipped = TRUE THEN 1 ELSE 0 END)::DECIMAL * 100 / COUNT(*), 2) AS skip_rate
FROM spotify_streaming_data
GROUP BY track_name, artist_name
HAVING COUNT(*) > 10  -- Only consider tracks with more than 10 plays
ORDER BY skip_rate DESC
LIMIT 10;

-- 11. Album Analysis
-- Problem: Which albums have the highest average playtime per track?
SELECT album_name, AVG(ms_played)/60000 AS avg_play_time_minutes
FROM spotify_streaming_data
GROUP BY album_name
ORDER BY avg_play_time_minutes DESC
LIMIT 10;

-- 12. Platform Preferences
-- Problem: Which platform is preferred for specific genres or artists?
SELECT platform, artist_name, SUM(ms_played)/60000 AS total_minutes_played
FROM spotify_streaming_data
GROUP BY platform, artist_name
ORDER BY total_minutes_played DESC
LIMIT 10;


