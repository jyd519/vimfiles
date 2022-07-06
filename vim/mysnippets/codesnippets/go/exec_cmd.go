func execCmd(cmd string, args ...string) error {
	cmd := exec.Command(cmd, args...)
	if err := cmd.Start(); err != nil {
		return errors.Wrap(err, "failed to start cmd")
	}
	done := make(chan error)
	go func() { done <- cmd.Wait() }()
	select {
	case err := <-done:
		// exited
	case <-time.After(10 * time.Second):
		// timed out
	}

	return nil
}
