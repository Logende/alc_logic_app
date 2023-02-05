package main

import (
	"backend/pkg"
	"log"
	"net/http"
)

func main() {

	var taskDefinitions pkg.TaskDefinitionList
	taskDefinitions, error := taskDefinitions.ReadTaskDefinitions()

	if error != nil {
		print(error)
	}

	tasks := taskDefinitions.ReadTasks()
	print(tasks)
	server := &pkg.UserServer{Store: pkg.NewInMemoryUserStore()}
	log.Fatal(http.ListenAndServe(":5001", server))
}
