# Remove Jboss Logs
this script Remove Jboss/Wildfly logs

# Usage
insert into crontab file this string
```
00 1 * * * /path/to/remove_jboss_log.sh /path/to/log days >> /dev/null
```
sample
```
00 1 * * * $HOME/bin/remove_jboss_log.sh /opt/OpenIAM/jboss/jboss-as-7.1.1.Final/standalone/log 30 >> /dev/null
```
