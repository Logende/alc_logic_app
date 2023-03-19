package pkg

import (
	"encoding/json"
	"fmt"
	"html/template"
	"net/http"
	"strconv"
	"strings"
)

type UserStore interface {
	UpdateUser(user UserProfile)
	GetUser(name string) (UserProfile, bool)
	GetUsers() []UserProfile
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
	Tasks []Task
}

type StatisticsPanelDisplayData struct {
	Stats []TaskStatistics
}

type TaskRemovableDisplayData struct {
	task Task
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

	case firstPart == "task":
		p.handleRequestTask(w, r, parts)
		break

	case firstPart == "admin" && length == 1:
		p.handleRequestAdminPanel(w, r)
		break

	case firstPart == "stats" && length == 1:
		p.handleRequestStatisticsPanel(w, r)
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

func (p *UserServer) handleRequestTask(w http.ResponseWriter, r *http.Request, parts []string) {
	switch r.Method {
	case http.MethodPost:

		err := r.ParseForm()
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		var concept = r.Form.Get("Concept")
		satisfiable, err := strconv.ParseBool(r.Form.Get("Satisfiable"))
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}
		complexity, err := strconv.Atoi(r.Form.Get("Complexity"))
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		var tasks = p.StoreTasks.GetTasks()
		tasks = append(tasks, Task{
			Concept:     concept,
			Satisfiable: satisfiable,
			Complexity:  complexity,
		})
		p.StoreTasks.UpdateTasks(tasks)

		w.Header().Set("Content-Type", "text/html")
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		t, err := template.ParseFiles("web/template/added_task_template.html")
		if err != nil {
			fmt.Fprintf(w, "Unable to load template")
		}

		data := AdminPanelDisplayData{
			Tasks: p.StoreTasks.GetTasks(),
		}

		err = t.Execute(w, data)
		if err != nil {
			fmt.Fprintf(w, "Unable to execute template")
			return
		}
		break

	case http.MethodDelete:
		requestedId := parts[1]

		identifiedIndex := -1

		for i, task := range p.StoreTasks.GetTasks() {
			taskId := task.String()

			if taskId == requestedId {
				identifiedIndex = i
				break
			}
		}

		if identifiedIndex >= 0 {
			tasks := p.StoreTasks.GetTasks()
			tasks = append(tasks[:identifiedIndex], tasks[identifiedIndex+1:]...)
			p.StoreTasks.UpdateTasks(tasks)
		}

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
			Tasks: p.StoreTasks.GetTasks(),
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

func (p *UserServer) handleRequestStatisticsPanel(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case http.MethodPost:
		// TODO
		break

	case http.MethodGet:

		w.Header().Set("Content-Type", "text/html")
		w.Header().Set("Content-Type", "text/html; charset=utf-8")

		t, err := template.ParseFiles("web/template/statistics_panel_template.html")
		if err != nil {
			fmt.Fprintf(w, "Unable to load template")
		}

		var stats []TaskStatistics
		aggregated := AggregateTaskStatistics(p.StoreUsers.GetUsers())
		for _, task := range p.StoreTasks.GetTasks() {
			value, exists := aggregated[task.String()]
			if exists {
				stats = append(stats, value)
			}
		}

		data := StatisticsPanelDisplayData{
			Stats: stats,
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
