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

.data
	.global open_file_path
	.global close_file_descriptor
	.global read_from_file_vectored
	.global write_to_file_vectored
	.global allocate_memory
	.global unallocate_memory
	.global read_sequence
	.global count_nucleotides
	.global get_entropy



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


	read_sequence_count_nucs:
		#define BUFF_NUC %rdi
		#define BUFF_CNT %rsi
		#define CHAR_REG %r10b
		#define DWRD_REG %r10
		#define CNTR_REG %rcx
		#define HEAD_CHR $62
		#define ENDL_CHR $10
		#define SUCC_RET $0
		#define FAIL_RET $-1
		#define RETR_REG %rax

		xor DWRD_REG, DWRD_REG
		movb (BUFF_NUC), CHAR_REG

		cmp HEAD_CHAR, CHAR_REG
		je 2f
	
	1:	
		movb (BUFF_NUC), CHAR_REG
		movw (BUFF_CNT, DWRD_REG), CNTR_REG
		incw CNTR_REG
		movw CNTR_REG, (DWRD_REG)
		cmp ENDL_REG, CHAR_REG
		jne 3f

	2:
		movq FAIL_REG, RETR_REG
		jmp 1b

	3:
		ret

