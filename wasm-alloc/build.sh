rm -rf build
mkdir -p build
cd build

# Install wabt
sudo apt-get install wabt binaryen

# Download wasi-sdk
export WASI_VERSION=12
export WASI_VERSION_FULL=${WASI_VERSION}.0
wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_VERSION}/wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz
tar xvf wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz

# Install wasi-sdk
export WASI_SDK_PATH=`pwd`/wasi-sdk-${WASI_VERSION_FULL}
CC="${WASI_SDK_PATH}/bin/clang --sysroot=${WASI_SDK_PATH}/share/wasi-sysroot"

# Generate main wasm file with allocator functions export
$CC ../placeholder.c -o alloc.wasm -Wl,--export=malloc -Wl,--export=calloc -Wl,--export=realloc -Wl,--export=free

# Decompile main wasm file to wat file
wasm2wat alloc.wasm -o alloc.wat

cd ..

# Simplify wat file
python simplify.py

# Compile wat file to wasm file
wat2wasm alloc.wat -o alloc.wasm

# Optimize wasm file
wasm-opt alloc.wasm -O3 -o alloc.wasm

# Save new decompiled `wasm to wat` file
wasm2wat alloc.wasm -o alloc.wat
