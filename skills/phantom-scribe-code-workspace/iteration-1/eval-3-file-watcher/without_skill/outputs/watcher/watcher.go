package watcher

import (
	"os"
	"path/filepath"
	"sync"
	"time"
)

// Event represents a file change event.
type Event struct {
	Path string
	Time time.Time
}

// Watcher polls a directory tree for file modifications.
type Watcher struct {
	root     string
	debounce time.Duration
	events   chan Event
	done     chan struct{}
	wg       sync.WaitGroup
	modTimes map[string]time.Time
}

// New creates a Watcher that monitors the given directory.
func New(dir string, debounce time.Duration) (*Watcher, error) {
	absDir, err := filepath.Abs(dir)
	if err != nil {
		return nil, err
	}

	// make sure it exists
	info, err := os.Stat(absDir)
	if err != nil {
		return nil, err
	}
	if !info.IsDir() {
		return nil, &os.PathError{Op: "watch", Path: absDir, Err: os.ErrInvalid}
	}

	w := &Watcher{
		root:     absDir,
		debounce: debounce,
		events:   make(chan Event, 32),
		done:     make(chan struct{}),
		modTimes: make(map[string]time.Time),
	}

	// Build initial snapshot
	w.scan()

	// Start polling
	w.wg.Add(1)
	go w.pollLoop()

	return w, nil
}

// Events returns a read-only channel of file change events.
func (w *Watcher) Events() <-chan Event {
	return w.events
}

// Close stops the watcher and cleans up resources.
func (w *Watcher) Close() error {
	close(w.done)
	w.wg.Wait()
	close(w.events)
	return nil
}

func (w *Watcher) pollLoop() {
	defer w.wg.Done()

	ticker := time.NewTicker(w.debounce)
	defer ticker.Stop()

	for {
		select {
		case <-w.done:
			return
		case <-ticker.C:
			w.check()
		}
	}
}

func (w *Watcher) scan() {
	filepath.Walk(w.root, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return nil // skip files we can't stat
		}
		if info.IsDir() {
			// skip hidden directories
			if len(info.Name()) > 1 && info.Name()[0] == '.' {
				return filepath.SkipDir
			}
			return nil
		}
		w.modTimes[path] = info.ModTime()
		return nil
	})
}

func (w *Watcher) check() {
	current := make(map[string]time.Time)

	filepath.Walk(w.root, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return nil
		}
		if info.IsDir() {
			if len(info.Name()) > 1 && info.Name()[0] == '.' {
				return filepath.SkipDir
			}
			return nil
		}
		current[path] = info.ModTime()
		return nil
	})

	// Check for new or modified files
	for path, modTime := range current {
		prev, existed := w.modTimes[path]
		if !existed || modTime.After(prev) {
			select {
			case w.events <- Event{Path: path, Time: modTime}:
			default:
				// drop if channel is full, don't block the poller
			}
		}
	}

	w.modTimes = current
}
