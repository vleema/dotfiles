#!/bin/sh

# This script reads package names from an input file passed 
# as an argument in the command line,
# and check if the packages in the file list are available
# either in the main repository or as a AUR package.
# The result "PACMAN" or "AUR" is sent to the standard output.
# In the input file, the packages must come one per line.


# Check if the package list file is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <package_list_file>"
    exit 1
fi

# Assign the package list file from the command-line argument
pkg_list_file="$1"

# Check if the package list file exists
if [ ! -f "$pkg_list_file" ]; then
    echo "Error: Package list file '$pkg_list_file' not found."
    exit 1
fi


# Open a new file descriptor (FD) for the "Querying package" messages
exec 3>&1

# Loop through each line in the package list file
while IFS= read -r package; do
    # Print the "Querying package" message to standard output
    echo "Querying package: $package" >&3

    # Search for the package
    if pacman -Ssq "$package" >/dev/null; then
        # Package is available in the main repositories
        echo "$package, PACMAN"
    else
        # Package is available in AUR
        echo "$package, AUR"
    fi
done < "$pkg_list_file" > output.txt

# Close the file descriptor
exec 3>&-
