# processFreezer

This project extends the xv6 operating system with a process freezing mechanism that allows temporarily suspending and resuming processes. This feature is useful for process management, debugging, and system resource control.

## Features

- **Process Freezing**: Temporarily suspend a running process
- **Process Unfreezing**: Resume a previously frozen process
- **State Preservation**: Maintains process state and resources while frozen
- **Safe Process Management**: Prevents freezing of zombie or unused processes

## Implementation Details

### System Calls

Two new system calls have been added:

1. `freeze(pid)`: Freezes a process with the specified PID
   - Returns 0 on success, -1 on failure
   - Cannot freeze zombie or unused processes
   - Cannot freeze already frozen processes

2. `unfreeze(pid)`: Unfreezes a previously frozen process
   - Returns 0 on success, -1 on failure
   - Automatically wakes up sleeping processes when unfrozen

### Process Structure

The process structure (`struct proc`) has been extended with:
- `frozen`: A flag indicating whether the process is frozen (1) or not (0)

### Testing

A test program (`freezerTest.c`) is included to demonstrate the functionality:
- Creates a child process that continuously prints its status
- Freezes the child process
- Keeps it frozen for a period
- Unfreezes the process
- Terminates the child process

## Building and Running

1. Build xv6:
```bash
make qemu
```

2. Run the test program:
```bash
freezerTest
```

## Usage Example

```c
// Freeze a process
int result = freeze(pid);
if(result < 0) {
    // Handle error
}

// Unfreeze a process
result = unfreeze(pid);
if(result < 0) {
    // Handle error
}
```

## Implementation Notes

- The freezing mechanism is implemented at the kernel level
- Frozen processes maintain their state and resources
- The system ensures safe process state transitions
- Proper locking mechanisms are used to prevent race conditions

## Limitations

- Cannot freeze zombie or unused processes
- Cannot freeze already frozen processes
- Process must exist and be in a valid state for freezing/unfreezing

## Future Improvements

Potential areas for enhancement:
- Add support for freezing process groups
- Implement timeout mechanism for frozen processes
- Add system-wide freeze/unfreeze capabilities
- Enhance error reporting and status monitoring
