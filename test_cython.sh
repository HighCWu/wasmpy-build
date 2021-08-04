sudo apt-get install wabt
pip3 install Cython wasmpy-build

# Get the emsdk repo
git clone https://github.com/emscripten-core/emsdk.git

# Enter that directory
cd emsdk

# Fetch the latest version of the emsdk (not needed the first time you clone)
git pull

# Download and install the latest SDK tools.
./emsdk install latest

# Make the "latest" SDK "active" for the current user. (writes .emscripten file)
./emsdk activate latest

# Activate PATH and other environment variables in the current terminal
source ./emsdk_env.sh

cd ../

cython -X language_level=3 add.py

python3 -m wasmpy_build -o add_wasm.wasm add.c

wasm2c add_wasm.wasm -o add_wasm.c

clang -shared -pthread -fPIC -fwrapv -O2 -Wall -fno-strict-aliasing \
      -I/usr/include/python3.8 -o add_wasm.cpython-38m-x86_64-linux-gnu.so add_wasm.c

python3 call_pyd.py
