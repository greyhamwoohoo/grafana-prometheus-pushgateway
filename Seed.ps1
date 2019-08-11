# Crude loopy PowerShell script that continuously pushes metric values (test pass rate) to a Dashboard
#
# NOTE: Push Gateway needs UNIX Line Endings: https://github.com/prometheus/pushgateway/issues/147
#
do {
$body = @"
# TYPE test_passrate_percent gauge
test_passrate_percent{test_name="thisIsTest1"} 100
test_passrate_percent{test_name="thisIsTest2"} 100
test_passrate_percent{test_name="thisIsTest3"} 100

"@.Replace("`r`n","`n")

Invoke-RestMethod -Method PUT -Uri "http://localhost:9091/metrics/job/test_result_job/instance/environment_dev" -Body $body
Invoke-RestMethod -Method PUT -Uri "http://localhost:9091/metrics/job/test_result_job/instance/environment_uat" -Body $body

sleep 30

$body = @"
# TYPE test_passrate_percent gauge
test_passrate_percent{test_name="thisIsTest1"} 0
test_passrate_percent{test_name="thisIsTest2"} 100
test_passrate_percent{test_name="thisIsTest3"} 0

"@.Replace("`r`n","`n")

Invoke-RestMethod -Method PUT -Uri "http://localhost:9091/metrics/job/test_result_job/instance/environment_dev" -Body $body
Invoke-RestMethod -Method PUT -Uri "http://localhost:9091/metrics/job/test_result_job/instance/environment_uat" -Body $body

sleep 30

$body = @"
# TYPE test_passrate_percent gauge
test_passrate_percent{test_name="thisIsTest1"} 100
test_passrate_percent{test_name="thisIsTest2"} 100
test_passrate_percent{test_name="thisIsTest3"} 0

"@.Replace("`r`n","`n")

Invoke-RestMethod -Method PUT -Uri "http://localhost:9091/metrics/job/test_result_job/instance/environment_dev" -Body $body
Invoke-RestMethod -Method PUT -Uri "http://localhost:9091/metrics/job/test_result_job/instance/environment_uat" -Body $body

sleep 30

} while($true)
