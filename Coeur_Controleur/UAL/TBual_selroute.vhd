library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ual_selroute is
end tb_ual_selroute;

architecture testbench of tb_ual_selroute is
    component ual_selroute
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
    end component;

    -- Signaux 
    signal SEL_ROUTE, A_IN, B_IN, Buffer_A, Buffer_B                          : std_logic_vector(3 downto 0);
    signal S,MEM_CACHE_1_IN, MEM_CACHE_2_IN, MEM_CACHE_1_OUT, MEM_CACHE_2_OUT : std_logic_vector(7 downto 0);
    signal EN_Buffer_A, EN_Buffer_B,EN_MEM_CACHE_1,EN_MEM_CACHE_2             : std_logic;

begin
    -- Laison 
    selroute: ual_selroute
        port map (
            SEL_ROUTE       => SEL_ROUTE,
            A_IN            => A_IN,
            B_IN            => B_IN,
            S               => S,
            MEM_CACHE_1_IN  => MEM_CACHE_1_IN,
            MEM_CACHE_2_IN  => MEM_CACHE_2_IN,
            Buffer_A        => Buffer_A,
            Buffer_B        => Buffer_B,
            MEM_CACHE_1_OUT => MEM_CACHE_1_OUT,
            MEM_CACHE_2_OUT => MEM_CACHE_2_OUT,
            EN_Buffer_A     => EN_Buffer_A,
            EN_Buffer_B     => EN_Buffer_B,
            EN_MEM_CACHE_1  => EN_MEM_CACHE_1,
            EN_MEM_CACHE_2  => EN_MEM_CACHE_2
        );

    process
    begin
        -- initialisation des valeurs pour A, B S, MEM1 et MEM2 
        A_in <= "0001";
        B_in <= "0010";
        S <= "10101001";
        MEM_CACHE_1_IN <= "00111100";
        MEM_CACHE_2_IN <= "11010100";
        -- On test toutes les valeurs de sel_route 
        for i in 0 to 15 loop
            SEL_ROUTE <= std_logic_vector(to_unsigned(i, 4));
            wait for 10 ns;
            EN_Buffer_A    <= '0';
            EN_Buffer_B    <= '0';
            EN_MEM_CACHE_1 <= '0';
            EN_MEM_CACHE_2 <= '0';
        end loop;

        wait;
    end process;

end testbench;
