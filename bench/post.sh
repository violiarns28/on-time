# !/bin/bash

echo "Running post attendance"
K6_WEB_DASHBOARD=true K6_WEB_DASHBOARD_EXPORT=attendance_simulation_report.html k6 run ./attendance/post.js
echo "Done running post attendance"

