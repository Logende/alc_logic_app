package main

type Concept interface {
}

type OperatorBinary interface {
	Concept
	Concept
}

type OperatorUnary interface {
	Concept
}

type Quantifier interface {
	Role
	Concept
}

type BaseConcept struct {
	Name string
}

type Role struct {
	Name string
}

type OperatorNegation struct {
	C Concept
}

type OperatorIntersection struct {
	A Concept
	B Concept
}

type OperatorUnion struct {
	A Concept
	B Concept
}

type QuantifierForEach struct {
	R Role
	C Concept
}

type QuantifierExists struct {
	R Role
	C Concept
}
