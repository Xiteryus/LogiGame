library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_mem_control is
end tb_mem_control;

architecture Behavioral of tb_mem_control is

    -- Composant 
    component mem_control
        port (
            clk       : in  std_logic;
            INST_out  : out std_logic_vector(9 downto 0);
            INST_addr : in  std_logic_vector(6 downto 0);
            INST_CE   : in  std_logic
        );
    end component;

    -- Signaux
    signal clk       : std_logic := '0';
    signal INST_out  : std_logic_vector(9 downto 0) := (others => '0');
    signal INST_addr : std_logic_vector(6 downto 0) := (others => '0');
    signal INST_CE   : std_logic := '0';

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Liason 
    uut: mem_control
        port map (
            clk       => clk,
            INST_out  => INST_out,
            INST_addr => INST_addr,
            INST_CE   => INST_CE
        );

    -- Horloge
    clk_process : process
    begin
        while now < 300 ns loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimuli
    stim_proc: process
    begin
        wait for 15 ns;
        INST_CE <= '1';

        -- 0 à 16
        for i in 0 to 16 loop
            INST_addr <= std_logic_vector(to_unsigned(i, 7));
            wait for CLK_PERIOD;
        end loop;
        wait;
    end process;

end Behavioral;
