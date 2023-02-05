package pkg

import (
	"encoding/json"
	"net/http"
	"strings"
)

type UserStore interface {
	UpdateUser(user UserProfile)
	GetUser(name string) (UserProfile, bool)
}

type UserServer struct {
	Store UserStore
}

func (p *UserServer) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	parts := strings.Split(r.URL.Path, "/")[1:]
	firstPart := strings.ToLower(parts[0])
	length := len(parts)

	switch {
	case firstPart == "" && length == 1:
		// TODO: main page

		break

	case firstPart == "user" && length == 2:
		p.handleRequestUser(w, r, parts[1])
		break

	default:
		http.NotFound(w, r)
		return
	}
}

func (p *UserServer) handleRequestUser(w http.ResponseWriter, r *http.Request, name string) {
	switch r.Method {
	case http.MethodPost:
		// TODO
	case http.MethodGet:

		user, ok := p.Store.GetUser(name)
		if !ok {
			http.NotFound(w, r)
		} else {
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusOK)
			json.NewEncoder(w).Encode(user)
		}
	}
}

type HandlerFunc func(http.ResponseWriter, *http.Request)
