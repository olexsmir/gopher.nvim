package main

type Testinger interface {
	Get(id string) int
	// Set 
	Set(id string, val int)
}
