# Processor Project 1

Due Oct 25th

| Criteria | Ratings | Pts |
| --- | --- | --- |
| Prelab: team contract was submitted and completely filled out | 5 pts | 5 pts |
| Problem 1: MIPS Single-Cycle Processor. 5 points for reasonable schematic; 5 points for VHDL file that reasonably matches schematic | 10 pts | 10 pts |
| Problem 2: Component Implementation a: 3 points for spreadsheet; 4 points for testbench and corresponding schematic; b: 3 points for description; 3 points for schematic and answer; 3 points for testbench and corresponding schematic c: 9 points for ALU -- equal points for reasonable components and total ALU design (all or nothing -- must have everything required, including testbenches, design schematics, question responses, waveforms, discussion, etc.) | 25 pts | 25 pts |
| Problem 3: Testing Each required test is equally weighted fraction of total points. If any part of waveform, annotation/discussion, or assembly file is missing, no points for that test. Full credit is given so long as the program reasonably meets the intended testing purpose (must successfully run in MARS, but not necessarily on processor). | 20 pts | 20 pts |                
| Problem 4: Synthesis 5 points for reporting a reasonable critical path that is tracked through their top-level modules (PC -> Memory -> reg file -> ALU -> Memory, etc), if not the specific signals of the design (PC bit 0 -> Memory address 0 -> reg file address A bit 0 -> register file mux select line bit 0 , etc). 5 points for Fmax | 10 pts | 10 pts |
| Correctness: 10 points * (Fraction of HW5 test cases that work) 5 points for every instruction test program entirely working (all or nothing) 10 points for bubblesort (and mergesort if $>4$ ) matching MARS (must have implementation working reasonably well in MARS to get points) (all or nothing) 5 points for Grendel.s entirely working | 30 pts | 30 pts |


## Project Structure 

```bash
.
├── 381_tf.sh
├── cpre381-toolflow.md
├── cpre381-toolflow.pdf
├── internal
│   ├── boilerplate_mips
│   │   ├── addiseq.s
│   │   ├── fibonacci.s
│   │   ├── grendel.s
│   │   ├── lab3Seq.s
│   │   └── simplebranch.s
│   ├── boilerplate_src
│   │   ├── MIPS_types.vhd
│   │   ├── README.md
│   │   └── TopLevel
│   │       ├── mem.vhd
│   │       └── MIPS_Processor.vhd
│   ├── config.ini
│   ├── format.sh
│   ├── headers (program to add headers to files based on git)
│   │   ├── go.mod
│   │   ├── main.go
│   │   └── out.md
│   ├── Mars
│   │   └── MARS_CPRE381.jar
│   ├── ModelSimContainer (Questasim Simulation files)
│   ├── snthpy (Synthesis Python files)
│   └── testpy (Test Python files)
├── Makefile
├── proj
│   ├── mips
│   │   └── {assembly-files}
│   ├── procProj1.cr.mti (Questasim project file)
│   ├── procProj1.mpf (Questasim project file)
│   ├── src
│   │   ├── LowLevel
│   │   │   └── {low-level-components}
│   │   ├── MIPS_types.vhd
│   │   ├── README.md
│   │   └── TopLevel
│   │       ├── barrelShifter.vhd
│   │       ├── Control
│   │       │   └── control_unit.vhd
│   │       ├── Fetch
│   │       │   ├── program_counter_dff.vhd
│   │       │   ├── program_counter.vhd
│   │       │   └── register_file.vhd
│   │       ├── mem.vhd
│   │       ├── MIPS_Processor.vhd
│   │       └── Sign-Extend
│   │           └── sign_extend.vhd
│   └── test
│       ├── tb_control_unit.do
│       ├── tb_control_unit.vhd
│       ├── tb_decoder_5t32.do
│       ├── tb_decoder_5t32.vhd
│       ├── tb_dffg.do
│       ├── tb_dffg_n.do
│       ├── tb_dffg_n.vhd
│       ├── tb_dffg.vhd
│       ├── tb_mux2t1_N.do
│       ├── tb_mux2t1_N.vhd
│       ├── tb_register_file.do
│       ├── tb_register_file.vhd
│       ├── tb_sign_extend.do
│       └── tb_sign_extend.vhd
├── Proj1_control_signals(1).xlsx
├── Proj1_Fall23.pdf
├── Proj1_report.doc
├── Proj1_team_contract.doc
├── pyproject.toml
├── README.md
└── uv.lock
```

## SSH KEYS




## Using SSH Tokens (github)

1. Generate a new SSH key
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

2. Start the ssh-agent in the background
```bash
eval "$(ssh-agent -s)"
```

3. Add your SSH private key to the ssh-agent
```bash
ssh-add ~/.ssh/id_ed25519
```
and print out the public key:
```bash
cat ~/.ssh/id_ed25519.pub
```

4. Add the SSH key to your GitHub account

**Select** SSH and GPG Keys under the access menuitem in your account settings.

<img src="resources/Pasted%20image%2020240407141847.png" alt="Pasted image 20240407141847.png" style="zoom:50%;" />

**Click** on new SSH key and paste the public key into the input box to be shown.

<img src="./resources/Pasted image 20240407142015.png" alt="Pasted image 20240407142015.png" style="zoom:50%;" />

**Paste** the public key into the key input shown below.

<img src="resources/Pasted%20image%2020240407142115.png" alt="Pasted image 20240407142115.png" style="zoom:50%;" />

You should now be **ready** to use ssh just remember to either set the remote url manually or clone using ssh. The terminal command to clone this repo using ssh is in the next step.

1. Use the SSH URL to clone the repository

```bash
git clone git@github.com:conneroisu/processor-proj-1.git
```


