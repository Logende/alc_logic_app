package main

import "fmt"

func generateConcepts(nBasicConcepts int, nRoles int, nLevels int) []interface{} {

	// generate base concepts A, B, Concept, ..., TOP, BOTTOM
	var concepts []interface{}
	for i := 0; i < nBasicConcepts; i++ {
		concepts = append(concepts, BaseConcept{Name: conceptNameByIndex(i)})
	}
	concepts = append(concepts, BaseConcept{Name: "⊤"}, BaseConcept{Name: "⊥"})

	// generate roles r, s, ...
	var roles []Role
	for i := 0; i < nRoles; i++ {
		roles = append(roles, Role{Name: roleNameByIndex(i)})
	}

	level := concepts
	for i := 1; i < nLevels; i++ {
		level = combineConcepts(level, roles)
		fmt.Println("Finished lvl with ", len(level), " combinations")
	}
	return level
}

func combineConcepts(previousLevel []interface{}, roles []Role) []interface{} {
	var level []interface{}

	for i := 0; i < len(previousLevel); i++ {
		conceptA := previousLevel[i]
		level = append(level, conceptA)
		level = append(level, OperatorNegation{C: conceptA})

		for j := i + 1; j < len(previousLevel); j++ {
			conceptB := previousLevel[j]
			level = append(level, OperatorIntersection{A: conceptA, B: conceptB})
			level = append(level, OperatorUnion{A: conceptA, B: conceptB})
		}

		for _, role := range roles {
			level = append(level, QuantifierExists{R: role, C: conceptA})
			level = append(level, QuantifierForEach{R: role, C: conceptA})
		}
	}

	return level
}
