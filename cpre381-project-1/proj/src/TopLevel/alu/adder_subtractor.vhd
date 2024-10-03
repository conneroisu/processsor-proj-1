-------------------------------------------------------------------------
-- Conner Ohnesorge
-- DEPARTMENT OF ELECTRICAL ENGINEERING
-- IOWA STATE UNIVERSITY
-------------------------------------------------------------------------
-- name: adder_subtractor.vhd
-------------------------------------------------------------------------
-- Description: This file contains the VHDL code for a 32-bit adder/subtractor.
-- The adder/subtractor is implemented using a full adder, a 2-to-1 multiplexer,
-- and a 32-bit 1's complementer. The adder/subtractor has a control signal
-- that determines whether the operation is addition or subtraction.
-------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Entity for the adder/subtractor.
ENTITY adder_subtractor IS
  GENERIC (
    n : INTEGER := 32 -- Generic of type integer for input/output data width. Default value is 32.
  );
  PORT (
    nadd_sub : IN STD_LOGIC;
    i_a : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0); 	-- Input A
    i_b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0); 	-- Input B
    i_s : IN STD_LOGIC;				-- selects between signed or unsigned operations (signed = 1)
    o_y : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0); -- Output Y
    o_cout : OUT STD_LOGIC; 			-- Carry out
    o_overflow : OUT STD_LOGIC 			-- Overflow Indicator
  );
END ENTITY adder_subtractor;

-- Architecture for the adder/subtractor.
ARCHITECTURE structural OF adder_subtractor IS

  COMPONENT mux2t1_n IS GENERIC (
    n : INTEGER := 32
    );
    PORT (
      i_s : IN STD_LOGIC;
      i_d0 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      i_d1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      o_o : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT comp1_N IS GENERIC (
    n : INTEGER := 32
    );
    PORT (
      i_D0 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      o_O : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT fulladder IS
    PORT (
      i_x0 : IN STD_LOGIC;
      i_x1 : IN STD_LOGIC;
      i_cin : IN STD_LOGIC;
      o_y : OUT STD_LOGIC;
      o_cout : OUT STD_LOGIC
    );
  END COMPONENT;

-- Overflow occurs when:  
    -- Two negative numbers are added and an answer comes positive or 
    -- Two positive numbers are added and an answer comes as negative. 

-- used for overflow detection (if carry value into MSB doesn't match the carry out value, then overflow occured)
  COMPONENT xorg2 is
  	port (i_a : in	std_logic;
    	i_b : in	std_logic;
    	o_f : out	std_logic
  	);
  END COMPONENT;

  COMPONENT andg2 is
  	port (i_a : in	std_logic;
    	i_b : in	std_logic;
    	o_f : out	std_logic
  	);
  END COMPONENT;

  COMPONENT mux2t1 is
  	port (
    	i_s  : in std_logic; -- selector
    	i_d0 : in std_logic; -- data inputs
    	i_d1 : in std_logic; -- data inputs
    	o_o  : out std_logic -- output
  	);
  END COMPONENT;

  SIGNAL s_overflow : STD_LOGIC;
  SIGNAL c : STD_LOGIC_VECTOR(n DOWNTO 0); -- Carry
  SIGNAL s1, s2, s3, s4 : STD_LOGIC_VECTOR(n - 1 DOWNTO 0); -- Signals for the 2nd input and the output of the 2nd input.

BEGIN

  -- Invert the 2nd input and output it in wire s1. (used for signed operations)
  inverter : COMPONENT comp1_N
    PORT MAP(
      i_D0 => i_b,
      o_O => s1
    );

-- TODO  replace addsubctrl 1/2 and operationsigned with 4t1 mux

    addsubctrl1 : COMPONENT mux2t1_n --wtf is this meant to do, what was I thinking
      PORT MAP(
        i_s => nadd_sub,
        i_d0 => i_b,
        i_d1 => i_b,
        o_o => s2
      );

    -- Forward either subtraction signal or addition signal
    addsubctrl2 : COMPONENT mux2t1_n
      PORT MAP(
        i_s => nadd_sub,
        i_d0 => i_b,
        i_d1 => s1,
        o_o => s3
      );

    -- Let through either signed/unsigned addition signal, or subtraction signal (inverted)
    -- forward either current signal or inverted (for unsigned subtraction)
    OperationSigned : COMPONENT mux2t1_n
      PORT MAP(
        i_s => nadd_sub,
        i_d0 => s2,
        i_d1 => s3,
        o_o => s4
      );

      c(0) <= nadd_sub; --does 2s complement for signed subtraction only

      g_fulladder : FOR i IN 0 TO n - 1 GENERATE -- create 32 full adders in parallel

        fulladderlist : COMPONENT fulladder
          PORT MAP(
            i_x0 => i_a(i),
            i_x1 => s3(i),
            i_cin => c(i),
            o_y => o_y(i),
            o_cout => c(i + 1)
          );

        END GENERATE g_fulladder;

        o_cout <= c(n);	    

	--overflow_detection : COMPONENT xorg2 (TODO REIMPLEMENT IN FINAL ITERATION)
	--PORT MAP(
		--i_a => c(n), -- carry out of MSB
		--i_b => c(n-1), -- carry in of MSB
		--o_f => s_overflow
	--);
	s_overflow <= c(n) XOR c(n-1);

	overflow_suppression: COMPONENT andg2
	PORT MAP(
			i_a => s_overflow, 	-- carry out of MSB
			i_b => i_s,		-- no overflow on unsigned operations
			o_f => o_overflow
	);

      END ARCHITECTURE structural;
