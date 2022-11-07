#  Minicron

A tiny CLI tool to process simple cron jobs

## Build

Required: XCode 14
* Open the project
* Select minicron scheme
* Cmd+B

## Run debug

* Select minicron scheme
* Run it with Cmd+R
* Put your input into the terminal
* Press Ctrl+D to indicate end of input
* Observe output

## Archive
* Select minicron scheme
* Select Product > Archive
* Select built product in Organiser
* Click "Distribute Content" button on the right
* Select "Built Products" option and click Next
* Select location for the built product and click Export

## CLI usage
```
Workflow:
     CLI        |            minicron-framework           |        CLI
[parse input] ----> [create model] ----> [build output] ----> [print output]
```
### Call format
<input> minicron <simulated_time?>
where:
**input** - STDIN stream
**simulated_time** - Optional parameter of simulated current time, format hh:mm
**Input format:** see minicron-framework

### Example
Given you have a text file with the following configurations:
```
30 1 /bin/run_me_daily
45 * /bin/run_me_hourly
* * /bin/run_me_every_minute
* 19 /bin/run_me_sixty_times
```
To execute this tool against simulated 16:10 time:
`cat configs.txt | minicron 16:10`

Output:
```
1:30 tomorrow - /bin/run_me_daily
16:45 today - /bin/run_me_hourly
16:10 today - /bin/run_me_every_minute
19:00 today - /bin/run_me_sixty_times
```
