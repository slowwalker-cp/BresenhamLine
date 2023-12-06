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
xi dw 219
yi dw 99
xf dw 50
yf dw 50

.code
main proc
    mov ax, @data
    mov ds, ax
    mov ax, 13h
    int 10h

    ; initialize
    invoke straightLine, xi, yi, xf, yf
    xor ax, ax
    int 16h
    mov ax, 03h
    int 10h
    mov ax, 4c00h
    int 21h
main endp 

straightLine proc, x0: word, y0: word, x1: word, y1: word
    local sx: word, sy: word, error: word, deltax: word, deltay: word, e2: word 
    mov ax, x1
    sub ax, x0
    mov deltax, ax
    .if sword ptr ax < 0
        neg deltax
    .endif
    mov ax, x0
    .if ax < x1
        mov sx, 1
    .else 
        mov sx, -1
    .endif
    mov ax, y1
    sub ax, y0
    mov deltay, ax
    .if sword ptr ax > 0
        neg deltay
    .endif
    mov ax, y0
    .if sword ptr ax < y1
        mov sy, 1
    .else
        mov sy, -1
    .endif
    mov ax, deltax
    add ax, deltay
    mov error, ax
    mov ax, 0a000h
    mov es, ax
    xor di, di
    xor dx, dx
    mov ax, y0
    mov bx, 320
    mul bx
    add ax, x0
    mov di, ax
    .while 1
        mov al, 0fh
        stosb
        mov ax, x0
        mov bx, y0
        .if ax == x1 && bx == y1 
            .break 
        .endif
        mov ax, error
        mov e2, ax
        sal e2, 1
        mov ax, e2
        .if  sword ptr ax >= deltay
            mov ax, x0
            .if ax == x1
                .break
            .endif
            mov ax, error
            add ax, deltay
            mov error, ax
            mov ax, x0
            add ax, sx
            mov x0, ax
            mov ax, sx
            add di, ax
        .endif
        mov ax, e2
        .if sword ptr ax <= deltax
            mov ax, y0
            .if ax == y1
                .break
            .endif
            mov ax, error
            add ax, deltax
            mov error, ax
            mov ax, y0 
            add ax, sy
            mov y0, ax
            mov ax, sy
            xor dx, dx
            mov bx, 320
            mul bx
            add di, ax
        .endif
    .endw
ret
straightLine endp



end main