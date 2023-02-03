package main

import (
	"log"
	"net/http"
)

func main() {
	server := &DiceServer{NewInMemoryDiceStore()}
	log.Fatal(http.ListenAndServe(":5001", server))
}
