这个是我看到的最接近的一个。但是他使用了原始的nasm汇编生成引导部分程序，kernel使用rust，但是编译到`staticlib`，再使用`ld`进行链接而不是`lld`，再额外使用了gnu mtools。

我想模仿[这个工程](https://os.phil-opp.com/)，将代码分为bootloader和kernel两部分，我对工程做了如下修改，但是不能如愿运行：

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

