library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        a, b, c: in std_logic_vector(7 downto 0); -- a and b are the inputs from the register, c is the direct one from the decoder
        op: in std_logic_vector(2 downto 0);
        result: out std_logic_vector(7 downto 0); -- result is directly put according to the write adress coming out of the decoder
		  w_enable : out std_logic
    );
end ALU;		

architecture ALU_arch of ALU is
begin
    process(a, b, c, op)
    begin
        case op is
            when "000" => result <= std_logic_vector(unsigned(a) + unsigned(c));
            when "001" => result <= std_logic_vector(unsigned(a) - unsigned(c));
				when "010" => result(0) <= a(to_integer(unsigned(b))) xnor c(0); -- checks if the floor is called :  a:call list, b:current floor, c:1 to check if florr if called 0 else
            when "011" => result <= c;
            when "100" => result(0) <= ((b(0) and ((b(1) and (not b(2)) and a(7)) or ((not b(1)) and (((a(6)) or (a(7))) or ((not b(2)) and a(5))))))or 
				((not b(0)) and ((a(4) or a(5) or a(6) or a(7)) or ((not(b(1))) and ((a(2) or a(3)) or ((not b(2)) and a(1)))) or (b(1) and a(3)))));
            when "101" => result <= c;
				when "110" => result <= c; 
            when "111" => result <= a xnor c; 
        end case;
		  if ((op = "101") or (op="110")) then
				w_enable <= '0';
		  else
				w_enable <= '1';
		  end if;
    end process;
end ALU_arch;
