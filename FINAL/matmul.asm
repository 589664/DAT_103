matmul:
   ;pushing data to stack for later use:
   push dword matrixA     ; matrixA      #9
   push dword matrixB     ; matrixB      #8
   push dword matrixC     ; matrixC      #7
   push dword 0           ; k            #6
   push dword 0           ; i            #5
   push dword 0           ; j            #4
   push dword 0           ; acc          #3
   push dword l           ; l            #2
   push dword n           ; n            #1
   push dword m           ; m            #0

l3:
   
   ;reading MATRIX A saving to ecx
   readoutMatrix ecx, w32FrStck(9), w32FrStck(1), w32FrStck(5), w32FrStck(6)
                           ; m     ,     w=n      ,     i       ,     k
   ;reading MATRIX B saving to eax
   readoutMatrix eax, w32FrStck(8), w32FrStck(0), w32FrStck(6), w32FrStck(4)
                           ; m     ,     w=m     ,      k       ,     j
   
   mul ecx                 ; A[i][k] * B[k][j] -> eax
   mov ebx, w32FrStck(3)   ; acc -> ebx
   add eax, ebx            ; acc + A[i][k] * B[k][j]
   mov w32FrStck(3), eax   ; update acc with new value aka acc += A[i][k] * B[k][j]

   ;update new values for k
   mov eax, w32FrStck(6)   ; k -> eax
   inc eax                 ; k++
   mov w32FrStck(6), eax   ; update k in stack

   mov ecx, w32FrStck(1)   ; n

   cmp eax, ecx            ; compare ecx = n and eax = k

   jl l3                   ; if k < n

l2:
   mov ecx, w32FrStck(3)   ; acc -> ecx

   ;MATRIX C, write acc to matrix aka C[i][j] = acc;
   writeToMatrix ecx, w32FrStck(7), w32FrStck(0), w32FrStck(5), w32FrStck(4)
                           ; m     ,     w       ,     i       ,     j

   ;reset k for new l3 - loop
   mov eax, 0              ; eax <-- 0
   mov w32FrStck(6), eax   ; update k in stack
   mov w32FrStck(3), eax   ; reset eax before starting on l3 again

   ;update new value j to stack
   mov eax, w32FrStck(4)   ; j -> eax
   inc eax                 ; j++
   mov w32FrStck(4), eax   ; update j in stack

   mov ecx, w32FrStck(0)   ; m

   cmp eax, ecx            ; compare j and m

   jl l3

l1:
   ;reset j for new l3 - loop
   mov eax, 0              ; eax <-- 0
   mov w32FrStck(4), eax   ; update j in stack
 
   ;update new value i to stack
   mov eax, w32FrStck(5)   ; i -> eax
   inc eax                 ; i++
   mov w32FrStck(5), eax   ; updated k in stack
 
   mov ecx, w32FrStck(2)   ; l   
   
   cmp eax, ecx            ; compare i and l

   jl l3                   ; if i < l

   ;cleaning up the stack to prevent segmentation failure, so the routine can return
   pop eax           ; m            #0                  
   pop eax           ; n            #1
   pop eax           ; l            #2
   pop eax           ; acc          #3
   pop eax           ; j            #4
   pop eax           ; i            #5
   pop eax           ; k            #6
   pop eax           ; matrixC      #7
   pop eax           ; matrixB      #8
   pop eax           ; matrixA      #9

   ret         ; end/stop return