package pkg

import (
	"context"
	"fmt"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"log"
)

func NewMongoUserStore(client *mongo.Client) *MongoUserStore {
	return &MongoUserStore{client}
}

type MongoUserStore struct {
	client *mongo.Client
}

func (i *MongoUserStore) GetUser(name string) (UserProfile, bool) {
	return ReadUserFromDB(i.client, name)
}

func (i *MongoUserStore) GetUsers() []UserProfile {
	return ReadUsersFromDB(i.client)
}

func (i *MongoUserStore) UpdateUser(user UserProfile) {
	UpdateUserInDB(i.client, user)
}

func ReadUserFromDB(client *mongo.Client, name string) (UserProfile, bool) {

	collection := client.Database("alc_logic").Collection("users")
	cursor, err := collection.Find(context.TODO(), bson.M{"Name": name})
	if err != nil {
		fmt.Println(err)
		return UserProfile{}, false
	}

	for cursor.Next(context.TODO()) {
		var result UserProfile
		err = cursor.Decode(&result)

		if err != nil {
			fmt.Println(err)
			return UserProfile{}, false
		}

		return result, true

	}

	return UserProfile{}, false

}

func ReadUsersFromDB(client *mongo.Client) []UserProfile {
	var users []UserProfile

	collection := client.Database("alc_logic").Collection("users")
	cursor, err := collection.Find(context.TODO(), bson.D{})
	if err != nil {
		panic(err)
	}

	for cursor.Next(context.TODO()) {
		var result UserProfile
		err := cursor.Decode(&result)

		if err != nil {
			panic(err)
		}

		users = append(users, result)

	}

	return users
}

func UpdateUserInDB(client *mongo.Client, user UserProfile) {
	collection := client.Database("alc_logic").Collection("users")

	insertResult, err := collection.InsertOne(context.TODO(), user)
	if err != nil {
		log.Fatal(err)
	} else {
		fmt.Println("Inserted user: ", insertResult.InsertedID)
	}

}
