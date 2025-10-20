package demos

func ifErr() error {
	out, err := doSomething()

	_ = out
}

func doSomething() (string, error) {
	return "", nil
}
