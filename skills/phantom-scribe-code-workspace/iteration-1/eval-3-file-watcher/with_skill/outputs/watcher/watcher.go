package watcher

import (
	"os"
	"path/filepath"
	"strings"
	"time"
)

// Event is what we send back to the caller. Keeping it minimal for now,
// might add Op type later if we need create vs modify distinction
type Event struct {
	Path    string
	ModTime time.Time
}

// Watcher polls a directory tree. Yeah polling isn't ideal but it works
// cross-platform without cgo and the fsnotify dep was causing issues
// on older mac systems. Revisit if CPU becomes a problem.
type Watcher struct {
	root     string
	exts     []string
	snapshot map[string]time.Time
	events   chan Event
	done     chan struct{}
}

// poll interval — 500ms is a decent tradeoff. faster eats CPU on large trees,
// slower feels laggy for dev workflow
const pollInterval = 500 * time.Millisecond

func New(dir string, exts []string) (*Watcher, error) {
	absDir, err := filepath.Abs(dir)
	if err != nil {
		return nil, err
	}

	// make sure dir actually exists before we start
	info, err := os.Stat(absDir)
	if err != nil {
		return nil, err
	}
	if !info.IsDir() {
		return nil, &os.PathError{Op: "watch", Path: absDir, Err: os.ErrInvalid}
	}

	w := &Watcher{
		root:     absDir,
		exts:     exts,
		snapshot: make(map[string]time.Time),
		events:   make(chan Event, 32),
		done:     make(chan struct{}),
	}

	// take initial snapshot so we don't fire on existing files
	w.scan(true)
	return w, nil
}

func (w *Watcher) Start() <-chan Event {
	go w.loop()
	return w.events
}

func (w *Watcher) Close() {
	close(w.done)
}

func (w *Watcher) loop() {
	ticker := time.NewTicker(pollInterval)
	defer ticker.Stop()
	defer close(w.events)

	for {
		select {
		case <-ticker.C:
			w.scan(false)
		case <-w.done:
			return
		}
	}
}

func (w *Watcher) scan(initial bool) {
	seen := make(map[string]bool)

	filepath.Walk(w.root, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return nil // skip unreadable stuff, don't blow up
		}

		// skip hidden dirs (node_modules/.git/etc get caught by this too)
		name := info.Name()
		if info.IsDir() && strings.HasPrefix(name, ".") {
			return filepath.SkipDir
		}
		if info.IsDir() {
			// also skip node_modules explicitly bc it's not always dotprefixed
			if name == "node_modules" || name == "vendor" || name == "__pycache__" {
				return filepath.SkipDir
			}
			return nil
		}

		if !w.matchExt(path) {
			return nil
		}

		seen[path] = true
		modTime := info.ModTime()

		prev, exists := w.snapshot[path]
		if !exists || modTime.After(prev) {
			w.snapshot[path] = modTime
			if !initial {
				select {
				case w.events <- Event{Path: path, ModTime: modTime}:
				default:
					// channel full, drop event. caller will catch next poll cycle anyway
				}
			}
		}
		return nil
	})

	// detect deletions — not strictly needed for "run on change" but
	// useful if someone wants to trigger on file removal
	if !initial {
		for path := range w.snapshot {
			if !seen[path] {
				delete(w.snapshot, path)
				// could emit a delete event here, leaving for v2
			}
		}
	}
}

func (w *Watcher) matchExt(path string) bool {
	if len(w.exts) == 0 {
		return true // no filter = watch everything
	}
	ext := filepath.Ext(path)
	for _, e := range w.exts {
		if ext == e {
			return true
		}
	}
	return false
}
