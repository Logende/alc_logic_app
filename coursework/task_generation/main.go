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
		1,
		5, // todo: change to 0 as first levels are hardcoded
		44,
		70,
	}

	// fixed seed for deterministic results
	rand.Seed(7)

	var chosenConcepts []interface{}
	for complexity, count := range desiredCounts {
		options := conceptsByComplexity[complexity]
		countSatisfiable := count / 2
		countNonSatisfiable := count/2 + count%2
		chosenConcepts = append(chosenConcepts, pickRandomConcepts(options, countSatisfiable, countNonSatisfiable))
	}

	// for every desiredCounts elements, pick random object of index complexity
	// check if concept is satisfiable. Keep searching until half of desired elements is satisfiable and other half is not

	println(chosenConcepts)
	println(conceptsByComplexity)
	println(desiredCounts)

}

func pickRandomConcepts(options []interface{}, countSatisfiable int, countNonSatisfiable int) []interface{} {
	var result []interface{}

	// shuffle options ti get random order
	for i := range options {
		j := rand.Intn(i + 1)
		options[i], options[j] = options[j], options[i]
	}

	for i := 0; i < len(options) && (countSatisfiable > 0 || countNonSatisfiable > 0); i++ {
		pick := options[i]
		satisfiable := isSatisfiable(pick)

		if satisfiable && countSatisfiable > 0 {
			result = append(result, pick)
			countSatisfiable -= 1
		} else if !satisfiable && countNonSatisfiable > 0 {
			result = append(result, pick)
			countNonSatisfiable -= 1
		}
	}

	return result
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

func determineComplexity(concept interface{}) int {
	var result int

	switch concept.(type) {
	case BaseConcept:
		result = 0
		break
	case OperatorUnion:
		result = 1 + determineComplexity(concept.(OperatorUnion).A) + determineComplexity(concept.(OperatorUnion).B)
		break
	case OperatorIntersection:
		result = 1 + determineComplexity(concept.(OperatorIntersection).A) + determineComplexity(concept.(OperatorIntersection).B)
		break
	case OperatorNegation:
		result = 1 + determineComplexity(concept.(OperatorNegation).C)
		break
	case QuantifierForEach:
		result = 1 + determineComplexity(concept.(QuantifierForEach).C)
		break
	case QuantifierExists:
		result = 1 + determineComplexity(concept.(QuantifierExists).C)
		break
	}

	return result
}
