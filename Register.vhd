library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;


entity reg is
	port(
			rw,en		:	in std_logic;
			clk		:	in std_logic;
			Adress	:	in std_logic_vector(7 downto 0);
			Data_in	:	in std_logic_vector(7 downto 0);
			Data_out:	out std_logic_vector(7 downto 0)
			);
end reg;

architecture register_arch of reg is

type reg is array(0 to 7) of std_logic_vector(15 downto 0);

signal Data_reg : reg ;



--------------- BEGIN -----------------------------------------------------------------
begin
-- rw='1' alors lecture
	acces_reg:process(rst, clk)
		begin
		
		if rising_edge(clk) then
			if en='1' then
				if(rw='1') then 
					Data_out <= Data_reg(to_integer(unsigned(Adress)));
				else
					Data_reg(to_integer(unsigned(Adress))) <= Data_in;
				end if;
			end if;
		end if;
		
	end process acces_reg;

end reg_arch;
