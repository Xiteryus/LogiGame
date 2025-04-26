library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MEM_CONTROL is
    port (
        clk          : in  std_logic;
        A_IN         : in  std_logic_vector(3 downto 0);
        B_IN         : in  std_logic_vector(3 downto 0);
        S            : in  std_logic_vector(7 downto 0);
        SEL_ROUTE    : in  std_logic_vector(3 downto 0);
        SEL_FCT      : in  std_logic_vector(3 downto 0);
        SEL_OUT      : in  std_logic_vector(1 downto 0);
        SR_IN_L      : in  std_logic;
        SR_IN_R      : in  std_logic;
        
        Buffer_A     : out std_logic_vector(3 downto 0);
        Buffer_B     : out std_logic_vector(3 downto 0);
        MEM_CACHE_1  : out std_logic_vector(7 downto 0);
        MEM_CACHE_2  : out std_logic_vector(7 downto 0);
        MEM_SEL_FCT  : out std_logic_vector(3 downto 0);
        MEM_SEL_OUT  : out std_logic_vector(1 downto 0);
        MEM_SR_IN_L  : out std_logic;
        MEM_SR_IN_R  : out std_logic;
        RES_OUT      : out std_logic_vector(7 downto 0)
    );
end MEM_CONTROL;

architecture Behavioral of MEM_CONTROL is
    signal reg_Buffer_A    : std_logic_vector(3 downto 0) := (others => '0');
    signal reg_Buffer_B    : std_logic_vector(3 downto 0) := (others => '0');
    signal reg_CACHE_1     : std_logic_vector(7 downto 0) := (others => '0');
    signal reg_CACHE_2     : std_logic_vector(7 downto 0) := (others => '0');
    signal reg_SEL_FCT     : std_logic_vector(3 downto 0);
    signal reg_SEL_OUT     : std_logic_vector(1 downto 0);
    signal reg_SR_IN_L     : std_logic;
    signal reg_SR_IN_R     : std_logic;
begin

    -- Sorties synchronisées
    Buffer_A     <= reg_Buffer_A;
    Buffer_B     <= reg_Buffer_B;
    MEM_CACHE_1  <= reg_CACHE_1;
    MEM_CACHE_2  <= reg_CACHE_2;
    MEM_SEL_FCT  <= reg_SEL_FCT;
    MEM_SEL_OUT  <= reg_SEL_OUT;
    MEM_SR_IN_L  <= reg_SR_IN_L;
    MEM_SR_IN_R  <= reg_SR_IN_R;

    -- Mémorisation des entrées
    process(clk)
    begin
        if rising_edge(clk) then
            reg_SEL_FCT  <= SEL_FCT;
            reg_SEL_OUT  <= SEL_OUT;
            reg_SR_IN_L  <= SR_IN_L;
            reg_SR_IN_R  <= SR_IN_R;

            case SEL_ROUTE is
                -- Buffer_A
                when "0000" => 
                    reg_Buffer_A <= A_IN;
                when "0001" => 
                    reg_Buffer_A <= reg_CACHE_1(3 downto 0);
                when "0010" => 
                    reg_Buffer_A <= reg_CACHE_1(7 downto 4);
                when "0011" => 
                    reg_Buffer_A <= reg_CACHE_2(3 downto 0);
                when "0100" => 
                    reg_Buffer_A <= reg_CACHE_2(7 downto 4);
                when "0101" => 
                    reg_Buffer_A <= S(3 downto 0);
                when "0110" => 
                    reg_Buffer_A <= S(7 downto 4);

                -- Buffer_B
                when "0111" => 
                    reg_Buffer_B <= B_IN;
                when "1000" => 
                    reg_Buffer_B <= reg_CACHE_1(3 downto 0);
                when "1001" => 
                    reg_Buffer_B <= reg_CACHE_1(7 downto 4);
                when "1010" => 
                    reg_Buffer_B <= reg_CACHE_2(3 downto 0);
                when "1011" => 
                    reg_Buffer_B <= reg_CACHE_2(7 downto 4);
                when "1100" => 
                    reg_Buffer_B <= S(3 downto 0);
                when "1101" => 
                    reg_Buffer_B <= S(7 downto 4);

                -- MEM_CACHE
                when "1110" => 
                    reg_CACHE_1 <= S;
                when "1111" => 
                    reg_CACHE_2 <= S;

                when others => null;
            end case;
        end if;
    end process;

    -- Résultat en combinatoire
    process(reg_SEL_OUT, reg_CACHE_1, reg_CACHE_2, S)
    begin
        case reg_SEL_OUT is
            when "00" => 
                RES_OUT <= (others => '0');
            when "01" => 
                RES_OUT <= reg_CACHE_1;
            when "10" => 
                RES_OUT <= reg_CACHE_2;
            when "11" => 
                RES_OUT <= S;
            when others => 
                RES_OUT <= (others => '0');
        end case;
    end process;

end Behavioral;
