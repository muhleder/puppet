#!/bin/sh

description="server-backup-`date +%Y-%m-%d-%H-%M-%S`"
volumeid=<VOLUME-ID>
accesskeyid=<ACCESS-KEY>
secretaccesskey=<SECRET-KEY>
region=<REGION>


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
--months 3 --weeks 4 --days 7 \
--dayofmonth 1 --dayofweek 1 \
--region=$region \
$volumeid