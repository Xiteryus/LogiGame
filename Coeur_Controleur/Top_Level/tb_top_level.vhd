library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.env.all;


entity tb_Top_level is
end tb_Top_level;

architecture Behavioral of tb_Top_level is
    -- Composant à tester
    component Top_level
        Port (
            CLK100MHZ : in STD_LOGIC;
            sw : in STD_LOGIC_VECTOR(3 downto 0);
            btn : in STD_LOGIC_VECTOR(3 downto 0);
            led : out STD_LOGIC_VECTOR(3 downto 0);
            led0_r : out STD_LOGIC; led0_g : out STD_LOGIC; led0_b : out STD_LOGIC;                
            led1_r : out STD_LOGIC; led1_g : out STD_LOGIC; led1_b : out STD_LOGIC;
            led2_r : out STD_LOGIC; led2_g : out STD_LOGIC; led2_b : out STD_LOGIC;                
            led3_r : out STD_LOGIC; led3_g : out STD_LOGIC; led3_b : out STD_LOGIC
        );
    end component;

    -- Signaux du testbench
    signal CLK100MHZ : std_logic := '0';
    signal sw : std_logic_vector(3 downto 0) := "0000";
    signal btn : std_logic_vector(3 downto 0) := "0000";
    signal led : std_logic_vector(3 downto 0);
    signal led0_r, led0_g, led0_b : std_logic;
    signal led1_r, led1_g, led1_b : std_logic;
    signal led2_r, led2_g, led2_b : std_logic;
    signal led3_r, led3_g, led3_b : std_logic;

begin

    -- Instanciation du DUT
    DUT: Top_level port map (
        CLK100MHZ => CLK100MHZ,
        sw => sw,
        btn => btn,
        led => led,
        led0_r => led0_r, led0_g => led0_g, led0_b => led0_b,
        led1_r => led1_r, led1_g => led1_g, led1_b => led1_b,
        led2_r => led2_r, led2_g => led2_g, led2_b => led2_b,
        led3_r => led3_r, led3_g => led3_g, led3_b => led3_b
    );

    -- Génération de l'horloge 100 MHz
    CLK_process : process
    begin
        CLK100MHZ <= '0';
        wait for 5 ns;
        CLK100MHZ <= '1';
        wait for 5 ns;
    end process;

    -- Stimulus
    stim_proc: process
    begin
        -- Reset
        btn(0) <= '1'; wait for 20 ns;
        btn(0) <= '0'; wait for 20 ns;

        -- Test fonction 1 (btn(1))
        btn(1) <= '1'; sw <= "1010"; wait for 200 ns;
        btn(1) <= '0'; wait for 200 ns;

        -- Test fonction 2 (btn(2))
        btn(2) <= '1'; sw <= "0101"; wait for 500 ns;
        btn(2) <= '0'; wait for 500 ns;

        -- Test fonction 3 (btn(3))
        btn(3) <= '1'; sw <= "1111"; wait for 1000 ns;
        btn(3) <= '0'; wait for 1000 ns;

        -- Fin de la simulation
        std.env.stop;
    end process;

end Behavioral;