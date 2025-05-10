library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_valcore is
end entity;

architecture sim of tb_valcore is

    component VALCORE
        generic (
            N : integer := 4
        );
        port (
            A        : in  std_logic_vector(N-1 downto 0);
            B        : in  std_logic_vector(N-1 downto 0);
            SR_IN_L  : in  std_logic;
            SR_IN_R  : in  std_logic;
            SEL_fct  : in  std_logic_vector(N-1 downto 0);
            S        : out std_logic_vector(7 downto 0);
            SR_OUT_L : out std_logic;
            SR_OUT_R : out std_logic
        );
    end component;

    -- Signaux de test
    signal A, B           : std_logic_vector(3 downto 0);
    signal SR_IN_L, SR_IN_R : std_logic;
    signal SEL_fct        : std_logic_vector(3 downto 0);
    signal S              : std_logic_vector(7 downto 0);
    signal SR_OUT_L, SR_OUT_R : std_logic;

begin

    uut_valcore: VALCORE
        generic map (N => 4)
        port map (
            A => A,
            B => B,
            SR_IN_L => SR_IN_L,
            SR_IN_R => SR_IN_R,
            SEL_fct => SEL_fct,
            S => S,
            SR_OUT_L => SR_OUT_L,
            SR_OUT_R => SR_OUT_R
        );

    stim_proc: process
    begin
        -- Valeurs de base pour A, B, et SR
        A <= "1010";
        B <= "0011";
        SR_IN_L <= '1';
        SR_IN_R <= '0';

        -- Boucle sur toutes les fonctions de 0000 à 1111
        for i in 0 to 15 loop
            SEL_fct <= std_logic_vector(to_unsigned(i, 4));
            wait for 10 ns;
        end loop;

        wait;
    end process;

end architecture;
