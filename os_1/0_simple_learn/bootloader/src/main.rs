#![feature(lang_items)]
#![feature(global_asm)]
#![feature(llvm_asm)]
#![no_std]
#![no_main]


use bootloader::bootinfo::{BootInfo, FrameRange};

global_asm!(include_str!("stage_1.s"));

mod boot_info;

#[panic_handler]
#[no_mangle]
pub fn panic(info: &PanicInfo) -> ! {
    loop {}
}

#[lang = "eh_personality"]
#[no_mangle]
pub extern "C" fn eh_personality() {
    loop {}
}

#[no_mangle]
pub extern "C" fn _Unwind_Resume() {
    loop {}
}