

.text
.global _main

	_main: 
		# file descriptor strandart input output
		li a0, 0
		
		
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
	
	diamond: 	# diamond(int a1)
		
		get_valid_input:
			la a0, prompter
			li a7, 4
			ecall
			
			li a7,5
			ecall  						# a0 has the user input
			
			bge zero, a0, get_valid_input	# if (input < 0) get input again
			
			mv t0, a0						# t0 = input
			li t1, 2						# t1 = 2
			rem t0, t0, t1					# t0 = 0 or 1
			blt zero, t0, diamond_back		# 0 < t0 
			j get_valid_input					
		
		diamond_back:
		mv a1, a0 						# a1 = N input
		
		addi a4, a0, -1 
		srli a4, a4, 1 			# a4 = number of spaces		

		addi a2, zero, 1 		# a2 = 1 #number of stars
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
	prompter: .asciz "\nPlease enter a positive odd number to draw a star: "
	star: .asciz "*"
	new_line: .asciz "\n"
	space: .asciz " "
	error_message: .asciz "Error! Invalid input! The input must be a positive odd integer: "


		
	
					
	
