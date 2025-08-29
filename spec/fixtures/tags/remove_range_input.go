package main

type Test struct {
	ID      int      `asdf:"id"`
	Name    string   `asdf:"name"`
	Num     int64    `asdf:"num"`
	Cost    int      `asdf:"cost"`
	Thingy  []string `asdf:"thingy"`
	Testing int      `asdf:"testing"`
	Another struct {
		First  int    `asdf:"first"`
		Second string `asdf:"second"`
	} `asdf:"another"`
}
