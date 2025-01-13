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



# ❓ Business Questions Solved with SQL

1. User Engagement
How much time do users spend listening to music on each platform?

```sql

SELECT 
    platform, 
    SUM(ms_played) / 60000 AS total_minutes_played
FROM spotify_streaming_data
GROUP BY platform
ORDER BY total_minutes_played DESC;



