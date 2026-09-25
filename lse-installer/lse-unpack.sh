#!/bin/sh
# Usage: ./lse-unpack.sh /path/to/tar/folder [target_dir]

# Source directory containing archive files
SRC_DIR="$1"

# Target directory: default to /usr/local/lse or $2 if supplied
TARGET_DIR="${2:-/usr/local/lse}"

if [ -z "${SRC_DIR}" ]; then
    echo "Usage: $0 <source_folder> [target_folder]"
    echo "Example: $0 /usr/local/home/luis/archive /usr/local/lse/src"
    exit 1
fi

if [ ! -d "${SRC_DIR}" ]; then
    echo "Error: Source directory '${SRC_DIR}' does not exist."
    exit 1
fi

# Ensure destination directory exists
if [ ! -d "${TARGET_DIR}" ]; then
    echo "Creating target directory: ${TARGET_DIR}"
    mkdir -p "${TARGET_DIR}" || exit 1
fi

echo "=================================================="
echo " Unpacking archives from : ${SRC_DIR}"
echo " Into target directory   : ${TARGET_DIR}"
echo "=================================================="

cd "${SRC_DIR}" || exit 1

for file in *; do
    # Skip if no matching files in directory
    if [ ! -f "${file}" ]; then
        continue
    fi

    case "${file}" in
        *.tar.gz|*.tgz)
            echo "--> Extracting gzipped tar: ${file}"
            gzip -dc "${file}" | (cd "${TARGET_DIR}" && tar xvf -)
            ;;
        *.tar.Z)
            echo "--> Extracting compressed tar: ${file}"
            compress -dc "${file}" | (cd "${TARGET_DIR}" && tar xvf -)
            ;;
        *.tar)
            echo "--> Extracting raw tar: ${file}"
            (cd "${TARGET_DIR}" && tar xvf "${SRC_DIR}/${file}")
            ;;
        *)
            echo "--> Skipping non-tar file: ${file}"
            ;;
    esac
done

echo "=================================================="
echo " Unpacking completed successfully."
echo "=================================================="
