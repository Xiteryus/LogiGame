library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.env.all;

entity tb_minuteur is
end tb_minuteur;

architecture testbench of tb_minuteur is

    component minuteur
        Port (
            clk       : in  std_logic;
            reset     : in  std_logic;
            start     : in  std_logic;
            sw_level  : in  std_logic_vector(1 downto 0);
            timeout   : out std_logic
        );
    end component;

    signal clk       : std_logic := '0';
    signal reset     : std_logic := '0';
    signal start     : std_logic := '0';
    signal sw_level  : std_logic_vector(1 downto 0) := "00";
    signal timeout   : std_logic;

    -- Horloge 100 MHz 
    constant CLK_PERIOD : time := 5 ns;
    
    -- Constantes réduites simulation
    constant TRES_FACILE_CYCLES : integer := 1000000;  
    constant FACILE_CYCLES      : integer := 500000;   
    constant MOYEN_CYCLES       : integer := 250000;   
    constant DIFFICILE_CYCLES   : integer := 130000;   

begin

    minut: entity work.minuteur
        generic map (
            TRES_FACILE => TRES_FACILE_CYCLES,
            FACILE      => FACILE_CYCLES,
            MOYEN       => MOYEN_CYCLES,
            DIFFICILE   => DIFFICILE_CYCLES
        )
        port map (
            clk      => clk,
            reset    => reset,
            start    => start,
            sw_level => sw_level,
            timeout  => timeout
        );

    -- Génération de l'horloge
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    stim_proc: process
    begin
        
        -- Test niveau "00" (très facile)
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        sw_level <= "00";
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        
        -- Attendre le timeout (100 cycles + marge)
        wait until timeout = '1' for (TRES_FACILE_CYCLES + 10)*CLK_PERIOD;
        assert timeout = '1' 
            report "Erreur : timeout non activé (niveau 00)" 
            severity error;
        
        wait for 5*CLK_PERIOD;
        
        -- Test niveau "01" (facile)
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        sw_level <= "01";
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        
        wait until timeout = '1' for (FACILE_CYCLES + 10)*CLK_PERIOD;
        assert timeout = '1' 
            report "Erreur : timeout non activé (niveau 01)" 
            severity error;
        
        wait for 5*CLK_PERIOD;
        
        -- Test niveau "10" (moyen)
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        sw_level <= "10";
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        
        wait until timeout = '1' for (MOYEN_CYCLES + 10)*CLK_PERIOD;
        assert timeout = '1' 
            report "Erreur : timeout non activé (niveau 10)" 
            severity error;
        
        wait for 5*CLK_PERIOD;
        
        -- Test niveau "11" (difficile)
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        sw_level <= "11";
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        
        wait until timeout = '1' for (DIFFICILE_CYCLES + 10)*CLK_PERIOD;
        assert timeout = '1' 
            report "Erreur : timeout non activé (niveau 11)" 
            severity error;
        
        wait for 10*CLK_PERIOD;
        std.env.stop; -- stoper la simulation

    end process;

end testbench;