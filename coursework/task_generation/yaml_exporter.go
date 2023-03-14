package main

import (
	"fmt"
	"gopkg.in/yaml.v3"
	"log"
	"os"
	"strconv"
)

func convertToTasksForYaml(tasks TaskList) TaskListForYaml {
	var rawTaskStrings []string
	for _, task := range tasks.Tasks {
		rawTaskString := toString(task.Concept) + ":" + strconv.FormatBool(task.Satisfiable) + ":" + strconv.Itoa(task.Complexity)
		rawTaskStrings = append(rawTaskStrings, rawTaskString)
	}
	return TaskListForYaml{Tasks: rawTaskStrings}
}

func exportAsYAML(tasks TaskList, filePath string) {
	tasksForYaml := convertToTasksForYaml(tasks)

	data, err := yaml.Marshal(tasksForYaml)

	if err != nil {
		log.Fatal(err)
	}

	err2 := os.WriteFile(filePath, data, 0666)

	if err2 != nil {
		log.Fatal(err2)
	}

	fmt.Println("data written")
}
