package main

type Test struct {
	ID      int    `xml:"id,someoption"`
	Name    string `xml:"name,someoption"`
	Num     int64  `xml:"num,someoption"`
	Another struct {
		First  int    `xml:"first,someoption"`
		Second string `xml:"second,someoption"`
	} `xml:"another,someoption"`
}
