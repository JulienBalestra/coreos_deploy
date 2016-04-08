data = {
    "MESSAGE",
    "MESSAGE_ID",
    "UNIT",
    "CODE_FILE",
    "CODE_FUNCTION",
    "CODE_LINE",
    "ERRNO",
    "INTERFACE",
    "PRIORITY",
    "RESULT",
    "SYSLOG_FACILITY",
    "SYSLOG_IDENTIFIER",
    "_BOOT_ID",
    "_CAP_EFFECTIVE",
    "_CMDLINE",
    "_COMM",
    "_EXE",
    "_GID",
    "_HOSTNAME",
    "_MACHINE_ID",
    "_PID",
    "_SELINUX_CONTEXT",
    "_SOURCE_MONOTONIC_TIMESTAMP",
    "_SOURCE_REALTIME_TIMESTAMP",
    "_SYSTEMD_CGROUP",
    "_SYSTEMD_SLICE",
    "_SYSTEMD_UNIT",
    "_TRANSPORT",
    "_UID",
    "__CURSOR",
    "__MONOTONIC_TIMESTAMP",
    "__REALTIME_TIMESTAMP",
    "INITRD_USEC",
    "KERNEL_USEC",
    "PACKAGE",
    "SYSLOG_PID",
    "USERSPACE_USEC",
    "EXIT_CODE",
    "EXIT_STATUS"
}

sorted_d = [k for k in data]
sorted_d.sort()

for i in sorted_d:
    new = "%s" % i
    new = new.lower()
    while new[0] == "_":
        new = new[1:]
    print "\"%s\" => \"%s\"" % (i, new)
