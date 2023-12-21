

.text
.global _main

	_main: 
		# file descriptor strandart input output
		li a0, 0
		
	
		la a0, prompter
		jal x1 print_function_from_ecall
		
		# call diamond function 
		jal x1, diamond

		# call the exit function 
		jal x1, exit_function_from_ecall
		
		

	exit_function_from_ecall:
		li a7, 93
		li a2, 2
		ecall
		jalr x0 0(x1)
	
	print_function_from_ecall: 
		li a7, 4
		ecall
		jalr x0 0(x1)
	
	diamond: # diamong(int a1)
		
	
		li a7,5
		ecall
		
		mv a1, a0 # a1 = N input
		
		addi a4, a0, -1 
		srli a4, a4, 1 # a4 = number of spaces		

		addi a2, zero, 1 # a2 = 1 #number of stars
		print_upper_diamond:
			blt a1, a2, cont #  if input is less than number of stars, branch
			add a3, a2, zero # a3 = a2 util value to print stars
			add a5, a4, zero # a5 = a4 util value to print sspaces
			print_spaces:
				beq a5, zero, print_stars
				la a0 space
				li a7, 4
				ecall
				addi a5, a5, -1
				beq x0, x0, print_spaces

			print_stars: 	
				beq a3, x0, end_of_printing_stars 
				la a0 star
				li a7, 4
				ecall
				addi a3, a3, -1
				beq x0 x0 print_stars
			end_of_printing_stars:
				la a0 new_line
				li a7, 4
				ecall
				addi a2, a2, 2
				addi a4, a4, -1		
				beq x0, x0 print_upper_diamond
		

		cont:
			addi a2, a1, -2 # number of stars should be 2 fewer than number of stars
			addi a4, zero, 1 # number of spaces
		
		print_lower_diamond:
			bge zero, a2, Exit
			add a3, a2, zero # a3 = a2 util value to print stars
			add a5, a4, zero # a5 = a4 util value to print sspaces
			print_spaces_lower:
				beq a5, zero, print_stars_lower
				la a0 space
				li a7, 4
				ecall
				addi a5, a5, -1
				beq x0, x0, print_spaces_lower
			print_stars_lower:
				beq a3, x0, end_of_line
				la a0 star
				li a7, 4
				ecall
				addi a3, a3, -1
				beq x0 x0 print_stars_lower
			end_of_line:
				la a0 new_line
				li a7, 4
				ecall
				addi a2, a2, -2
				addi a4, a4, 1		
				beq x0, x0 print_lower_diamond

		Exit: 
			jalr x0, 0(x1)

			

.data	
	prompter: .asciz "Please enter a positive odd number to draw a star: "
	star: .asciz "*"
	new_line: .asciz "\n"
	space: .asciz " "
	error_message: .asciz "Error! Invalid input! The input must be a positive odd integer: "


		
	
					
	
