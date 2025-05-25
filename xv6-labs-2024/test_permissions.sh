#!/bin/bash

# Test script for XV6 chmod implementation and default permissions
echo "Testing XV6 chmod implementation and default file permissions..."
echo

cd /mnt/Primary/UNI/xv6/xv6-labs-2024

# Create a test input file
cat > xv6_test_input.txt << 'EOF'
echo "=== Testing default file permissions ==="
echo hello world > testfile
ls -l testfile 2>/dev/null || ls testfile
echo

echo "=== Testing chmod functionality ==="
chmod 755 testfile
ls -l testfile 2>/dev/null || ls testfile
echo

chmod 644 testfile  
ls -l testfile 2>/dev/null || ls testfile
echo

chmod 600 testfile
ls -l testfile 2>/dev/null || ls testfile
echo

echo "=== Testing directory permissions ==="
mkdir testdir
ls -l testdir 2>/dev/null || ls testdir
echo

chmod 755 testdir
ls -l testdir 2>/dev/null || ls testdir
echo

chmod 700 testdir
ls -l testdir 2>/dev/null || ls testdir
echo

echo "=== Testing device files ==="
ls -l console 2>/dev/null || ls console
echo

echo "=== Final directory listing ==="
ls
echo

echo "=== Test completed ==="
EOF

echo "Created test input file. Now running XV6 with test input..."
echo

# Run XV6 with the test input
timeout 30s qemu-system-riscv64 -machine virt -bios none -kernel kernel/kernel -m 128M -smp 3 -nographic -global virtio-mmio.force-legacy=false -drive file=fs.img,if=none,format=raw,id=x0 -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0 < xv6_test_input.txt

echo
echo "Test completed!"
