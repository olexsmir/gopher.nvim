package main

type Test struct {
	ID      int `xml:"id,theoption"`
	Another struct {
		Second string `xml:"second,theoption"`
	} `xml:"another,theoption"`
}
