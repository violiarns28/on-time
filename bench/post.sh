# !/bin/bash

BASE_URL="https://attendance-api.zenta.dev"
# BASE_URL="http://localhost:3000"

# run post attendance
echo "Running post attendance"
K6_WEB_DASHBOARD=true K6_WEB_DASHBOARD_EXPORT=attendance_simulation_report.html k6 run -e BASE_URL=$BASE_URL  ./attendance/post.js
echo "Done running post attendance"

