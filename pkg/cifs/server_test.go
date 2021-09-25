package cifs

import (
	"testing"

	"github.com/container-storage-interface/spec/lib/go/csi"
)

func TestIdentityInterface(t *testing.T) {
	var server interface{} = Server{}

	test := func(csi.IdentityServer) error {
		return nil
	}

	if err := test(server); err != nil {
		t.Fail()
	}
}

func TestNodeInterface(t *testing.T) {
	var server interface{} = Server{}

	test := func(csi.NodeServer) error {
		return nil
	}

	if err := test(server); err != nil {
		t.Fail()
	}
}
