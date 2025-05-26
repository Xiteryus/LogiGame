library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity minuteur is
    generic (
        TRES_FACILE : integer := 100_000_000;
        FACILE      : integer := 50_000_000;
        MOYEN       : integer := 25_000_000;
        DIFFICILE   : integer := 12_500_000
    );
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        start      : in  std_logic;
        sw_level   : in  std_logic_vector(1 downto 0);  
        timeout    : out std_logic
    );
end minuteur;

architecture Behavioral of minuteur is
    signal counter       : unsigned(26 downto 0) := (others => '0');
    signal target_count  : unsigned(26 downto 0) := (others => '0');
    signal counting      : std_logic := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                counter      <= (others => '0');
                timeout      <= '0';
                counting     <= '0';
            elsif start = '1' then
                case sw_level is
                    when "00" => target_count <= to_unsigned(TRES_FACILE, 27);
                    when "01" => target_count <= to_unsigned(FACILE, 27);
                    when "10" => target_count <= to_unsigned(MOYEN, 27);
                    when "11" => target_count <= to_unsigned(DIFFICILE, 27);
                    when others => target_count <= to_unsigned(TRES_FACILE, 27);
                end case;
                counter   <= (others => '0');
                timeout   <= '0';
                counting  <= '1';
            elsif counting = '1' then
                if counter < target_count then
                    counter <= counter + 1;
                else
                    timeout   <= '1';
                    counting  <= '0';
                end if;
            end if;
        end if;
    end process;

end Behavioral;