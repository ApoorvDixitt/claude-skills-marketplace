package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"os/signal"
	"strings"
	"syscall"
	"time"

	"github.com/filewatch/watcher"
)

func main() {
	dir := flag.String("dir", ".", "Directory to watch")
	cmd := flag.String("cmd", "", "Command to run on file change")
	debounce := flag.Duration("debounce", 500*time.Millisecond, "Debounce duration between triggers")
	flag.Parse()

	if *cmd == "" {
		fmt.Fprintf(os.Stderr, "Usage: filewatch -cmd \"go test ./...\" [-dir .] [-debounce 500ms]\n")
		os.Exit(1)
	}

	w, err := watcher.New(*dir, *debounce)
	if err != nil {
		log.Fatalf("Failed to create watcher: %v", err)
	}
	defer w.Close()

	// Handle ctrl+c gracefully
	sigCh := make(chan os.Signal, 1)
	signal.Notify(sigCh, syscall.SIGINT, syscall.SIGTERM)

	fmt.Printf("Watching %s for changes...\n", *dir)
	fmt.Printf("Running: %s\n\n", *cmd)

	events := w.Events()

	go func() {
		for {
			select {
			case ev, ok := <-events:
				if !ok {
					return
				}
				fmt.Printf("[%s] %s changed\n", time.Now().Format("15:04:05"), ev.Path)
				runCommand(*cmd)
			}
		}
	}()

	<-sigCh
	fmt.Println("\nShutting down.")
}

func runCommand(cmdStr string) {
	parts := strings.Fields(cmdStr)
	if len(parts) == 0 {
		return
	}

	cmd := exec.Command(parts[0], parts[1:]...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	fmt.Println("--- running command ---")
	start := time.Now()

	err := cmd.Run()

	elapsed := time.Since(start)
	if err != nil {
		fmt.Printf("--- failed (%s): %v ---\n\n", elapsed.Round(time.Millisecond), err)
	} else {
		fmt.Printf("--- done (%s) ---\n\n", elapsed.Round(time.Millisecond))
	}
}
