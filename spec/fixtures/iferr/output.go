package main

import "net"

func main() {
	_, err := net.Listen("tcp", ":8080")
	if err != nil {
		return
	}
}
