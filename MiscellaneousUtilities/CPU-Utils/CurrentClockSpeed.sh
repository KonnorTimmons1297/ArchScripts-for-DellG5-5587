#! /bin/bash

cpupower frequency-info | grep "current CPU frequency" | grep "kernel"
