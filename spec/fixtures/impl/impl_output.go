package main

type Tester2 struct{}

func (w *Tester2) Write(p []byte) (n int, err error) {
	panic("not implemented") // TODO: Implement
}

