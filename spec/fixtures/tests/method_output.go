package fortest

import "testing"

func TestForTest_Add(t *testing.T) {
	type args struct {
		x int
		y int
	}
	tests := []struct {
		name string
		tr   *ForTest
		args args
		want int
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tr := &ForTest{}
			if got := tr.Add(tt.args.x, tt.args.y); got != tt.want {
				t.Errorf("ForTest.Add() = %v, want %v", got, tt.want)
			}
		})
	}
}
