# !/bin/bash

echo "Running post attendance"
K6_WEB_DASHBOARD=true K6_WEB_DASHBOARD_EXPORT=report.html k6 run ./attendance/post.js
echo "Done running post attendance"

