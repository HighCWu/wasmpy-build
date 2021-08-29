#include <stdlib.h>
#include "build/main.h"


void wasi_snapshot_preview1_proc_exit(u32 exit_code)
{
    exit(exit_code);
}

void (*Z_wasi_snapshot_preview1Z_proc_exitZ_vi)(u32) = &wasi_snapshot_preview1_proc_exit;
