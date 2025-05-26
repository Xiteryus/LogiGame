library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mem_control is
    port (
        clk : in std_logic;
        reset : in std_logic;

        INST_in : in std_logic_vector(9 downto 0);
        INST_out : out std_logic_vector(9 downto 0);
        INST_addr: in std_logic_vector(3 downto 0);
        INST_CE: in std_logic
    );
end mem_control;

architecture Behavioral of mem_control is

    -- Type de la mémoire
    type data_memory_type is array (0 to 127) of std_logic_vector(9 downto 0);

    -- Mémoire
    signal INSTR_memory : data_memory_type := (others => (others => '0'));

begin

    -- Lecture synchrone (front montant)
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                INST_out <= (others => '0');
            elsif INST_CE = '1' then
                INST_out <= INSTR_memory(to_integer(unsigned(INST_addr)));
            end if;
        end if;
    end process;

    INSTR_memory(0) <= "0000000000";
    INSTR_memory(1) <= "0000000001";
    INSTR_memory(2) <= "0000000010";
    INSTR_memory(3) <= "0000000011";
    INSTR_memory(4) <= "0000000100";
    -- Remplir jusqu’à 127 si besoin

end Behavioral;
