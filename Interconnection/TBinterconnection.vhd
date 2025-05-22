library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_interco is
end entity;

architecture sim of tb_interco is
    -- Composant à tester
    component interco
        port (
            SEL_ROUTE      : in  std_logic_vector(3 downto 0);
            SEL_OUT        : in  std_logic_vector(1 downto 0);
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
            EN_MEM_CACHE_2 : out std_logic;
            RES_OUT        : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Signaux de test
    signal SEL_ROUTE      : std_logic_vector(3 downto 0);
    signal SEL_OUT        : std_logic_vector(1 downto 0);
    signal A_IN, B_IN     : std_logic_vector(3 downto 0);
    signal S              : std_logic_vector(7 downto 0);
    signal MEM_CACHE_1_IN, MEM_CACHE_2_IN : std_logic_vector(7 downto 0);

    signal Buffer_A, Buffer_B : std_logic_vector(3 downto 0);
    signal MEM_CACHE_1_OUT, MEM_CACHE_2_OUT : std_logic_vector(7 downto 0);
    signal EN_Buffer_A, EN_Buffer_B : std_logic;
    signal EN_MEM_CACHE_1, EN_MEM_CACHE_2 : std_logic;
    signal RES_OUT : std_logic_vector(7 downto 0);

begin
    -- Instanciation
    interconnexion_teste: interco
        port map (
            SEL_ROUTE => SEL_ROUTE,
            SEL_OUT => SEL_OUT,
            A_IN => A_IN,
            B_IN => B_IN,
            S => S,
            MEM_CACHE_1_IN => MEM_CACHE_1_IN,
            MEM_CACHE_2_IN => MEM_CACHE_2_IN,
            Buffer_A => Buffer_A,
            Buffer_B => Buffer_B,
            MEM_CACHE_1_OUT => MEM_CACHE_1_OUT,
            MEM_CACHE_2_OUT => MEM_CACHE_2_OUT,
            EN_Buffer_A => EN_Buffer_A,
            EN_Buffer_B => EN_Buffer_B,
            EN_MEM_CACHE_1 => EN_MEM_CACHE_1,
            EN_MEM_CACHE_2 => EN_MEM_CACHE_2,
            RES_OUT => RES_OUT
        );

    -- Stimuli
    stim_proc: process
    begin
        -- Initialisation des données sources
        A_IN <= "1010";
        B_IN <= "0101";
        S <= "11110000";
        MEM_CACHE_1_IN <= "11001100";
        MEM_CACHE_2_IN <= "00110011";
    
        -- Boucle sur toutes les valeurs de SEL_ROUTE
        for i in 0 to 15 loop
            SEL_ROUTE <= std_logic_vector(to_unsigned(i, 4));
            wait for 100 ns;
        end loop;
    
        -- Test de toutes les sorties possibles (SEL_OUT)
        SEL_OUT <= "00"; wait for 100 ns; -- Résultat = 0
        SEL_OUT <= "01"; wait for 100 ns; -- Résultat = MEM_CACHE_1_IN
        SEL_OUT <= "10"; wait for 100 ns; -- Résultat = MEM_CACHE_2_IN
        SEL_OUT <= "11"; wait for 100 ns; -- Résultat = S
    
        wait;
    end process;
    

end architecture;
