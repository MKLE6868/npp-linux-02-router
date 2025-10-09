#!/bin/bash

# This setup script configures IP addresses on all nodes for the mod2-bgp
# topology.  It mirrors the original demo2-bgp setup, but adds IP addresses
# on rtrB eth3 and rtrC eth3 to support the new link between B and C.  Use
# `create` to apply the configuration and `delete` to remove it.

lan1="docker exec -it  clab-mod2-bgp-lan1"
lan2="docker exec -it  clab-mod2-bgp-lan2"
rtrA="docker exec -it  clab-mod2-bgp-rtrA"
rtrB="docker exec -it  clab-mod2-bgp-rtrB"
rtrC="docker exec -it  clab-mod2-bgp-rtrC"
rtrD="docker exec -it  clab-mod2-bgp-rtrD"

create_setup() {
    echo 'creating setup'

    # Configure LAN interfaces and routes on lan1
    $lan1 ip addr add 10.10.0.2/24 dev eth1
    $lan1 ip addr add 1.1.1.1 dev eth1
    $lan1 ip addr add 3.3.3.3 dev eth1
    $lan1 ip route add 2.2.2.0/24 dev eth1 via 10.10.0.1
    $lan1 ip route add 4.4.4.0/24 dev eth1 via 10.10.0.1

    # Configure LAN interfaces and routes on lan2
    $lan2 ip addr add 10.10.5.2/24 dev eth1
    $lan2 ip addr add 2.2.2.2 dev eth1
    $lan2 ip addr add 4.4.4.4 dev eth1
    $lan2 ip route add 1.1.1.0/24 dev eth1 via 10.10.5.1
    $lan2 ip route add 3.3.3.0/24 dev eth1 via 10.10.5.1

    # Configure rtrA interfaces
    $rtrA ip addr add 10.10.0.1/30 dev eth1
    $rtrA ip addr add 10.10.1.1/30 dev eth2
    $rtrA ip addr add 10.10.2.1/30 dev eth3

    # Configure rtrB interfaces
    $rtrB ip addr add 10.10.1.2/30 dev eth1
    $rtrB ip addr add 10.10.3.1/30 dev eth2
    # New interface for B–C link
    $rtrB ip addr add rtrB:eth3 dev eth3

    # Configure rtrC interfaces
    $rtrC ip addr add 10.10.2.2/30 dev eth1
    $rtrC ip addr add 10.10.4.1/30 dev eth2
    # New interface for C–B link
    $rtrC ip addr add 10.10.6.1/30 dev eth3

    # Configure rtrD interfaces
    $rtrD ip addr add 10.10.5.1/30 dev eth1
    $rtrD ip addr add 10.10.3.2/30 dev eth2
    $rtrD ip addr add 10.10.4.2/30 dev eth3
}

delete_setup() {
    echo 'delete setup'

    # Remove LAN addresses
    $lan1 ip addr del 10.10.0.2/24 dev eth1
    $lan1 ip addr del 1.1.1.1 dev eth1
    $lan1 ip addr del 3.3.3.3 dev eth1
    # Not removing routes because they were commented out in the original script

    $lan2 ip addr del 10.10.5.2/24 dev eth1
    $lan2 ip addr del 2.2.2.2 dev eth1
    $lan2 ip addr del 4.4.4.4 dev eth1

    # Remove rtrA interfaces
    $rtrA ip addr del 10.10.0.1/30 dev eth1
    $rtrA ip addr del 10.10.1.1/30 dev eth2
    $rtrA ip addr del 10.10.2.1/30 dev eth3

    # Remove rtrB interfaces
    $rtrB ip addr del 10.10.1.2/30 dev eth1
    $rtrB ip addr del 10.10.3.1/30 dev eth2
    # Remove new B–C interface
    $rtrB ip addr del rtrB:eth3 dev eth3

    # Remove rtrC interfaces
    $rtrC ip addr del 10.10.2.2/30 dev eth1
    $rtrC ip addr del 10.10.4.1/30 dev eth2
    # Remove new C–B interface
    $rtrC ip addr del 10.10.6.1/30 dev eth3

    # Remove rtrD interfaces
    $rtrD ip addr del 10.10.5.1/30 dev eth1
    $rtrD ip addr del 10.10.3.2/30 dev eth2
    $rtrD ip addr del 10.10.4.2/30 dev eth3
}

if [ $# != 1 ]; then
    echo "specify delete or create"
elif [ "$1" == "delete" ]; then
    delete_setup
elif [ "$1" == "create" ]; then
    create_setup
else
    echo "specify delete or create"
fi
