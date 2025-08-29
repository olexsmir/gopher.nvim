package main

type Test struct {
	ID      int
	Name    string `gopher:"name"`
	Num     int64  `gopher:"num"`
	Cost    int    `gopher:"cost"`
	Thingy  []string
	Testing int
	Another struct {
		First  int
		Second string
	}
}
