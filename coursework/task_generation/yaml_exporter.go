package main

import (
	"fmt"
	"gopkg.in/yaml.v3"
	"log"
	"os"
)

func trimTasksForExport(tasks TaskList) TaskList {
	var trimmedTasks []Task
	for _, task := range tasks.Tasks {
		trimmedTask := Task{
			Concept:     task.Concept,
			Satisfiable: task.Satisfiable,
			Complexity:  task.Complexity,
			C:           nil,
		}
		trimmedTasks = append(trimmedTasks, trimmedTask)
	}
	return TaskList{Tasks: trimmedTasks}
}

func exportAsYAML(tasks TaskList, filePath string) {
	tasks = trimTasksForExport(tasks)

	data, err := yaml.Marshal(tasks)

	if err != nil {
		log.Fatal(err)
	}

	err2 := os.WriteFile(filePath, data, 0666)

	if err2 != nil {
		log.Fatal(err2)
	}

	fmt.Println("data written")
}
