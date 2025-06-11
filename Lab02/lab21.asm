; Spending a little time and then I acknowledge the running principle of this program.
; and I think it is essential to write it again by myself to better learn the x86 Assembly Programming.
; I will also reconstruct and write all the following labs myself.

; 这是我本人写的第一个汇编程序，调了我一个下午，汇编这玩意真不是人写的，草你妈

DATA SEGMENT
DD1 DB 35H,76H,12H
DD2 DB '?'
DATA ENDS

CODE SEGMENT

MAIN PROC FAR

    ASSUME CS:CODE, DS:DATA

START:  PUSH DS
        SUB AX, AX
        PUSH AX
        ; 特别注意这边，之所以先要把DATA放入到AX中，
        ; 是因为x86指令集规定，MOV到段寄存器(DS/CS/ES/SS)只能从一个通用寄存器(AX/.../BX等)
        ; 而并不能直接使用立即数
        ; AX是一个16位寄存器
        MOV AX, SEG DATA
        MOV DS, AX
        MOV AL, [DD1]
        CMP AL, [DD1+1]
        ; 注意这里面的细节：如果AL > DD1 + 1, CF = 0 && ZF = 0
        ; AL = DD1 + 1, ZF = 1; AL < DD1 + 1, CF = 1 && ZF = 0
        ; 对于JA的跳转条件为 CF = 0 && ZF = 0
        JA AAA1
        MOV AL, [DD1+1]
AAA1:   CMP AL, [DD1+2]
        JA AAA2
        MOV AL, [DD1+2]
AAA2:   MOV [DD2], AL
        ; RET


        ; 这边真的贼坑，我也是他妈的服了。特别注意！DOS规定功能02返回值AL = DL，
        ; 所以实际上AL的值在第一个字符打印后会发生变化！！！因此要维护一个临时寄存器存储AL的值，留着后面打印第二个字符或者别的什么用途使用，这实在是太坑了
        MOV BL, AL
        ; 将AL的高/低 4 位分别转换成 ASCII 然后打印
        ; 高4位
        MOV AH, AL
        AND AH, 0F0h
        ; SHR 有两种写法：1. 默认移1位 2. 用一个寄存器的值传递给它移位，而不是直接给个常量；
        MOV CL, 4
        SHR AH, CL
        CALL PrintHexDigit

        ; 低4位
        ; MOV AH, AL
        MOV AH, BL
        AND AH, 0Fh
        CALL PrintHexDigit

        ; 换行
        ; 0Dh对应ASCII中的回车
        ; 02h表示“输出一个字符到标准输出
        ;这边下面三行的意思是：执行中断，调用DOS，然后输出一个回车（也就是一个字符）
        MOV DL, 0Dh
        MOV AH, 02h
        INT 21h
        MOV DL, 0Ah
        INT 21h

        ; 结束程序，返回dos
        MOV AH, 4ch
        INT 21h

MAIN    ENDP

; 下面这个是子程序
PrintHexDigit PROC NEAR
    CMP AH, 9
    JA LBL_ALPHA
    ADD AH, '0'
    JMP LBL_OUT
LBL_ALPHA:
    ADD AH, 'A' - 10
LBL_OUT:
    MOV DL, AH
    MOV AH, 02h
    INT 21h
    RET
PrintHexDigit ENDP

CODE    ENDS
        END START