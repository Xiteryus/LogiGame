library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity buffer_ual is
    Port (
        clk                : in  std_logic;
        reset              : in  std_logic;
        
        enable_buffer_A     : in  std_logic;
        enable_buffer_B     : in  std_logic;
       
        e1 : in  std_logic_vector(3 downto 0);
        
        buffer_A_out   : out std_logic_vector(3 downto 0);
        buffer_B_out   : out std_logic_vector(3 downto 0)
    );
end buffer_ual;

architecture bufferUAL_Arch of buffer_ual is
    begin
        -- Buffer A
        BufferA : process(clk, reset)
        begin
            if reset = '1' then
            buffer_A_out <= (others => '0');
            elsif rising_edge(clk) then
                if enable_buffer_A = '1' then
                buffer_A_out <= e1;
                end if;
            end if;
        end process;

        -- Buffer B
        BufferB : process(clk, reset)
        begin
            if reset = '1' then
            buffer_B_out <= (others => '0');
            elsif rising_edge(clk) then
                if enable_buffer_A = '1' then
                buffer_B_out <= e1;
                end if;
            end if;
        end process;       
end bufferUAL_Arch;

