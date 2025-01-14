# 🎵 Spotify Streaming Data Analysis
![Project Logo](https://github.com/Omarnot2far/Spotify_Streaming_Data-_Analysis/blob/main/Spotify_Full_Logo_RGB_Green.png)


---

## 📖 Overview

This project analyzes Spotify streaming data to extract meaningful insights about user behavior, track performance, platform engagement, and more. By leveraging PostgreSQL and SQL queries, this project provides actionable insights for decision-making to improve user experience and optimize streaming performance.

---

## 🎯 Objective

The primary goal of this project is to:
- Analyze Spotify streaming data to uncover user behavior and engagement trends.
- Provide business recommendations to improve user retention, track popularity, and platform performance.

---

## 📂 Dataset

dataset: https://mavenanalytics.io/challenges/maven-music-challenge/e161353d-9967-4297-869c-505de168e610

The dataset contains detailed Spotify streaming logs with the following columns:

| **Field**            | **Description**                                                                 |
|-----------------------|---------------------------------------------------------------------------------|
| `spotify_track_uri`   | Spotify URI uniquely identifying each track.                                   |
| `ts`                 | Timestamp indicating when the track stopped playing (in UTC).                  |
| `platform`           | Platform used for streaming (e.g., web, mobile, desktop).                      |
| `ms_played`          | Number of milliseconds the track was played.                                   |
| `track_name`         | Name of the track.                                                             |
| `artist_name`        | Name of the artist.                                                            |
| `album_name`         | Name of the album.                                                             |
| `reason_start`       | Why the track started (e.g., playlist, user search).                           |
| `reason_end`         | Why the track ended (e.g., skipped, completed).                                |
| `shuffle`            | Boolean indicating if shuffle mode was active.                                 |
| `skipped`            | Boolean indicating if the track was skipped by the user.                       |

---

## 🗃️ Data Schema

The data is stored in a PostgreSQL table with the following schema:

```sql
CREATE TABLE spotify_streaming_data (
    spotify_track_uri TEXT NOT NULL,
    ts TIMESTAMP NOT NULL,
    platform TEXT NOT NULL,
    ms_played INTEGER NOT NULL,
    track_name TEXT,
    artist_name TEXT,
    album_name TEXT,
    reason_start TEXT,
    reason_end TEXT,
    shuffle BOOLEAN,
    skipped BOOLEAN
);
```




## 1. User Engagement and Retention
### How much time do users spend listening to music on each platform?


```sql
SELECT 
    platform, 
    SUM(ms_played) / 60000 AS total_minutes_played
FROM spotify_streaming_data
GROUP BY platform
ORDER BY total_minutes_played DESC;
```
![1 Logo](https://github.com/Omarnot2far/Spotify_Streaming_Data-_Analysis/blob/main/1.platform.png)

## 2. Track Performance
### What are the top 10 most-played tracks?

```sql
SELECT 
    track_name, 
    artist_name, 
    SUM(ms_played)/60000 AS total_minutes_played
FROM spotify_streaming_data
GROUP BY track_name, artist_name
ORDER BY total_minutes_played DESC
LIMIT 10;
```
![Project Logo](2.tracks.png)
## 3. Skipping Behavior
### What percentage of songs are skipped on shuffle vs. non-shuffle mode?

```sql
SELECT 
    shuffle,
    COUNT(*) AS total_tracks,
    SUM(CASE WHEN skipped = TRUE THEN 1 ELSE 0 END) AS skipped_tracks,
	ROUND(SUM(CASE WHEN skipped = TRUE THEN 1 ELSE 0 END)::DECIMAL * 100 / COUNT(*), 2) AS skip_percentage
FROM spotify_streaming_data
GROUP BY shuffle;
```
![Project Logo](3.shuffle.png)
## 4. Artist and Album Popularity
### Which artist has the highest total playtime?

```sql
Select 
    artist_name,
    SUM(ms_played)/60000 AS total_minutes_played
from spotify_streaming_data
group by artist_name
ORDER BY total_minutes_played DESC
LIMIT 10;
```
![Project Logo](4.artist_playtime.png)
## 5. Reasons for Playback
### What are the common reasons users start and stop tracks?
#### reasons to start the tracks
```sql
SELECT
	reason_start,
	COUNT(*) AS occurrences
FROM spotify_streaming_data
GROUP BY reason_start
ORDER BY occurrences DESC
LIMIT 10;
```
![Project Logo](5.reason_start.png)
#### reasons to end the tracks
```sql
SELECT
	reason_end,
	COUNT(*) AS occurrences
FROM spotify_streaming_data
GROUP BY reason_end
ORDER BY occurrences DESC
LIMIT 10;
```
![Project Logo](5.reason_end.png)
## 6. Track Completion Rate
### How many tracks are played fully without skipping?
```sql
SELECT 
    COUNT(*) AS total_tracks,
    SUM(CASE WHEN skipped = FALSE THEN 1 ELSE 0 END) AS not_skipped_tracks,
    ROUND(SUM(CASE WHEN skipped = FALSE THEN 1 ELSE 0 END)::DECIMAL * 100 / COUNT(*), 2) AS completion_rate
FROM spotify_streaming_data;
```
![Project Logo](6.tranck_comp_rate_witoutskip.png)
## 7. Time-Based Trends
### What is the hourly trend for music streaming activity?
```sql
SELECT 
    EXTRACT(HOUR FROM ts) AS hour_of_day, 
    SUM(ms_played)/60000 AS total_minutes_played
FROM spotify_streaming_data
GROUP BY EXTRACT(HOUR FROM ts)
ORDER BY hour_of_day;
```
![Project Logo](7.hour.png)
## 8. Impact of Shuffle Mode
### Does shuffle mode increase or decrease total listening time?
```sql
SELECT 
    shuffle, 
    SUM(ms_played)/60000 AS total_minutes_played
FROM spotify_streaming_data
GROUP BY shuffle;
```
![Project Logo](8.impact_suffle.png)
## 9. Skipped Tracks Analysis
### Which tracks have the highest skip rate?
```sql
SELECT
    track_name,
    artist_name, 
    COUNT(*) AS total_plays, 
    SUM(CASE WHEN skipped = TRUE THEN 1 ELSE 0 END) AS skipped_count,
    ROUND(SUM(CASE WHEN skipped = TRUE THEN 1 ELSE 0 END)::DECIMAL * 100 / COUNT(*), 2) AS skip_rate
FROM spotify_streaming_data
GROUP BY track_name, artist_name
HAVING COUNT(*) > 10  -- Only consider tracks with more than 10 plays
ORDER BY skip_rate DESC
LIMIT 10;
```
![Project Logo](9.skip_rate_tracks_artist.png)
## 10. Album Analysis
### Which albums have the highest average playtime per track?
```sql
SELECT 
    album_name, 
    AVG(ms_played)/60000 AS avg_play_time_minutes
FROM spotify_streaming_data
GROUP BY album_name
ORDER BY avg_play_time_minutes DESC
LIMIT 10;
```
![Project Logo](10.high_avg_play_album.png)
## 11. Platform Preferences
### Which platform is preferred for specific genres or artists?
```sql
SELECT 
    platform, 
    artist_name, 
    SUM(ms_played)/60000 AS total_minutes_played
FROM spotify_streaming_data
GROUP BY platform, artist_name
ORDER BY total_minutes_played DESC
LIMIT 10;
```
![Project Logo](11.platform_artist.png)
