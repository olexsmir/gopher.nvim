package main

type Testinger interface {
	Get(id string) int
	Set(id string, val int)
}
