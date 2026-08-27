package main

import "io"

type Decoder[T any, R io.Reader] struct {
	value  T
	reader R
}
