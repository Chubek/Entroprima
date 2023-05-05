#define SYSCNR_read $0
#define SYSCNR_write $1
#define SYSCNR_open $2
#define SYSCNR_close $3
#define SYSCNR_readv $19
#define SYSCNR_writev $20
#define SYSCNR_mmap $90
#define SYSCNR_munmap $91
#define SYSCNR_register %rax
#define SYSCNR_yield %rax

#define SYSCID_stdout $1

#define SYSCARG_0 %rdi
#define SYSCARG_1 %rsi
#define SYSCARG_2 %rdx
#define SYSCARG_3 %r10
#define SYSCARG_4 %r8
#define SYSCARG_5 %r9


#define SUBROUT_R %rax

.data
	.global open_file_path
	.global close_file_descriptor
	.global read_from_file_vectored
	.global write_to_file_vectored
	.global allocate_memory
	.global unallocate_memory
	.global read_sequence
	.global get_entropy
	.global count_bytes_til_newl
	.global uint16_to_ascii_and_print


	divmagics:
	#include "divmagics.inc"


.text
	open_file_path:
		#define FILE_LOC %rdi
		#define OPEN_FLG %rsi

		movq SYSCNR_open, SYSCNR_register
		syscall

		ret

		#undef FILE_LOC
		#undef OPEN_FLG

	close_file_descriptor:
		#define FILE_DSC %rdi

		movq SYSCNR_close, SYSCNR_register
		syscall

		ret


		#undef FILE_DSC


	read_from_file_vectored:
		#define FILE_DSC %rdi
		#define BUFS_PTR %rsi
		#define BUFS_NUM %rdx

		movq SYSCNR_readv, SYSCNR_register
		syscall

		ret

		#undef FILE_DSC
		#undef BUFS_PTR
		#undef BUFS_NUM


	write_to_file_vectored:
		#define FILE_DSC %rdi
		#define BUFS_PTR %rsi
		#define BUFS_NUM %rdx

		movq SYSCNR_writev, SYSCNR_register
		syscall

		ret

		#undef FILE_DSC
		#undef BUFS_PTR
		#undef BUFS_NUM

	allocate_memory:
		#define SIZE_MEM %rdi
		#define PROT_RWX $7
		#define FLAG_SAN $21
		#define NULL_FLD $-1

		movq SIZE_MEM, SYSCARG_1
		xorq SYSCARG_0, SYSCARG_0
		movq PROT_RWX, SYSCARG_2
		movq FLAG_SAN, SYSCARG_3
		movq NULL_FLD, SYSCARG_4
		xorq SYSCARG_5, SYSCARG_5
		movq SYSCNR_mmap, SYSCNR_register
		syscall

		ret

		#undef SIZE_MEM
		#undef PROT_RWX
		#undef FLAG_SAN
		#undef NULL_FLD

	unallocate_memory:
		#define BUFF_PTR %rdi
		#define BUFF_LEN %rsi

		movq SYSCNR_mmap, SYSCNR_register
		syscall

		#undef BUFF_PTR
		#undef BUFF_LEN
/*

	count_bytes_til_newl:
		#define BYTE_PTR %rdi
		#define CNTR_PTR %rsi
		#define BYTE_LEN %rdx
		#define CNTR_REG %rcx
		#define BYTE_REG %r10b
		#define DWRD_REG %r10
		#define TEMP_REG %r11
		#define NEWL_NUM $10


		movq BYTE_LEN, CNTR_REG
		xorq DWRD_REG, DWRD_REG
	1:
		movb (BYTE_PTR), BYTE_REG
		cmpb NEWL_NUM, BYTE_REG
		je 2f
		movq (CNTR_PTR, DWRD_REG), TEMP_REG
		incq TEMP_REG
		movq (TEMP_REG), (CNTR_PTR, DWRD_REG)
		loop 1b

	2:
		ret

		#undef BYTE_PTR
        #undef CNTR_PTR
        #undef BYTE_LEN
        #undef CNTR_REG
        #undef BYTE_REG
        #undef DWRD_REG
        #undef TEMP_REG
        #undef NEWL_NUM
*/

    uint16_to_ascii_and_print:
    	#define NUMB_INT %rdi
    	#define CNTR_REG %rcx
    	#define STCK_PTR %rsp
    	#define FRAM_PTR %rbp
    	#define TEMP_RG1 %r10
    	#define TEMP_RG2 %r11
    	#define TEMP_BY1 %r10b
    	#define MULQ_REG %rax
    	#define UI16_MAX $65535
    	#define UI16_BIT $16
    	#define ASCI_ZER $48
    	#define MAXM_LEN $64
    	#define MAXM_NUL $65
    	#define DECA_MAG $39322
    	#define DECA_SH1 $1
    	#define DECA_SH2 $3
    	#define NEWL_CHR $10

    	pushq FRAM_PTR
    	movq STCK_PTR, FRAM_PTR
    	movq FRAM_PTR, CNTR_REG

    1:
    	decq FRAM_PTR
    	movq DECA_MAG, MULQ_REG
    	mulq NUMB_INT
    	shrq UI16_BIT, MULQ_REG
    	andq UI16_MAX, MULQ_REG
    	movq NUMB_INT, TEMP_RG2
    	subq MULQ_REG, TEMP_RG2
    	shrq DECA_SH1, TEMP_RG2
    	addq TEMP_RG2, MULQ_REG
    	shrq DECA_SH2, MULQ_REG
    	movq MULQ_REG, TEMP_RG1
    	movq MULQ_REG, TEMP_RG2
    	shlq DECA_SH1, TEMP_RG1
    	shlq DECA_SH2, TEMP_RG2
    	addq TEMP_RG1, TEMP_RG2
    	movq NUMB_INT, TEMP_RG1
    	subq TEMP_RG2, TEMP_RG1
    	addq ASCI_ZER, TEMP_RG1
    	movb TEMP_BY1, (FRAM_PTR)
    	movq MULQ_REG, NUMB_INT
    	test NUMB_INT, NUMB_INT
    	jnz 1b
    	
    	movb NEWL_CHR, TEMP_BY1
    	movb TEMP_BY1, (CNTR_REG)
    	subq FRAM_PTR, CNTR_REG
    	incq CNTR_REG
    	movq SYSCNR_write, SYSCNR_register
    	movq SYSCID_stdout, SYSCARG_0
    	movq FRAM_PTR, SYSCARG_1
    	movq CNTR_REG, SYSCARG_2
    	syscall

    	popq FRAM_PTR

    	ret

    	#undef NUMB_INT
        #undef CNTR_REG
        #undef STCK_PTR
        #undef FRAM_PTR
        #undef TEMP_RG1
        #undef TEMP_RG2
        #undef TEMP_BY1
        #undef MULQ_REG
        #undef UI16_MAX
        #undef UI16_BIT
        #undef ASCI_ZER
        #undef MAXM_LEN
        #undef MAXM_NUL
        #undef DECA_MAG
        #undef DECA_SH1
        #undef DECA_SH2
        #undef NEWL_CHR
