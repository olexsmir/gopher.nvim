package main

import "io"

type Decoder[T any, R io.Reader] struct {
	value  T
	reader R
}

func NewDecoder[T any, R io.Reader](value T, reader R) Decoder[T, R] {
	return Decoder[T, R]{
		value:  value,
		reader: reader,
	}
}
