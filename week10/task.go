package main

import (
	"fmt"
	"math/rand"
	"os"
	"strconv"
)

const minDie = 1
const maxDie = 6
const possibleOutcomesCount = maxDie - minDie + 1

func main() {
	// the first argument is always program name
	userInput := os.Args[1]

	n, err := strconv.Atoi(userInput)
	if err != nil {
		panic(err)
	}
	var dice = Dice{}
	dice.equalDistr = false
	throwDicesAndPrintStatistics(dice, n)

	dice.resetStatistics()
	dice.equalDistr = true
	throwDicesAndPrintStatistics(dice, n)

}

func throwDicesAndPrintStatistics(d Dice, n int) {
	for i := 0; i <= n; i++ {
		d.throwDice()
	}
	fmt.Printf("sumStatistics: %v\n", d.sumStatistics)
}

type Dice struct {
	equalDistr     bool
	die            [2]int
	numberOfThrows int
	sumStatistics  [possibleOutcomesCount*2 - 1]int
}

func (d *Dice) throwDice() {
	if !d.equalDistr {
		d.die[0] = minDie + rand.Intn(possibleOutcomesCount)
		d.die[1] = minDie + rand.Intn(possibleOutcomesCount)
	} else {

		numberTotal := minDie*2 + rand.Intn(maxDie*2-minDie*2+1)
		var possibleCombinations [][2]int
		// This will go over all combinations and collect relevant ones
		for number1 := minDie; number1 <= maxDie; number1++ {
			for number2 := minDie; number2 <= maxDie; number2++ {
				if number1+number2 == numberTotal {
					possibleCombinations = append(possibleCombinations, [2]int{number1, number2})
				}
			}
		}
		var chosenCombinationIndex = rand.Intn(len(possibleCombinations))
		d.die = possibleCombinations[chosenCombinationIndex]
	}

	d.numberOfThrows++

	var sum = d.die[0] + d.die[1]
	d.sumStatistics[sum-minDie-1] += 1
}

func (d *Dice) resetStatistics() {
	d.numberOfThrows = 0
	for i := 0; i < len(d.sumStatistics); i++ {
		d.sumStatistics[i] = 0
	}
}
