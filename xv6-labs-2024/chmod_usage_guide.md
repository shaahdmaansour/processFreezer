## XV6 chmod Complete Usage Guide

### 1. BASIC USAGE
chmod <permissions> <filename>

### 2. PERMISSION NUMBERS EXPLAINED
- First digit = Owner (user) permissions
- Second digit = Group permissions  
- Third digit = Others permissions

Each digit is the sum of:
- 4 = read (r)
- 2 = write (w)
- 1 = execute (x)

### 3. COMMON EXAMPLES

# Create a test file (gets default 644 permissions)
echo "Hello World" > myfile.txt
ls                          # Shows: -rw-r--r-- myfile.txt

# Make file executable by owner
chmod 755 myfile.txt
ls                          # Shows: -rwxr-xr-x myfile.txt

# Make file private (owner read/write only)
chmod 600 myfile.txt  
ls                          # Shows: -rw------- myfile.txt

# Make file read-only for everyone
chmod 444 myfile.txt
ls                          # Shows: -r--r--r-- myfile.txt

# Make file fully accessible to everyone
chmod 777 myfile.txt
ls                          # Shows: -rwxrwxrwx myfile.txt

# Create and modify directory permissions
mkdir testdir
ls                          # Shows: drwxr-xr-x testdir (default 755)

chmod 700 testdir           # Owner only access
ls                          # Shows: drwx------ testdir

chmod 755 testdir           # Restore normal directory permissions
ls                          # Shows: drwxr-xr-x testdir

### 4. PERMISSION REFERENCE CHART

| Octal | Binary | Permissions | Description |
|-------|--------|-------------|-------------|
| 0     | 000    | ---         | No permissions |
| 1     | 001    | --x         | Execute only |
| 2     | 010    | -w-         | Write only |
| 3     | 011    | -wx         | Write + Execute |
| 4     | 100    | r--         | Read only |
| 5     | 101    | r-x         | Read + Execute |
| 6     | 110    | rw-         | Read + Write |
| 7     | 111    | rwx         | Read + Write + Execute |

### 5. COMMON PERMISSION PATTERNS

644 = -rw-r--r--    # Standard file (owner: rw, others: r)
755 = -rwxr-xr-x    # Executable file (owner: rwx, others: rx)
600 = -rw-------    # Private file (owner: rw, others: none)
700 = -rwx------    # Private executable (owner: rwx, others: none)
666 = -rw-rw-rw-    # World writable file
777 = -rwxrwxrwx    # World writable executable

### 6. TESTING COMMANDS TO TRY

# Basic file operations
echo "test content" > file1.txt
echo "more content" > file2.txt
ls

# Test different permissions
chmod 644 file1.txt
chmod 755 file2.txt
ls

# Create directories
mkdir dir1
mkdir dir2
chmod 700 dir1
chmod 755 dir2
ls

# View device files
ls console              # Should show: crw-rw-rw- console

### 7. ERROR CHECKING
# Invalid permission (should show error)
chmod 888 file1.txt     # Invalid octal digit

# Invalid file (should show error)  
chmod 644 nonexistent   # File doesn't exist
