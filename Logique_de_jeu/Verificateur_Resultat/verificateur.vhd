library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.env.all;

entity tb_verificateur is
end tb_verificateur;

architecture sim of tb_verificateur is

    component verificateur
        Port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            timeout    : in  std_logic;
            led_color  : in  std_logic_vector(2 downto 0);
            btn_r      : in  std_logic;
            btn_g      : in  std_logic;
            btn_b      : in  std_logic;
            valid_hit  : out std_logic
        );
    end component;

    signal clk       : std_logic := '0';
    signal reset     : std_logic := '0';
    signal timeout   : std_logic := '0';
    signal led_color : std_logic_vector(2 downto 0) := (others => '0');
    signal btn_r, btn_g, btn_b : std_logic := '0';
    signal valid_hit : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Horloge
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Instanciation
    uut: verificateur
        port map (
            clk        => clk,
            reset      => reset,
            timeout    => timeout,
            led_color  => led_color,
            btn_r      => btn_r,
            btn_g      => btn_g,
            btn_b      => btn_b,
            valid_hit  => valid_hit
        );

    -- Stimulus
    stim_proc: process
    begin
        report "Début du test du vérificateur";

        -- Réinitialisation
        reset <= '1';
        wait until rising_edge(clk);
        reset <= '0';
        wait until rising_edge(clk);

        --------------------------------------------------------
        -- Test 1 : Appui correct sur bouton rouge (led = rouge)
        --------------------------------------------------------
        led_color <= "100";  -- Rouge
        btn_r <= '1'; wait until rising_edge(clk); btn_r <= '0';
        wait until rising_edge(clk);
        assert valid_hit = '1' report "Erreur : bouton rouge correct non détecté" severity error;

        --------------------------------------------------------
        -- Test 2 : Appui sur mauvais bouton (led = vert)
        --------------------------------------------------------
        reset <= '1'; wait until rising_edge(clk); reset <= '0';
        led_color <= "010";  -- Vert
        btn_r <= '1'; wait until rising_edge(clk); btn_r <= '0';  -- Mauvaise réponse
        wait until rising_edge(clk);
        assert valid_hit = '0' report "Erreur : bouton rouge accepté au lieu du vert" severity error;

        --------------------------------------------------------
        -- Test 3 : Appui correct sur bleu, mais timeout avant
        --------------------------------------------------------
        reset <= '1'; wait until rising_edge(clk); reset <= '0';
        led_color <= "001";  -- Bleu
        timeout <= '1';  -- Timeout actif
        btn_b <= '1'; wait until rising_edge(clk); btn_b <= '0';
        timeout <= '0';
        wait until rising_edge(clk);
        assert valid_hit = '0' report "Erreur : réponse acceptée après timeout" severity error;

        --------------------------------------------------------
        -- Test 4 : Bonne réponse sur vert sans timeout
        --------------------------------------------------------
        reset <= '1'; wait until rising_edge(clk); reset <= '0';
        led_color <= "010";
        btn_g <= '1'; wait until rising_edge(clk); btn_g <= '0';
        wait until rising_edge(clk);
        assert valid_hit = '1' report "Erreur : bouton vert correct non détecté" severity error;

        --------------------------------------------------------
        report "Tous les tests du vérificateur ont réussi !" severity note;
        std.env.stop;
    end process;

end sim;
