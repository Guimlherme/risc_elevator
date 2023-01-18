library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;


entity reg is
	port(
			en		:	in std_logic;
			w_enable :  in std_logic;
			clk		:	in std_logic;
			Address_w	:	in std_logic_vector(3 downto 0);
			Address_r_1 :  in std_logic_vector(3 downto 0); --address of a
			Address_r_2 :  in std_logic_vector(3 downto 0); --address of b
			Data_in	:	in std_logic_vector(7 downto 0);
			SW :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
			Data_out_1:	out std_logic_vector(7 downto 0); -- value a in ALU
			Data_out_2:	out std_logic_vector(7 downto 0); -- value b in ALU
			pc : out std_logic_vector(7 downto 0)
	);
end reg;

architecture reg_arch of reg is

type reg is array(0 to 7) of std_logic_vector(7 downto 0);

signal Data_reg : reg ;



--------------- BEGIN -----------------------------------------------------------------
begin

	acces_reg:process(rst, clk)
		begin
		
		if rising_edge(clk) then
			Data_reg(to_integer(unsigned("000"))) <= std_logic_vector(unsigned(Data_reg(to_integer(unsigned("000"))) + 1)); -- implementation du program counter
			pc <= Data_reg(to_integer(unsigned("000")));
			if en='1' then
				Data_out_1 <= Data_reg(to_integer(unsigned(Address_r_1)));
				Data_out_2 <= Data_reg(to_integer(unsigned(Address_r_2)));
				if w_enable='1' then
					Data_reg(to_integer(unsigned(Adress_w))) <= Data_in;
				end if;
			end if;
			if rising_edge(SW(0)) then
				Data_reg(to_integer(unsigned("001")))(5) <= '0';
			end if;
			if rising_edge(SW(1)) then
				Data_reg(to_integer(unsigned("010")))(0) <= '1';
			end if;
			if rising_edge(SW(2)) then
				Data_reg(to_integer(unsigned("010")))(1) <= '1';
			end if;
			if rising_edge(SW(3)) then
				Data_reg(to_integer(unsigned("010")))(2) <= '1';
			end if;
			if rising_edge(SW(4)) then
				Data_reg(to_integer(unsigned("010")))(3) <= '1';
			end if;
			if rising_edge(SW(5)) then
				Data_reg(to_integer(unsigned("010")))(4) <= '1';
			end if;
			if rising_edge(SW(6)) then
				Data_reg(to_integer(unsigned("010")))(5) <= '1';
			end if;
			if rising_edge(SW(7)) then
				Data_reg(to_integer(unsigned("010")))(6) <= '1';
			end if;
			if rising_edge(SW(8)) then
				Data_reg(to_integer(unsigned("010")))(7) <= '1';
			end if;
		end if;
		
	end process acces_reg;

end reg_arch;
