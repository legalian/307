	.file	"descriptors5.c"
	.text
	.section	.rodata
.LC0:
	.string	"file.txt"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$432, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$3, -432(%rbp)
	leaq	-416(%rbp), %rdx
	movl	$0, %eax
	movl	$50, %ecx
	movq	%rdx, %rdi
	rep stosq
	movl	-432(%rbp), %eax
	movl	%eax, -416(%rbp)
	movl	$1, -428(%rbp)
	movl	$0, -424(%rbp)
	jmp	.L2
.L4:
	movl	-432(%rbp), %eax
	cltq
	movl	-416(%rbp,%rax,4), %eax
	cmpl	$1, %eax
	jne	.L3
	movl	$0, %esi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	open@PLT
	movl	%eax, -420(%rbp)
.L3:
	movl	-416(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -416(%rbp)
.L2:
	cmpl	$999, -424(%rbp)
	jle	.L4
	movl	$0, %eax
	movq	-8(%rbp), %rsi
	subq	%fs:40, %rsi
	je	.L6
	call	__stack_chk_fail@PLT
.L6:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
	.section	.note.GNU-stack,"",@progbits
