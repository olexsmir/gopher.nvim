package main

func getErr() error { return nil }

func test() error {
	err := getErr()
}
