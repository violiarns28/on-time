# !/bin/bash

# set environment variables for k6
ACCESS_TOKEN="eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MywiZW1haWwiOiJqb2huQGdtYWlsLmNvbSIsIm5hbWUiOiJKb2huIiwiZGV2aWNlSWQiOiIwMTk2MzI5Yi1iYTU5LTcyNTAtOGEzZC0yOGI2NjJhZDkwNWQiLCJpYXQiOjE3NDQ2OTc1NTh9.1kJQK-gBowIGBkER5XDKKubGQ2s7aZ4btvuIs_BWZnM"

BASE_URL="https://attendance-api.zenta.dev"
# BASE_URL="http://localhost:3000"

# run post attendance
echo "Running post attendance"
K6_WEB_DASHBOARD=true k6 run -e ACCESS_TOKEN=$ACCESS_TOKEN -e BASE_URL=$BASE_URL ./attendance/post.js
echo "Done running post attendance"

