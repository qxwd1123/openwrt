#!/bin/env bash

set -o pipefail

if [[ $# -eq 1 ]]; then
    local_branch=$(git branch --show-current)
    branch=$(git rev-parse --abbrev-ref remotes/origin/HEAD | sed -e "s/^origin\///")
    if [[ "${local_branch}" != "${branch}" ]]; then
        until git fetch origin "${branch}":"${branch}" -u --tags; do
            sleep 1
        done

        until git rebase "${branch}"; do
            sleep 1
        done
    else
        until git pull --rebase; do
            sleep 1
        done
    fi

    git submodule foreach git pull --rebase

    while IFS= read -r -d '' d; do
        pushd "$d" || exit
        local_branch=$(git branch --show-current)
        branch=$(git rev-parse --abbrev-ref remotes/origin/HEAD | sed -e "s/^origin\///")
        if [[ "${local_branch}" != "${branch}" ]]; then
            until git fetch origin "${branch}":"${branch}" -u --tags; do
                sleep 1
            done

            until git rebase "${branch}"; do
                sleep 1
            done
        else
            until git pull --rebase; do
                sleep 1
            done
        fi
        popd || exit
    done < <(find -L ./feeds -maxdepth 1 -mindepth 1 -type d ! \( -name '*tmp' -o -iname 'base' \) -print0)
fi

if [[ $1 == "k2p" ]]; then
    cp .config_k2p .config
else
    cp .config_x86 .config
fi

until ./scripts/feeds update -i; do
    sleep 1
done

until ./scripts/feeds install -a; do
    sleep 1
done

yes "" | make oldconfig

if [[ $# -eq 1 ]]; then
    (yes "" ||:) | make V=sc -j1 2>&1 | tee compile.log
else
    (yes "" ||:) | make V=sc -j8 2>&1 | tee compile.log
fi

if [[ $? -eq 0 ]] && [[ $1 == "x86" ]]; then
    rsync -e 'ssh -p11221' --progress -b --suffix ".$(date +'%Y%m%d%k%M')" ./bin/targets/x86/64/openwrt-x86-64-generic-rootfs.tar.gz root@zzdd.eu.org:/var/lib/vz/template/cache
    rsync -e 'ssh -p11221' --progress -b --suffix ".$(date +'%Y%m%d%k%M')" ./bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined.img.gz root@zzdd.eu.org:/var/lib/vz/template/iso
fi

if [[ $1 == "k2p" ]]; then
    cp .config .config_k2p
else
    cp .config .config_x86
fi

