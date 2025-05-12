library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_control is
    port (

        clk : std_logic;
        SEL_ROUTE : in std_logic_vector(3 downto 0);
        SEL_OUT : in std_logic_vector(1 downto 0);
        A_IN : in std_logic_vector(3 downto 0); 
        B_IN : in std_logic_vector(3 downto 0);
        S : in std_logic_vector(7 downto 0);
        mem_instruction : in std_logic_vector(6 downto 0);
        Buffer_A : in std_logic_vector(3 downto 0);
        Buffer_B : in std_logic_vector(3 downto 0);
        S_out : out std_logic_vector(7 downto 0)
    );

end mem_control;

architecture Behavioral of mem_control is

    signal MEM_CACHE_1 : std_logic_vector(7 downto 0) := (others => '0');
    signal MEM_CACHE_2 : std_logic_vector(7 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then
            -- Gestion du routage vers les caches
            case SEL_ROUTE is
                when "1110" =>  -- S vers MEM_CACHE_1
                    MEM_CACHE_1 <= S;
                when "1111" =>  -- S vers MEM_CACHE_2
                    MEM_CACHE_2 <= S;
                when others =>
                    -- aucun transfert ici
                    null;
            end case;

            -- Gestion de la sortie
            case SEL_OUT is
                when "00" => S_out <= (others => '0');
                when "01" => S_out <= MEM_CACHE_1;
                when "10" => S_out <= MEM_CACHE_2;
                when "11" => S_out <= S;
                when others => S_out <= (others => '0');
            end case;
        end if;
    end process;

end Behavioral;
