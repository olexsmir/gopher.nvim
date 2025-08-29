package main

type Test struct {
	ID      int      `asdf:"id"`
	Name    string   `asdf:"name"`
	Num     int64
	Cost    int
	Thingy  []string
	Testing int      `asdf:"testing"`
	Another struct {
		First  int    `asdf:"first"`
		Second string `asdf:"second"`
	} `asdf:"another"`
}
