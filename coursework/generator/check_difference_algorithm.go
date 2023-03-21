package main

import "reflect"

func isFunctionallyEqual(conceptA interface{}, conceptB interface{}) bool {
	normalizedA := normalizeConcept(conceptA)
	normalizedB := normalizeConcept(conceptB)
	return reflect.DeepEqual(normalizedA, normalizedB)
}

func normalizeConcept(concept interface{}) interface{} {
	mapping := map[string]string{
		"⊥": "⊥",
		"⊤": "⊤",
	}
	idCounter := 0

	normalizedConcept, _ := normalizeConceptStep(concept, mapping, idCounter)
	return normalizedConcept
}

func normalizeConceptStep(concept interface{}, mapping map[string]string, idCounter int) (interface{}, int) {
	switch concept.(type) {
	case BaseConcept:
		normalizedName, idCounter := normalizeName(concept.(BaseConcept).Name, mapping, idCounter)
		return BaseConcept{Name: normalizedName}, idCounter

	case OperatorNegation:
		normalizedConcept, idCounter := normalizeConceptStep(concept.(OperatorNegation).C, mapping, idCounter)
		return OperatorNegation{C: normalizedConcept}, idCounter

	case OperatorUnion:
		normalizedConceptA, idCounter := normalizeConceptStep(concept.(OperatorUnion).A, mapping, idCounter)
		normalizedConceptB, idCounter := normalizeConceptStep(concept.(OperatorUnion).B, mapping, idCounter)
		return OperatorUnion{A: normalizedConceptA, B: normalizedConceptB}, idCounter

	case OperatorIntersection:
		normalizedConceptA, idCounter := normalizeConceptStep(concept.(OperatorIntersection).A, mapping, idCounter)
		normalizedConceptB, idCounter := normalizeConceptStep(concept.(OperatorIntersection).B, mapping, idCounter)
		return OperatorIntersection{A: normalizedConceptA, B: normalizedConceptB}, idCounter

	case QuantifierExists:
		normalizedConcept, idCounter := normalizeConceptStep(concept.(QuantifierExists).C, mapping, idCounter)
		normalizedRoleName, idCounter := normalizeName(concept.(QuantifierExists).R.Name, mapping, idCounter)
		return QuantifierExists{
			R: Role{Name: normalizedRoleName},
			C: normalizedConcept,
		}, idCounter

	case QuantifierForEach:
		normalizedConcept, idCounter := normalizeConceptStep(concept.(QuantifierForEach).C, mapping, idCounter)
		normalizedRoleName, idCounter := normalizeName(concept.(QuantifierForEach).R.Name, mapping, idCounter)
		return QuantifierForEach{
			R: Role{Name: normalizedRoleName},
			C: normalizedConcept,
		}, idCounter

	default:
		panic("unknown concept type ")
	}

}

func normalizeName(originalName string, mapping map[string]string, idCounter int) (string, int) {
	val, ok := mapping[originalName]
	if ok {
		return val, idCounter
	} else {
		return conceptNameByIndex(idCounter), idCounter + 1
	}
}
