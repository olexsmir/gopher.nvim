package demos

type AddTagsToMe struct {
	Name    string
	ID      int
	Address string
	Aliases []string
	Nested  struct {
		Foo string
		Bar float32
	}
}
