library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_control is
    port (
        clk : in std_logic;
        reset : in std_logic;

        INST_in : in std_logic_vector(9 downto 0);
        INST_out : out std_logic_vector(9 downto 0);
        INST_addr: in std_logic_vector(3 downto 0);
        INST_CE: in std_logic;
    );

end mem_control;

architecture Behavioral of mem_control is
    type data_memory_type is array (0 to 127) of std_logic_vector(9 downto 0);
    signal INSTR_memory : data_memory;

begin

    INSTR_out <= INSTR_memory(to_integer(unsigned(INST_addr))) when falling_edge(clk) and INST_CE = '1' else (others => '0');

    INSTR_memory(0) <= "0000000000";
    INSTR_memory(1) <= "0000000001";
    INSTR_memory(2) <= "0000000010";
    INSTR_memory(3) <= "0000000011";
    INSTR_memory(4) <= "0000000100";
    -- ... 127 ? 
end Behavioral;
