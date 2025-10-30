package main

type Test struct {
	ID      int    `json:"id,omitempty" xml:"id,someoption"`
	Name    string `json:"name,omitempty" xml:"name,someoption"`
	Num     int64  `json:"num,omitempty" xml:"num,someoption"`
	Another struct {
		First  int    `json:"first,omitempty" xml:"first,someoption"`
		Second string `json:"second,omitempty" xml:"second,someoption"`
	} `json:"another,omitempty" xml:"another,someoption"`
}
