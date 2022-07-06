type RenyiSender struct {
	config  *RenyiConfig
	actions chan func()
}

func NewRenyiSender(config *RenyiConfig) *RenyiSender {
	s := &RenyiSender{
		config:  config,
		actions: make(chan func()),
	}
	go s.runLoop()
	return s
}

func (r *RenyiSender) runLoop() {
	for {
		select {
		case fn := <-r.actions:
			fn()
		}
	}
}

