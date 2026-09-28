#!/bin/sh
# Usage: ./lse-unpack.sh /path/to/tar/folder [target_dir]

# 1. Force PATH to look in /usr/local/lse/bin first
PATH=/usr/local/lse/bin:$PATH
export PATH

# Source directory containing archive files
SRC_DIR="$1"

# Target directory: default to /usr/local/lse or $2 if supplied
TARGET_DIR="${2:-/usr/local/lse}"

if [ -z "${SRC_DIR}" ]; then
    echo "Usage: $0 <source_folder> [target_folder]"
    echo "Example: $0 /usr/local/home/user/downloads /usr/local/lse"
    echo 
    echo "Make sure in the source_folder you only have lse archives,"
    echo "everything tar.gz,tar.Z will be un-packed."
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

# 2. Phase 1: Unpack gzip-*.tar first so GNU gzip lands in /usr/local/lse/bin
for gz_bootstrap in gzip-*.tar; do
    if [ -f "${gz_bootstrap}" ]; then
        echo "--> [Bootstrap Phase] Extracting raw gzip tar: ${gz_bootstrap}"
        (cd "${TARGET_DIR}" && tar xvf "${SRC_DIR}/${gz_bootstrap}")
    fi
done

# Ensure PATH hash is cleared so the shell finds the newly installed gzip
hash -r 2>/dev/null || rehash 2>/dev/null

# 3. Phase 2: Unpack all remaining archive files
for file in *; do
    # Skip if no matching files in directory
    if [ ! -f "${file}" ]; then
        continue
    fi

    # Skip gzip-*.tar since it was extracted in Phase 1
    case "${file}" in
        gzip-*.tar)
            continue
            ;;
    esac

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
