library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
    port (
        clk	:	in std_logic;
		  
        instruction: in std_logic_vector(22 downto 0);
		  
		  alu_zero: in std_logic;
		  
        jmp: out std_logic; -- Remember to put jump address in the ALU result
		  
--		  ram_read: out std_logic_vector;
--		  ram_write: out std_logic_vector;
--		  ram_address: out std_logic_vector(7 downto 0); -- Won't be necessary for this project
		  
		  reg_write: out std_logic;
		  reg_write_address: out std_logic_vector(3 downto 0);
		  
		  alu_reg_in1: out std_logic_vector(3 downto 0);
		  alu_reg_in2: out std_logic_vector(3 downto 0);
		  alu_immediate_in: out std_logic_vector(7 downto 0);
		  alu_op: out std_logic_vector(2 downto 0)
    );
end decoder;

architecture decoder_a of decoder is

signal opcode: std_logic_vector(2 downto 0);
signal reg_dest: std_logic_vector(3 downto 0);
signal alu_in1: std_logic_vector(3 downto 0);
signal alu_in2: std_logic_vector(3 downto 0);
signal alu_in3: std_logic_vector(3 downto 0);
signal alu_in4: std_logic_vector(3 downto 0);


begin

	-- Decompose the entry	

	opcode <= instruction(22 downto 20);
	reg_dest <= instruction(19 downto 16);
	alu_in1 <= instruction(15 downto 12);
	alu_in2 <= instruction(11 downto 8);
	alu_in3 <= instruction(7 downto 4);
	alu_in4 <= instruction(3 downto 0);


	decode:process(clk)
	begin

		if rising_edge(clk) then

		jmp <= '0';
		reg_write <= '0';

		alu_op <= opcode;

		case opcode is
			
			when "000" => -- ADD
				reg_write <= '1';
				reg_write_address <= reg_dest;
				
				alu_reg_in1 <= alu_in1;
				alu_immediate_in <= alu_in2 & alu_in3;
				
				
			when "001" => -- SUB
				reg_write <= '1';
				reg_write_address <= reg_dest;
				
				alu_reg_in1 <= alu_in1;
				alu_immediate_in <= alu_in2 & alu_in3;
				
			when "010" => -- FLC
				reg_write <= '1';
				reg_write_address <= reg_dest;
				
				alu_reg_in1 <= alu_in1;
				alu_reg_in2 <= alu_in2;
				alu_immediate_in <= alu_in3 & alu_in4;
			
			
			when "011" => -- MOV
				reg_write <= '1';
				reg_write_address <= reg_dest;
				
				alu_immediate_in <= alu_in1 & alu_in2;
				
			when "100" => -- CAE
				reg_write <= '1';
				reg_write_address <= reg_dest;
				
				alu_immediate_in <= alu_in1 & alu_in2;
			
			when "101" => -- PASS
				-- Nothing
			
			when "110" => -- JMPZ -- All jumps need 3 clock cycles to complete
				if alu_zero = '1' then
					jmp <= '1';
				else
					jmp <= '0';
				end if;
				alu_reg_in1 <= reg_dest;
			
			when "111" => -- AND
				reg_write <= '1';
				reg_write_address <= reg_dest;
				
				alu_reg_in1 <= alu_in1;
				alu_immediate_in <= alu_in2 & alu_in3;
				
			when others => NULL;
			
			
		end case;

		end if;
		
	end process decode;
	 
	 
end decoder_a;
