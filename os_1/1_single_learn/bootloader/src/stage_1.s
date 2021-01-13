.code16
.text
    jmp entry
 
    .byte 0x90
    .ascii "HELLOIPL"   # ブートセクタの名前
    .word 512       # 1セクタの大きさ
    .byte 1         # クラスタの大きさ
    .word 1         # FATがどこから始まるか
    .byte 2         # FATの個数
    .word 224       # ルートディレクトリのサイズ
    .word 2880      # このドライブの大きさ
    .byte 0xf0      # メディアのタイプ
    .word 9         # FAT領域の長さ
    .word 18        # 1トラックにいくつのセクタがあるか
    .word 2         # ヘッドの数
    .int 0          # 必ず0
    .int 2880       # ドライブのサイズ
    .byte 0, 0, 0x29
    .int 0xffffffff     # ボリュームシリアル番号
    .ascii "HELLO-OS   "    # ディスクの名前
    .ascii "FAT12   "   # フォーマットの名前
.skip 18, 0x00          # 18バイト空ける
 
# プログラム本体
entry:
    movw $0, %ax        # レジスタ初期化
    movw %ax, %ss
    movw $0x7c00, %sp
    movw %ax, %ds
    movw %ax, %es
     
    movw $msg, %si
putloop:
    movb (%si), %al
    addw $1, %si
    cmpb $0, %al
    je fin
    movb $0x0e, %ah     # 一文字表示BIOSコール
    movw $15, %bx       # カラーコード
    int $0x10       # ビデオBIOS呼び出し
    jmp putloop
fin:
    hlt
    jmp fin
 
.data
msg: .string "Hello, world!\n"