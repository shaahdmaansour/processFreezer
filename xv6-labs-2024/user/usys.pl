#!/usr/bin/perl -w

# Generate usys.S, the stubs for syscalls.

print "# generated by usys.pl - do not edit\n";

print "#include \"kernel/syscall.h\"\n";

sub entry {
    my $n = shift;
    print ".global $n\n";
    print "${n}:\n";
    print " li a7, SYS_${n}\n";
    print " ecall\n";
    print " ret\n";
}

entry("fork");
entry("exit");
entry("wait");
entry("pipe");
entry("read");
entry("kill");
entry("exec");
entry("fstat");
entry("chdir");
entry("dup");
entry("getpid");
entry("sbrk");
entry("sleep");
entry("uptime");
entry("open");
entry("write");
entry("mknod");
entry("unlink");
entry("link");
entry("mkdir");
entry("close");
entry("freeze");
entry("unfreeze");
