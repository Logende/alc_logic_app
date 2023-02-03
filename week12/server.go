package main

import (
	"fmt"
	"html/template"
	"net/http"
	"strconv"
	"strings"
)

type DiceStore interface {
	RollDice(numberOfPair int)
	GetDice(numberOfPair int) Dice
}

type DiceServer struct {
	store DiceStore
}

func (p *DiceServer) ServeHTTP(w http.ResponseWriter, r *http.Request) {

	//TODO: support also different prefixes
	value := strings.TrimPrefix(r.URL.Path, "/dice/")

	numberOfPair, err := strconv.Atoi(value)
	if err != nil {
		panic(err)
	}
	if numberOfPair < 0 || numberOfPair >= 10 {
		w.WriteHeader(http.StatusNotFound)
		return
	}

	switch r.Method {
	case http.MethodPost:
		p.rollDice(w, numberOfPair)
	case http.MethodGet:
		p.getDice(w, numberOfPair)
	}
}

func (p *DiceServer) rollDice(w http.ResponseWriter, numberOfPair int) {
	p.store.RollDice(numberOfPair)
	w.WriteHeader(http.StatusAccepted)
}

type DiceDisplayData struct {
	Die1 int
	Die2 int
}

func (p *DiceServer) getDice(w http.ResponseWriter, numberOfPair int) {
	dice := p.store.GetDice(numberOfPair)

	w.Header().Set("Content-Type", "text/html")

	w.Header().Set("Content-Type", "text/html; charset=utf-8")

	t, err := template.ParseFiles("template.html")
	if err != nil {
		fmt.Fprintf(w, "Unable to load template")
	}

	//t.Execute(w, dice)

	user := DiceDisplayData{
		Die1: dice.die[0],
		Die2: dice.die[1],
	}

	// https://vivek-syngh.medium.com/http-response-in-golang-4ca1b3688d6
	t.Execute(w, user)
}

type HandlerFunc func(http.ResponseWriter, *http.Request)
