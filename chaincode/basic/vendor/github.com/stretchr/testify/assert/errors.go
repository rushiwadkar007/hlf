package assert

import (
	"errors"
)

// AnError is an error instance useful for universitymvping.  If the code does not care
// about error specifics, and only needs to return the error for universitymvp, this
// error should be used to make the universitymvp code more readable.
var AnError = errors.New("assert.AnError general error for universitymvping")
