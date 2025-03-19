package main

type Test struct {
	ID      int    `test4:"id" test5:"id" test1:"id" test2:"id"`
	Name    string `test4:"name" test5:"name" test1:"name" test2:"name"`
	Num     int64  `test4:"num" test5:"num" test1:"num" test2:"num"`
	Another struct {
		First  int    `test4:"first" test5:"first" test1:"first" test2:"first"`
		Second string `test4:"second" test5:"second" test1:"second" test2:"second"`
	} `test4:"another" test5:"another" test1:"another" test2:"another"`
}
