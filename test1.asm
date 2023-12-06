;\*Bresenham straightline*/
.model small, c
.stack 100h
.586
.data
    initialize macro
        mov ax, 0a000h
        mov es, ax
        xor di, di
        xor al, al
        mov cx, 320 * 200
        rep stosb
    endm
    straightLine proto, x0: word, y0: word, x1: word, y1: word
xi dw 0
yi dw 199
xf dw 160
yf dw 100

.code
main proc
    mov ax, @data
    mov ds, ax
    mov ax, 13h
    int 10h

    ; initialize
    invoke straightLine, 90,10, 160, 101
    invoke straightLine, 10,190, 160, 102
    invoke straightLine, 310,10, 160, 101
    invoke straightLine, 310,190, 160, 101
    xor ax, ax
    int 16h
    mov ax, 03h
    int 10h
    mov ax, 4c00h
    int 21h
main endp 

straightLine proc, x0: word, y0: word, x1: word, y1: word
local sx: word, sy: word, error: word, deltax: word, deltay: word, e2: word, canvasWidth: word
    mov ax, 320
    mov canvasWidth, ax 
    mov ax, x1
    sub ax, x0
    mov deltax, ax
    sar ax, 15
    xor deltax, ax
    mov ax, x0
    .if ax < x1
        mov sx, 1
    .else
        mov sx, -1
    .endif
    mov ax, y1
    sub ax, y0
    mov deltay, ax
    sar ax, 15
    xor deltay, ax
    neg deltay
    mov ax, y0
    .if ax < y1
        mov sy, 320
    .else
        mov sy, -320
    .endif
    mov ax, deltax
    add ax, deltay
    mov error, ax
    mov ax, 0a000h
    mov es, ax
    xor dx, dx
    mov ax, 320
    mul y0
    add ax, x0
    mov di, ax
    .while 1
        mov al, 0fh
        mov es:[di], al
        mov ax, x0
        mov bx, y0
        .break .if ax == x1 && bx == y1
        mov ax, error
        add ax, ax
        mov e2, ax
        .if  sword ptr ax >= deltay
            mov ax, x0
            .break .if ax == x1
            mov ax, deltay
            add error, ax
            mov ax, sx
            add x0, ax
            add di, sx
        .endif
        mov ax, e2
        .if sword ptr ax <= deltax
            mov ax, y0
            .break .if ax == y1
            mov ax, deltax
            add error, ax
            mov ax, sy
            add y0, ax
            xor dx, dx
            imul canvasWidth
            add di, ax
        .endif
    .endw
ret
straightLine endp



end main
