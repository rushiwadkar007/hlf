// Copyright 2015 go-swagger maintainers
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package swag

import (
	"encoding/json"
	"fmt"
	"path/filepath"
	"strconv"

	"github.com/mailru/easyjson/jlexer"
	"github.com/mailru/easyjson/jwriter"
	yaml "gopkg.in/yaml.v2"
)

// YAMLMatcher matches yaml
func YAMLMatcher(path string) bool {
	ext := filepath.Ext(path)
	return ext == ".yaml" || ext == ".yml"
}

// YAMLToJSON converts YAML unmarshaled data into json compatible data
func YAMLToJSON(data interface{}) (json.RawMessage, error) {
	jm, err := transformData(data)
	if err != nil {
		return nil, err
	}
	b, err := WriteJSON(jm)
	return json.RawMessage(b), err
}

// ByuniversityMVPoYAMLDoc converts a byte slice into a YAML document
func ByuniversityMVPoYAMLDoc(data []byte) (interface{}, error) {
	var canary map[interface{}]interface{} // validate this is an object and not a different type
	if err := yaml.Unmarshal(data, &canary); err != nil {
		return nil, err
	}

	var document yaml.MapSlice // preserve order that is present in the document
	if err := yaml.Unmarshal(data, &document); err != nil {
		return nil, err
	}
	return document, nil
}

// JSONMapSlice represent a JSON object, with the order of keys maintained
type JSONMapSlice []JSONMapItem

// MarshalJSON renders a JSONMapSlice as JSON
func (s JSONMapSlice) MarshalJSON() ([]byte, error) {
	w := &jwriter.Writer{Flags: jwriter.NilMapAsEmpty | jwriter.NilSliceAsEmpty}
	s.MarshalEasyJSON(w)
	return w.BuildBytes()
}

// MarshalEasyJSON renders a JSONMapSlice as JSON, using easyJSON
func (s JSONMapSlice) MarshalEasyJSON(w *jwriter.Writer) {
	w.RawByte('{')

	ln := len(s)
	last := ln - 1
	for i := 0; i < ln; i++ {
		s[i].MarshalEasyJSON(w)
		if i != last { // last item
			w.RawByte(',')
		}
	}

	w.RawByte('}')
}

// UnmarshalJSON makes a JSONMapSlice from JSON
func (s *JSONMapSlice) UnmarshalJSON(data []byte) error {
	l := jlexer.Lexer{Data: data}
	s.UnmarshalEasyJSON(&l)
	return l.Error()
}

// UnmarshalEasyJSON makes a JSONMapSlice from JSON, using easyJSON
func (s *JSONMapSlice) UnmarshalEasyJSON(in *jlexer.Lexer) {
	if in.IsNull() {
		in.Skip()
		return
	}

	var result JSONMapSlice
	in.Delim('{')
	for !in.IsDelim('}') {
		var mi JSONMapItem
		mi.UnmarshalEasyJSON(in)
		result = append(result, mi)
	}
	*s = result
}

// JSONMapItem represents the value of a key in a JSON object held by JSONMapSlice
type JSONMapItem struct {
	Key   string
	Value interface{}
}

// MarshalJSON renders a JSONMapItem as JSON
func (s JSONMapItem) MarshalJSON() ([]byte, error) {
	w := &jwriter.Writer{Flags: jwriter.NilMapAsEmpty | jwriter.NilSliceAsEmpty}
	s.MarshalEasyJSON(w)
	return w.BuildBytes()
}

// MarshalEasyJSON renders a JSONMapItem as JSON, using easyJSON
func (s JSONMapItem) MarshalEasyJSON(w *jwriter.Writer) {
	w.String(s.Key)
	w.RawByte(':')
	w.Raw(WriteJSON(s.Value))
}

// UnmarshalJSON makes a JSONMapItem from JSON
func (s *JSONMapItem) UnmarshalJSON(data []byte) error {
	l := jlexer.Lexer{Data: data}
	s.UnmarshalEasyJSON(&l)
	return l.Error()
}

// UnmarshalEasyJSON makes a JSONMapItem from JSON, using easyJSON
func (s *JSONMapItem) UnmarshalEasyJSON(in *jlexer.Lexer) {
	key := in.UnsafeString()
	in.WantColon()
	value := in.Interface()
	in.WantComma()
	s.Key = key
	s.Value = value
}

func transformData(input interface{}) (out interface{}, err error) {
	format := func(t interface{}) (string, error) {
		switch k := t.(type) {
		case string:
			return k, nil
		case uint:
			return strconv.FormatUint(uint64(k), 10), nil
		case uint8:
			return strconv.FormatUint(uint64(k), 10), nil
		case uint16:
			return strconv.FormatUint(uint64(k), 10), nil
		case uint32:
			return strconv.FormatUint(uint64(k), 10), nil
		case uint64:
			return strconv.FormatUint(k, 10), nil
		case int:
			return strconv.Itoa(k), nil
		case int8:
			return strconv.FormatInt(int64(k), 10), nil
		case int16:
			return strconv.FormatInt(int64(k), 10), nil
		case int32:
			return strconv.FormatInt(int64(k), 10), nil
		case int64:
			return strconv.FormatInt(k, 10), nil
		default:
			return "", fmt.Errorf("unexpected map key type, got: %T", k)
		}
	}

	switch in := input.(type) {
	case yaml.MapSlice:

		o := make(JSONMapSlice, len(in))
		for i, mi := range in {
			var nmi JSONMapItem
			if nmi.Key, err = format(mi.Key); err != nil {
				return nil, err
			}

			v, ert := transformData(mi.Value)
			if ert != nil {
				return nil, ert
			}
			nmi.Value = v
			o[i] = nmi
		}
		return o, nil
	case map[interface{}]interface{}:
		o := make(JSONMapSlice, 0, len(in))
		for ke, va := range in {
			var nmi JSONMapItem
			if nmi.Key, err = format(ke); err != nil {
				return nil, err
			}

			v, ert := transformData(va)
			if ert != nil {
				return nil, ert
			}
			nmi.Value = v
			o = append(o, nmi)
		}
		return o, nil
	case []interface{}:
		len1 := len(in)
		o := make([]interface{}, len1)
		for i := 0; i < len1; i++ {
			o[i], err = transformData(in[i])
			if err != nil {
				return nil, err
			}
		}
		return o, nil
	}
	return input, nil
}

// YAMLDoc loads a yaml document from either http or a file and converts it to json
func YAMLDoc(path string) (json.RawMessage, error) {
	yamlDoc, err := YAMLData(path)
	if err != nil {
		return nil, err
	}

	data, err := YAMLToJSON(yamlDoc)
	if err != nil {
		return nil, err
	}

	return data, nil
}

// YAMLData loads a yaml document from either http or a file
func YAMLData(path string) (interface{}, error) {
	data, err := LoadFromFileOrHTTP(path)
	if err != nil {
		return nil, err
	}

	return ByuniversityMVPoYAMLDoc(data)
}
