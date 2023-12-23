.text
.global _main


_main:

	li a0, 0						# File descriptor
	
	la, a0, prompter				# Load address of the prompter to a0	
	jal ra, ecall_print_str			# print the prompter
	
	jal ra, ecall_get_integer			# get number of numbers from the user
								# a0 has the user input
	mv a1, a0					# set arguments of get_array_elements
	jal ra, get_array_elements		# get elements from the user as many as the input
	
	jal ra, bubble_sort
	
	la a0, end_message			# print the final message
	jal ra ecall_print_str			# call print ecall
	
	jal ra, print_array				# prints the array

	jal ra, ecall_exit				# Exit the program
	
	

get_array_elements: #( input [a1], )
	mv t1, a1
	la, a2, array										# a2 == 0(array)
	get_element:							
		beqz t1, get_array_elements_exit					# if t1 == 0 exit the function
	
		addi sp, sp, -4	
		sw ra, 0(sp)									# store return address to stack
	
		jal ra, ecall_get_integer 						# a0 = integer entered by user
	
		lw ra, 0(sp)									# load back return address of the caller from stack
		addi sp, sp, 4
	
		addi sp, sp, -4	
		sw ra, 0(sp)									# store return address to stack
	
		jal ra, array_append 							# add a0 to array
	
		lw ra, 0(sp)									# load back return address of the caller from stack
		addi sp, sp, 4
	
		addi t1, t1, -1									# a1--
		addi a2, a2, 4									# set the address to the next word
		j get_element
	
	get_array_elements_exit:
		jalr zero, 0(ra)

bubble_sort: # bubbleSort( a1 = number of elements in the array, )
	la a2, array							# saves the address of the array to a2
	addi a3, a1, -1							# a3 = i = length - 1
	
	outer_loop:							# for(i = 0; i < length - 1; i++) ## double check here possible logic mistake
	
		beqz a3, end_outer_loop			# if( a3 == 0) exit outer loop
		
		addi a4, zero, 0 
		
		inner_loop:						# for(j = i; j < length - 1; j++)
			
			bge a4, a3 end_inner_loop		# if(j >= i) exit inner loop
			slli a5, a4, 2  					# a4 = a4 * 4
			add a5, a2, a5  				# a5 = &array[j]
			lw a6 0(a5)					# a6 = array[j]
			lw a7, 4(a5)					# a7 = array[j +1]
			blt a7, a6, increment_j			# if (array[j + 1] < array[j]) => no need to swap
		
			swap:						# if( array[j] > array[j+1])
				sw a6, 4(a5)  				# array[i + 1] = array[i]
    				sw a7, 0(a5)  				# array[i] = array[i + 1]			
			increment_j:
				addi a4, a4, 1  			# j++	
				j inner_loop			
		end_inner_loop:
		
		addi a3, a3, -1						#i--
		j outer_loop
	end_outer_loop:
		
	exit_bubble_sort:
		jalr zero 0(ra)
	

print_array: # printArray(a1 = the number of elements to print)

	la a2, array							# a2 has the adress of the array[0]
	mv t1, a1								#t1 is the number of elements to print				
	print_element:
		beqz t1, print_array_exit			 # if t1 == 0 stop printing
		
		addi sp, sp, -4	
		sw ra, 0(sp)						# store return address to stack
		
		jal ra,  array_get					# the element is in a0
		
		jal ra, ecall_print_int				# print the element in a0
		
		la a0, white_space
		jal ra, ecall_print_str				# print a space
		
		lw ra, 0(sp)						# load back return address of the caller from stack
		addi sp, sp, 4
		
		addi t1, t1, -1						# t1-- 
		addi a2, a2, 4						# set the address to the next word
		j print_element					# go back to the loop
			
	print_array_exit:
		jalr zero, 0(ra)


# Helper Functions

array_append: # array.append(a0 = value,  a2 = address) 
	sw a0, 0(a2)
	jalr zero, 0(ra)

array_get:  # array.get( a2 = address) 
	lw a0, 0(a2)
	jalr zero, 0(ra)


# Ecall Functions

						
ecall_exit:
	li a7, 93
	ecall
	jalr x0 0(x1)
	
ecall_print_str: 
	li a7, 4
	ecall
	jalr x0 0(x1)

ecall_print_int: #(a0 = integer)
	li a7, 1
	ecall
	jalr zero, 0(ra)

ecall_get_integer:
	li a7, 5
	ecall	
	jalr zero 0(ra) 
				
.data
	end_message: .asciz "Your sorted array: "
	white_space: .asciz " "
	next_line: .asciz " \n"
	prompter: .asciz "How many integers are you going to enter?: "
	prompter_2: .asciz "Printing the array:\n"
	.align 4
	array: .word 


							