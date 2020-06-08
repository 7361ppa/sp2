.data
        x: .space 2 
        i: .word 0x0  
	arr: .byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF 
	arrcounter: .byte 0x0
	ap: .space 4
	newline: .string "\n"
	sum: .word 0x0

.text
        .globl main
        .type main, @function

        output:

                // delimoe v registr ax
                movw %dx, %ax

                // delitel 10
                movb $0xA, %cl

        divcycle:
                incw (i)

                // delim
                div %cl

                // ostatok v stek
                movb %ah, %bl
                movb $0x0, %bh
                push %bx
		
		// starshaya chast ne nujna
               	movb $0x0, %ah 
		
                // konec chisla?
                cmp $0x0, %al
                jne divcycle

        printcycle:

                // kod ascii v x
                movl $0x0, %ecx
                pop %cx
                add $0x30, %cx
                movw %cx, (x)


                // output on screen       
                movl $4, %eax
                movl $1, %ebx
                movl $x, %ecx
                movl $2, %edx
                int $0x80

                decw (i)
                cmpw $0x0, (i)
                jne printcycle

                ret


	printnewline:
		movl $4, %eax
                movl $1, %ebx
                movl $newline, %ecx
                movl $1, %edx
                int $0x80
		ret


        main:
		leal arr, %ebx
		movl %ebx, (ap)
		
	cycle:	
		movl (ap), %eax		
        movb (%eax), %dl

		testb $0x40, %dl
		je ending
		
		shrb $0x1, %dl
		movb %dl, (%eax) 

	ending:
		movb $0x0, %dh
		addw %dx, (sum)
		incl (ap)
		incb (arrcounter)
		cmpb $0xA, (arrcounter)
		jne cycle

		movw (sum), %dx
		call output
		call printnewline

                movl $1, %eax
		movl $0, %ebx
                int $0x80
                .size main, .-main

