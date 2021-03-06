declare network_name="sys_net_prov"
declare vm_name="WordPress"
declare iso_file_path="../../CentOS-7-x86_64-Minimal-1810.iso'"
declare size_in_mb=3600
declare ctrl_type1='sata'
declare ctrl_type2='ide'
declare ctrlr_name1='satacontroller'
declare ctrlr_name2='idecontroller'
declare memory_mb=1280

VBoxManage createvm --name ${vm_name} --register

VBoxManage createhd --filename "/Users/MinSuSong/VirtualBox VMs/WordPress"/${vm_name}.vdi \
                    --size ${size_in_mb} -variant Standard

VBoxManage storagectl ${vm_name} --name ${ctrlr_name1} --add ${ctrl_type1} --bootable on
VBoxManage storagectl ${vm_name} --name ${ctrlr_name2} --add ${ctrl_type2} --bootable on

#Attaching Installation ISO
# VBoxManage storageattach ${vm_name} \
#             --storagectl ${ctrlr_name1} \
#             --port 00 \
#             --device 00 \
#             --type dvddrive \
#             --medium ${iso_file_path}

#Attaching VirtualBox Guest Additions ISO file
# VBoxManage storageattach ${vm_name} \
#             --storagectl ${ctrlr_name2} \
#             --port 01 \
#             --device 01 \
#             --type dvddrive \
#             --medium "/Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso"

# Attaching hard disk and specify it's an SSD
# VBoxManage storageattach ${vm_name} \
#             --storagectl ${ctrlr_name2} \
#             --port 01 \
#             --device 01 \
#             --type hdd \
#             --medium "/Users/MinSuSong/VirtualBox VMs/WordPress"/${vm_name}.vdi \
#             --nonrotational on

VBoxManage modifyvm ${vm_name}\
            --groups ""\
            --macaddress1 "020000000001"\
            --ostype "RedHat_64"\
            --cpus 1\
            --hwvirtex on\
            --nestedpaging on\
            --largepages on\
            --firmware bios\
            --nic1 natnetwork\
            --nat-network1 "${network_name}"\
            --cableconnected1 on\
            --audio none\
            --boot1 disk\
            --boot2 net\
            --boot3 none\
            --boot4 none\
            --memory ${memory_mb}

# VBoxManage startvm "acit_4640_pxe" --type gui
VBoxManage startvm ${vm_name} --type gui

ssh pxe 'sudo chown -R admin:wheel /usr/share/nginx'
scp /Users/MinSuSong/ACIT4640/deliverables/kickstart/wp_ks.cfg pxe:/usr/share/nginx/html/
scp -r /Users/MinSuSong/ACIT4640/setup root@pxe:/usr/share/nginx/html
ssh pxe 'sudo chown -R nginx:wheel /usr/share/nginx'
ssh pxe 'sudo chown nginx:wheel /usr/share/nginx/html/wp_ks.cfg'
ssh pxe 'chmod ugo+r /usr/share/nginx/html/wp_ks.cfg'
ssh pxe 'chmod ugo+rx /usr/share/nginx/html/setup'
ssh pxe 'chmod -R ugo+r /usr/share/nginx/html/setup/*'

until [[ $(ssh -q wp exit && echo "online") == "online" ]] ; do
  sleep 10s
  echo "waiting for wp vm to come online"
done