package config

import (
	"github.com/BurntSushi/toml"
)

// Load 加载应用程序配置
func Load(path string, config interface{}) error {
	if _, err := toml.DecodeFile(path, config); err != nil {
		return err
	}
	return nil
}
