library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.env.all;

entity tb_compteur is
end tb_compteur;

architecture testbench of tb_compteur is

    component compteur
        Port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            valid_hit  : in  std_logic;
            score      : out std_logic_vector(3 downto 0);
            game_over  : out std_logic
        );
    end component;

    -- Signaux d'entrée
    signal clk       : std_logic := '0';
    signal reset     : std_logic := '0';
    signal valid_hit : std_logic := '0';
    
    -- Signaux de sortie
    signal score     : std_logic_vector(3 downto 0);
    signal game_over : std_logic;
    
    -- Période d'horloge
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instanciation du compteur
    uut: compteur
        port map (
            clk       => clk,
            reset     => reset,
            valid_hit => valid_hit,
            score     => score,
            game_over => game_over
        );

    -- Génération de l'horloge
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Processus de test
    stim_proc: process
    begin
        
        -- Initialisation
        reset <= '1';
        valid_hit <= '0';
        wait for CLK_PERIOD;
        reset <= '0';
        wait for CLK_PERIOD;
        
        -- Test 1: 
        assert score = "0000" and game_over = '0'
            report "Erreur après reset" severity error;
        
        -- Test 2: Incrémentation normale
        valid_hit <= '1';
        wait for CLK_PERIOD;
        assert score = "0001" and game_over = '0'
            report "Erreur après 1er valid_hit" severity error;
        report "Test 2: Premier incrément OK";
        
        -- Test 3: Plusieurs valid_hit successifs
        for i in 2 to 13 loop
            wait for CLK_PERIOD;
            assert to_integer(unsigned(score)) = i and game_over = '0'
                report "Erreur après " & integer'image(i) & " valid_hit" severity error;
        end loop;
        report "Test 3: 13 valid_hit successifs OK";
        
        -- Test 4: Atteinte du score maximal (15)
        valid_hit <= '1';
        wait for CLK_PERIOD; -- score = 14
        assert score = "1110" and game_over = '0'
            report "Erreur à score=14" severity error;
            
        wait for CLK_PERIOD; -- score = 15 (game_over)
        assert score = "1111" and game_over = '1'
            report "Erreur à score=15 (game_over)" severity error;
        report "Test 4: Atteinte du score maximal OK";
        
        -- Test 5: Blocage après game_over
        valid_hit <= '1';
        wait for CLK_PERIOD;
        assert score = "1111" and game_over = '1'
            report "Erreur: score change après game_over" severity error;
        report "Test 5: Blocage après game_over OK";
        
        -- Réinitialisation
        reset <= '1';
        valid_hit <= '0';
        wait for CLK_PERIOD;
        reset <= '0';
        wait for CLK_PERIOD;
        assert score = "0000" and game_over = '0'
            report "Erreur après deuxième reset" severity error;
        
        -- Test 6: Mauvaise réponse (valid_hit = '0')
        valid_hit <= '0';
        wait for CLK_PERIOD;
        assert game_over = '1'
            report "Erreur: game_over non activé après mauvaise réponse" severity error;
        report "Test 6: Mauvaise réponse OK";
        
        
        report "Tous les tests du compteur de score ont réussi!" severity note;
        std.env.stop; -- stoper la simulation

    end process;

end testbench;