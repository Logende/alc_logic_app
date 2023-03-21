package main

import (
	"backend/pkg"
	"context"
	"fmt"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"log"
	"net/http"
)

func main() {

	// Set client options
	clientOptions := options.Client().ApplyURI("mongodb://localhost:27017")

	// Connect to MongoDB
	client, err := mongo.Connect(context.TODO(), clientOptions)

	if err != nil {
		log.Fatal(err)
	}

	// Check the connection
	err = client.Ping(context.TODO(), nil)

	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Connected to MongoDB!")
	defer client.Disconnect(context.TODO())

	// read the default tasks from file system
	var taskDefinitions pkg.TaskDefinitionList
	taskDefinitions, error := taskDefinitions.ReadTaskDefinitions()
	if error != nil {
		print(error)
	}
	tasks := taskDefinitions.ReadTasks()

	// create server and already connect with Mongodb and if there are existing tasks, take them over
	// otherwise use default tasks and write them to DB
	server := &pkg.UserServer{StoreUsers: pkg.NewMongoUserStore(client), StoreTasks: pkg.NewMongoTaskStore(tasks, client)}

	// start running server
	log.Fatal(http.ListenAndServe(":5001", server))
}
