package pkg

import (
	"gopkg.in/yaml.v2"
	"os"
)

type TaskDefinitionList struct {
	Tasks []string `yaml:"tasks"`
}

func (c *TaskDefinitionList) ReadTaskDefinitions() (TaskDefinitionList, error) {
	yamlFile, err := os.ReadFile("assets/generated_tasks_backend.yaml")

	if err == nil {
		err = yaml.Unmarshal(yamlFile, c)
	}

	return *c, err
}

func (c *TaskDefinitionList) ReadTasks() []Task {
	var tasks []Task

	for _, taskDefinition := range c.Tasks {
		tasks = append(tasks, NewTask(taskDefinition))
	}

	return tasks
}
