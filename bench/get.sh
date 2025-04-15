# !/bin/bash

# set environment variables for k6
ACCESS_TOKEN="eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MiwiZW1haWwiOiJqb2huQGdtYWlsLmNvbSIsIm5hbWUiOiJKb2huIiwiZGV2aWNlSWQiOiIwMTk2MWZjMS05NWIwLTdmNzYtOTFjMi1iNWFhZmJlNmM5YmUiLCJpYXQiOjE3NDQ0NDA4NTd9.qGDfH_NwmgRVTKwAyb-Qw-Flpm63zKHQxocCT5LBWtI"

# run get attendance
echo "Running get attendance"
K6_WEB_DASHBOARD=true k6 run -e ACCESS_TOKEN=$ACCESS_TOKEN ./attendance/get.js
echo "Done running get attendance"

