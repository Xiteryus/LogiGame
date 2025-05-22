library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity minuteur is
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        start      : in  std_logic;
        sw_level   : in  std_logic_vector(1 downto 0);  
        timeout    : out std_logic
    );
end minuteur;

architecture Behavioral of minuteur is

    signal counter       : unsigned(26 downto 0) := (others => '0');  -- max 100_000_000
    signal target_count  : unsigned(26 downto 0) := (others => '0');
    signal counting      : std_logic := '0';

begin

    -- Process principal
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then -- Reset : on met tout à zéro
                counter      <= (others => '0');
                timeout      <= '0';
                counting     <= '0';
            elsif start = '1' then
                -- Démarrage du minuteur
                case sw_level is
                    when "00" => target_count <= to_unsigned(100_000_000, 27); -- Tres facile : 1s
                    when "01" => target_count <= to_unsigned(50_000_000, 27);  -- Facile : 0.5s
                    when "10" => target_count <= to_unsigned(25_000_000, 27);  -- Moyen : 0.25s
                    when "11" => target_count <= to_unsigned(12_500_000, 27);  -- Difficile : 0.125s
                    when others => target_count <= to_unsigned(100_000_000, 27); -- sécurité
                end case;
                counter   <= (others => '0');
                timeout   <= '0';
                counting  <= '1';

            elsif counting = '1' then
                if counter < target_count then
                    counter <= counter + 1;
                else
                    timeout   <= '1';  -- délai atteint
                    counting  <= '0';  -- attente d’un nouveau start
                end if;
            end if;
        end if;
    end process;

end Behavioral;
