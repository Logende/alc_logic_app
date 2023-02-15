package main

import "fmt"

func generateConceptsB(nBasicConcepts int, nRoles int, nLevels int) []interface{} {
	// generate base concepts A, B, C, ..., TOP, BOTTOM
	var concepts []BaseConcept
	for i := 0; i < nBasicConcepts; i++ {
		concepts = append(concepts, BaseConcept{Name: conceptNameByIndex(i)})
	}
	concepts = append(concepts, BaseConcept{Name: "⊤"}, BaseConcept{Name: "⊥"})

	// generate roles r, s, ...
	var roles []Role
	for i := 0; i < nRoles; i++ {
		roles = append(roles, Role{Name: roleNameByIndex(i)})
	}

	// generate different formula combinations with placeholder concepts and roles
	combinations := generatePlaceholderConcepts(nLevels)
	return combinations
}

func generatePlaceholderConcepts(nLevels int) []interface{} {
	concepts := []BaseConcept{{Name: "?"}}
	roles := []Role{{Name: "?"}}

	// generate 2d array levels = concepts, lvl1, lvl2, ...
	level := make([]interface{}, len(concepts))
	for i, v := range concepts {
		level[i] = v
	}
	allConcepts := level

	for i := 1; i < nLevels; i++ {
		allConcepts, level = combineConceptsB(allConcepts, level, roles)
		fmt.Println("Finished lvl with ", len(level), " combinations")
	}
	return allConcepts
}

func combineConceptsB(allConcepts []interface{}, previousLevel []interface{}, roles []Role) ([]interface{}, []interface{}) {
	var level []interface{}

	for _, conceptA := range previousLevel {
		level = append(level, OperatorNegation{C: conceptA})

		for _, conceptB := range allConcepts {
			level = append(level, OperatorIntersection{A: conceptA, B: conceptB})
			level = append(level, OperatorUnion{A: conceptA, B: conceptB})
		}

		for _, role := range roles {
			level = append(level, QuantifierExists{R: role, C: conceptA})
			level = append(level, QuantifierForEach{R: role, C: conceptA})
		}
	}

	allConcepts = append(allConcepts, level...)
	return allConcepts, level
}
