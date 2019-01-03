@ File: HJohnsey413Lab2.s

@ Author: Hayley Johnsey
@ Description: Plastic Utensil Factory (ARM Lab Assignment 2)
@ Date: 9-14-18

@ Use these commands to assemble, link, and run this program

@   as -o HJohnsey413Lab2.o HJohnsey413Lab2.s
@   gcc -o HJohnsey413Lab2 HJohnsey413Lab2.o
@   ./HJohnsey413Lab2 ;echo $?

.global main

main:

@Program prompts the user for the utensil to make and run until the user quits or runs out of the plastic to make a minimum batch. After each batch print the total number of each type of utensil made and the amount of plastic left in the vats.
@Polypropylene vat starts out with 50 kg and the polystyrene vat starts out with 75 kg

@ Utensil   Polypropylene   Polystyrene   Number in One Batch
@ Fork      120 g           120 g         40
@ Spoon     100 g           60 g          40
@ Knife     140 g           160 g         60
@ Spork     90 g            110 g         50

@ Checks user inputs for errors and print appropriate error messages
@ Has all outputs clearly labeled

initialize:
  ldr r4, =#50000   @Polypropylene vat starts at 50 kg (50000 g)
  ldr r5, =#75000   @Polystyrene vat starts at 75 kg (75000 g)

  mov r8, #0       @Initialize number of forks to 0
  mov r9, #0       @Initialize number of spoons to 0
  mov r10, #0      @Initialize number of knives to 0
  mov r11, #0      @Initialize number of sporks to 0

@Ask user to enter a utensil type to make and run
userprompt:
  ldr r0, =struserprompt  @load r0 with struserprompt message
  bl printf               @print struserprompt message
  ldr r0, =struserprompt2 @load r0 with struserprompt2 message
  bl printf               @print struserprompt2 message

@Scan for input
promptinput:
  ldr r0, =numinputpattern   @Setup to read in a number
  sub sp, sp, #4             @Update stack pointer to new location
    mov r1, sp                 @Put address into r1 for read
    bl scanf                   @Scan the keyboard
    ldr r1, [sp, #0]           @The number is on the stack
  add sp, sp, #4               @Reset the stack

saveinputandcmp:
  mov r6, r1        @Move the contents of r1 (user input) to r3

  cmp r6, #1        @Compare the contents of r6 to 1
  beq forks         @If [r6]==1 branch to forks
  cmp r6, #2        @Compare the contents of r6 to 2
  beq spoons        @If [r6]==2 branch to spoons
  cmp r6, #3        @Compare the contents of r6 to 3
  beq knives        @If [r6]==3 branch to knives
  cmp r6, #4        @Compare the contents of r6 to 4
  beq sporks        @If [r6]==4 branch to sporks
  cmp r6, #0x51     @Compare the contents of r6 to 'Q'
  beq quit          @If [r6]=='Q' branch to quit
  cmp r6, #0x71     @Compare the contents of r6 to 'q'
  beq quit          @If [r6]=='q' branch to quit
  bne invalid       @If [r6]!=1, 2, 3, 4 or q/Q then branch to invalid for input error message

forks:
  cmp r4, #120      @Compare contents of r4 to 120
  blt forkerror     @If less than 120 branch to forkerror
  cmp r5, #120      @Compare contents of r5 to 120
  blt forkerror     @If less than 120 branch to forkerror

  add r8, r8, #40   @Add 40 to the number of forks made (a batch)
  sub r4, r4, #120  @Subtract 120 g of polypropylene from total (a batch)
  sub r5, r5, #120  @Subtract 120 g of polystyrene from total (a batch)
  b printstats      @Branch to printstats

forkerror:
  ldr r0, =forkerroroutput    @Get ready to print forkerroroutput
  bl printf                   @Print forkerroroutput

spoons:
  cmp r4, #100      @Compare contents of r4 to 100
  blt spoonerror     @If less than 100 branch to spoonerror
  cmp r5, #60      @Compare contents of r5 to 60
  blt spoonerror     @If less than 120 branch to spoonerror

  add r9, r9, #40   @Add 40 to the number of spoons made (a batch)
  sub r4, r4, #100  @Subtract 100 g of polypropylene from total (a batch)
  sub r5, r5, #60   @Subtract 60 g of polystyrene from total (a batch)
  b printstats      @Branch to printstats

spoonerror:
  ldr r0, =spoonerroroutput   @Get ready to print spoonerroroutput
  bl printf                   @Print spoonerroroutput

knives:
  cmp r4, #140      @Compare contents of r4 to 140
  blt knifeerror    @If less than 140 branch to knifeerror
  cmp r5, #160      @Compare contents of r5 to 160
  blt knifeerror    @If less than 160 branch to knifeerror

  add r10, r10, #60   @Add 60 to the number of knives made (a batch)
  sub r4, r4, #140    @Subtract 140 g of polypropylene from total (a batch)
  sub r5, r5, #160    @Subtract 160 g of polystyrene from total (a batch)
  b printstats        @Branch to printstats

knifeerror:
  ldr r0, =knifeerroroutput     @Get ready to print knifeerroroutput
  bl printf                     @Print knifeerroroutput

sporks:
  cmp r4, #90       @Compare contents of r4 to 90
  blt sporkerror    @If less than 90 branch to sporkerror
  cmp r5, #110      @Compare contents of r5 to 110
  blt sporkerror    @If less than 110 branch to sporkerror

  add r11, r11, #50   @Add 50 to the number of sporks made (a batch)
  sub r4, r4, #90     @Subtract 90 g of polypropylene from total (a batch)
  sub r5, r5, #110    @Subtract 110 g of polystyrene from total (a batch)
  b printstats

sporkerror:
  ldr r0, =sporkerroroutput   @Get ready to print sporkerroroutput
  bl printf                   @Print sporkerroroutput

printstats:
  mov r1, r8                  @Move r8 contents to r1
  ldr r0, =forkoutputpattern   @Get ready to print
  bl printf                   @Print number of forks made so far

  mov r1, r9                  @Move r9 contents to r1
  ldr r0, =spoonoutputpattern   @Get ready to print
  bl printf                   @Print number of spoons made so far

  mov r1, r10                 @Move r10 contents to r1
  ldr r0, =knifeoutputpattern   @Get ready to print
  bl printf                   @Print number of knives made so far

  mov r1, r11                 @Move r11 contents to r1
  ldr r0, =sporkoutputpattern   @Get ready to print
  bl printf                   @Print number of sporks made so far

  mov r1, r4                  @Move r4 contents to r1
  ldr r0, =plastic1output       @Get ready to print
  bl printf                   @Print grams of polypropylene left

  mov r1, r5                  @Move r5 contents to r1
  ldr r0, =plastic2output       @Get ready to print
  bl printf                   @Print grams of polystyrene left

  b plasticcheck              @Branch to plasticcheck

plasticcheck:
  cmp r4, #90           @Compare contents of r4 with 90
  blt outofplastic1     @If r4 contents is less than 90 branch to outofplastic1
  cmp r5, #60           @Compare contents of r5 with 60
  blt outofplastic2     @If r5 contents is less then 60 branch to outofplastic2

  b userprompt      @Branch to userprompt otherwise

invalid:
  ldr r0, =strinvalidinput    @Load r0 with invalidinput message
  bl printf                   @Print invalidinput message
  b userprompt                @Branch to userprompt

outofplastic1:
  cmp r5, #60               @Compare r5 contents with 60
  blt outofboth             @This means out of both plastic; branch to outofboth

  ldr r0, =outof1output     @Get ready to print outof1output
  bl printf                 @Print outof1output
  b quit                    @Branch to quit

outofplastic2:
  ldr r0, =outof2output     @Get ready to print outof2output
  bl printf                 @Print outof2output
  b quit                    @Branch to quit

outofboth:
  ldr r0, =outofbothoutput  @Get ready to print outofbothoutput
  bl printf                 @Print outofbothoutput
  b quit                    @Branch to quit

quit:
  ldr r0, =strquitmessage   @Load r0 with strquitmessage
  bl printf                 @Print strquitmessage
  b myexit                  @Branch to exit code

myexit:

  mov r7, #0x01 @SVC call to exit

  svc 0         @Make the system call

.data
@ Declare the strings and data needed

.balign 4
struserprompt: .asciz "Enter 1 to make a batch of forks, 2 to make spoons, 3 to make knives, and 4 to make sporks.\n"

.balign 4
struserprompt2: .asciz "Enter Q or q to quit.\n"

.balign 4
numinputpattern: .asciz "%d"

.balign 4
forkerroroutput: .asciz "You do not have enough plastic to make a batch of forks.\n"

.balign 4
spoonerroroutput: .asciz "You do not have enough plastic to make a batch of spoons.\n"

.balign 4
knifeerroroutput: .asciz "You do not have enough plastic to make a batch of knives.\n"

.balign 4
sporkerroroutput: .asciz "You do not have enough plastic to make a batch of sporks.\n"

.balign 4
forkoutputpattern: .asciz "%d forks have been made.\n"

.balign 4
spoonoutputpattern: .asciz "%d spoons have been made.\n"

.balign 4
knifeoutputpattern: .asciz "%d knives have been made.\n"

.balign 4
sporkoutputpattern: .asciz "%d sporks have been made.\n"

.balign 4
plastic1output: .asciz "There are %d grams left of polypropylene.\n"

.balign 4
plastic2output: .asciz "There are %d grams left of polystyrene.\n"

.balign 4
outof1output: .asciz "There is not enough polypropylene to make another batch.\n"

.balign 4
outof2output: .asciz "There is not enough polystyrene to make another batch.\n"

.balign 4
outofbothoutput: .asciz "There is not enough polypropylene or polystyrene to make another batch.\n"

.balign 4
strinvalidinput: .asciz "You have entered an invalid input.\n"

.balign 4
strquitmessage: .asciz "Exiting the program.\n"

.global printf
.global scanf

@end of code
