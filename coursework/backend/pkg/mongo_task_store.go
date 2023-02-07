package pkg

import (
	"context"
	"fmt"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"log"
)

func NewMongoTaskStore(defaultTasks []Task, client *mongo.Client) *MongoTaskStore {
	databaseAlcLogic := client.Database("alc_logic")
	collectionTasks := databaseAlcLogic.Collection("tasks")
	count, err := collectionTasks.CountDocuments(context.TODO(), bson.D{})
	if count == 0 || err != nil {
		WriteTasksToDB(defaultTasks, client)
	}
	tasks := ReadTasksFromDB(client)

	return &MongoTaskStore{tasks, client}
}

type MongoTaskStore struct {
	tasks  []Task
	client *mongo.Client
}

func (i *MongoTaskStore) GetTasks() []Task {
	return i.tasks
}

func (i *MongoTaskStore) UpdateTasks(tasks []Task) {
	i.tasks = tasks
}

func ReadTasksFromDB(client *mongo.Client) []Task {
	var tasks []Task

	collection := client.Database("alc_logic").Collection("tasks")
	cursor, err := collection.Find(context.TODO(), bson.D{})
	if err != nil {
		panic(err)
	} else {
		for cursor.Next(context.TODO()) {
			var result Task
			err := cursor.Decode(&result)
			tasks = append(tasks, result)

			if err != nil {
				panic(err)
			}

		}
	}

	return tasks
}

func WriteTasksToDB(tasks []Task, client *mongo.Client) {
	collection := client.Database("alc_logic").Collection("tasks")

	elements := make([]interface{}, len(tasks))
	for i := range tasks {
		elements[i] = tasks[i]
	}

	insertManyResult, err := collection.InsertMany(context.TODO(), elements)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Inserted multiple documents: ", insertManyResult.InsertedIDs)
}
