-------------------------------------------------------------------------
-- author(s): Conner Ohnesorge & Levi Wenck
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- name: tb_alu.vhd
-------------------------------------------------------------------------
-- Description: This file is the test bench for the ALU. It tests the
-- ALU with different test cases. 
-------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_textio.ALL; -- For logic types I/O
LIBRARY std;
USE std.env.ALL; -- For hierarchical/external signals
USE std.textio.ALL; -- For basic I/O
-- The entity for the ALU test bench
ENTITY tb_adder_subtractor IS
	GENERIC (gCLK_HPER : TIME := 10 ns); -- Generic for half of the clock cycle period
END tb_adder_subtractor;
-- The architecture for the ALU test bench
ARCHITECTURE arch OF tb_adder_subtractor IS
	--define the total clock period time
	CONSTANT cCLK_PER : TIME := gCLK_HPER * 2;
	COMPONENT adder_subtractor IS
  PORT (
    nadd_sub : IN STD_LOGIC;
    i_a : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Input A
    i_b : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Input B
    i_s : IN STD_LOGIC;				-- selects between signed or unsigned operations (signed = 1)
    o_y : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); -- Output Y
    o_cout : OUT STD_LOGIC; -- Carry out
    o_overflow : OUT STD_LOGIC -- Overflow Indicator
  );
	END COMPONENT;
	-- Create signals for all of the inputs and outputs of the file that you are testing
	SIGNAL iCLK, reset, carry, s_S,s_addsub, overflow : STD_LOGIC := '0';
	SIGNAL s_Data1, s_Data2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL s_ADDSUBRslt : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL s_Expected: STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
	DUT0 : adder_subtractor
 	PORT MAP(
    		nadd_sub => s_addsub,
    		i_a => s_Data1,
    		i_b => s_Data2,
    		i_s => s_S,
    		o_y => s_ADDSUBRslt,
    		o_cout => carry,
    		o_overflow => overflow
	);
	--This first process is to setup the clock for the test bench
	P_CLK : PROCESS
	BEGIN
		iCLK <= '1'; -- clock starts at 1
		WAIT FOR gCLK_HPER; -- after half a cycle
		iCLK <= '0'; -- clock becomes a 0 (negative edge)
		WAIT FOR gCLK_HPER; -- after half a cycle, process begins evaluation again
	END PROCESS;
	P_RST : PROCESS
	BEGIN
		reset <= '0';
		WAIT FOR gCLK_HPER/2;
		reset <= '1';
		WAIT FOR gCLK_HPER * 2;
		reset <= '0';
		WAIT;
	END PROCESS;
	-- Assign inputs for each test case.
	P_TEST_CASES : PROCESS
	BEGIN
		WAIT FOR gCLK_HPER/2; 
		--Test case 1: subtraction (theoretical outcome?)
		s_Data1 <= x"00000000";
		s_Data2 <= x"80000000";
		s_Expected <= x"7FFFFFFF";
		s_S <= '1';
		s_addsub <= '1';
		WAIT FOR gCLK_HPER * 2;
		WAIT FOR gCLK_HPER * 2;
	END PROCESS;
END arch;
