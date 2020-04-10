%include "io.inc"

extern getAST
extern freeAST

struc myStruct 
    data:       resd 1
    leftChild:  resd 1
    rightChild: resd 1
endstruc
section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1

section .text
global main
main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp
    
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    mov [root], eax
    ; Implementati rezolvarea aici
    push eax
    call verifica_daca_e_semn
    add esp, 4
      
    PRINT_DEC 4, esi
    
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    
    
     
    xor eax, eax
    leave
    ret
    
    verifica_daca_e_semn:
        push ebp
        mov ebp, esp

        push eax
        push ebx
        
        mov eax, [ebp + 8]
        mov ebx, [eax]
        mov ecx, [ebx]
    adunare:
        cmp ecx, "+"
        jne scadere
        ;daca e adunare verificam pe stanga
        push dword[eax +4]
        call verifica_daca_e_semn
        add esp, 4
        push ecx
        push esi
        ;si pe dreapta
        push dword[eax + 8]
        call verifica_daca_e_semn
        add esp,4
        ;cand se ajunge la numere le intorc prin esi
        ;si le adun/scad/impart/inmultesc in functie de operatie
        pop ecx
        add esi, ecx
        pop ecx
        cmp ecx, 48
        jg sari_peste
    scadere:
        cmp ecx, "-"
        jne inmultire
        push dword[eax +4]
        call verifica_daca_e_semn
        add esp, 4
        push ecx
        push esi
        push dword[eax + 8]
        call verifica_daca_e_semn
        add esp,4
        pop ecx
        sub ecx, esi
        mov esi, ecx
        pop ecx
        cmp ecx, 48
        jg sari_peste
    inmultire:
        cmp ecx, "*"
        jne impartire
        push dword[eax +4]
        call verifica_daca_e_semn
        add esp, 4
        push ecx
        push esi
        push dword[eax + 8]
        call verifica_daca_e_semn
        add esp,4
        pop eax
        imul esi
        mov esi, eax
        pop ecx
        cmp ecx, 48
        jg sari_peste
    impartire:
        cmp ecx, "/"
        jne out_1
        push dword[eax +4]
        call verifica_daca_e_semn
        add esp, 4
        push ecx
        push esi
        push dword[eax + 8]
        call verifica_daca_e_semn
        add esp,4
        pop eax
        cdq
        idiv esi
        mov esi, eax
        pop ecx
        cmp ecx, 48
        jg sari_peste
    out_1:
        push ebx
        call convertCharToInt
        add esp, 4
        mov esi, edi
    sari_peste:
        pop ebx
        pop eax
        leave
        ret
        
    ;Convert char to int
    ;verificam daca e negativ
    negativ:
        
        mov esi, 1
        inc ebx
        jmp aux
    ;in caz ca e negativ il negam
    negativ_1:
        neg edi
        jmp out_convertCharToInt
    
    ;functia principala
    convertCharToInt:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        xor edi, edi
        xor ebx, ebx
        xor ecx, ecx
        xor esi, esi
        
        mov ebx, [ebp + 8]
        mov cl, byte[ebx]
        ;PRINT_CHAR CL
        ;NEWLINE
        cmp cl, '-'

        je negativ
    ;verifica fiecare caracter de tip char si il transforma   
    aux:    
        mov cl, byte[ebx]
        cmp cl, 0
        je out
        ;PRINT_CHAR CL
        ;NEWLINE
        inc ebx
        
        cmp cl, '9'
        ja out
        cmp cl, '0'
        jb out
        
        sub ecx, '0'
        
        imul edi, 10
        add edi, ecx
        jmp aux
    ;aici verifica daca a fost negativ
    out:
        cmp esi, 1
        je negativ_1
    out_convertCharToInt:
        pop esi
        pop ecx
        pop ebx
        leave
        ret
        
                                                                                                            ;Adrian Argint
                                                                                                            ;   323CB