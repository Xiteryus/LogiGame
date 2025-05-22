library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TBlsfr4bits is
end TBlsfr4bits;

architecture test of TBlsfr4bits is

    -- Composant 
    component lsfr4bits
        Port (
            clk    : in  std_logic;
            reset  : in  std_logic;
            enable : in  std_logic;
            rnd    : out std_logic_vector(3 downto 0)
        );
    end component;

    -- Signaux 
    signal clk    : std_logic := '0';
    signal reset  : std_logic := '1';
    signal enable : std_logic := '0';
    signal rnd    : std_logic_vector(3 downto 0);

    -- Horloge : 100 MHz (10 ns période)
    constant CLK_PERIOD : time := 10 ns;

begin

    -- LIASON
    lsfr: lsfr4bits
        port map (
            clk    => clk,
            reset  => reset,
            enable => enable,
            rnd    => rnd
        );

    -- Horloge
    clk_process : process
    begin
        while now < 1000 ns loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Simulation
    stim_proc: process
    begin
        wait for 20 ns;
        reset <= '0';
        enable <= '1';
        wait for 500 ns;
        enable <= '0';
        wait;
    end process;
end test;
