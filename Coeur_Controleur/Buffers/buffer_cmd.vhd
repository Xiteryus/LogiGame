library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity buffer_cmd is
    Port (
        clk : in std_logic;
        reset : in std_logic;
        enable_buffer : in std_logic;
        buffer_in : in std_logic_vector(7 downto 0);
        buffer_out : out std_logic_vector(7 downto 0)
    );
end buffer_cmd;

architecture buffercmd_Arch of buffer_cmd is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            buffer_out <= (others => '0');
        elsif rising_edge(clk) then
            if enable_buffer = '1' then
                buffer_out <= buffer_in;
            end if;
        end if;
    end process;
end buffercmd_Arch;
