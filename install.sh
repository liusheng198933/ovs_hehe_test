#!/bin/bash

# shut down openvswitch service
input="/home/shengliu/Workspace/mininet/causalSDN/in.txt"
ps aux | grep ovs-vswitchd | grep root | awk '{print $2}'>"$input"
ps aux | grep ovsdb-server | grep root | awk '{print $2}'>>"$input"
while IFS= read -r var; do sudo kill -9 $var; done < "$input"

# install
./boot.sh
./configure --enable-Werror
make
make install

# init database
export PATH=$PATH:/usr/local/share/openvswitch/scripts
ovs-ctl start
sudo mkdir -p /usr/local/var/run/openvswitch
sudo ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \
                     --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
                     --private-key=db:Open_vSwitch,SSL,private_key \
                     --certificate=db:Open_vSwitch,SSL,certificate \
                     --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
                     --pidfile --detach
sudo ovs-vsctl --no-wait init
sudo ovs-vswitchd --pidfile --detach
