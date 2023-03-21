package main

import (
	"fmt"
	"math/rand"
)

func main() {

	// number of basic concepts like A, B, C, D, E to use for task generation
	nBasicConcepts := 3

	// number of roles to use for task generation
	nRoles := 2

	// use algorithm generateConceptsA to generate complex concepts based on the given input.
	// the algorithm will take all concepts it currently has and apply all the different operators (negation, union,
	// intersection, quantifiers) on them. For binary operators, it will combine two of the existing concepts.
	// This is repeated nLevels times. With every iteration, the resulting concepts get more complex and longer.
	concepts := generateConceptsA(nBasicConcepts, nRoles, 4)
	fmt.Println("concept count: ", len(concepts))

	// group concepts by complexity (i.e. operator count)
	conceptsByComplexity := groupConceptsByComplexity(concepts)

	// definition of how many concepts we would like to pick for a given complexity
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

		// when choosing tasks: how do we want them to be like?
		// half of them should be satisfiable
		countSatisfiable := count / 2
		// the rest should be non-satisfiable
		countNonSatisfiable := count/2 + count%2
		// we limit the amount of concepts that include top or bottom to one third
		maxCountWithTopBottom := count / 3
		chosenTasks = append(chosenTasks, pickRandomTasks(options, countSatisfiable, countNonSatisfiable,
			maxCountWithTopBottom)...)
	}

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
				Concept:     pick,
				Satisfiable: satisfiable,
				Complexity:  determineComplexity(pick),
			})
			countSatisfiable -= 1
			fmt.Println("chose satisfiable formula ", toString(pick))
		} else if !satisfiable && countNonSatisfiable > 0 {
			result = append(result, Task{
				Concept:     pick,
				Satisfiable: satisfiable,
				Complexity:  determineComplexity(pick),
			})
			countNonSatisfiable -= 1
			fmt.Println("chose non-satisfiable formula ", toString(pick))
		}
	}

	return result
}

func isFunctionallyEqualTaskContained(tasks []Task, concept interface{}) bool {
	for _, task := range tasks {
		if isFunctionallyEqual(concept, task.Concept) {
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
