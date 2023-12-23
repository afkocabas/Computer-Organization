.text
.global _main


_main:

	li a0, 0					# File descriptor
	
	la, a0, prompter			# Load address of the prompter to a0	
	jal ra, print_string			# print the prompter
	
	jal ra, get_integer			# get number of numbers from the user
							# a0 has the user input
	mv a1, a0				# set arguments of get_array_elements
	jal ra, get_array_elements	# get elements from the user as many as the input

	jal ra, exit				# Exit the program
	
	
get_integer:
	li a7, 5
	ecall	
	jalr zero 0(ra) 


get_array_elements: #( input [a1], )
	
	la, a2, array								# a2 == 0(array)
	get_element:							
		beqz a1, get_array_exit					# if t1 == 0 exit the function
	
		addi sp, sp, -4	
		sw ra, 0(sp)							# store return address to stack
	
		jal ra, get_integer 						# a0 = integer entered by user
	
		lw ra, 0(sp)							# load back return address of the caller from stack
		addi sp, sp, 4
	
		addi sp, sp, -4	
		sw ra, 0(sp)							# store return address to stack
	
		jal ra, add_element_to_the_array 		# add a0 to array
	
		lw ra, 0(sp)							# load back return address of the caller from stack
		addi sp, sp, 4
	
		addi a1, a1, -1							# a1--
		addi a2, a2, 4
		beq x0, x0, get_element
	
	get_array_exit:
		jalr zero, 0(ra)
	

	
exit:
	li a7, 93
	ecall
	jalr x0 0(x1)
	
print_string: 
	li a7, 4
	ecall
	jalr x0 0(x1)

print_integer:
	li a7, 1
	ecall
	jalr zero, 0(ra)
	


add_element_to_the_array: # (a0 = value,  a2 = address)
		sw a0, 0(a2)
		jalr zero, 0(ra)

print_array:
	la a2, array			# a2 has the adress of the array
	print_element:
		
	

				
.data
	next_line: .asciz " \n"
	prompter: .asciz "How many integers are you going to enter?: "
	prompter_2: .asciz "Printing the array:\n"
	.align 4
	array: .word 


							