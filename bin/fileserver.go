package main

import (
	"fmt"
	"log"
	"net/http"
)

func loggingHandler(h http.Handler) http.Handler {
	fn := func(w http.ResponseWriter, r *http.Request) {
		log.Printf("[%s] %s\n", r.Method, r.URL)
		h.ServeHTTP(w, r)
	}
	return http.HandlerFunc(fn)
}

func main() {
	fmt.Println("Serving files on http://localhost:8080")
	http.Handle("/", loggingHandler(http.FileServer(http.Dir("."))))
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal("ListenAndServer: ", err)
	}
}
