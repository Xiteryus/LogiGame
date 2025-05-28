library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mem_control is
    port (
        clk       : in  std_logic; -- Horloge 
        INST_out  : out std_logic_vector(9 downto 0); -- Insutrction lue (le code en dur)
        INST_addr : in  std_logic_vector(6 downto 0);  -- 7 bits pour 128 instructions
        INST_CE   : in  std_logic -- Active la lecture des instructions 
    );
end mem_control;

architecture Behavioral of mem_control is
    type mem_type is array (0 to 127) of std_logic_vector(9 downto 0);
    signal mem : mem_type := (
        -- Code en dur : 
        -- 4 premier bits : SEL_FCT (fonction à exectuer --> UAL)
        -- 4 bits suivant : SEL_ROUTE (Chemin --> UAL_selroute)
        -- 2 Dernier bits : SEL_OUT (Sortie à prendre --> Sel_out)
        -- Premiere fonction (A*B)
        0  => "0000000000", 
        1  => "0000011100", 
        2  => "1111000011", 

        -- Deuxieme fonction ((A + B) xnor A)
        3  => "0000000000",
        4  => "0000011100",
        5  => "1101111000",
        6  => "0000100000",
        7  => "0111111100",
        8  => "0000001100",
        9  => "0011000011",

        -- Troisieme fonction ((A0 and B1) or (A1 and B0))
        10 => "0000000000",
        11 => "0000011100",
        12 => "0101111000",
        13 => "0101111100",
        14 => "0000000100",
        15 => "0000101000",
        16 => "0110000011",

        others => (others => '0')
    );
begin
    process(clk) -- On active la lecture quand INST_CE est à 1 
    begin
        if rising_edge(clk) then
            if INST_CE = '1' then
                INST_out <= mem(to_integer(unsigned(INST_addr)));
            else
                INST_out <= (others => '0');
            end if;
        end if;
    end process;
end Behavioral;