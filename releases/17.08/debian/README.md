# Cambridge

Run "get-debian-installer-local.sh <build-num>"
Upload $HOME/<build-num>/ to http://172.27.80.1:5000/admin/images

Open http://172.27.80.1:5000/admin/machines/5
    - Edit to latest build
    - Reboot

## ThunderX

Open ipmitool -v -I lanplus -H 172.27.64.111 -U admin -P 'admin' sol activate
    - Press any key for boot selection
    - Boot #3, PXE

# Austin

scp get-debian-installer-austin.sh qa-pxe:~/
ssh -t qa-pxe sudo sh get-debian-installer-austin.sh <build-num>



## Amberwing

# Open Estuary

