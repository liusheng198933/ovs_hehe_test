#!/bin/bash

ovs-vsctl --verbose --log-file=/home/shengliu/Workspace/log/log.txt add-br br0 -- set Bridge br0 fail-mode=secure
for i in 1 2 3 4; do
    ovs-vsctl add-port br0 p$i -- set Interface p$i ofport_request=$i
    ovs-ofctl mod-port br0 p$i up
done
ovs-ofctl add-flow br0 \
   "table=0, dl_src=01:00:00:00:00:00/01:00:00:00:00:00, actions=drop"
ovs-ofctl add-flow br0 "table=0, priority=0, actions=resubmit(,1)"
