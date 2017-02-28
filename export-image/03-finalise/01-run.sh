#!/bin/bash -e

IMG_FILE="${STAGE_WORK_DIR}/${IMG_DATE}-${IMG_NAME}${IMG_SUFFIX}.img"

on_chroot << EOF
/etc/init.d/fake-hwclock stop
hardlink -t /usr/share/doc
EOF

if [ -d ${ROOTFS_DIR}/home/pi/.config ]; then
	chmod 700 ${ROOTFS_DIR}/home/pi/.config
fi
install -m 600 -o 1000 -g 1000 -D files/authorized_keys ${ROOTFS_DIR}/home/pi/.ssh/authorized_keys
install -m 700  -D files/pi-install-runner/pi-install-runner ${ROOTFS_DIR}/usr/sbin/pi-install-runner
install -m 700  -D "files/pi-install-runner/pi-install-local" "${ROOTFS_DIR}/usr/sbin/pi-install-local"
install -m 600  -D files/pi-install-runner_crontab ${ROOTFS_DIR}/etc/cron.d/pi-install-runner

rm -f ${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache
rm -f ${ROOTFS_DIR}/usr/sbin/policy-rc.d
rm -f ${ROOTFS_DIR}/usr/bin/qemu-arm-static
if [ -e ${ROOTFS_DIR}/etc/ld.so.preload.disabled ]; then
        mv ${ROOTFS_DIR}/etc/ld.so.preload.disabled ${ROOTFS_DIR}/etc/ld.so.preload
fi

update_issue $(basename ${EXPORT_DIR})
install -m 644 ${ROOTFS_DIR}/etc/rpi-issue ${ROOTFS_DIR}/boot/issue.txt
install files/LICENSE.oracle ${ROOTFS_DIR}/boot/

ROOT_DEV=$(mount | grep "${ROOTFS_DIR} " | cut -f1 -d' ')

unmount ${ROOTFS_DIR}
zerofree -v ${ROOT_DEV}

unmount_image ${IMG_FILE}

mkdir -p ${DEPLOY_DIR}

rm -f ${DEPLOY_DIR}/image_${IMG_DATE}-${IMG_NAME}${IMG_SUFFIX}.zip

echo zip ${DEPLOY_DIR}/image_${IMG_DATE}-${IMG_NAME}${IMG_SUFFIX}.zip ${IMG_FILE}
pushd ${STAGE_WORK_DIR} > /dev/null
zip ${DEPLOY_DIR}/image_${IMG_DATE}-${IMG_NAME}${IMG_SUFFIX}.zip $(basename ${IMG_FILE})
popd > /dev/null
