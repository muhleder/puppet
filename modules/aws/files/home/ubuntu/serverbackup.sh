#!/bin/sh
# Confidential keys etc should be set as global environment variables in /etc/environment
. /etc/environment
description="server-backup-`date +%Y-%m-%d-%H-%M-%S`"

ec2-consistent-snapshot  \
--debug \
--aws-access-key-id=$AWS_ACCESS_KEY \
--aws-secret-access-key=$AWS_SECRET_KEY \
--description=$description  \
--region=$AWS_REGION \
$AWS_VOLUME_ID


ec2-prune-snapshots  \
--aws-access-key-id=$AWS_ACCESS_KEY \
--aws-secret-access-key=$AWS_SECRET_KEY \
--months 0 --weeks 1 --days 1 \
--dayofmonth 1 --dayofweek 1 \
--region=$AWS_REGION \
$AWS_VOLUME_ID