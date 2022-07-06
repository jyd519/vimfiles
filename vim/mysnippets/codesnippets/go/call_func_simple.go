func callFunc(fn interface{}, args ...interface{}) []reflect.Value {
	if !(reflect.TypeOf(fn).Kind() == reflect.Func) {
		return fmt.Errorf("%s is not of type reflect.Func", reflect.TypeOf(fn).Kind())
	}
	f := reflect.ValueOf(fn)
	passedArguments := make([]reflect.Value, 0)
	for _, arg := range args {
		passedArguments = append(passedArguments, reflect.ValueOf(arg))
	}

	f.Call(passedArguments)
}
