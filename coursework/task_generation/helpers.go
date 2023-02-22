package main

func conceptNameByIndex(i int) string {
	return string(rune('A' + i))
}

func roleNameByIndex(i int) string {
	return string(rune('r' + i))
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

func containsBaseConcept(concept interface{}, conceptName string) bool {
	baseConcepts := extractBaseConcepts(concept)
	for _, baseConcept := range baseConcepts {
		if baseConcept.Name == conceptName {
			return true
		}
	}
	return false
}

func extractBaseConcepts(concept interface{}) []BaseConcept {
	var result []BaseConcept

	switch concept.(type) {
	case BaseConcept:
		result = append(result, concept.(BaseConcept))
		break
	case OperatorUnion:
		result = append(result, extractBaseConcepts(concept.(OperatorUnion).A)...)
		result = append(result, extractBaseConcepts(concept.(OperatorUnion).B)...)
		break
	case OperatorIntersection:
		result = append(result, extractBaseConcepts(concept.(OperatorIntersection).A)...)
		result = append(result, extractBaseConcepts(concept.(OperatorIntersection).B)...)
		break
	case OperatorNegation:
		result = append(result, extractBaseConcepts(concept.(OperatorNegation).C)...)
		break
	case QuantifierForEach:
		result = append(result, extractBaseConcepts(concept.(QuantifierForEach).C)...)
		break
	case QuantifierExists:
		result = append(result, extractBaseConcepts(concept.(QuantifierExists).C)...)
		break
	}

	return result
}
