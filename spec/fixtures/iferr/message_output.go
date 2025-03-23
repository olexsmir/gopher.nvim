package main

func getErr() error { return nil }

func test() error {
	err := getErr()
	if err != nil {
		return fmt.Errorf("failed to %w", err)
	}
}
