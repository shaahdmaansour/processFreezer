#!/bin/bash

echo "Building xv6 with ptree system call..."
cd /mnt/Primary/UNI/xv6/xv6-labs-2024
make clean > /dev/null 2>&1
make > /dev/null 2>&1

echo "Starting xv6..."
echo "You can now test the ptree system call with these commands:"
echo "  ptree           - Basic process tree"
echo "  ptree_linear    - Linear chain of processes" 
echo "  ptree_binary    - Binary tree structure"
echo "  ptree_wide      - Wide tree with many siblings"
echo "  ptree_mixed     - Mixed deep and wide tree"
echo ""
echo "Starting xv6 now..."

make qemu-nox
