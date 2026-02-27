#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//Default Port constants
#define PUERTO_LOG_DEFECTO 0x86
#define PUERTO_SALIDA_DEFECTO 0x80
#define PUERTO_ENTRADA_DEFECTO 0x81

//Varaible Ports
short logPort = PUERTO_LOG_DEFECTO;
short outPort = PUERTO_SALIDA_DEFECTO;
short inPort = PUERTO_ENTRADA_DEFECTO;

//Requirements For Stack Imlementation
#define STACK_SIZE 31
short stack[STACK_SIZE];
short stackPointer = 0;

//Extra Variables
short command = 0;

//Function Prototypes
void GetNumber();
void ChangeOutPort();
void ChangeLogPort();
void ShowTopOfStack();
void ShowFullStack();
void DuplicateTopOfStack();
void SwapTopOfStack();
void NegateTopOfStack();
short RecursiveFactorial(short);
void FactorialTopOfStack();
void SumFullStack();
void addition();
void subtraction();
void Product();
void Division();
void Modulus();
void AndBB();
void OrBB();
void LeftShift();
void RightShift();
void Clear();
void Halt();
void Errors(short);

//Main Function
int main () {

	short cero = 0;
	//Main Loop
	while(1) {
		fprintf(logPort, "%hd", cero);
		fscanf(inPort, "%hd", &command);
		fprintf(logPort, "%hd", command);
		switch (command) {
			case 1:
				GetNumber();
				break;
			case 2:
				ChangeOutPort();
				break;
			case 3:
				ChangeLogPort();
				break;
			case 4:
				ShowTopOfStack();
				break;
			case 5:
				ShowFullStack();
				break;
			case 6:
				DuplicateTopOfStack();
				break;
			case 7:
				SwapTopOfStack();
				break;
			case 8:
				NegateTopOfStack();
				break;
			case 9:
				FactorialTopOfStack();
				break;
			case 10:
				SumFullStack();
				break;
			case 11:
				addition();
				break;
			case 12:
				subtraction();
				break;
			case 13:
				Product();
				break;
			case 14:
				Division();
				break;
			case 15:
				Modulus();
				break;
			case 16:
				AndBB();
				break;
			case 17:
				OrBB();
				break;
			case 18:
				LeftShift();
				break;
			case 19:
				RightShift();
				break;
			case 254:
				Clear();
				break;
			case 255:
				Halt();
				break;
			default:
				Errors(2);
				break;
		}
	}

}

//Function Definitions
void GetNumber() {

	short number = 0;

	fscanf(inPort, "%hd", &number);
	fprintf(logPort, "%hd", number);

	if (stackPointer < STACK_SIZE) {
		stack[stackPointer] = number;
		stackPointer++;
		Errors(16);
	} else {
		Errors(4);
	}

}

void ChangeOutPort() {

	short newPort = 0;

	fscanf(inPort, "%hd", &newPort);
	fprintf(logPort, "%hd", newPort);

	outPort = newPort;

	Errors(16);

}

void ChangeLogPort() {

	short newPort = 0;

	fscanf(inPort, "%hd", &newPort);
	fprintf(logPort, "%hd", newPort);

	logPort = newPort;

	Errors(16);

}

void ShowTopOfStack() {

	if (stackPointer > 0) {
		fprintf(outPort, "%hd", stack[stackPointer - 1]);
	} else {
		Errors(8);
	}

}

void ShowFullStack() {

	short i = 0;

	if (stackPointer > 0) {
		for (i = stackPointer-1; i >= 0; i--) {
			fprintf(outPort, "%hd", stack[i]);
		}
	} else {
		Errors(8);
	}

}

void DuplicateTopOfStack() {

	if (stackPointer > 0) {
		if (stackPointer < STACK_SIZE) {
			stack[stackPointer] = stack[stackPointer - 1];
			stackPointer++;
			Errors(16);
		} else {
			Errors(4);
		}
	} else {
		Errors(8);
	}

}

void SwapTopOfStack() {

	short temp = 0;

	if (stackPointer > 1) {
		temp = stack[stackPointer - 1];
		stack[stackPointer - 1] = stack[stackPointer - 2];
		stack[stackPointer - 2] = temp;
		Errors(16);
	} else {
		Errors(8);
	}

}

void NegateTopOfStack() {

	if (stackPointer > 0) {
		stack[stackPointer - 1] = stack[stackPointer - 1] * -1;
		Errors(16);
	} else {
		Errors(8);
	}

}

short RecursiveFactorial(short number) {

	if (number == 0) {
		return 1;
	} else {
		return number * RecursiveFactorial(number - 1);
	}

}

void FactorialTopOfStack() {

	short number = 0;

	if (stackPointer > 0) {
		number = stack[stackPointer - 1];
		stack[stackPointer - 1] = RecursiveFactorial(number);
		Errors(16);
	} else {
		Errors(8);
	}

}

void SumFullStack() {

	short sum = 0;

	if (stackPointer > 0) {
		while (stackPointer > 0) {
			sum += stack[stackPointer - 1];
			stackPointer--;
		}
		stack[stackPointer] = sum;
		stackPointer++;
		Errors(16);
	} else {
		Errors(8);
	}

}

void addition() {

	short number1 = 0;
	short number2 = 0;

	if (stackPointer > 1) {
		number1 = stack[stackPointer - 1];
		number2 = stack[stackPointer - 2];
		stack[stackPointer - 2] = number1 + number2;
		stackPointer--;
		Errors(16);
	} else {
		Errors(8);
	}

}

void subtraction() {

	short number1 = 0;
	short number2 = 0;

	if (stackPointer > 1) {
		number1 = stack[stackPointer - 1];
		number2 = stack[stackPointer - 2];
		stack[stackPointer - 2] = number2 - number1;
		stackPointer--;
		Errors(16);
	} else {
		Errors(8);
	}

}

void Product() {

	short number1 = 0;
	short number2 = 0;

	if (stackPointer > 1) {
		number1 = stack[stackPointer - 1];
		number2 = stack[stackPointer - 2];
		stack[stackPointer - 2] = number1 * number2;
		stackPointer--;
		Errors(16);
	} else {
		Errors(8);
	}

}

void Division() {

	short number1 = 0;
	short number2 = 0;

	if (stackPointer > 1) {
		number1 = stack[stackPointer - 1];
		number2 = stack[stackPointer - 2];
		stack[stackPointer - 2] = number2 / number1;
		stackPointer--;
		Errors(16);
	} else {
		Errors(8);
	}

}

void Modulus() {

	short number1 = 0;
	short number2 = 0;

	if (stackPointer > 1) {
		number1 = stack[stackPointer - 1];
		number2 = stack[stackPointer - 2];
		stack[stackPointer - 2] = number2 % number1;
		stackPointer--;
		Errors(16);
	} else {
		Errors(8);
	}

}

void AndBB() {

	short number1 = 0;
	short number2 = 0;

	if (stackPointer > 1) {
		number1 = stack[stackPointer - 1];
		number2 = stack[stackPointer - 2];
		stack[stackPointer - 2] = number1 & number2;
		stackPointer--;
		Errors(16);
	} else {
		Errors(8);
	}

}

void OrBB() {

	short number1 = 0;
	short number2 = 0;

	if (stackPointer > 1) {
		number1 = stack[stackPointer - 1];
		number2 = stack[stackPointer - 2];
		stack[stackPointer - 2] = number1 | number2;
		stackPointer--;
		Errors(16);
	} else {
		Errors(8);
	}

}

void leftShift() {

	short number1 = 0;
	short number2 = 0;

	if (stackPointer > 1) {
		number1 = stack[stackPointer - 1];
		number2 = stack[stackPointer - 2];
		stack[stackPointer - 2] = number2 << number1;
		stackPointer--;
		Errors(16);
	} else {
		Errors(8);
	}

}

void rightShift() {

	short number1 = 0;
	short number2 = 0;

	if (stackPointer > 1) {
		number1 = stack[stackPointer - 1];
		number2 = stack[stackPointer - 2];
		stack[stackPointer - 2] = number2 >> number1;
		stackPointer--;
		Errors(16);
	} else {
		Errors(8);
	}

}

void clear() {

	stackPointer = 0;
	Errors(16);

}

void halt() {

	Errors(16);
	while(1) {}

}

void Errors(short error) {

	fprintf(logPort, "%hd", error);

}
