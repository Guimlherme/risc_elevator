library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;


entity reg is
	port(
			en		:	in std_logic;
			w_enable :  in std_logic;
			clk		:	in std_logic;
			SW :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
			Address_w	:	in std_logic_vector(3 downto 0);
			Address_r_1 :  in std_logic_vector(3 downto 0); --address of a
			Address_r_2 :  in std_logic_vector(3 downto 0); --address of b
			Data_in	:	in std_logic_vector(7 downto 0);
			Data_out_1:	out std_logic_vector(7 downto 0); -- value a in ALU
			Data_out_2:	out std_logic_vector(7 downto 0); -- value b in ALU
	);
end reg;

architecture reg_arch of reg is


type reg is array(0 to 7) of std_logic_vector(7 downto 0);

signal Data_reg : reg ;



--------------- BEGIN -----------------------------------------------------------------
begin

	acces_reg:process(clk)
		begin
		
		if rising_edge(clk) then
--			Data_reg(0) <= std_logic_vector(unsigned(Data_reg(0)) + 1); -- implementation du program counter
--			pc <= Data_reg(0); -- pc was moved to fetch
			if en='1' then
				Data_out_1 <= Data_reg(to_integer(unsigned(Address_r_1)));
				Data_out_2 <= Data_reg(to_integer(unsigned(Address_r_2)));
				if w_enable='1' then
					Data_reg(to_integer(unsigned(Address_w))) <= Data_in;
				end if;
			end if;
			if SW(0) = '1' then
				Data_reg(1)(5) <= '0';
			end if;
			Data_reg(2) <= SW(8 downto 1);
		end if;
		
	end process acces_reg;

end reg_arch;
