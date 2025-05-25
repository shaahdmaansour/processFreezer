#!/bin/bash

echo "Creating a simpler test for XV6 chmod..."
cd /mnt/Primary/UNI/xv6/xv6-labs-2024

# Create a simpler test input
cat > simple_test.txt << 'EOF'
echo hello > test.txt
ls
chmod 755 test.txt
ls
chmod 600 test.txt
ls
mkdir dir1
ls
chmod 700 dir1
ls
EOF

echo "Running simple test..."
timeout 15s qemu-system-riscv64 -machine virt -bios none -kernel kernel/kernel -m 128M -smp 3 -nographic -global virtio-mmio.force-legacy=false -drive file=fs.img,if=none,format=raw,id=x0 -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0 < simple_test.txt 2>/dev/null

echo "Test completed!"
