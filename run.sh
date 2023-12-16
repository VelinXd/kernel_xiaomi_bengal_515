#!/bin/bash

# --------------------------------------------
#    KernelBuilder V1.0
# --------------------------------------------
# by eraselk

TIMESTAMP=$(date +"%Y%m%d")
DATES=$(date +"%Y-%m-%d")
FW=RUI1
CHAT_ID=-1002113758146
BOT_TOKEN=6879942354:AAEwmBXT4NvLWj1h8BmfgoQltrrNH8Ebbx4
nama_kernel=VelinMz
# ketik /id di grup
TOKEN_BOT=6879942354:AAEwmBXT4NvLWj1h8BmfgoQltrrNH8Ebbx4
curl -X POST --silent --output /dev/null https://api.telegram.org/bot${BOT_TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d text="|| Starting cloning Velin Master ||"
sleep 10s
# Package
sudo apt update -y && sudo apt upgrade -y && sudo apt install nano bc bison ca-certificates curl flex gcc git libc6-dev libssl-dev openssl python-is-python3 ssh wget zip zstd make clang gcc-arm-linux-gnueabi software-properties-common build-essential libarchive-tools gcc-aarch64-linux-gnu -y && sudo apt install build-essential -y && sudo apt install libssl-dev libffi-dev libncurses5-dev zlib1g zlib1g-dev libreadline-dev libbz2-dev libsqlite3-dev make gcc -y && sudo apt install pigz -y && sudo apt install python2 -y && sudo apt install python3 -y
# Clone
git clone --depth=1 https://github.com/nibaji/DragonTC-9.0 clang # you can also change this clang.
git clone https://github.com/Sepatu-Bot/arm64-gcc gcc64
git clone https://github.com/Sepatu-Bot/gcc-arm gcc32
git clone --depth=1 https://github.com/eraselk/Anykernel3 anykernel
# KSU (KernelSU). 0= No. 1= Yes.
KSU=1

# Function
if [[ $KSU == "1" ]]; then
curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -
fi 
git clone --depth=1 https://github.com/EternalX-project/aarch64-linux-gnu.git gcc64
git clone --depth=1 https://github.com/EternalX-project/arm-linux-gnueabi.git gcc32

#endfunc
#permission
find . -type f -exec chmod 777 {} +
#
sleep 10s
curl -X POST --silent --output /dev/null https://api.telegram.org/bot${BOT_TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d text="|| Build Started ||"
# compile
export KBUILD_BUILD_USER="velin-master"
export KBUILD_BUILD_HOST="android-builds"

make O=out ARCH=arm64 #your defconfig here.
PATH="${PWD}/clang/bin:${PATH}:${PWD}/gcc32/bin:${PATH}:${PWD}/gcc64/bin:${PATH}" \
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC="clang" \
                      CROSS_COMPILE="${PWD}/gcc64/bin/aarch64-linux-gnu-" \
                      CROSS_COMPILE_ARM32="${PWD}/gcc32/bin/arm-linux-gnueabi-" \
                      CONFIG_NO_ERROR_ON_MISMATCH=y \
                      CONFIG_DEBUG_SECTION_MISMATCH=y \
V=0 2>&1 | tee log.txt

if [[ -f "out/arch/arm64/boot/Image.gz-dtb" ]]; then
curl -X POST --silent --output /dev/null https://api.telegram.org/bot${BOT_TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d text="|| Kernel Build Success!, Zipping Kernel... ||"
cp ${PWD}/out/arch/arm64/boot/Image.gz-dtb ${PWD}/anykernel
    # Zip the kernel
    cd ${PWD}/anykernel
    zip -r9 "${nama_kernel}-${TIMESTAMP}-${FW}".zip * -x .git README.md *placeholder
    cd ..
    # make zip directory
    mkdir -p zipd
    mv ${PWD}/anykernel/YOURKERNELNAME-${TIMESTAMP}-${FW}.zip ${PWD}/zipd
curl -F chat_id=${CHATID} -F document=@${PWD}/zipd/${nama_kernel}-${TIMESTAMP}-${FW}.zip -F caption="Zipping Kernel Done || Build Date: ${DATES}" "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument"
curl -F chat_id=${CHAT_ID} -F document=@${PWD}/log.txt -F caption="Build Log" "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument"
exit 1
else
echo "Kernel doesn't Compiled 100%"
curl -X POST --silent --output /dev/null https://api.telegram.org/bot${BOT_TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d text="|| @- KERNEL BUILD FAILED!"
sleep 4s
curl -F chat_id=${CHAT_ID} -F document=@${PWD}/log.txt -F caption="Build Log" "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument"
# exit with error, why?. because the server will turn off.
exit 1
fi
