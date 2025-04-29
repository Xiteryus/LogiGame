-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity buffer_B is
generic (
    N : integer := 4
);
port (
    e1 : in std_logic_vector (N-1 downto 0);
    reset : in std_logic;
    preset : in std_logic;
    clock : in std_logic;
    s1 : out std_logic_vector (N-1 downto 0)
);
end  buffer_B;

architecture bufferNbits_Arch of buffer_B is
    begin
    
        -- Processus explicite MyBufferNbitsProc
        MyBufferNbitsProc : process(clock, reset)
        begin
            -- Reset asynchrone sur niveau haut
            if reset = '1' then
                s1 <= (others => '0');
            elsif rising_edge(clock) then
                -- Preset synchrone sur niveau haut
                if preset = '1' then
                    s1 <= (others => '1');
                else
                    -- Bufferisation sur front montant de l'horloge d'entrée
                    s1 <= e1;
                end if;
            end if;
        end process;
    end bufferNbits_Arch;