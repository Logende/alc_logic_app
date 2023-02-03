package main

func NewInMemoryDiceStore() *InMemoryDiceStore {
	return &InMemoryDiceStore{map[int]Dice{}}
}

type InMemoryDiceStore struct {
	store map[int]Dice
}

func (i *InMemoryDiceStore) GetDice(numberOfPair int) Dice {
	return i.store[numberOfPair]
}

func (i *InMemoryDiceStore) RollDice(numberOfPair int) {
	dice := i.store[numberOfPair]
	dice.throwDice()
	i.store[numberOfPair] = dice
}
