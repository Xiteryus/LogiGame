library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_minuteur is
end tb_minuteur;

architecture testbench of tb_minuteur is


    component minuteur
        Port (
            clk       : in  std_logic;
            reset     : in  std_logic;
            start     : in  std_logic;
            sw_level  : in  std_logic_vector(1 downto 0);
            timeout   : out std_logic
        );
    end component;


