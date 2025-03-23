package main

type CloserTest2 struct{}

func (closertest *CloserTest2) Close() error {
	panic("not implemented") // TODO: Implement
}
