package web

import (
	"context"
	"net/http"
)

// AuthUser represents account
type AuthUser struct {
	User     string `toml:"user"`
	Password string `toml:"password"`
}

type key int

// ctxUserKey refers the current user name in the Context
const ctxUserKey key = 0

// BasicAuth authenticate requests with given credential
func BasicAuth(users map[string]string) func(next http.Handler) http.Handler {
	middle := func(next http.Handler) http.Handler {
		fn := func(w http.ResponseWriter, r *http.Request) {
			// Get the Basic Authentication credentials
			user, password, hasAuth := r.BasicAuth()

			if hasAuth {
				requiredPassword, ok := users[user]
				if ok && password == requiredPassword {
					// Delegate request to the given handle
					ctx := context.WithValue(r.Context(), ctxUserKey, user)
					next.ServeHTTP(w, r.WithContext(ctx))
					return
				}
			}

			// Request Basic Authentication otherwise
			w.Header().Set("WWW-Authenticate", "Basic realm=Restricted")
			http.Error(w, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)
		}

		return http.HandlerFunc(fn)
	}

	return middle
}

// GetAuthUser return current user's name in the context
func GetAuthUser(r *http.Request) string {
	v := r.Context().Value(ctxUserKey)
	if v == nil {
		return ""
	}
	return v.(string)
}
