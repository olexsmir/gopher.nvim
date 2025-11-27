package main

type Test struct {
	ID      int    `json:"id,omitempty"`
	Name    string `json:"name,omitempty"`
	Num     int64  `json:"num,omitempty"`
	Another struct {
		First  int    `json:"first,omitempty"`
		Second string `json:"second,omitempty"`
	} `json:"another,omitempty"`
}
