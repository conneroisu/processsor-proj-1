--Aidan Foss
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_barrelShifter is
	generic (
	   halfClk 	: time := 50 ns;
	   N		: integer := 32);
end tb_barrelShifter;

architecture behavior of tb_barrelShifter is
	constant ClkHelper : time := halfClk * 2;
	component barrelShifter is
		generic (N: integer := 32);
		port (
            		i_data        : in  std_logic_vector(N - 1 downto 0);
            		i_shamt       : in  std_logic_vector(4 downto 0);  --01001 would do shift 3 and shift 0, mux each bit to decide how much to shift
            		i_leftOrRight : in  std_logic;  --0=right, 1=left
            		i_shiftType   : in  std_logic;  --0 for logicical shift, 1 for arithmetic shift
           		o_O           : out std_logic_vector(N - 1 downto 0)  --shifted output
         	);
	end component;
	signal s_data, s_O : std_logic_vector(N-1 downto 0);
	signal s_shamt : std_logic_vector(4 downto 0);
	signal s_leftOrRight, s_shiftType : std_logic;
	signal s_debug : std_logic_vector(N-1 downto 0); --debug value is genius
begin
	shifter1 : barrelShifter
		port map(
			i_data		=> s_data,
			i_shamt		=> s_shamt,
			i_leftOrRight	=> s_leftOrRight,
			i_shiftType	=> s_shiftType,
			o_O		=> s_O);
	shiftTest : process
	begin
----------------------------------------------------------------------------------------------------------
--Begin logical tests, look for improper sign extension
---------------------------------------------------------------------------------------------------------- 
		s_shiftType <= '0';            		--logical shift tests firsts

        	wait for ClkHelper;
       	 	s_leftOrRight          <= '0';          --sll 0
        	s_data          <= x"30303030";		-- 00110000001100000011000000110000 to 00110000001100000011000000110000
	       	s_debug   <= x"30303030"; 		-- 30303030 to 30303030
	       	s_shamt      <= "00000";
	        
	       	wait for ClkHelper;
	       	s_leftOrRight          <= '0';          --sll 1
	       	s_data          <= x"30303030";		-- 00110000001100000011000000110000 to 01100000011000000110000001100000
	       	s_debug   <= x"C0C0C0C0"; 		-- 30303030 to 60606060
	       	s_shamt      <= "00001";  		
	       	 
	       	wait for ClkHelper;
	        s_leftOrRight          <= '1';          --srl 2 (RIGHT 2)
	        s_data          <= x"30303030"; 	-- 0011 0000 0011 0000 0011 0000 0011 0000  	to 	0000 1100 0000 1100 0000 1100 0000 1100
	        s_debug   <= x"0C0C0C0C";		-- 30303030 					to 	0C0C0C0C
	        s_shamt      <= "00010";
 	        
	        wait for ClkHelper;
	        s_leftOrRight          <= '1';          --srl 3 (RIGHT 3)
	        s_data          <= x"30303030"; 	-- 0011 0000 0011 0000 0011 0000 0011 0000 	to 	0000 0110 0000 0110 0000 0110 0000 0110
	        s_debug   <= x"06060606";		-- 30303030 					to 	06060606
 	        s_shamt      <= "00011";
	        
 	        wait for ClkHelper;
 	        s_leftOrRight          <= '1';          --srl 4 (RIGHT 4)
	        s_data          <= x"30303030";  	-- 0011 0000 0011 0000 0011 0000 0011 0000 	to	0000 0011 0000 0011 0000 0011 0000 0011
	        s_debug   <= x"03030303";		-- 30303030 					to	03030303
	        s_shamt      <= "00100";--4
	        
	        wait for ClkHelper;
	        s_leftOrRight          <= '0';          --sll 4 (left 4)
	        s_data          <= x"30303030";  	-- 0011 0000 0011 0000 0011 0000 0011 0000 	to	0000 0011 0000 0011 0000 0011 0000 0000
 	        s_debug   <= x"03030300";		-- 30303030					to	03030300
 	        s_shamt      <= "00100";--4

	        wait for ClkHelper;
	        s_leftOrRight          <= '0';          --sll 5 (left 5)
	        s_data          <= x"40404040";  	-- 0100 0000 0100 0000 0100 0000 0100 0000 	to	0000 1000 0000 1000 0000 1000 0000 0000
 	        s_debug   <= x"06060600";		-- 40404040					to	08080800
 	        s_shamt      <= "00100";--4
	        
	       	wait for ClkHelper;
	       	s_leftOrRight          <= '1';         	--srl 8 (RIGHT 8)
	       	s_data          <= x"30303030";  	-- 0011 0000 0011 0000 0011 0000 0011 0000	to	0000 0000 0011 0000 0011 0000 0011 0000
	       	s_debug   <= x"00303030";		-- 30303030					to	00303030
 	       	s_shamt      <= "01000";
 	       
 	       	wait for ClkHelper;
 	       	s_leftOrRight          <= '0';          --sll 8
 	       	s_data          <= x"40404040";  	--0100 0000 0100 0000 0100 0000 0100 0000	to	0100 0000 0100 0000 0100 0000 0000 0000
 	       	s_debug   <= x"40404000";		--40404040					to	40404000
 	       	s_shamt      <= "01000";

 	       	wait for ClkHelper; --human x2 positive
 	       	s_leftOrRight          <= '0';          --sll 1 (this one should maintain positive value, 5 to 10)
 	       	s_data          <= x"00000005";		--(0)000 0000 0000 0000 0000 0000 0000 0101	to	(0)000 0000 0000 0000 0000 0000 0000 1010
 	       	s_debug   <= x"0000000A";		--00000005					to	0000000A
   	       	s_shamt      <= "00001";

 	       	wait for ClkHelper; --human x2 negative
 	       	s_leftOrRight          <= '0';          --sll 1 (this one shouldnt maintain negative value, -5 to 10)
 	       	s_data          <= x"80000005";		--1000 0000 0000 0000 0000 0000 0000 0101	to	0000 0000 0000 0000 0000 0000 0000 1010
 	       	s_debug   <= x"8000000A";		--80000005					to	0000000A
   	       	s_shamt      <= "00001";

----------------------------------------------------------------------------------------------------------
--Begin arithmetic tests, look for proper sign extension
---------------------------------------------------------------------------------------------------------- 	       
  	        s_shiftType <= '1';
  	      
 	       	wait for ClkHelper;
 	       	s_leftOrRight          <= '0';          --sla 0
  	       	s_data          <= x"ABCDEF12";		--1010 1011 1100 1101 1110 1111 0001 0010	to	1010 1011 1100 1101 1110 1111 0001 0010
  	       	s_debug   <= x"ABCDEF12";		--ABCDEF12					to 	ABCDEF12
  	       	s_shamt      <= "00000";
 	       
 	       	wait for ClkHelper;
 	       	s_leftOrRight          <= '0';          --sla 1 (this one should maintain negative value, -522133280 to -1044266560)
 	       	s_data          <= x"E0E0E0E0";		--(1)110 0000 1110 0000 1110 0000 1110 0000	to	(1)100 0001 1100 0001 1100 0001 1100 0000
 	       	s_debug   <= x"C1C1C1C0";		--E0E0E0E0					to	C1C1C1C0
   	       	s_shamt      <= "00001";

 	       	wait for ClkHelper;
 	       	s_leftOrRight          <= '0';          --sla 1 (this one should maintain positive value, 235802126 to 471604252)
 	       	s_data          <= x"0E0E0E0E";		--(0)000 1110 0000 1110 0000 1110 0000 1110	to	(0)001 1100 0001 1100 0001 1100 0001 1100
 	       	s_debug   <= x"C1C1C1C0";		--E0E0E0E0					to	1C1C1C1C
   	       	s_shamt      <= "00001";

 	       	wait for ClkHelper; --human x2 positive
 	       	s_leftOrRight          <= '0';          --sla 1 (this one should maintain positive value, 5 to 10)
 	       	s_data          <= x"00000005";		--(0)000 0000 0000 0000 0000 0000 0000 0101	to	(0)000 0000 0000 0000 0000 0000 0000 1010
 	       	s_debug   <= x"0000000A";		--00000005					to	0000000A
   	       	s_shamt      <= "00001";

 	       	wait for ClkHelper; --human x2 negative
 	       	s_leftOrRight          <= '0';          --sla 1 (this one should maintain negative value, -5 to -10)
 	       	s_data          <= x"80000005";		--(1)000 0000 0000 0000 0000 0000 0000 0101	to	(1)000 0000 0000 0000 0000 0000 0000 1010
 	       	s_debug   <= x"8000000A";		--80000005					to	8000000A
   	       	s_shamt      <= "00001";
  	      
   	       	wait for ClkHelper;
  	       	s_leftOrRight          <= '1';           --sra
  	       	s_data          <= x"E0E0E0E0";
   	       	s_debug   <= x"F8383838";
  	       	s_shamt      <= "00010";
 	       
 	       	wait for ClkHelper;
 	       	s_leftOrRight          <= '1';           --sra
 	       	s_data          <= x"E0E0E0E0";
 	       	s_debug   <= x"FC1C1C1C";
 	       	s_shamt      <= "00011";
 	       	
 	       	wait for ClkHelper;
  	      	s_leftOrRight          <= '1';           --sra
  	      	s_data          <= x"E0E0E0E0";  -- shift by 4 should mean it becomes F7070707
  	      	s_debug   <= x"FE0E0E0E";
  	      	s_shamt      <= "00100";
   	     	
   	     	wait for ClkHelper;
 	        s_leftOrRight          <= '0';            --sla
  	      	s_data          <= x"30303030";  -- shift by 4 should mean it becomes 07070700
	        s_debug   <= x"07070700";
	        s_shamt      <= "00100";
	        
 	        wait for ClkHelper;
 	        s_leftOrRight          <= '1';            --sra
 	        s_data          <= x"30303030";  -- shift by 8 should mean it becomes 00707070
 	        s_debug   <= x"00707070";
 	        s_shamt      <= "01000";
	        
 	        wait for ClkHelper;
 	       	s_leftOrRight          <= '0';            --sla
  	      	s_data          <= x"30303030";  -- shift by 8 should mean it becomes 70707000
  	      	s_debug   <= x"70707000";
  		s_shamt      <= "01000";
 	   
    end process;
end behavior;
		

