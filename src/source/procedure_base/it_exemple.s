	.file "/home/lou/Documents/ETN5/SoC/controller_IT/src/source/procedure_base/IT_exemple.c"
	.section	.text,code
	.align	2
	.global	_UART_Handler	; export
	.type	_UART_Handler,@function
_UART_Handler:
	.set ___PA___,1
	return	
	.set ___PA___,0
	.size	_UART_Handler, .-_UART_Handler
	.align	2
	.global	_CTRL_IT_init_Ext	; export
	.type	_CTRL_IT_init_Ext,@function
_CTRL_IT_init_Ext:
	.set ___PA___,1
	mov	_CTRL_IT,w0
	clr	[w0]
	mov	_CTRL_IT,w3
	mov	#4,w1
	clr	w0
	mov.b	#-8,w6
	mov	#handle(_CTRL_IT_init_Ext),w5
.L3:
	add	w3,w0,w2
	add	#38,w2
	and.b	w6,[w2],w4
	ior.b	w4,#3,[w2]
	add	w0,#4,w2
	add	w2,w2,w2
	mov	w5,[w3+w2]
	inc	w0,w0
	dec	w1,w1
	.set ___BP___,80
	bra	nz,.L3
	mov	#1,w0
	mov	w0,[w3]
	return	
	.set ___PA___,0
	.size	_CTRL_IT_init_Ext, .-_CTRL_IT_init_Ext
	.align	2
	.global	_nIT_CPU_Handler	; export
	.type	_nIT_CPU_Handler,@function
_nIT_CPU_Handler:
	.set ___PA___,1
	mov	_CTRL_IT,w0
	mov	[w0+6],w0
	call	w0
	return	
	.set ___PA___,0
	.size	_nIT_CPU_Handler, .-_nIT_CPU_Handler
	.align	2
	.global	_Ext_Handler	; export
	.type	_Ext_Handler,@function
_Ext_Handler:
	.set ___PA___,1
	return	
	.set ___PA___,0
	.size	_Ext_Handler, .-_Ext_Handler
	.align	2
	.global	_CTRL_IT_init_UART	; export
	.type	_CTRL_IT_init_UART,@function
_CTRL_IT_init_UART:
	.set ___PA___,1
	mov	_CTRL_IT,w0
	clr	[w0]
	mov	_CTRL_IT,w0
	mov	#2048,w1
	mov	w1,[w0+2]
	mov	#handle(_UART_Handler),w1
	mov	w1,[w0+30]
	mov	#1,w1
	mov	w1,[w0]
	return	
	.set ___PA___,0
	.size	_CTRL_IT_init_UART, .-_CTRL_IT_init_UART
	.global	_CTRL_IT	; export
	.section	.ndata,data,near
	.align	2
	.type	_CTRL_IT,@object
	.size	_CTRL_IT, 2
_CTRL_IT:
	.word	-3856



	.section __c30_info, info, bss
__large_data_scalar:

	.section __c30_signature, info, data
	.word 0x0001
	.word 0x0006
	.word 0x0000

; MCHP configuration words

	.set ___PA___,0
	.end
