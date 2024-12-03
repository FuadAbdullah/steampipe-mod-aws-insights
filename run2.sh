#!/bin/bash

# Stop and then start Steampipe server
steampipe service stop
steampipe service start

# Check the status of the Steampipe server
steampipe service status

# Start Powerpipe dashboard
powerpipe server
