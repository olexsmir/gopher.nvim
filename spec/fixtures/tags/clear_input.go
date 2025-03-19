package main

type Test struct {
	ID      int    `json:"id"      yaml:"id"      xml:"id"      db:"id"`
	Name    string `json:"name"    yaml:"name"    xml:"name"    db:"name"`
	Num     int64  `json:"num"     yaml:"num"     xml:"num"     db:"num"`
	Another struct {
		First  int    `json:"first" yaml:"first" xml:"first" db:"first"`
		Second string `json:"second" yaml:"second" xml:"second" db:"second"`
	} `json:"another" yaml:"another" xml:"another" db:"another"`
}
