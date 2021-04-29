package main

import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	fmt.Println("Hello, User!")
	a := InputNumber("Enter numerator:")
	b := InputNumber("Enter denominator:")
	g := Gcd(a, b)
	fmt.Printf("Result: %d/%d", a/g, b/g)
}

func Gcd(a, b int) int {
	if a == 0 {
		return b
	}
	return Gcd(b%a, b)
}

func InputNumber(promt string) int {
	fmt.Println(promt)
	str := ""
	_, err := fmt.Scanln(&str)
	if err != nil {
		fmt.Println("Error")
		os.Exit(-1)
	}
	num, err := strconv.Atoi(str)
	if err != nil {
		fmt.Println("Nem számot adtál meg!")
		return InputNumber(promt)
	}
	return num
}
