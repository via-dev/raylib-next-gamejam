@echo off
if not exist docs mkdir docs

echo Building for WASM...

odin build src/game -target=freestanding_wasm32 -out:docs/game -build-mode:obj -show-system-calls -show-timings

set STACK_SIZE=1048576
set HEAP_SIZE=67108864
set c_files=src/web_release/main_wasm.c docs/game.wasm.o raylib/wasm/libraylib.a
set c_compile_flags=-sUSE_GLFW=3 -sGL_ENABLE_GET_PROC_ADDRESS -DWEB_BUILD -sSTACK_SIZE=%STACK_SIZE% -sALLOW_MEMORY_GROWTH -sERROR_ON_UNDEFINED_SYMBOLS=0 -sFORCE_FILESYSTEM -sEXIT_RUNTIME=1
set preload_files=--preload-file assets
emcc -o docs/index.html %c_files% %c_compile_flags% %preload_files%
