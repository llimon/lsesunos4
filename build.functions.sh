#!/bin/sh

. /home/luis/source/build.vars.sh


if [ ! -d "${stagedir}" ]; then
  mkdir -p "${stagedir}"
  if [ ! -d "${stagedir}" ]; then
      echo "Error: Directory '${stagedir}' does not exist." >&2
      exit 1
  fi
fi

if [ -z "${prefix}" ] || [ -z "${distdir}" ] || [ -z "${app}" ] || \
   [ -z "${release}" ] || [ -z "${osversion}" ] || [ -z "${osname}" ]; then
  echo "Error: Required variable is empty." >&2
  exit 1
fi

# Ensure stagedir starts with /
if [ "`expr "${stagedir}" : '/.*'`" -eq 0 ]; then
  echo "Error: stagedir [${stagedir}] is not an absolute path." >&2
  exit 1
fi

export CPPFLAGS="-I/usr/local/lse/include"
export LDFLAGS="-L/usr/local/lse/lib"

src_folder="${app}-${release}"
if [[ -n "${custom_src_folder}" ]]; then
   src_folder="${custom_src_folder}"
fi

clean_stage() {
        saved_dir=`pwd`
        
        cd "${stagedir}" && rm -rf usr && echo "Done Clearing stage" || {
                echo "ERROR: Failed to clear stage directory!"
                exit 1
        }
        
        cd "${saved_dir}"
}

generic_clean(){
	rm -r -f "${builddir}/${src_folder}" || exit 1
}

generic_prep(){

        mkdir -p "${builddir}"
        if [ -d "${builddir}/${src_folder}" ]; then
                echo "Removing previous build..."
                generic_clean
        fi
        cd  "${builddir}" || exit 1
        gzip -d -c "${srcfiles}/${app}-${release}.tar.gz" | tar -xvf -

        # Enter directory before applying patches
        cd "${builddir}/${src_folder}" || exit 1

        # Apply patches if defined
        if [ -n "$(declare -p patches 2>/dev/null | grep 'declare -a')" ] && [ ${#patches[@]} -gt 0 ]; then
                for i in "${!patches[@]}"; do
                        patch_src="${patches[$i]}"
                        echo "Applying patch $i: ${patch_src}"

                        case "${patch_src}" in
                                *.gz) pipecmd="gzip -d -c" ;;
                                *.Z)  pipecmd="zcat" ;;
                                *)    pipecmd="cat" ;;
                        esac

                        # Stream directly into patch - no eval, no hang
                        ${pipecmd} "${srcfiles}/${patch_src}" | patch -p1
                done
        fi

        # Fix permissions and timestamps
        chmod -R u+w .
        find . -print | xargs touch

        # Return to working root
        cd "${builddir}"
}

generic_build(){
    local sub_dir="${1:-.}"

    cd "${builddir}/${src_folder}/${sub_dir}" || exit 1

    ./configure --prefix="${prefix}"

    make
}


generic_install(){
    local sub_dir="${1:-.}"

    clean_stage
    echo "creating ${stagedir}${prefix}"
    mkdir -p ${stagedir}${prefix}

    cd "${builddir}/${src_folder}/${sub_dir}" || exit 1


    # Install into the temporary staging area using the locally built binary
    make install prefix="${stagedir}${prefix}" 
}

generic_pack(){
    local sub_dir="${1:-.}"

    mkdir -p "${distdir}"
    
    # 1. Debug listing of what we are packaging
    ls -al "${stagedir}${prefix}/${sub_dir}"
    
    # 2. Step out ONE level higher than the prefix directory
    # If ${prefix} is "/usr/local/lse", this steps into "/usr/local/stage/usr/local"
    (
        cd "${stagedir}${prefix}/.." || exit 1
        echo "running tar starting from the ${distribution} folder"
        
        # Archive the actual folder name instead of ./*
        tar -cvf "${distdir}/${app}-${release}-${osversion}.tar" "${distribution}"
    )
    
    pwd
    gzip -f "${distdir}/${app}-${release}-${osversion}.tar"
    sleep 1
    ls -al "${distdir}/${app}-${release}-${osversion}.tar.gz"
}


param_router() {
 if [ -z "$1" ]; then
    echo "Error: syntax $0 <param> : build, install, clean, pack"
 fi 
 case "$1" in
    build)
        build
        ;;
    install)
        install
        ;;
    clean)
        clean
	;;
    prep)
        prep 
        ;;
    pack)
        pack
        ;;
    *)
        echo "Error: Unknown command '$1'" >&2
        usage
        ;;
 esac
}	
