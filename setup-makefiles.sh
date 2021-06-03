#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

export DEVICE=whyred
export VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Initialize the helper for device
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false

# Warning headers and guards
write_headers "${DEVICE}"

# The standard device blobs
write_makefiles "${MY_DIR}/proprietary-files.txt" true
write_makefiles "${MY_DIR}/proprietary-files-whyred.txt" true

printf "\n%s\n" "ifeq (\$(BOARD_HAVE_QCOM_FM),true)" >> "${PRODUCTMK}"
write_makefiles "${MY_DIR}/proprietary-files-fm.txt" true
echo "endif" >> "${PRODUCTMK}"

printf "\n%s\n" "ifeq (\$(BOARD_HAVE_IR),true)" >> "${PRODUCTMK}"
write_makefiles "${MY_DIR}/proprietary-files-ir.txt" true
echo "endif" >> "${PRODUCTMK}"

# Finish
write_footers
