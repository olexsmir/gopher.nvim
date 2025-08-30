package demos

func ifErr() {
	out, err := doSomething()

	_ = out
}

func doSomething() (string, error) {
	return "", nil
}
