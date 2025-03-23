package main

type WriterTest2 struct{}

func (w *WriterTest2) Write(p []byte) (n int, err error) {
	panic("not implemented") // TODO: Implement
}
