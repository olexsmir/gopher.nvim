package for_test

import (
	"testing"

	"gotest.tools/v3/assert"
)

func TestAdd(t *testing.T) {
	type args struct {
		x int
		y int
	}
	tests := []struct {
		name string
		args args
		want int
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			assert.Equal(t, tt.want, Add(tt.args.x, tt.args.y))
		})
	}
}
