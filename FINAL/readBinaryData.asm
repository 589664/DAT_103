readBinaryData:
   mov eax,SYS_READ        ; eax <-- SYS_READ = 3 (system read call)
   mov ebx,STDIN           ; ebx <-- STDIN = 0 (innput from keyboard/file)
   mov ecx, w32FrStck(1)   ; ecx <-- pointer to current element in current matrix (depends on what is pushed with macro call2 for example)
   mov edx, 8*4            ; edx <-- define read size: 8 digit with size 4 bytes = 32 bits 
   int 80h                 ; int = interupts current program runs 80h and invoke GNU / Linux services
   mov eax, 8*4            ; eax <-- define jump size: 8 digit with size 4 bytes = 32 bits 
   mov ecx, w32FrStck(1)   ; ecx <-- adress in memory of current matrix element
   add ecx, eax            ; ecx <-- (eax + ecx) "aka adress current element + 32" jump to next values to read
   mov w32FrStck(1), ecx   ; w32FrStck(1) <-- ecx we update new position for next element in matrix in the stack
   mov edx, w32FrStck(2)   ; edx <-- moving size of matrix example 4*l*n 
   sub edx, eax            ; edx <-- (eax - edx) "aka size of matrix - 32", decrease size so we can use it for compare to loop jump/loop readBinaryData
   mov w32FrStck(2), edx   ; w32FrStck(2) <-- edx updating size in stack to new size since 32 bits are already occupied for later use as mentioned above
   cmp edx, 0              ; compare new size to 0, jump to readBinaryData "run method once again" if cmp return greater than 0 "aka edx > 0"
   jg readBinaryData       ; jumps to begining of method if cmp returned greater than 0 "aka edx > 0"
   ret                     ; ends when cmp returns 0 or lower... "aka edx is not greater than 0"

; Question 1:
; Would the routine work with matrices of any size? It does work with the A- and B matrices we are using,
; but what requirement makes this possible?

; Answer:
; Like method is now it will not work with matrixes of any size, since it needs to containt
; amount of elements devidable by 8, since we're reading 8 elements at a time with size of 4 byte
; with other words the size of matrix needs to be of size devidable by 32 since 8 element * 4 byte
; matrixA has size 60000 = 4 * 300 * 50 that is devidable by 8 and matrixB has size 100000 = 4 * 50 * 500
; that is also devidable by 32

; Question 2:
; What could be changed to actually make it work with any size? Discuss if your suggestion has any
; drawbacks?

; Answer:
; We can change the routine to read one element at a time with same size of every element
; the drawbacks of this adjustment will result in a worse performance of the routine
; we can make the routine to read 2 elements at a time but this will work only with matrixes
; of even size, but will have better performance than reading one element at a time

; if it also has to work with elements of any size then we need to read a byte at a time 
; that is actually the safest way to do it, but again it will give a worse performance of 
; the routine, and we will not be using performance assembly x32 gives us

; it's worth to mention that if we try to read more than 32 bits/4 bytes at once, will result in failure
; since assembly x32 cannot read more than 32 bits /4 bytes at a time