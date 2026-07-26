package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"os/signal"
	"strings"
	"syscall"
	"time"

	"fwatch/watcher"
)

// debounce window — 300ms felt right after testing with vim swapfiles
const defaultDebounce = 300 * time.Millisecond

func main() {
	dir := flag.String("d", ".", "directory to watch")
	cmd := flag.String("c", "", "command to run on change")
	ext := flag.String("ext", "", "file extensions to watch, comma-separated (e.g. go,js)")
	debounceMs := flag.Int("debounce", 300, "debounce window in ms")
	flag.Parse()

	if *cmd == "" {
		fmt.Fprintf(os.Stderr, "usage: fwatch -c <command> [-d dir] [-ext go,js]\n")
		os.Exit(1)
	}

	exts := []string{}
	if *ext != "" {
		for _, e := range strings.Split(*ext, ",") {
			e = strings.TrimSpace(e)
			if !strings.HasPrefix(e, ".") {
				e = "." + e
			}
			exts = append(exts, e)
		}
	}

	debounce := time.Duration(*debounceMs) * time.Millisecond

	w, err := watcher.New(*dir, exts)
	if err != nil {
		fmt.Fprintf(os.Stderr, "failed to init watcher: %v\n", err)
		os.Exit(1)
	}
	defer w.Close()

	// trap signals so we clean up the inotify/kqueue handles
	sigCh := make(chan os.Signal, 1)
	signal.Notify(sigCh, syscall.SIGINT, syscall.SIGTERM)

	events := w.Start()
	fmt.Printf("watching %s for changes...\n", *dir)

	var timer *time.Timer
	var pending bool

	for {
		select {
		case ev, ok := <-events:
			if !ok {
				return
			}
			if !pending {
				pending = true
				timer = time.AfterFunc(debounce, func() {
					runCmd(*cmd, ev)
					pending = false
				})
			} else {
				// reset debounce on rapid changes
				timer.Reset(debounce)
			}

		case sig := <-sigCh:
			fmt.Printf("\ncaught %v, shutting down\n", sig)
			return
		}
	}
}

func runCmd(cmdStr string, ev watcher.Event) {
	fmt.Printf("\n--- %s changed, running command ---\n", ev.Path)
	parts := strings.Fields(cmdStr)
	cmd := exec.Command(parts[0], parts[1:]...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	start := time.Now()
	err := cmd.Run()
	elapsed := time.Since(start)

	if err != nil {
		fmt.Fprintf(os.Stderr, "command failed (%v): %v\n", elapsed, err)
	} else {
		fmt.Printf("--- done in %v ---\n", elapsed)
	}
}
