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
	Satisfiable bool
	Complexity  int
	Concept     interface{}
}

type TaskList struct {
	Tasks []Task
}

type TaskListForYaml struct {
	Tasks []string `yaml:"tasks"`
}
