package main

type Something struct {
	MyStuff []string
	private string
}

func NewSomething(myStuff []string, private string) Something {
	return Something{
		MyStuff: myStuff,
		private: private,
	}
}
