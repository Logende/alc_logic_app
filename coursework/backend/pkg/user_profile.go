package pkg

import "go.mongodb.org/mongo-driver/bson/primitive"

type UserProfile struct {
	ID              primitive.ObjectID `bson:"_id"`
	Name            string
	PasswordHash    string
	TasksStatistics map[string]TaskStatistics
}

type TaskStatistics struct {
	Attempts        int32
	Successes       int32
	TotalTimeNeeded float64
	Task            Task
}
