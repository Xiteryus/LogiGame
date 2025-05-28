library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.env.all;


entity tb_Top_level is
end tb_Top_level;

architecture Behavioral of tb_Top_level is
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

    signal CLK100MHZ : std_logic := '0';
    signal sw : std_logic_vector(3 downto 0) := "0000";
    signal btn : std_logic_vector(3 downto 0) := "0000";
    signal led : std_logic_vector(3 downto 0);
    signal led0_r, led0_g, led0_b : std_logic;
    signal led1_r, led1_g, led1_b : std_logic;
    signal led2_r, led2_g, led2_b : std_logic;
    signal led3_r, led3_g, led3_b : std_logic;

begin

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

    -- Horloge
    CLK_process : process
    begin
        CLK100MHZ <= '0';
        wait for 5 ns;
        CLK100MHZ <= '1';
        wait for 5 ns;
    end process;

stim_proc: process
begin
    -- Reset
    btn(0) <= '1'; wait for 20 ns;
    btn(0) <= '0'; wait for 20 ns;

    -- Test fonction 1
    btn <= "0001"; sw <= "0010"; wait for 500 ns;
    btn <= "0000"; wait for 100 ns;
    wait for 1 us;
    report "=== TEST 1 ===" severity note;
    report "A=" & integer'image(to_integer(unsigned(sw))) severity note;
    report "B=" & integer'image(to_integer(unsigned(sw))) severity note;
    report "Resultat (led)=" & integer'image(to_integer(unsigned(led))) severity note;

    -- Test fonction 2
    btn <= "0010"; sw <= "0100"; wait for 1000 ns;
    btn <= "0000"; wait for 100 ns;
    report "=== TEST 2 ===" severity note;
    report "A=" & integer'image(to_integer(unsigned(sw))) severity note;
    report "B=" & integer'image(to_integer(unsigned(sw))) severity note;
    report "Resultat (led)=" & integer'image(to_integer(unsigned(led))) severity note;

    -- Test fonction 3
    btn <= "0011"; sw <= "0100"; wait for 2000 ns;
    btn <= "0000"; wait for 100 ns;
    report "=== TEST 3 ===" severity note;
    report "A=" & integer'image(to_integer(unsigned(sw))) severity note;
    report "B=" & integer'image(to_integer(unsigned(sw))) severity note;
    report "Resultat (led)=" & integer'image(to_integer(unsigned(led))) severity note;

    std.env.stop;
end process;



end Behavioral;
