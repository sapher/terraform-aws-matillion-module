#! /bin/bash

# Install awslogs
yum install -y awslogs

# Override region
sed -i 's/us-east-1/${region}/g' /etc/awslogs/awscli.conf

# Configure logs groups
cat > /etc/awslogs/awslogs.conf <<- 'EOF'
[general]
state_file = /var/lib/awslogs/agent-state

[/var/log/messages]
datetime_format = %b %d %H:%M:%S
file = /var/log/messages
buffer_duration = 5000
log_stream_name = {instance_id}/os
initial_position = start_of_file
log_group_name = ${log_group}

[/var/log/tomcat8/catalina.out]
datetime_format = %d-%b-%Y %H:%M:%S.%f
file = /var/log/tomcat8/catalina.out
buffer_duration = 5000
log_stream_name = {instance_id}/app
initial_position = start_of_file
log_group_name = ${log_group}
EOF

# Start aws agent for push Matillion log on Cloud Watch
service awslogs start

# Start aws agent on boot
chkconfig awslogs on
