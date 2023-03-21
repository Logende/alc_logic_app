package main

func isSatisfiable(concept interface{}) bool {
	// convert to NNF
	concept = BNF2NNF(concept)

	tableaus := []Tableau{
		Tableau{
			elementConcepts: []interface{}{},
			clash:           false,
			relationships:   []Relationship{},
			awaitingForEach: []QuantifierForEach{},
		},
	}
	tableaus = completeSatisfiabilityAlgorithm(tableaus, concept)
	return hasSolutionWithoutClash(tableaus)
}

type Tableau struct {
	elementConcepts []interface{}
	clash           bool
	relationships   []Relationship
	awaitingForEach []QuantifierForEach
}

type Relationship struct {
	role                 Role
	otherConceptTableaus []Tableau
}

func completeSatisfiabilityAlgorithm(tableaus []Tableau, concept interface{}) []Tableau {
	tableaus = computeSatisfiability(tableaus, concept)

	var resultingTableaus []Tableau
	for _, tableau := range tableaus {
		if len(tableau.awaitingForEach) > 0 {
			tableau.applyQuantifierForEachRule()
			tableau.awaitingForEach = nil
		}
		resultingTableaus = append(resultingTableaus, tableau)
	}
	tableaus = resultingTableaus

	return tableaus
}

func (t Tableau) applyQuantifierForEachRule() {
	for _, concept := range t.awaitingForEach {
		for _, relationship := range t.relationships {
			if relationship.role == concept.R {
				relationship.otherConceptTableaus = completeSatisfiabilityAlgorithm(relationship.otherConceptTableaus, concept.C)
			}
		}
	}

}

func hasSolutionWithoutClash(tableaus []Tableau) bool {
	for _, tableau := range tableaus {
		if !tableau.clash {

			if len(tableau.relationships) > 0 {
				for _, relationship := range tableau.relationships {
					if hasSolutionWithoutClash(relationship.otherConceptTableaus) {
						return true
					}
				}
			} else {
				return true
			}
		}
	}
	return false
}

func computeSatisfiability(tableaus []Tableau, concept interface{}) []Tableau {
	var result []Tableau

	for _, tableau := range tableaus {
		result = append(result, tableau.computeSatisfiability(concept)...)
	}

	return result
}

func (t Tableau) computeSatisfiability(concept interface{}) []Tableau {
	var tableaus []Tableau

	switch concept.(type) {
	case BaseConcept:
		t.elementConcepts = append(t.elementConcepts, concept.(BaseConcept))
		if concept.(BaseConcept).Name == "⊥" || containsClashWithNewBaseConcept(t.elementConcepts, concept.(BaseConcept)) {
			t.clash = true
		}
		tableaus = []Tableau{t}
		break

	case OperatorNegation:
		t.elementConcepts = append(t.elementConcepts, concept.(OperatorNegation))
		if concept.(OperatorNegation).C.(BaseConcept).Name == "⊤" || containsClashWithNewNegation(t.elementConcepts, concept.(OperatorNegation)) {
			t.clash = true
		}
		tableaus = []Tableau{t}
		break

	case OperatorIntersection:
		// it is possible that computation of satisfiability of A leads to multiple tableaus
		// therefore, for every outcoming tableau, compute satisfiability with B and then return all combinations
		subTableaus := t.computeSatisfiability(concept.(OperatorIntersection).A)
		for _, tableau := range subTableaus {
			tableaus = append(tableaus, tableau.computeSatisfiability(concept.(OperatorIntersection).B)...)
		}
		// if any outcoming tableau should be without clash, that means there is a solution with A combined with B
		// that has no clash
		someSuccess := false
		for _, tableau := range tableaus {
			if !tableau.clash {
				someSuccess = true
			}
		}
		if !someSuccess {
			t.clash = true
		}
		break

	case OperatorUnion:
		tableauA := Tableau{
			// should be copy because not using pointer
			elementConcepts: t.elementConcepts,
			clash:           t.clash,
			relationships:   t.relationships,
		}
		tableauB := Tableau{
			// should be copy because not using pointer
			elementConcepts: t.elementConcepts,
			clash:           t.clash,
			relationships:   t.relationships,
		}
		tableaus = append(tableaus, tableauA.computeSatisfiability(concept.(OperatorUnion).A)...)
		tableaus = append(tableaus, tableauB.computeSatisfiability(concept.(OperatorUnion).B)...)
		break

	case QuantifierExists:
		otherConceptTableau := Tableau{
			elementConcepts: []interface{}{},
			clash:           false,
			relationships:   []Relationship{},
			awaitingForEach: []QuantifierForEach{},
		}
		relationship := Relationship{
			role:                 concept.(QuantifierExists).R,
			otherConceptTableaus: otherConceptTableau.computeSatisfiability(concept.(QuantifierExists).C),
		}

		t.relationships = append(t.relationships, relationship)
		tableaus = []Tableau{t}
		break

	case QuantifierForEach:
		// quantifierForEach we keep until the end. Only after having done everything else (including quantifierExists),
		// do we go over quantifierForEach and check if they apply on all relationships
		t.awaitingForEach = append(t.awaitingForEach, concept.(QuantifierForEach))
		tableaus = []Tableau{t}
		break

	}

	return tableaus
}

func containsClashWithNewBaseConcept(elementConcepts []interface{}, newElement BaseConcept) bool {
	for _, concept := range elementConcepts {
		switch concept.(type) {
		case OperatorNegation:
			if concept.(OperatorNegation).C == newElement {
				return true
			}
		}
	}
	return false
}

func containsClashWithNewNegation(elementConcepts []interface{}, newElement OperatorNegation) bool {
	for _, concept := range elementConcepts {
		switch concept.(type) {
		case BaseConcept:
			if concept == newElement.C {
				return true
			}
		}
	}
	return false
}
