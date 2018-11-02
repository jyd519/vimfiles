func DecodeUTF16(b []byte, order binary.ByteOrder) string {
	u16s := []uint16{}
	for i, j := 0, len(b); i < j; i += 2 {
		u16s = append(u16s, order.Uint16(b[i:]))
	}
	runes := utf16.Decode(u16s)
	return string(runes)
}

func EncodeUTF16(s string, order binary.ByteOrder) []byte {
	runes := []rune{}
	for _, r := range s {
		runes = append(runes, r)
	}
	u16 := utf16.Encode(runes)
	r := make([]byte, len(u16)*2)
	for i, j := 0, len(u16); i < j; i++ {
		order.PutUint16(r[i*2:], u16[i])
	}
	return r
}
