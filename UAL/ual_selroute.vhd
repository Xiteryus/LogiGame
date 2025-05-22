library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ual_selroute is
    port (
        SEL_ROUTE      : in  std_logic_vector(3 downto 0);
        A_IN           : in  std_logic_vector(3 downto 0);
        B_IN           : in  std_logic_vector(3 downto 0);
        S              : in  std_logic_vector(7 downto 0);
        MEM_CACHE_1_IN : in  std_logic_vector(7 downto 0);
        MEM_CACHE_2_IN : in  std_logic_vector(7 downto 0);

        Buffer_A       : out std_logic_vector(3 downto 0);
        Buffer_B       : out std_logic_vector(3 downto 0);
        MEM_CACHE_1_OUT : out std_logic_vector(7 downto 0);
        MEM_CACHE_2_OUT : out std_logic_vector(7 downto 0);

        EN_Buffer_A    : out std_logic;
        EN_Buffer_B    : out std_logic;
        EN_MEM_CACHE_1 : out std_logic;
        EN_MEM_CACHE_2 : out std_logic
    );
end ual_selroute;

architecture ual_sel_route of ual_selroute is
begin

    -- Processus de routage des données
    process1 :process (SEL_ROUTE, A_IN, B_IN, S, MEM_CACHE_1_IN, MEM_CACHE_2_IN)
    begin
        case SEL_ROUTE is
            -- A_IN -> Buffer_A
            when "0000" =>
                Buffer_A    <= A_IN;
                EN_Buffer_A <= '1';

            -- MEM_CACHE_1 (LSB) -> Buffer_A
            when "0001" =>
                Buffer_A    <= MEM_CACHE_1_IN(3 downto 0);
                EN_Buffer_A <= '1';

            -- MEM_CACHE_1 (MSB) -> Buffer_A
            when "0010" =>
                Buffer_A    <= MEM_CACHE_1_IN(7 downto 4);
                EN_Buffer_A <= '1';

            -- MEM_CACHE_2 (LSB) -> Buffer_A
            when "0011" =>
                Buffer_A    <= MEM_CACHE_2_IN(3 downto 0);
                EN_Buffer_A <= '1';

            -- MEM_CACHE_2 (MSB) -> Buffer_A
            when "0100" =>
                Buffer_A    <= MEM_CACHE_2_IN(7 downto 4);
                EN_Buffer_A <= '1';

            -- S (LSB) -> Buffer_A
            when "0101" =>
                Buffer_A    <= S(3 downto 0);
                EN_Buffer_A <= '1';

            -- S (MSB) -> Buffer_A
            when "0110" =>
                Buffer_A    <= S(7 downto 4);
                EN_Buffer_A <= '1';
                                                                                    
            -- B_IN -> Buffer_B
            when "0111" =>
                Buffer_B    <= B_IN;
                EN_Buffer_B <= '1';

            -- MEM_CACHE_1 (LSB) -> Buffer_B
            when "1000" =>
                Buffer_B    <= MEM_CACHE_1_IN(3 downto 0);
                EN_Buffer_B <= '1';

            -- MEM_CACHE_1 (MSB) -> Buffer_B
            when "1001" =>
                Buffer_B    <= MEM_CACHE_1_IN(7 downto 4);
                EN_Buffer_B <= '1';

            -- MEM_CACHE_2 (LSB) -> Buffer_B
            when "1010" =>
                Buffer_B    <= MEM_CACHE_2_IN(3 downto 0);
                EN_Buffer_B <= '1';

            -- MEM_CACHE_2 (MSB) -> Buffer_B
            when "1011" =>
                Buffer_B    <= MEM_CACHE_2_IN(7 downto 4);
                EN_Buffer_B <= '1';

            -- S (LSB) -> Buffer_B
            when "1100" =>
                Buffer_B    <= S(3 downto 0);
                EN_Buffer_B <= '1';

            -- S (MSB) -> Buffer_B
            when "1101" =>
                Buffer_B    <= S(7 downto 4);
                EN_Buffer_B <= '1';

            -- S -> MEM_CACHE_1
            when "1110" =>
                MEM_CACHE_1_OUT    <= S;
                EN_MEM_CACHE_1   <= '1';

            -- S -> MEM_CACHE_2
            when "1111" =>
                MEM_CACHE_2_OUT    <= S;
                EN_MEM_CACHE_2   <= '1';

            when others =>
                -- Rien
                null;
        end case;
    end process;
end ual_sel_route;