package cmd

import (
	"backend/pkg"
	"log"
	"net/http"
)

func main() {
	server := &pkg.UserServer{Store: pkg.NewInMemoryUserStore()}
	log.Fatal(http.ListenAndServe(":5001", server))
}
