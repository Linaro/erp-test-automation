# Cambridge

Run "setup-local.sh <build-num>"
Upload $HOME/<build-num>/ to http://172.27.80.1:5000/admin/images

Open http://172.27.80.1:5000/admin/machines/5
    - Edit to latest build
    - Reboot

## ThunderX

Open ipmitool -v -I lanplus -H 172.27.64.111 -U admin -P 'admin' sol activate
    - Press any key for boot selection
    - Boot #3, PXE
    - If "Network autoconfiguration failed", reboot and it will work the second time.


# Austin

scp setup-austin.sh qa-pxe:~/
ssh -t qa-pxe sudo sh setup-austin.sh <build-num>

## Amberwing

ssh -t aus-colo.linaro.org ipmitool -I lanplus -A PASSWORD -U admin -P Password1 -H r3-a14-bmc chassis power reset
ssh -t aus-colo.linaro.org ipmitool -I lanplus -A PASSWORD -U admin -P Password1 -H r3-a14-bmc sol activate

hit "Space", select EFI Network in boot menu.

# Open Estuary

scp setup-openestuary.sh oe-board-server:~/
ssh -t oe-board-server sh setup-openestuary.sh <build-num>

## D03/D05
board_reboot 2
board_connect 2

# From boot menu, select EFI Network 2
