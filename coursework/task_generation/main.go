package main

import (
	"fmt"
	"math/rand"
)

func main() {

	nBasicConcepts := 3
	nRoles := 2

	concepts := generateConceptsA(nBasicConcepts, nRoles, 4)
	fmt.Println("concept count: ", len(concepts))

	conceptsByComplexity := groupConceptsByComplexity(concepts)

	desiredCounts := []int{
		2, // complexity 0 -> just one base concept such as A or bottom or top
		5, // complexity 1 -> concepts such as neg(A) or A AND B or EXISTS ROLE R for BOTTOM
		30,
		30,
		30,
		30,
		30,
		50,
	}

	// fixed seed for deterministic results
	rand.Seed(7)

	var chosenTasks []Task
	for complexity, count := range desiredCounts {
		options := conceptsByComplexity[complexity]
		countSatisfiable := count / 2
		countNonSatisfiable := count/2 + count%2
		maxCountWithTopBottom := count / 3
		chosenTasks = append(chosenTasks, pickRandomTasks(options, countSatisfiable, countNonSatisfiable,
			maxCountWithTopBottom)...)
	}

	// for every desiredCounts elements, pick random object of index complexity
	// check if concept is satisfiable. Keep searching until half of desired elements is satisfiable and other half is not

	println(chosenTasks)
	println(conceptsByComplexity)
	println(desiredCounts)

	exportAsYAML(TaskList{Tasks: chosenTasks}, "tasks.yml")

}

func pickRandomTasks(options []interface{}, countSatisfiable int, countNonSatisfiable int,
	maxCountWithTopBottom int) []Task {
	var result []Task

	// shuffle options ti get random order
	for i := range options {
		j := rand.Intn(i + 1)
		options[i], options[j] = options[j], options[i]
	}

	for i := 0; i < len(options) && (countSatisfiable > 0 || countNonSatisfiable > 0); i++ {
		pick := options[i]

		if isFunctionallyEqualTaskContained(result, pick) {
			continue
		}

		satisfiable := isSatisfiable(pick)
		containsTopOrBottom := containsBaseConcept(pick, "⊥") || containsBaseConcept(pick, "⊤")

		if containsTopOrBottom {
			if maxCountWithTopBottom > 0 {
				maxCountWithTopBottom -= 1
			} else {
				continue
			}
		}

		if satisfiable && countSatisfiable > 0 {
			result = append(result, Task{
				Concept:     toString(pick),
				Satisfiable: satisfiable,
				Complexity:  determineComplexity(pick),
				C:           pick,
			})
			countSatisfiable -= 1
			fmt.Println("chose satisfiable formula ", toString(pick))
		} else if !satisfiable && countNonSatisfiable > 0 {
			result = append(result, Task{
				Concept:     toString(pick),
				Satisfiable: satisfiable,
				Complexity:  determineComplexity(pick),
				C:           pick,
			})
			countNonSatisfiable -= 1
			fmt.Println("chose non-satisfiable formula ", toString(pick))
		}
	}

	return result
}

func isFunctionallyEqualTaskContained(tasks []Task, concept interface{}) bool {
	for _, task := range tasks {
		if isFunctionallyEqual(concept, task.C) {
			return true
		}
	}

	return false
}

func groupConceptsByComplexity(concepts []interface{}) [][]interface{} {
	var result [][]interface{}

	for _, concept := range concepts {
		complexity := determineComplexity(concept)

		for len(result) <= complexity {
			var complexityElements []interface{}
			result = append(result, complexityElements)
		}

		result[complexity] = append(result[complexity], concept)
	}

	return result
}
