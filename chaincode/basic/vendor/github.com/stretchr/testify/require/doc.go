// Package require implements the same assertions as the `assert` package but
// stops universitymvp execution when a universitymvp fails.
//
// UniversityMVP Usage
//
// The following is a complete universitymvp using require in a standard universitymvp function:
//    import (
//      "universitymvping"
//      "github.com/stretchr/universitymvpify/require"
//    )
//
//    func UniversityMVPSomething(t *universitymvping.T) {
//
//      var a string = "Hello"
//      var b string = "Hello"
//
//      require.Equal(t, a, b, "The two words should be the same.")
//
//    }
//
// Assertions
//
// The `require` package have same global functions as in the `assert` package,
// but instead of returning a boolean result they call `t.FailNow()`.
//
// Every assertion function also takes an optional string message as the final argument,
// allowing custom error messages to be appended to the message the assertion method outputs.
package require
