rm -rf build
mkdir -p build
cd build

# Install wabt
sudo apt-get install wabt

# Download wasi-sdk
export WASI_VERSION=12
export WASI_VERSION_FULL=${WASI_VERSION}.0
wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_VERSION}/wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz
tar xvf wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz

# Install wasi-sdk
export WASI_SDK_PATH=`pwd`/wasi-sdk-${WASI_VERSION_FULL}
CC="${WASI_SDK_PATH}/bin/clang --sysroot=${WASI_SDK_PATH}/share/wasi-sysroot"

# Generate main wasm file with allocator functions export
$CC ../main.c -o main.wasm

# Decompile main wasm file to c file
wasm2c main.wasm -o main.c

# Get dependencies
wget https://raw.githubusercontent.com/WebAssembly/wabt/1.0.24/wasm2c/wasm-rt.h
wget https://raw.githubusercontent.com/WebAssembly/wabt/1.0.24/wasm2c/wasm-rt-impl.h
wget https://raw.githubusercontent.com/WebAssembly/wabt/1.0.24/wasm2c/wasm-rt-impl.c

# Compile (error now)
clang -o main wasm-rt-impl.c ../wasi-impl.c main.c -I../
