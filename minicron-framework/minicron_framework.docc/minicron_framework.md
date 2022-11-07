# ``minicron_framework``

Parsing and processing of simple cron jobs

## Overview

`CronJob` allows you to map and process cron jobs

### Inputs
Input line of format `mm hh task` where:
`mm` is minutes between 0 and 59
`hh` are hours between 0 and 23
`task` is executable name

#### Example
```swift
let everyMinuteJob = CronJob("* * /etc/run_every_minute")
let dailyJob = CronJob("45 12 /etc/run_daily")
let hourlyJob = CronJob("30 * /etc/run_hourly")
let sixtyTimesJob = CronJob("* 17 /etc/run_sixty_times")
```

### Output
Call `CronJob.time.nextTrigger(_:)` to get the next execution time possible 
