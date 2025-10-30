package main

type Test struct {
	ID      int `xml:"id,otheroption"`
	Another struct {
		Second string `xml:"second,otheroption"`
	} `xml:"another,otheroption"`
}
