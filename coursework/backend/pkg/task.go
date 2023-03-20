package pkg

import (
	"fmt"
	"strconv"
	"strings"
)

type Task struct {
	Concept     string
	Satisfiable bool
	Complexity  int
}

func (task Task) String() string {
	return fmt.Sprintf("%s:%t:%d", task.Concept, task.Satisfiable, task.Complexity)
}

func NewTask(definition string) Task {
	parts := strings.Split(definition, ":")
	satisfiable, _ := strconv.ParseBool(parts[1])
	complexity, _ := strconv.Atoi(parts[2])

	return Task{
		Concept:     parts[0],
		Satisfiable: satisfiable,
		Complexity:  complexity,
	}
}
