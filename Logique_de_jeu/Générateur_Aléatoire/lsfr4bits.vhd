library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lsfr4bits is
    Port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        enable : in  std_logic;
        rnd    : out std_logic_vector(3 downto 0)
    );
end lsfr4bits;

architecture lfsr of lsfr4bits is
    signal lfsr_reg : std_logic_vector(3 downto 0) := "1011"; -- Valeur initiale
begin
    process(clk)
        variable temp : std_logic;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                lfsr_reg <= "1011"; 
            elsif enable = '1' then
                -- X^4 + X^3 + 1 => XOR entre bit 3 et bit 0
                temp := lfsr_reg(3) xor lfsr_reg(0);  
                -- Décalage à droite
                lfsr_reg <= temp & lfsr_reg(3 downto 1);  
            end if;
        end if;
    end process;

    rnd <= lfsr_reg;
end lfsr;