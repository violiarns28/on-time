@echo off
set BASE_URL=https://attendance-api.zenta.dev
REM set BASE_URL=http://localhost:3000

REM Run post attendance
echo Running post attendance
set K6_WEB_DASHBOARD=true
k6 run -e BASE_URL=%BASE_URL% ./attendance/post.js
echo Done running post attendance
