.text
.global _main


_main: 
	li a0, 0           # File descriptor, 0 for STDIN
	
        la a0, prompter	        	# prepare to print prompter 
        li a7, 4			# print prompter
        ecall
        
        jal ra, get_integer_from_ecall # get integer from the user
        
	jal ra, function 		# call function(n)
	
	mv a1, a0
	
	la a0, result	        	# prepare to print prompter 
       	li a7, 4			# print prompter
        ecall
	
	
	mv a0, a1
	
	li a7, 1			# Print integer. (the value is taken from a0)
	ecall

	

        
        jal ra, exit_function_from_ecall
 

function:

	base:
		addi sp,sp,-8
	 	sw   x1,4(sp)
	 	sw   a0,0(sp)
	 	addi a5,a0,-2 		#  a5 = n - 1
	 	bge  a5,x0,recursion 	# if n - 1 >= 0, go to recursion
	 	
	 	addi a0 , x0,3  	# return 3
	 	addi sp, sp, 8
	 	jalr zero ,0(ra)
	 	


	recursion:
		addi x10,x10,-1 	# n--
	 	jal  ra, function 	# call function(n - 1)
	 	addi a6, x10, 0		# a6 = function(n - 1)
	 	
	 	addi a7, zero, 3	# a7 = 3
	 	mul a6, a6, a7 		# a6 = 3 * function(n - 1)
	 	
	 	lw a0, 0(sp)		# load callers return value
	 	lw ra, 4(sp)		# load caller's adress
	 	
	 	add a0, a6, a0		# return 3 * function(n - 1) + n
	 	
	 	addi sp, sp, 8		# stack pointer to natural place
	 	jalr zero, 0(ra)	# return to caller's address

		
	
exit_function_from_ecall:
	li a7, 93
	li a2, 2
	ecall
	jalr x0 0(x1) 
	
print_function_from_ecall: 
	li a7, 4
	ecall
	jalr x0 0(x1)

get_integer_from_ecall: 
	li a0, 0            # File descriptor, 0 for STDIN
        li a7, 5            # System call code for read integer. The value will be in a0
        ecall
        jalr zero 0(ra)
	


.data 
	prompter: .asciz "Please enter the parameter of the function(x): "
	result: .asciz "The result of the function is: "
