	.file	"IT_exemple.c"
	.text
	.globl	CTRL_IT
	.bss
	.align 8
	.type	CTRL_IT, @object
	.size	CTRL_IT, 8
CTRL_IT:
	.zero	8
	.text
	.globl	nIT_CPU_Handler
	.type	nIT_CPU_Handler, @function
nIT_CPU_Handler:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	CTRL_IT(%rip), %rax
	movq	8(%rax), %rax
	call	*%rax
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	nIT_CPU_Handler, .-nIT_CPU_Handler
	.globl	UART_Handler
	.type	UART_Handler, @function
UART_Handler:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	UART_Handler, .-UART_Handler
	.globl	Ext_Handler
	.type	Ext_Handler, @function
Ext_Handler:
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	Ext_Handler, .-Ext_Handler
	.globl	CTRL_IT_init_Ext
	.type	CTRL_IT_init_Ext, @function
CTRL_IT_init_Ext:
.LFB3:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	CTRL_IT(%rip), %rax
	movw	$0, (%rax)
	movl	$0, -4(%rbp)
	jmp	.L5
.L6:
	movq	CTRL_IT(%rip), %rdx
	movl	-4(%rbp), %eax
	movzbl	136(%rdx,%rax), %ecx
	andl	$-8, %ecx
	orl	$3, %ecx
	movb	%cl, 136(%rdx,%rax)
	movq	CTRL_IT(%rip), %rax
	movl	-4(%rbp), %edx
	addq	$2, %rdx
	leaq	CTRL_IT_init_Ext(%rip), %rcx
	movq	%rcx, (%rax,%rdx,8)
	addl	$1, -4(%rbp)
.L5:
	cmpl	$3, -4(%rbp)
	jbe	.L6
	movq	CTRL_IT(%rip), %rax
	movw	$1, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	CTRL_IT_init_Ext, .-CTRL_IT_init_Ext
	.globl	CTRL_IT_init
	.type	CTRL_IT_init, @function
CTRL_IT_init:
.LFB4:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	CTRL_IT(%rip), %rax
	movw	$0, (%rax)
	movq	CTRL_IT(%rip), %rax
	movw	$2048, 2(%rax)
	movq	CTRL_IT(%rip), %rax
	leaq	UART_Handler(%rip), %rdx
	movq	%rdx, 104(%rax)
	movq	CTRL_IT(%rip), %rax
	movw	$1, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	CTRL_IT_init, .-CTRL_IT_init
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
