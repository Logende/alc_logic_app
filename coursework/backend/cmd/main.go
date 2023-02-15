package main

import (
	"backend/pkg"
	"context"
	"fmt"
	"go.mongodb.org/mongo-driver/bson/primitive"
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

	var taskDefinitions pkg.TaskDefinitionList
	taskDefinitions, error := taskDefinitions.ReadTaskDefinitions()

	if error != nil {
		print(error)
	}

	exampleUser := pkg.UserProfile{
		ID:              primitive.ObjectID{},
		Name:            "someName",
		PasswordHash:    "werwer",
		TasksStatistics: map[string]pkg.TaskStatistics{},
	}
	
	fmt.Printf("%+v\n", exampleUser)

	tasks := taskDefinitions.ReadTasks()
	server := &pkg.UserServer{StoreUsers: pkg.NewMongoUserStore(client), StoreTasks: pkg.NewMongoTaskStore(tasks, client)}
	log.Fatal(http.ListenAndServe(":5001", server))
}
