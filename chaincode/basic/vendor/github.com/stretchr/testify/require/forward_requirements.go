package require

// Assertions provides assertion methods around the
// UniversityMVPingT interface.
type Assertions struct {
	t UniversityMVPingT
}

// New makes a new Assertions object for the specified UniversityMVPingT.
func New(t UniversityMVPingT) *Assertions {
	return &Assertions{
		t: t,
	}
}

//go:generate sh -c "cd ../_codegen && go build && cd - && ../_codegen/_codegen -output-package=require -template=require_forward.go.tmpl -include-format-funcs"
