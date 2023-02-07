package pkg

type UserProfile struct {
	Name            string
	PasswordHash    string
	TasksStatistics map[string]TaskStatistics
}

type TaskStatistics struct {
	Attempts        int
	Successes       int
	TotalTimeNeeded float64
	Task            Task
}
