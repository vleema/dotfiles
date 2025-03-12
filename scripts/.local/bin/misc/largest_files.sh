#!/bin/sh
#
#   This little script list the N largest files for a given directory.
#
function usage {
  eval msg="$1"
  echo 'Error:' "${msg}" >&2
  printf "Usage: largest-files <dir> [<how-many>]\n"
  printf "   <dir>        The directory where the search is done.\n"
  printf "   <how-many>   How many files to show (default is 5).\n"
  exit 1  # abort.
}

printf "This script lists the first N (default is 5) largest files from a target directory.\n"
printf "Examining source directory, please wait...\n\n"


# This is the directory we need to investigate.
SOURCE_DIR=$1
# Number of entries to list
N_ENTRIES=5  # Default value for how many files to list.

# [1] Let us test if we've got a directory to inspect.
if [ -z $1 ]; then
  MSG='missing source directory!'
  usage "\${MSG}"
fi

# [2] Let us test if this directory exists
if ! [ -d $SOURCE_DIR ] || [ -h $SOURCE_DIR ]; then
  MSG='invalid or non-existing source directory "'$SOURCE_DIR'"!'
  usage "\${MSG}"
fi

# [3] Let us test if we've got a third argument: the number of files to list.
if ! [[ -z $2 ]]; then # we have an argument, need to test if it's a valid one.
  re='^[0-9]+$' # Regex for an integer.
  # Test if we've got a integer
  if ! [[ $2 =~ $re ]] ; then
     echo "------------------------------------------------"
     echo "Warning: the second argument is not a number" >&2
     echo 'Keeping default value of' $N_ENTRIES
     echo "------------------------------------------------"
  else
    N_ENTRIES=$2 # Accept the 3rd argument as the number of entries to list.
  fi
fi

# Finally, the central command.
find $SOURCE_DIR -type f -exec du -sh {} \; |sort -rh|head -$N_ENTRIES
