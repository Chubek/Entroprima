#define SYSCNR_open $2
#define SYSCNR_close $3
#define SYSCNR_readv $19
#define SYSCNR_writev $20
#define SYSCNR_mmap $90
#define SYSCNR_munmap $91
#define SYSCNR_register %rax
#define SYSCNR_yield %rax

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
	.global int_to_ascii


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


    int_to_ascii:
    	#define NUMB_INT %rdi
    	#define CNTR_REG %rcx
    	#define STCK_PTR %rsp
    	#define FRAM_PTR %rbp
    	#define ASCI_ZER $48
    	#define MAXM_LEN $48
    	#define DECA_MAG $0x999a00030001

    	pushq FRAM_PTR
    	movq STCK_PTR, FRAM_PTR
    	subq MAXM_LEN, FRAM_PTR

    	movq MAXM_LEN, CNTR_REG
    
    1:
