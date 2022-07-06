		done := make(chan error)
		go func() { done <- c.client.Wait() }()
		select {
		case <-done:
			c.client = nil
		case <-time.After(5 * time.Second):
			log.Println("timeout to close client")
			c.client.Process.Kill()
		}
