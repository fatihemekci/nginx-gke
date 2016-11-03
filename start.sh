service rsyslog start
service google-fluentd restart
service nginx start
service stackdriver-agent restart
while true; do sleep 3m; done
