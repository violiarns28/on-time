# !/bin/bash

# set environment variables for k6
ACCESS_TOKEN="eyJhbGciOiJIUzI1NiJ9.eyJpZCI6NiwiZW1haWwiOiJhc2RmQGFzZGYuY29tIiwibmFtZSI6ImFzZGYiLCJkZXZpY2VJZCI6ImFzZGZhYXNkZiIsImlhdCI6MTc0MTI3Njg1M30.-e_E17rjmw5C1HqPq23K0jLaDO8uFimxJ8NxRL7HsK4"

# run get attendance
echo "Running get attendance"
K6_WEB_DASHBOARD=true k6 run -e ACCESS_TOKEN=$ACCESS_TOKEN ./attendance/get.js
echo "Done running get attendance"

