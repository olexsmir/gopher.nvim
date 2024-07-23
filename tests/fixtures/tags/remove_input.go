package main

type Test struct {
	ID      int    `json:"id"`
	Name    string `json:"name"`
	Num     int64  `json:"num"`
	Another struct {
		First  int    `json:"first"`
		Second string `json:"second"`
	} `json:"another"`
}
