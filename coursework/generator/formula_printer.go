package main

func toString(concept interface{}) string {
	switch concept.(type) {
	case BaseConcept:
		return concept.(BaseConcept).Name

	case OperatorNegation:
		return "¬" + toString(concept.(OperatorNegation).C)

	case OperatorUnion:
		return "(" + toString(concept.(OperatorUnion).A) + " ⊔ " + toString(concept.(OperatorUnion).B) + ")"

	case OperatorIntersection:
		return "(" + toString(concept.(OperatorIntersection).A) + " ⊓ " + toString(concept.(OperatorIntersection).B) + ")"

	case QuantifierForEach:
		return "(∀" + concept.(QuantifierForEach).R.Name + "." + toString(concept.(QuantifierForEach).C) + ")"

	case QuantifierExists:
		return "(∃" + concept.(QuantifierExists).R.Name + "." + toString(concept.(QuantifierExists).C) + ")"

	default:
		return "unknown_type"
	}
}
