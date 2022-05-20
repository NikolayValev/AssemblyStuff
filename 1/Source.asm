INCLUDE Irvine32.inc

BUFSIZE = 80
.data
buffer byte BUFSIZE DUP(?)
line byte "-----------------------------------------------------------------------------------",0
highmsg byte "The character with the highest value is ",0
;changemsg byte "The highest number has changed. It is now ", 0
space byte " , and it's value is ",0
msg1 byte "Enter filename", 0
count byte ?
filename byte 80 DUP(0); 80 is the maximum that you can store

filehandle handle ? ; special datatype for handle
highestchar byte ?
currentchar byte ?
highestnum byte 2 DUP(?)
currentnum byte 2 DUP(?)
.code

main PROC

L1:

;taking the name of the inputfile
mov edx, offset msg1
call writestring
call crlf

mov edx, offset filename
mov ecx, sizeof filename
call readstring


;opening the input file
mov edx, offset filename
call OpenInputFile
mov filehandle, eax

;read from file
mov edx, offset buffer
mov ecx, BUFSIZE
call readfromfile

;Display the buffer
mov buffer[eax],0 
;As eax contains the number of bytes read,
;there will be a null character immediately following the string
mov edx, offset buffer
call writestring

call crlf
call crlf

;close filehandle
 mov eax, filehandle
 call closefile

;Breaking them down
 cld
 mov esi, offset buffer
 mov edi, offset currentChar
 movsb currentChar, buffer
 inc count
 add esi, 1
 inc count
 mov edi, offset currentnum
 movsb currentnum, buffer
 movsb [currentnum+1], buffer
 add count, 2
 mov al, currentchar
 mov highestchar, al
 invoke Str_copy, addr currentnum, addr highestnum

 ITERATE:
 cmp count, 52
 jge ENDOFTHELINE
 add esi, 4
 add count, 4
 mov edi, offset currentChar
 movsb currentChar, buffer
 add esi, 1
 add count, 2
 mov edi, offset currentnum
 movsb currentnum, buffer
 movsb [currentnum+1], buffer
 add count, 2
 invoke str_compare, addr currentnum, addr highestnum
 ;TODO(nvalev): Compare the highest number to the string 
 ;invoke str_compare, addr [currentline+3], addr highestnum
 ja CHANGEHIGHEST
 jmp ITERATE

CHANGEHIGHEST:
 mov al, currentchar
 mov highestchar, al
 invoke str_copy, addr currentnum, addr highestnum
 jmp ITERATE

ENDOFTHELINE:
 mov edx, offset highmsg
 call writestring
 mov al, highestchar
 call writechar
 call crlf
INVOKE ExitProcess, 0

main ENDP
END main