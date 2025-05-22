library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ual_selout is
    Port (
        SEL_OUT : in  std_logic_vector(1 downto 0);
        S : in  std_logic_vector(7 downto 0);
        MEM_CACHE_1_IN : in  std_logic_vector(7 downto 0);
        MEM_CACHE_2_IN : in  std_logic_vector(7 downto 0);
        RES_OUT : out std_logic_vector(7 downto 0)
    );
end ual_selout;

architecture ual_sel_out of ual_selout is
begin
    process(SEL_OUT, S, MEM_CACHE_1_IN, MEM_CACHE_2_IN)
    begin
        case SEL_OUT is
            when "00" =>
                RES_OUT <= (others => '0');
            when "01" =>
                RES_OUT <= MEM_CACHE_1_IN;
            when "10" =>
                RES_OUT <= MEM_CACHE_2_IN;
            when others =>
                RES_OUT <= S;
        end case;
    end process;
end ual_sel_out;
