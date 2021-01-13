This is the closest one I have seen. But he used the original nasm assembly to generate the boot part of the program, the kernel used rust, but compiled to `staticlib`, and then used `ld` for linking instead of `lld`，and additionally used gnu mtools.

 I want to imitate [this project](https://os.phil-opp.com/) and divide the code into two parts: bootloader and kernel. I made the following changes to the project, but it didn’t work as expected:

`.cargo/config `

```toml
....

+ [unstable]
+ build-std = ["core", "compiler_builtins"]
+ build-std-features = ["compiler-builtins-mem"]
```

`src/lib.rs  -> src/main.rs`


```rust
#![no_std]
#![feature(asm)]
- #![feature(start)]
+ #![no_main]

....

#[no_mangle]
- #[start]
pub extern "C" fn haribote_os() -> ! {
    
....

```

`Cargo.toml`

```toml
- [lib]
- name = "haribote_os"
- crate-type = ["staticlib"]
```

`kernel.ld`

```link
....

- OUTPUT_FORMAT("binary")
+ /* OUTPUT_FORMAT("binary") */

....

- /DISCARD/ : {*(*)}
+ /*  /DISCARD/ : {*(*)}  */
}
```

`i686-haribote.json`

```
- "features": "",
+ "features": "-mmx,-sse,+soft-float",

....

- "code-model": "kernel",
- "relocation-model": "static",
- "archive-format": "gnu",
- "target-env": "gnu",
- "linker-flavor": "ld",
- "linker-is-gnu": true,

+ "linker-flavor": "ld.lld",
+ "linker": "rust-lld",
+ "pre-link-args": {
+     "ld.lld": ["--script=kernel.ld"]
+ },
+ "panic-strategy": "abort",
+ "executables": true
    
```

