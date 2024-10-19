package main

import (
	"bytes"
	"fmt"
	"log"
	"os/exec"
)

func main() {
	// The git command to be executed
	cmd := exec.Command("git", "log",
		"--date=iso8601-strict",
		"--pretty=format:{%n  \"commit\": \"%H\",%n  \"author\": \"%aN <%aE>\",%n  \"date\": \"%ad\",%n  \"timestamp\": %at,%n  \"message\": \"%f\",%n  \"repo\": \"$repository\"%n},",
		"main.go")

	// Buffer to capture the git output
	var gitLogBuffer bytes.Buffer
	cmd.Stdout = &gitLogBuffer

	// Execute the git log command
	err := cmd.Run()
	if err != nil {
		log.Fatalf("Failed to run git log command: %v", err)
	}

	// Use Perl to format the output
	perlCmd1 := exec.Command("perl", "-pe", "BEGIN{print \"[\"}; END{print \"]\\n\"}")
	perlCmd1.Stdin = &gitLogBuffer

	var perlBuffer1 bytes.Buffer
	perlCmd1.Stdout = &perlBuffer1

	err = perlCmd1.Run()
	if err != nil {
		log.Fatalf("Failed to run first Perl command: %v", err)
	}

	// Process the second Perl command (removing the trailing comma)
	perlCmd2 := exec.Command("perl", "-pe", "s/},]/}]/")
	perlCmd2.Stdin = &perlBuffer1

	var perlBuffer2 bytes.Buffer
	perlCmd2.Stdout = &perlBuffer2

	err = perlCmd2.Run()
	if err != nil {
		log.Fatalf("Failed to run second Perl command: %v", err)
	}

	// Process the third Perl command (handling backslashes)
	perlCmd3 := exec.Command("perl", "-pe", "s{\\\\}{\\\\\\\\}g")
	perlCmd3.Stdin = &perlBuffer2

	var perlFinalBuffer bytes.Buffer
	perlCmd3.Stdout = &perlFinalBuffer

	err = perlCmd3.Run()
	if err != nil {
		log.Fatalf("Failed to run third Perl command: %v", err)
	}

	// Print the final formatted output
	fmt.Println(perlFinalBuffer.String())
}
