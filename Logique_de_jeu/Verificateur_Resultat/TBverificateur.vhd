library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity verificateur is
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
end verificateur;

architecture Behavioral of verificateur is
    signal hit_reg        : std_logic := '0';
    signal user_pressed   : std_logic := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                hit_reg      <= '0';
                user_pressed <= '0';

            elsif user_pressed = '0' and timeout = '0' then
                case led_color is
                    when "100" =>  -- Rouge → BTN1
                        if btn_r = '1' then
                            hit_reg <= '1';
                            user_pressed <= '1';
                        elsif btn_g = '1' or btn_b = '1' then
                            user_pressed <= '1';  -- mauvaise réponse
                        end if;

                    when "010" =>  -- Vert → BTN2
                        if btn_g = '1' then
                            hit_reg <= '1';
                            user_pressed <= '1';
                        elsif btn_r = '1' or btn_b = '1' then
                            user_pressed <= '1';
                        end if;

                    when "001" =>  -- Bleu → BTN3
                        if btn_b = '1' then
                            hit_reg <= '1';
                            user_pressed <= '1';
                        elsif btn_r = '1' or btn_g = '1' then
                            user_pressed <= '1';
                        end if;

                    when others =>
                        null;
                end case;
            end if;

            -- Timeout ou fin du tour
            if timeout = '1' then
                user_pressed <= '1';
            end if;
        end if;
    end process;

    valid_hit <= hit_reg;

end Behavioral;
