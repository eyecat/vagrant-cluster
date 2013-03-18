#!/bin/sh

# start boxes sequentially to avoid vbox explosions
#vagrant up --no-provision

# but run provision tasks in parallel
multitail -l "vagrant provision master"  -l "vagrant provision slave1"

