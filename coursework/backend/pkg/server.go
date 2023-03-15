package pkg

import (
	"encoding/json"
	"fmt"
	"html/template"
	"net/http"
	"strings"
)

type UserStore interface {
	UpdateUser(user UserProfile)
	GetUser(name string) (UserProfile, bool)
}

type TaskStore interface {
	UpdateTasks(tasks []Task)
	GetTasks() []Task
}

type UserServer struct {
	StoreUsers UserStore
	StoreTasks TaskStore
}

type AdminPanelDisplayData struct {
	Die1 int
	Die2 int
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

	case firstPart == "tasks" && length == 1:
		p.handleRequestTasks(w, r)
		break

	case firstPart == "task" && length == 2:
		p.handleRequestTask(w, r)
		break

	case firstPart == "admin" && length == 1:
		p.handleRequestAdminPanel(w, r)
		break

	default:
		http.NotFound(w, r)
		return
	}
}

func (p *UserServer) handleRequestUser(w http.ResponseWriter, r *http.Request, name string) {
	switch r.Method {
	case http.MethodPut:
		// TODO
		break

	case http.MethodGet:

		user, ok := p.StoreUsers.GetUser(name)
		if !ok {
			http.NotFound(w, r)
		} else {
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusOK)
			json.NewEncoder(w).Encode(user)
		}
		break

	default:
		http.NotFound(w, r)
		break
	}
}

func (p *UserServer) handleRequestTasks(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case http.MethodPost:
		// TODO
		break

	case http.MethodGet:

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		encoder := json.NewEncoder(w)
		tasks := p.StoreTasks.GetTasks()
		_ = encoder.Encode(tasks)
		break

	default:
		http.NotFound(w, r)
		break
	}
}

func (p *UserServer) handleRequestTask(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case http.MethodPost:
		// TODO
		break

	case http.MethodDelete:
		// TODO
		break

	case http.MethodGet:

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		encoder := json.NewEncoder(w)
		tasks := p.StoreTasks.GetTasks()
		_ = encoder.Encode(tasks)
		break

	default:
		http.NotFound(w, r)
		break
	}
}

func (p *UserServer) handleRequestAdminPanel(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case http.MethodPost:
		// TODO
		break

	case http.MethodGet:

		w.Header().Set("Content-Type", "text/html")
		w.Header().Set("Content-Type", "text/html; charset=utf-8")

		t, err := template.ParseFiles("web/template/admin_panel_template.html")
		if err != nil {
			fmt.Fprintf(w, "Unable to load template")
		}

		data := AdminPanelDisplayData{
			Die1: 4,
			Die2: 1,
		}

		err = t.Execute(w, data)
		if err != nil {
			fmt.Fprintf(w, "Unable to execute template")
			return
		}

		break

	default:
		http.NotFound(w, r)
		break
	}
}

type HandlerFunc func(http.ResponseWriter, *http.Request)
