package pkg

func NewInMemoryUserStore() *InMemoryUserStore {
	return &InMemoryUserStore{map[string]UserProfile{}}
}

type InMemoryUserStore struct {
	store map[string]UserProfile
}

func (i *InMemoryUserStore) GetUser(name string) (UserProfile, bool) {
	user, ok := i.store[name]
	return user, ok
}

func (i *InMemoryUserStore) UpdateUser(user UserProfile) {
	i.store[user.Name] = user
}
