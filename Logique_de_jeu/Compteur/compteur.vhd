library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity compteur is
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        valid_hit  : in  std_logic;
        score      : out std_logic_vector(3 downto 0);
        game_over  : out std_logic
    );
end compteur;

architecture Behavioral of compteur is

    signal score_reg : unsigned(3 downto 0) := (others => '0');
    signal over      : std_logic := '0';

begin

    process(clk)
    begin
        if reset = '1' then
            score_reg <= (others => '0');
            over      <= '0';

        elsif rising_edge(clk) then
            if over = '0' then
                if valid_hit = '1' then
                    if score_reg = "1110" then  -- score = 14
                        score_reg <= score_reg + 1;  -- passe à 15
                        over      <= '1';            -- game over
                    else
                        score_reg <= score_reg + 1;
                    end if;
                else
                    over <= '1';  -- mauvaise réponse
                end if;
            end if;
        end if;
    end process;

    score     <= std_logic_vector(score_reg);
    game_over <= over;

end Behavioral;
