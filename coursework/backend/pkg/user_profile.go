package pkg

import "encoding/json"

type UserProfile struct {
	Name            string
	PasswordHash    string
	TasksStatistics map[string]TaskStatistics
}

type UserProfileForJson struct {
	Name            string
	PasswordHash    string
	TasksStatistics map[string]json.RawMessage
}

type UserProfileForJson2 struct {
	Name            string
	PasswordHash    string
	TasksStatistics map[string]TaskStatisticsForJson
}

type TaskStatistics struct {
	Attempts        int32
	Successes       int32
	TotalTimeNeeded float64
	Task            Task
}

type TaskStatisticsForJson struct {
	Attempts        int32
	Successes       int32
	TotalTimeNeeded float64
	Task            json.RawMessage
}

func (u UserProfileForJson) convertToUserProfile() UserProfile {
	return u.convertToUserProfileForJson2().convertToUserProfile()
}

func (u UserProfileForJson) convertToUserProfileForJson2() UserProfileForJson2 {
	stats := map[string]TaskStatisticsForJson{}
	for s, message := range u.TasksStatistics {
		var stat TaskStatisticsForJson
		err := json.Unmarshal(message, &stat)
		if err == nil {
			stats[s] = stat
		} else {
			println("Unable to unmarshal task statistics ", message)
		}
	}
	return UserProfileForJson2{
		Name:            u.Name,
		PasswordHash:    u.PasswordHash,
		TasksStatistics: stats,
	}
}

func (u UserProfileForJson2) convertToUserProfile() UserProfile {
	stats := map[string]TaskStatistics{}
	for s, taskStatisticForJson := range u.TasksStatistics {
		var task Task
		err := json.Unmarshal(taskStatisticForJson.Task, &task)
		if err == nil {
			stats[s] = TaskStatistics{
				Attempts:        taskStatisticForJson.Attempts,
				Successes:       taskStatisticForJson.Successes,
				TotalTimeNeeded: taskStatisticForJson.TotalTimeNeeded,
				Task:            task,
			}
		} else {
			println("Unable to unmarshal task ", taskStatisticForJson.Task)
		}
	}
	return UserProfile{
		Name:            u.Name,
		PasswordHash:    u.PasswordHash,
		TasksStatistics: stats,
	}
}
