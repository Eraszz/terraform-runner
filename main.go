package main

import (
	"fmt"
	"io/fs"
	"path/filepath"
)

var files = []string{}

func walk(path string, d fs.DirEntry, err error) error {
	if err != nil {
		fmt.Printf("prevent panic by handling failure accessing a path %q: %v\n", path, err)
		return err
	}

	switch isDir := d.IsDir(); isDir {
	case true:
		if d.Name() == ".terraform" {
			return filepath.SkipDir
		}
	case false:
		if d.Name() != "main.tf" {
			return nil
		}

		files = append(files, path)
	}
	return nil
}

func main() {
	filepath.WalkDir(".", walk)

	fmt.Printf("%v", files)

	currentTree, err := commit.Tree()
	CheckIfError(err)
}
