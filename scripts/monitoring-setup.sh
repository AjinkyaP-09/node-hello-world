# scripts/03-monitoring-setup.sh
# Installs and configures the AWS CloudWatch Agent.

#!/bin/bash
set -e

echo "--- Downloading the CloudWatch Agent ---"
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb

echo "--- Installing the Agent ---"
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

echo "--- Installing collectd dependency ---"
sudo apt-get install -y collectd

echo "--- Monitoring setup complete! ---"
echo "Next steps:"
echo "1. Run the configuration wizard: sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard"
echo "2. Start the agent with the new config: sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json"
