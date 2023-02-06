package pkg

func NewInMemoryTaskStore(tasks []Task) *InMemoryTaskStore {
	return &InMemoryTaskStore{tasks}
}

type InMemoryTaskStore struct {
	tasks []Task
}

func (i *InMemoryTaskStore) GetTasks() []Task {
	return i.tasks
}

func (i *InMemoryTaskStore) UpdateTasks(tasks []Task) {
	i.tasks = tasks
}
