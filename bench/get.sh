# !/bin/bash

ACCESS_TOKEN="eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MiwiZW1haWwiOiJqb2huQGdtYWlsLmNvbSIsIm5hbWUiOiJKb2huIiwiZGV2aWNlSWQiOiJqb2huIiwiaWF0IjoxNzQ0NzA2Njk2fQ._81Rc8wvQu7_tslbAwm00TbdIDf_BisbrMzdoihUnyk"

BASE_URL="https://attendance-api.zenta.dev"
# BASE_URL="http://localhost:3000"

# run get attendance
echo "Running get attendance"
K6_WEB_DASHBOARD=true k6 run -e ACCESS_TOKEN=$ACCESS_TOKEN -e BASE_URL=$BASE_URL ./attendance/get.js
echo "Done running get attendance"

