sbin/service-start: src/lunatics/service/service-start.sh
sbin/service-stop: src/lunatics/service/service-stop.sh

UTILS_SH += sbin/service-start sbin/service-stop
INITRD_UTILS += sbin/service-start sbin/service-stop
