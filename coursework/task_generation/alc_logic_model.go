package main

type Concept interface {
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

type Task struct {
	Concept     string      `yaml:"concept"`
	Satisfiable bool        `yaml:"satisfiable"`
	Complexity  int         `yaml:"complexity"`
	C           interface{} `yaml:"concept_structure,omitempty"`
}

type TaskList struct {
	Tasks []Task `yaml:"tasks"`
}
