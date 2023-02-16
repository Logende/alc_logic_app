package main

// taken from https://logic4free.informatik.uni-kiel.de/llocs/Negation_normal_form
func negNNF(concept interface{}) interface{} {
	switch concept.(type) {
	case BaseConcept:
		switch {
		case concept.(BaseConcept).Name == "⊤":
			return BaseConcept{"⊥"}
		case concept.(BaseConcept).Name == "⊥":
			return BaseConcept{"⊤"}
		default:
			return OperatorNegation{C: concept}
		}

	case OperatorNegation:
		return concept.(OperatorNegation).C

	case OperatorUnion:
		return OperatorIntersection{
			A: negNNF(concept.(OperatorUnion).A),
			B: negNNF(concept.(OperatorUnion).B),
		}

	case OperatorIntersection:
		return OperatorUnion{
			A: negNNF(concept.(OperatorIntersection).A),
			B: negNNF(concept.(OperatorIntersection).B),
		}

	default:
		return concept
	}
}

func BNF2NNF(concept interface{}) interface{} {
	switch concept.(type) {
	case BaseConcept:
		return concept

	case OperatorNegation:
		return negNNF(BNF2NNF(concept.(OperatorNegation).C))

	case OperatorIntersection:
		return OperatorIntersection{
			A: BNF2NNF(concept.(OperatorIntersection).A),
			B: BNF2NNF(concept.(OperatorIntersection).B),
		}

	case OperatorUnion:
		return OperatorUnion{
			A: BNF2NNF(concept.(OperatorUnion).A),
			B: BNF2NNF(concept.(OperatorUnion).B),
		}

	default:
		return concept
	}
}
