library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 use std.env.all;

entity tb_buffer_ual is
end tb_buffer_ual;

architecture behavior of tb_buffer_ual is

    component buffer_ual
        Port (
            clk          : in  std_logic;
            reset        : in  std_logic;
            enable_buffer: in  std_logic;
            buffer_in    : in  std_logic_vector(3 downto 0);
            buffer_out   : out std_logic_vector(3 downto 0)
        );
    end component;

    signal clk           : std_logic := '0';
    signal reset         : std_logic := '0';
    signal enable_buffer : std_logic := '0';
    signal buffer_in     : std_logic_vector(3 downto 0) := (others => '0');
    signal buffer_out    : std_logic_vector(3 downto 0);

    constant clk_period : time := 10 ns;

begin

    uut: buffer_ual
        port map (
            clk           => clk,
            reset         => reset,
            enable_buffer => enable_buffer,
            buffer_in     => buffer_in,
            buffer_out    => buffer_out
        );

    -- Clock process
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        -- Cas 1 
        buffer_in <= "1010";
        enable_buffer <= '1';
        wait for clk_period;
        -- Cas 2
        buffer_in <= "0101";
        enable_buffer <= '0';
        wait for clk_period;
        -- Cas 3 
        buffer_in <= "1111";
        enable_buffer <= '1';
        wait for clk_period;
        wait for clk_period;


    std.env.stop;
    end process;

end behavior;
