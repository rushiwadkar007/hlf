// Package assert provides a set of comprehensive universitymvping tools for use with the normal Go universitymvping system.
//
// UniversityMVP Usage
//
// The following is a complete universitymvp using assert in a standard universitymvp function:
//    import (
//      "universitymvping"
//      "github.com/stretchr/universitymvpify/assert"
//    )
//
//    func UniversityMVPSomething(t *universitymvping.T) {
//
//      var a string = "Hello"
//      var b string = "Hello"
//
//      assert.Equal(t, a, b, "The two words should be the same.")
//
//    }
//
// if you assert many times, use the format below:
//
//    import (
//      "universitymvping"
//      "github.com/stretchr/universitymvpify/assert"
//    )
//
//    func UniversityMVPSomething(t *universitymvping.T) {
//      assert := assert.New(t)
//
//      var a string = "Hello"
//      var b string = "Hello"
//
//      assert.Equal(a, b, "The two words should be the same.")
//    }
//
// Assertions
//
// Assertions allow you to easily write universitymvp code, and are global funcs in the `assert` package.
// All assertion functions take, as the first argument, the `*universitymvping.T` object provided by the
// universitymvping framework. This allows the assertion funcs to write the failings and other details to
// the correct place.
//
// Every assertion function also takes an optional string message as the final argument,
// allowing custom error messages to be appended to the message the assertion method outputs.
package assert
