package main

import (
	"fmt"
	"net/http"
	"strings"
	"time"
)

const version = "1.0.0"

func sayHello(w http.ResponseWriter, r *http.Request) {
	message := r.URL.Path
	message = strings.TrimPrefix(message, "/")
	message = "Hello " + message + "\nversion: " + version
	fmt.Fprintf(w, message)
}

func checkHealth(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(200)
}

func printVersion(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, version)
}

func greet(w http.ResponseWriter, r *http.Request) {
	t := time.Now()
	h := t.Hour()
	path := r.URL.Path
	user := strings.SplitAfter(path, "/greet/")[1]
	const (
		morning   = "Good Morning, "
		afternoon = "Good Afternoon, "
		evening   = "Good Evening, "
	)

	var message string

	switch {
	case h >= 0 && h < 12:
		message = morning
	case h >= 12 && h < 18:
		message = afternoon
	case h >= 18:
		message = evening
	}
	message = message + user + "!\n\n" + t.Format(time.ANSIC)
	fmt.Fprintf(w, message)
}

func main() {
	http.HandleFunc("/health", checkHealth)
	http.HandleFunc("/", sayHello)
	http.HandleFunc("/greet/", greet)
	http.HandleFunc("/version", printVersion)

	if err := http.ListenAndServe(":8000", nil); err != nil {
		panic(err)
	}

}
