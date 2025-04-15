# !/bin/bash

# set environment variables for k6
ACCESS_TOKEN="eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MjAwMDAzLCJlbWFpbCI6ImFzZGZAYXNkZi5jb20iLCJuYW1lIjoiYXNkZmFzIiwiZGV2aWNlSWQiOiJkZXZpY2VJZCIsImlhdCI6MTc0NDY5ODk1NX0.GFt5sms-KbR6nYiExXc7PZ0WzI5cHc09XA5yNE8qhA4"

BASE_URL="https://attendance-api.zenta.dev"
# BASE_URL="http://localhost:3000"

# run post attendance
echo "Running post attendance"
K6_WEB_DASHBOARD=true k6 run -e ACCESS_TOKEN=$ACCESS_TOKEN -e BASE_URL=$BASE_URL ./attendance/post.js
echo "Done running post attendance"

