library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity VALCORE is
    generic (
        N : integer := 4
    );
    port (
        A : in std_logic_vector (N-1 downto 0);
        B : in std_logic_vector (N-1 downto 0);
        SR_IN_L : in std_logic;
        SR_IN_R : in std_logic;
        SEL_fct : in std_logic_vector (N-1 downto 0);
        S : out std_logic_vector (7 downto 0);  -- étendu à 8 bits pour certaines opérations
        SR_OUT_L : out std_logic;
        SR_OUT_R : out std_logic
    );
end VALCORE;

architecture VALCORE_ARCH of VALCORE is
begin
    process (A, B, SEL_fct, SR_IN_L, SR_IN_R)
        variable svar : unsigned (7 downto 0);
        variable avar : unsigned (7 downto 0);
        variable bvar : unsigned (7 downto 0);
        variable cvar : unsigned (7 downto 0);
    begin
        case SEL_fct is
            when "0000" => -- NOP
                S <= (others => '0');
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';

            when "0001" => -- A
                S <= (others => '0');
                S(N-1 downto 0) <= A;
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';

            when "0010" => -- B
                S <= (others => '0');
                S(N-1 downto 0) <= B;
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';

            when "0011" => -- NOT A
                S <= (others => '0');
                S(N-1 downto 0) <= not A;
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';

            when "0100" => -- NOT B
                S <= (others => '0');
                S(N-1 downto 0) <= not B;
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';

            when "0101" => -- A AND B
                S <= (others => '0');
                S(N-1 downto 0) <= A and B;
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';

            when "0110" => -- A OR B
                S <= (others => '0');
                S(N-1 downto 0) <= A or B;
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';

            when "0111" => -- A XOR B
                S <= (others => '0');
                S(N-1 downto 0) <= A xor B;
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';

            when "1000" => -- shift left logical A
                S <= (others => '0');
                SR_OUT_R <= A(N-1);
                S(N-1 downto 1) <= A(N-2 downto 0);
                S(0) <= SR_IN_L;
                SR_OUT_L <= '0';

            when "1001" => -- shift right logical A
                S <= (others => '0');
                SR_OUT_L <= A(0);
                S(N-2 downto 0) <= A(N-1 downto 1);
                S(N-1) <= SR_IN_R;
                SR_OUT_R <= '0';

            when "1010" => -- shift left logical B
                S <= (others => '0');
                SR_OUT_R <= B(N-1);
                S(N-1 downto 1) <= B(N-2 downto 0);
                S(0) <= SR_IN_L;
                SR_OUT_L <= '0';

            when "1011" => -- shift right logical B
                S <= (others => '0');
                SR_OUT_L <= B(0);
                S(N-2 downto 0) <= B(N-1 downto 1);
                S(N-1) <= SR_IN_R;
                SR_OUT_R <= '0';

            when "1100" => -- A + B + carry
                avar := (others => A(N-1));
                bvar := (others => B(N-1));
                avar(N-1 downto 0) := unsigned(A);
                bvar(N-1 downto 0) := unsigned(B);
                cvar := (others => '0');
                cvar(0) := SR_IN_R;
                svar := avar + bvar + cvar;
                S <= std_logic_vector(svar);
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';

            when "1101" => -- A + B
                avar := (others => A(N-1));
                bvar := (others => B(N-1));
                avar(N-1 downto 0) := unsigned(A);
                bvar(N-1 downto 0) := unsigned(B);
                svar := avar + bvar;
                S <= std_logic_vector(svar);
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';

            when "1110" => -- A - B
                avar := (others => A(N-1));
                bvar := (others => B(N-1));
                avar(N-1 downto 0) := unsigned(A);
                bvar(N-1 downto 0) := unsigned(B);
                svar := avar - bvar;
                S <= std_logic_vector(svar);
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';

            when "1111" => -- A * B
                avar := (others => A(N-1));
                bvar := (others => B(N-1));
                avar(N-1 downto 0) := unsigned(A);
                bvar(N-1 downto 0) := unsigned(B);
                svar := avar * bvar;
                S <= std_logic_vector(svar);
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';

            when others =>
                S <= (others => '0');
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
        end case;
    end process;
end architecture VALCORE_ARCH;
