.model small, c
.stack 100h
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
    drawPoint proto, drawX: word, drawY: word
    xi dw 10
    yi dw 10
    xf dw 319
    yf dw 199

.code
main proc
    mov ax, @data
    mov ds, ax
    mov ax, 13h
    int 10h

    initialize
    invoke straightLine, xi, yi, xf, yf

    xor ax, ax
    int 16h
    mov ax, 03h
    int 10h
    mov ax, 4c00h
    int 21h
main endp 

 drawPoint proc, drawX: word, drawY: word
    push dx
    mov ax, 0a000h
    mov es, ax
    xor di, di
    mov ax, 320
    mov bx, drawY
    imul bx
    add ax, drawX
    mov di, ax
    mov al, 0fh
    stosb
    pop dx
    ret
    drawPoint endp
straightLine proc, x0: word, y0: word, x1: word, y1: word
local x: word, y: word, deltax: word, deltay: word, error: word, ystep:word, steep: word
mov ax, y1
sub ax, y0
mov bx, -1
.if sword ptr ax < 0 
    imul bx
.endif 
push ax ;abs(y1-y0)
mov ax, x1
sub ax, x0
mov bx, -1
.if sword ptr ax < 0 
    imul bx
.endif ;ax:abs(x1-x0)
pop bx
.if bx > ax
    mov steep, 1
.endif
.if steep == 1;xchg (x0, y0) xchg(x1, y1)
    mov ax, x0
    mov bx, y0
    mov x0, bx
    mov y0, ax
    mov ax, x1
    mov bx, y1
    mov x1, bx
    mov y1, ax
.endif
mov ax, x0
mov bx, x1
.if sword ptr ax > bx ;xchg (x0, x1) xchg (y0, y1)
    mov ax, x0
    mov bx, x1
    mov x0, bx
    mov x1, ax
    mov ax, y0
    mov bx, y1
    mov y0, bx
    mov y1, ax
.endif
mov ax, x1 ;int deltax := x0- x1
sub ax, x0
mov deltax, ax
xor dx, dx
mov bx, 2 ;error:=deltax/2
idiv bx
xor ah, ah
mov error, ax
mov ax, y1
sub ax, y0
mov bx, -1
.if sword ptr ax < 0 
    imul bx
.endif 
mov deltay ,ax
mov ax, y0
mov y, ax
mov ax, y0
mov bx, y1
cmp ax, bx
jge @f
    mov ystep, 1
    jmp endystep
@@:
    mov ystep, -1
endystep:
mov ax, ystep
mov dx, x0
.while sword ptr dx <= x1
    mov ax, y
    mov ax, dx
    mov ax, error
    mov ax, steep
    cmp ax, 1
    jne @f
        mov bx, y
        ; invoke drawPoint, y, dx
        mov ax, 0a000h
        mov es, ax
        xor di, di
        mov ax, 320
        mov bx, dx
        push dx
        imul bx
        add ax, y
        mov di, ax
        mov al, 0fh
        stosb
        pop dx
        jmp modifyerror
    @@:
        ; invoke drawPoint, dx, y
        push dx
        mov ax, 0a000h
        mov es, ax
        xor di, di
        mov ax, 320
        mov bx, y
        imul bx
        pop dx
        add ax, dx
        mov di, ax
        mov al, 0fh
        stosb

modifyerror:
    mov ax, error
    sub ax, deltay
    mov error, ax

    .if sword ptr ax < 0
        mov ax, y
        add ax, ystep
        mov y, ax
        mov ax, error
        add ax, deltax
        mov error, ax
    .endif
    mov ax, error
    inc dx
.endw
ret
straightLine endp
end main