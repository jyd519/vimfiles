import "encoding/json"

type msg struct {
	From    string                     `json:"from,omitempty"`
	To      string                     `json:"to,omitempty"`
	Payload map[string]json.RawMessage `json:"-"`
}

// MarshalJSON marshal msg as bytes
func (t *msg) MarshalJSON() ([]byte, error) {
	data := make(map[string]interface{})
	for k, v := range t.Payload {
		data[k] = v
	}
	if t.From != "" {
		data["from"] = t.From
	}
	if t.To != "" {
		data["to"] = t.To
	}
	return json.Marshal(data)
}

// UnmarshalJSON unmarshal msg from bytes
func (t *msg) UnmarshalJSON(data []byte) error {
	d := struct {
		From string `json:"from,omitempty"`
		To   string `json:"to,omitempty"`
	}{}
	if err := json.Unmarshal(data, &d); err != nil {
		return err
	}
	t.From = d.From
	t.To = d.To
	if err := json.Unmarshal(data, &t.Payload); err != nil {
		return err
	}
	delete(t.Payload, "from")
	delete(t.Payload, "to")
	return nil
}
