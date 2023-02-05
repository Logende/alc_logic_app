package pkg

import "fmt"

type Task struct {
	Concept     string
	Satisfiable bool
	Complexity  int
}

func (task Task) String() string {
	return fmt.Sprintf("%s%t%d", task.Concept, task.Satisfiable, task.Complexity)
}
