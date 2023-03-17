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
		InsertTasksInDB(client, defaultTasks)
	}

	return &MongoTaskStore{client}
}

type MongoTaskStore struct {
	client *mongo.Client
}

func (i *MongoTaskStore) GetTasks() []Task {
	return ReadTasksFromDB(i.client)
}

func (i *MongoTaskStore) UpdateTasks(tasks []Task) {
	UpdateTasksInDB(i.client, tasks)
}

func ReadTasksFromDB(client *mongo.Client) []Task {
	var tasks []Task

	collection := client.Database("alc_logic").Collection("tasks")
	cursor, err := collection.Find(context.TODO(), bson.D{})
	if err != nil {
		panic(err)
	}

	for cursor.Next(context.TODO()) {
		var result Task
		err := cursor.Decode(&result)

		if err != nil {
			panic(err)
		}

		tasks = append(tasks, result)

	}

	return tasks
}

func UpdateTasksInDB(client *mongo.Client, tasks []Task) {
	ClearTasksInDB(client)
	InsertTasksInDB(client, tasks)
}

func ClearTasksInDB(client *mongo.Client) {
	collection := client.Database("alc_logic").Collection("tasks")
	many, err := collection.DeleteMany(context.TODO(), bson.D{})

	if err != nil {
		log.Fatal(err)
	} else {
		fmt.Println("Removed tasks: ", many.DeletedCount)
	}

}

func InsertTasksInDB(client *mongo.Client, tasks []Task) {
	collection := client.Database("alc_logic").Collection("tasks")

	elements := make([]interface{}, len(tasks))
	for i := range tasks {
		elements[i] = tasks[i]
	}

	insertManyResult, err := collection.InsertMany(context.TODO(), elements)
	if err != nil {
		log.Fatal(err)
	} else {
		fmt.Println("Inserted tasks: ", insertManyResult.InsertedIDs)
	}

}
