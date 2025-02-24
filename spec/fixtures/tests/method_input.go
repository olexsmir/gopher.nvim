package fortest

type ForTest struct{}

func (t *ForTest) Add(x, y int) int {
	return 2 + x + y
}
