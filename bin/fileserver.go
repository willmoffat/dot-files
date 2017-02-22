package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
)

var (
	port = flag.String("port", "8000", "port number to attach to")
	dir  = flag.String("dir", ".", "directory to serve")
)

func loggingHandler(h http.Handler) http.Handler {
	fn := func(w http.ResponseWriter, r *http.Request) {
		log.Printf("[%s] %s\n", r.Method, r.URL)
		h.ServeHTTP(w, r)
	}
	return http.HandlerFunc(fn)
}

func main() {
	flag.Parse()
	fmt.Printf("serving %s on http://localhost:%s\n", *dir, *port)
	http.Handle("/", loggingHandler(http.FileServer(http.Dir(*dir))))
	if err := http.ListenAndServe(":"+*port, nil); err != nil {
		log.Fatal("ListenAndServer: ", err)
	}
}
