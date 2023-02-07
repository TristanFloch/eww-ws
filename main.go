package main

import (
	"log"
	"os"

	"github.com/akamensky/argparse"
)

type WM interface {
	detect() bool
	getWorkspaces() ([]Workspace, error)
	listen() error
}

var managers = []WM{Hyperland{}, Sway{}}

func parseArgs() Colors {
	parser := argparse.NewParser("Colors", "Color codes to include in the output")
	f := parser.String("f", "focused", &argparse.Options{Required: true, Help: "Color of the focused workspace"})
	v := parser.String("v", "visible", &argparse.Options{Required: true, Help: "Color of a visible workspace"})
	u := parser.String("u", "urgent", &argparse.Options{Required: true, Help: "Color of an urgent workspace"})
	a := parser.String("a", "active", &argparse.Options{Required: true, Help: "Color of an active workspace"})

	err := parser.Parse(os.Args)
	if err != nil {
		log.Fatal(parser.Usage(err))
	}

	return Colors{*f, *v, *u, *a}
}

var colors Colors = Colors{"#000000", "#000000","#000000","#000000"}

func main() {
	args := os.Args[1:]
	if len(args) > 0 {
		colors = parseArgs()
	}
	for _, manager := range managers {
		if manager.detect() {
			err := manager.listen()
			if err != nil {
				log.Fatal(err)
			}
		}
	}

}
