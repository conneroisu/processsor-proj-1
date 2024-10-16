package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"
)

// Header template for VHDL files
const headerTemplate = `-- <header>
-------------------------------------------------------------------------------
-- Author(s):
-- Name: %s
-- Notes:
%s
-------------------------------------------------------------------------------
-- </header>
`

// CommitInfo stores commit details for a contributor
type CommitInfo struct {
	AuthorName  string
	AuthorEmail string
	CommitMsg   string
}

func main() {
	// Define the file type that you want to add headers to
	fileExtension := ".vhd"

	// Get the list of all files with the given extension
	files, err := findFilesWithExtension(fileExtension)
	if err != nil {
		log.Fatalf("Error finding VHDL files: %v", err)
	}

	// Add header to each VHDL file
	for _, file := range files {
		commitInfos, err := getCommitHistory(file)
		if err != nil {
			log.Printf("Error getting commit history for %s: %v", file, err)
			continue
		}

		// Generate header content based on commit information
		headerContent := generateHeader(file, commitInfos)
		if err := updateHeaderInFile(file, headerContent); err != nil {
			log.Printf("Error updating header in file %s: %v", file, err)
		}
	}
}

// findFilesWithExtension finds all files with the given extension
func findFilesWithExtension(extension string) ([]string, error) {
	var files []string
	err := filepath.Walk(".", func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() && strings.HasSuffix(info.Name(), extension) {
			files = append(files, path)
		}
		return nil
	})

	if err != nil {
		return nil, err
	}
	return files, nil
}

// getCommitHistory gets the commit history for a given file
func getCommitHistory(filename string) ([]CommitInfo, error) {
	cmd := exec.Command("git", "log", "--pretty=format:%an|%ae|%s", filename)
	output, err := cmd.Output()
	if err != nil {
		return nil, err
	}

	var commitInfos []CommitInfo
	scanner := bufio.NewScanner(strings.NewReader(string(output)))
	for scanner.Scan() {
		parts := strings.Split(scanner.Text(), "|")
		if len(parts) == 3 {
			commitInfos = append(commitInfos, CommitInfo{
				AuthorName:  parts[0],
				AuthorEmail: parts[1],
				CommitMsg:   parts[2],
			})
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, err
	}

	return commitInfos, nil
}

// generateHeader generates the header content for a VHDL file
func generateHeader(filename string, commitInfos []CommitInfo) string {
	var notes strings.Builder
	for _, commit := range commitInfos {
		notes.WriteString(fmt.Sprintf("      - %s %s %s\n", commit.AuthorName, commit.AuthorEmail, commit.CommitMsg))
	}
	return fmt.Sprintf(headerTemplate, filename, notes.String())
}

// updateHeaderInFile updates the header in the VHDL file if the content has changed
func updateHeaderInFile(filename, headerContent string) error {
	// Read the original content of the file
	file, err := os.Open(filename)
	if err != nil {
		return err
	}
	defer file.Close()

	var originalContent strings.Builder
	scanner := bufio.NewScanner(file)
	insideHeader := false
	for scanner.Scan() {
		line := scanner.Text()
		if strings.Contains(line, "-- <header>") {
			insideHeader = true
		}
		if insideHeader && strings.Contains(line, "-- </header>") {
			insideHeader = false
			continue
		}
		if !insideHeader {
			originalContent.WriteString(line + "\n")
		}
	}

	if err := scanner.Err(); err != nil {
		return err
	}

	// Combine the new header with the original content
	newContent := headerContent + originalContent.String()

	// Check if the new content is different from the current content
	currentContent, err := os.ReadFile(filename)
	if err != nil {
		return err
	}

	if newContent == string(currentContent) {
		// No changes needed
		return nil
	}

	// Create a backup of the original file
	backupFilename := fmt.Sprintf("%s.bak_%d", filename, time.Now().Unix())
	if err := os.WriteFile(backupFilename, currentContent, 0644); err != nil {
		return err
	}

	// Write the updated content to the file
	return os.WriteFile(filename, []byte(newContent), 0644)
}
