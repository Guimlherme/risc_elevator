library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        a, b: in unsigned;
        op: in std_logic_vector(2 downto 0);
        result: out unsigned
    );
end ALU;

architecture ALU_arch of ALU is
begin
    process(a, b, op)
    begin
        case op is
            when "000" => result <= a + b;
            when "010" => result <= a - b;
				when "001" => result <= a + 1;
            when "011" => result <= a - 1;
            when "100" => result <= a and b;
            when "101" => result <= a or b;
				when "110" => result <= nothing; -- correct this later
            when "111" => result <= nothing; -- correct this later
        end case;
    end process;
end ALU_arch;
