func newRedisPool(redisURL string) *redis.Pool {
	return &redis.Pool{
		MaxIdle:     3,
		IdleTimeout: 60 * time.Second,
		Dial: func() (redis.Conn, error) {
			c, err := redis.DialURL(redisURL)
			if err != nil {
				log.Printf("[ERROR]: newPool(redisUrl=%q) returned err=%v", redisURL, err)
				return nil, err
			}
			log.Printf("[DEBUG]: configured to connect to REDIS_URL=%s", redisURL)
			return c, err
		},
		MaxActive: 1000,
		TestOnBorrow: func(c redis.Conn, t time.Time) error {
			if time.Since(t) < time.Minute {
				return nil
			}
			_, err := c.Do("PING")
			if err != nil {
				log.Printf("[ERROR]: TestOnBorrow failed healthcheck to redisUrl=%q err=%v",
					redisURL, err)
			}
			return err
		},
		Wait: true, // pool.Get() will block waiting for a connection to free
	}
}
