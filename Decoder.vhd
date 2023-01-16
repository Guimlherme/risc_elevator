library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
    port (
        clk		:	in std_logic;
		  
        instruction: in unsigned(3 downto 0);
		  
        jmp: out std_logic;
		  
		  reg_address: out std_logic_vector(7 downto 0);
		  alu_out1: out std_logic_vector(3 downto 0);
		  alu_out2: out std_logic_vector(3 downto 0);
		  alu_regin1: out std_logic_vector(2 downto 0);
		  alu_op: out std_logic_vector(2 downto 0)
    );
end decoder;

architecture decoder_a of decoder is

signal alu1, alu2: std_logic_vector(3 downto 0);
signal op: std_logic_vector(2 downto 0);

begin

-- define signals
-- Decompose the entry

    process(clk)
    begin
        case op is
            when "000" => alu_op <= "00"; -- Increment
            when "010" => result <= a - b; op = dec -- Decrement
				when "001" => result <= a + 1; op = nothing -- Set register
            when "011" => result <= a - 1; -- Conditional jump
            when "100" => result <= a and b; -- Equals
            when "101" => result <= a or b; -- Greater than
				when "110" => result <= nothing; -- Elevator comparison
            when "111" => result <= nothing; -- Reserved
        end case;
    end process;
	 
	 alu_out1 <= alu1
	 alu_out2 <= alu2
	 alu_op <= op;
	 
end decoder_a;
