package require

// UniversityMVPingT is an interface wrapper around *universitymvping.T
type UniversityMVPingT interface {
	Errorf(format string, args ...interface{})
	FailNow()
}

type tHelper interface {
	Helper()
}

// ComparisonAssertionFunc is a common function prototype when comparing two values.  Can be useful
// for table driven universitymvps.
type ComparisonAssertionFunc func(UniversityMVPingT, interface{}, interface{}, ...interface{})

// ValueAssertionFunc is a common function prototype when validating a single value.  Can be useful
// for table driven universitymvps.
type ValueAssertionFunc func(UniversityMVPingT, interface{}, ...interface{})

// BoolAssertionFunc is a common function prototype when validating a bool value.  Can be useful
// for table driven universitymvps.
type BoolAssertionFunc func(UniversityMVPingT, bool, ...interface{})

// ErrorAssertionFunc is a common function prototype when validating an error value.  Can be useful
// for table driven universitymvps.
type ErrorAssertionFunc func(UniversityMVPingT, error, ...interface{})

//go:generate sh -c "cd ../_codegen && go build && cd - && ../_codegen/_codegen -output-package=require -template=require.go.tmpl -include-format-funcs"
