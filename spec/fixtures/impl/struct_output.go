package main

type StructTest2 struct {
	someField  int
	otherField string
}

func (s *StructTest2) Write(p []byte) (n int, err error) {
	panic("not implemented") // TODO: Implement
}
