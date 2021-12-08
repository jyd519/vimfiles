import "github.com/stretchr/testify/assert"

func TestAssert(t *testing.T) {
	var a string = "Hello"
	var b string = "Hello"

	assert.Equal(t, a, b, "The two words should be the same.")
	assert.Contains(t, "Hello World", "World")
	assert.Empty(t, nil)
	// assert.JSONEqf(t, , , "error message %s", "formatted")
	// actualObj, err := SomeFunction()
	// if assert.Error(t, err) {
	// 	assert.Equal(t, expectedError, err)
	// }
}
