package main

import (
	"fmt"
	"html/template"
	"net/http"
	"strings"
	"time"
)

const version = "3.0.0"

var htmlTemplate = `<html>
<head>
    <title>Hello Go!</title>
</head>
<body>
	{{ .TimeOfTheDay }} <b><i>{{ .Name }}</i></b>
	<br><br>
	<b>{{ .Date }}</b>
	<br><br>
	Running version: <u> {{ .Version}} </u>
</body>
</html>`

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
	message := "\n<b>" + version + "</b>\n"
	fmt.Fprintf(w, message)
}

func greet(w http.ResponseWriter, r *http.Request) {
	tmpl := template.New("main")
	tmpl, _ = tmpl.Parse(htmlTemplate)

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

	type Data struct {
		TimeOfTheDay string
		Name         string
		Date         string
		Version      string
	}

	switch {
	case h >= 0 && h < 12:
		message = morning
	case h >= 12 && h < 18:
		message = afternoon
	case h >= 18:
		message = evening
	}

	data := Data{
		TimeOfTheDay: message,
		Name:         user,
		Date:         t.Format(time.ANSIC),
		Version:      version,
	}
	//message = message + "<i> " + user + "!</i>\n\n<br>" + t.Format(time.ANSIC) + "</br>\n"
	//fmt.Fprintf(w, message)
	tmpl.Execute(w, &data)
}

func main() {
	http.HandleFunc("/health", checkHealth)
	http.HandleFunc("/", sayHello)
	http.HandleFunc("/hello-go/greet/", greet)
	http.HandleFunc("/hello-go/version", printVersion)

	if err := http.ListenAndServe(":8000", nil); err != nil {
		panic(err)
	}

}
