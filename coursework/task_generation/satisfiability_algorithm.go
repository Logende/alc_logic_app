package main

func isSatisfiable(concept interface{}) bool {
	// convert to NNF
	concept = BNF2NNF(concept)
	tableaus := Tableau{
		elementConcepts: []interface{}{},
		clash:           false,
	}.computeSatisfiability(concept)

	for _, tableau := range tableaus {
		if !tableau.clash {
			return true
		}
	}

	return false
}

type Tableau struct {
	elementConcepts []interface{}
	clash           bool
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

	case OperatorUnion:
		// it is possible that computation of satisfiability of A leads to multiple tableaus
		// therefore, for every outcoming tableau, compute satisfiability with B and then return all combinations
		subTableaus := t.computeSatisfiability(concept.(OperatorUnion).A)
		for _, tableau := range subTableaus {
			tableaus = append(tableaus, tableau.computeSatisfiability(concept.(OperatorUnion).B)...)
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

	case OperatorIntersection:
		tableauA := Tableau{
			// should be copy because not using pointer
			elementConcepts: t.elementConcepts,
			clash:           t.clash,
		}
		tableauB := Tableau{
			// should be copy because not using pointer
			elementConcepts: t.elementConcepts,
			clash:           t.clash,
		}
		tableaus = append(tableaus, tableauA.computeSatisfiability(concept.(OperatorIntersection).A)...)
		tableaus = append(tableaus, tableauB.computeSatisfiability(concept.(OperatorIntersection).B)...)
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
