#!/bin/sh

description="server-backup-`date +%Y-%m-%d-%H-%M-%S`"
volumeid=$AWS_VOLUME_ID
accesskeyid=$AWS_ACCESS_KEY
secretaccesskey=$AWS_SECRET_KEY
region=$AWS_REGION


ec2-consistent-snapshot  \
--debug \
--aws-access-key-id=$accesskey \
--aws-secret-access-key=$secretaccesskey \
--description=$description  \
--region=$region \
$volumeid


ec2-prune-snapshots  \
--aws-access-key-id=$accesskey \
--aws-secret-access-key=$secretaccesskey \
--months 0 --weeks 1 --days 1 \
--dayofmonth 1 --dayofweek 1 \
--region=$region \
$volumeid