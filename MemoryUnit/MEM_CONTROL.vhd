library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_control is
    port (

        clk : std_logic;
        SEL_ROUTE : in std_logic_vector(3 downto 0);
        SEL_OUT : in std_logic_vector(1 downto 0);
        A_IN : in std_logic_vector(3 downto 0); 
        B_IN : in std_logic_vector(3 downto 0);
        S : in std_logic_vector(7 downto 0);
        mem_instruction : in std_logic_vector(6 downto 0);
        Buffer_A : in std_logic_vector(3 downto 0);
        Buffer_B : in std_logic_vector(3 downto 0);
        S_out : out std_logic_vector(7 downto 0);
    )