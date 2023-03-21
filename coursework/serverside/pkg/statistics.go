package pkg

func AggregateTaskStatistics(profiles []UserProfile) map[string]TaskStatistics {
	result := map[string]TaskStatistics{}
	for _, profile := range profiles {
		for s, stats := range profile.TasksStatistics {
			value, found := result[s]
			if !found {
				value = TaskStatistics{
					Attempts:        0,
					Successes:       0,
					TotalTimeNeeded: 0,
					Task:            NewTask(s),
				}
			}
			value.Successes += stats.Successes
			value.Attempts += stats.Attempts
			value.TotalTimeNeeded += stats.TotalTimeNeeded
			result[s] = value
		}
	}
	return result
}
