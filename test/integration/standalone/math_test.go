package math

import "testing"

func TestStandalone(t *testing.T){

    got := Add(4, 6)
    want := 10

    if got != want {
        t.Errorf("got %q, wanted %q", got, want)
    }
}
