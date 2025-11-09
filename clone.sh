#!/bin/bash

# Simple Kernel Cloning Script - OmKernel

cd /home/omrak325/KernelBuild || exit

# Clone Kernel Source
git clone https://github.com/karthik558/MsM-4.14-RyZeN- RyZeN

# Clone AnyKernel3 (for packaging)
git clone --depth=1 https://github.com/karthik558/AnyKernel3 AnyKernel

# Clone Clang Toolchain
git clone --depth=1 https://github.com/kdrag0n/proton-clang CLANG-13

# Start the build
bash run.sh
