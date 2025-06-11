; Spending a little time and then I acknowledge the running principle of this program.
; and I think it is essential to write it again by myself to better learn the x86 Assembly Programming.
; I will also reconstruct and write all the following labs myself.

; �����ұ���д�ĵ�һ�������򣬵�����һ�����磬����������治����д�ģ�������

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
        ; �ر�ע����ߣ�֮������Ҫ��DATA���뵽AX�У�
        ; ����Ϊx86ָ��涨��MOV���μĴ���(DS/CS/ES/SS)ֻ�ܴ�һ��ͨ�üĴ���(AX/.../BX��)
        ; ��������ֱ��ʹ��������
        ; AX��һ��16λ�Ĵ���
        MOV AX, SEG DATA
        MOV DS, AX
        MOV AL, [DD1]
        CMP AL, [DD1+1]
        ; ע���������ϸ�ڣ����AL > DD1 + 1, CF = 0 && ZF = 0
        ; AL = DD1 + 1, ZF = 1; AL < DD1 + 1, CF = 1 && ZF = 0
        ; ����JA����ת����Ϊ CF = 0 && ZF = 0
        JA AAA1
        MOV AL, [DD1+1]
AAA1:   CMP AL, [DD1+2]
        JA AAA2
        MOV AL, [DD1+2]
AAA2:   MOV [DD2], AL
        ; RET


        ; ���������ӣ���Ҳ������ķ��ˡ��ر�ע�⣡DOS�涨����02����ֵAL = DL��
        ; ����ʵ����AL��ֵ�ڵ�һ���ַ���ӡ��ᷢ���仯���������Ҫά��һ����ʱ�Ĵ����洢AL��ֵ�����ź����ӡ�ڶ����ַ����߱��ʲô��;ʹ�ã���ʵ����̫����
        MOV BL, AL
        ; ��AL�ĸ�/�� 4 λ�ֱ�ת���� ASCII Ȼ���ӡ
        ; ��4λ
        MOV AH, AL
        AND AH, 0F0h
        ; SHR ������д����1. Ĭ����1λ 2. ��һ���Ĵ�����ֵ���ݸ�����λ��������ֱ�Ӹ���������
        MOV CL, 4
        SHR AH, CL
        CALL PrintHexDigit

        ; ��4λ
        ; MOV AH, AL
        MOV AH, BL
        AND AH, 0Fh
        CALL PrintHexDigit

        ; ����
        ; 0Dh��ӦASCII�еĻس�
        ; 02h��ʾ�����һ���ַ�����׼���
        ;����������е���˼�ǣ�ִ���жϣ�����DOS��Ȼ�����һ���س���Ҳ����һ���ַ���
        MOV DL, 0Dh
        MOV AH, 02h
        INT 21h
        MOV DL, 0Ah
        INT 21h

        ; �������򣬷���dos
        MOV AH, 4ch
        INT 21h

MAIN    ENDP

; ����������ӳ���
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