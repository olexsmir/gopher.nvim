package main

func main() {
	s := struct {
		API string `xml:"api"`
		Key string `xml:"key"`
	}{
		API: "api.com",
		Key: "key",
	}
}
