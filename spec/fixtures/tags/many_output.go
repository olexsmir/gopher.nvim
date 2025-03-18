package main

type (
	TestOne struct {
		Asdf string
		ID   int
	}

	TestTwo struct {
		Fesa int  `testing:"fesa"`
		A    bool `testing:"a"`
	}

	TestThree struct {
		Asufj int
		Fs    string
	}
)
