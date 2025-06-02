library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ual_selout is
end tb_ual_selout;

architecture testbench of tb_ual_selout is
    component ual_selout
        Port (
            SEL_OUT : in  std_logic_vector(1 downto 0);
            S : in  std_logic_vector(7 downto 0);
            MEM_CACHE_1_IN : in  std_logic_vector(7 downto 0);
            MEM_CACHE_2_IN : in  std_logic_vector(7 downto 0);
            RES_OUT : out std_logic_vector(7 downto 0)
        );
    end component;

    signal SEL_OUT : std_logic_vector(1 downto 0);
    signal S : std_logic_vector(7 downto 0);
    signal MEM_CACHE_1_IN : std_logic_vector(7 downto 0);
    signal MEM_CACHE_2_IN : std_logic_vector(7 downto 0);
    signal RES_OUT : std_logic_vector(7 downto 0);

begin
    -- Liason
    selout: ual_selout
        port map (
            SEL_OUT => SEL_OUT,
            S => S,
            MEM_CACHE_1_IN => MEM_CACHE_1_IN,
            MEM_CACHE_2_IN => MEM_CACHE_2_IN,
            RES_OUT => RES_OUT
        );

    process
    begin
        -- initialisation des valeurs pour S, MEM1 et MEM2 
        S <= "10101010";               
        MEM_CACHE_1_IN <= "00010001";   
        MEM_CACHE_2_IN <= "00100010";  

        -- Cas 00 
        SEL_OUT <= "00";
        wait for 10 ns;

        -- Cas 01 
        SEL_OUT <= "01";
        wait for 10 ns;

        -- Cas 10 
        SEL_OUT <= "10";
        wait for 10 ns;

        -- Cas 11 
        SEL_OUT <= "11";
        wait for 10 ns;

        wait;
    end process;

end testbench;
