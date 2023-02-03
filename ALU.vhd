library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        a, b, c: in std_logic_vector(7 downto 0); -- a and b are the inputs from the register, c is the direct one from the decoder
        op: in std_logic_vector(2 downto 0);
        result_out: out std_logic_vector(7 downto 0); -- result is directly put according to the write adress coming out of the decoder
		  zero_flag: out std_logic
    );
end ALU;		

architecture ALU_arch of ALU is

signal result : std_logic_vector(7 downto 0);

begin

result_out <= result;

    process(a, b, c, op, result)
    begin
        case op is
            when "000" => result <= std_logic_vector(unsigned(a) + unsigned(c));
            when "001" => result <= std_logic_vector(unsigned(a) - unsigned(c));
				when "010" => result(0) <= (a(to_integer(unsigned(b(2 downto 0)))) xnor c(0)); -- checks if the floor is called :  a:call list, b:current floor, c:1 to check if florr if called 0 else
								  result(7 downto 1) <= "0000000";
            when "011" => result <= c;
            when "100" => result(0) <= ((b(0) and ((b(1) and (not b(2)) and a(7)) or ((not b(1)) and (((a(6)) or (a(7))) or ((not b(2)) and a(5))))))or 
				((not b(0)) and ((a(4) or a(5) or a(6) or a(7)) or ((not(b(1))) and ((a(2) or a(3)) or ((not b(2)) and a(1)))) or (b(1) and a(3)))));
								  result(7 downto 1) <= "0000000";
            when "101" => result <= c;
				when "110" => result <= c; 
            when "111" => result <= a and c;
				when others => NULL;
        end case;
		  if (result = "00000000") then
				zero_flag <= '1';
		  else
				zero_flag <= '0';
		  end if;
    end process;
end ALU_arch;
