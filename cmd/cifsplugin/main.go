package main

import (
	"net"

	"google.golang.org/grpc"
)

func main() {
	listener, _ := net.Listen("unix", "/tmp/csi.sock")

	opts := []grpc.ServerOption{}
	server := grpc.NewServer(opts...)

	if err := server.Serve(listener); err != nil {
		panic(err)
	}
}
