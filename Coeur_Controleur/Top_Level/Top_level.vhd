library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top_level is
    Port (
        CLK100MHZ : in STD_LOGIC; -- Horloge
        sw : in STD_LOGIC_VECTOR(3 downto 0); -- Entrées A & B
        btn : in STD_LOGIC_VECTOR(3 downto 0); -- Boutons : (0=reset, 1-3=fonctions)
        led : out STD_LOGIC_VECTOR(3 downto 0); -- Résultat final (4 bits)
        led0_r, led0_g, led0_b : out STD_LOGIC; -- LEDs statut
        led1_r, led1_g, led1_b : out STD_LOGIC;
        led2_r, led2_g, led2_b : out STD_LOGIC;
        led3_r, led3_g, led3_b : out STD_LOGIC
    );
end Top_level;

architecture Behavioral of Top_level is

    -- Déclarations des composants (comme dans ton code précédent)
    component buffer_ual
        Port ( clk, reset, enable_buffer : in std_logic;
               buffer_in : in std_logic_vector(3 downto 0);
               buffer_out : out std_logic_vector(3 downto 0));
    end component;
    
    component buffer_cmd
        Port ( clk, reset, enable_buffer : in std_logic;
               buffer_in : in std_logic_vector(7 downto 0);
               buffer_out : out std_logic_vector(7 downto 0));
    end component;
    
    component mem_control
        port ( clk : in std_logic;
               INST_out : out std_logic_vector(9 downto 0);
               INST_addr : in std_logic_vector(6 downto 0);
               INST_CE : in std_logic);
    end component;
    
    component ual
        generic (N : integer := 4);
        port ( A, B : in std_logic_vector(N-1 downto 0);
               SR_IN_L, SR_IN_R : in std_logic;
               SEL_fct : in std_logic_vector(N-1 downto 0);
               S : out std_logic_vector(7 downto 0);
               SR_OUT_L, SR_OUT_R : out std_logic);
    end component;
    
    component ual_selroute
        port ( SEL_ROUTE : in std_logic_vector(3 downto 0);
               A_IN, B_IN : in std_logic_vector(3 downto 0);
               S : in std_logic_vector(7 downto 0);
               MEM_CACHE_1_IN, MEM_CACHE_2_IN : in std_logic_vector(7 downto 0);
               Buffer_A, Buffer_B : out std_logic_vector(3 downto 0);
               MEM_CACHE_1_OUT, MEM_CACHE_2_OUT : out std_logic_vector(7 downto 0);
               EN_Buffer_A, EN_Buffer_B : out std_logic;
               EN_MEM_CACHE_1, EN_MEM_CACHE_2 : out std_logic);
    end component;
    
    component ual_selout
        port ( SEL_OUT : in std_logic_vector(1 downto 0);
               S, MEM_CACHE_1_IN, MEM_CACHE_2_IN : in std_logic_vector(7 downto 0);
               RES_OUT : out std_logic_vector(7 downto 0));
    end component;

    -- Signaux internes
    signal Buffer_A_in, Buffer_A_out, Buffer_B_in, Buffer_B_out : std_logic_vector(3 downto 0);
    signal MEM_CACHE_1_in, MEM_CACHE_1_out, MEM_CACHE_2_in, MEM_CACHE_2_out : std_logic_vector(7 downto 0);
    signal EN_Buffer_A, EN_Buffer_B, EN_MEM_CACHE_1, EN_MEM_CACHE_2 : std_logic;
    signal SEL_ROUTE : std_logic_vector(3 downto 0);
    signal SEL_fct : std_logic_vector(3 downto 0);
    signal SEL_OUT : std_logic_vector(1 downto 0);
    signal S, RES_OUT : std_logic_vector(7 downto 0);
    signal SR_OUT_L, SR_OUT_R : std_logic;
    signal A_in, B_in : std_logic_vector(3 downto 0);
    signal SR_IN_L, SR_IN_R : std_logic := '0';
    signal INST_out : std_logic_vector(9 downto 0);
    signal INST_addr : std_logic_vector(6 downto 0) := (others => '0');
    signal INST_CE : std_logic := '0';

    -- FSM pour piloter l'exécution des instructions
    type FSM_State is (Idle, Exec);
    signal state : FSM_State := Idle;
    signal last_instr_addr : std_logic_vector(6 downto 0);

begin

    -- Instances
    UAL_inst: ual
        port map ( A => Buffer_A_out, B => Buffer_B_out,
                   SR_IN_L => SR_IN_L, SR_IN_R => SR_IN_R,
                   SEL_fct => SEL_fct,
                   S => S, SR_OUT_L => SR_OUT_L, SR_OUT_R => SR_OUT_R);

    Buffer_A_inst: buffer_ual
        port map ( clk => CLK100MHZ, reset => btn(0),
                    enable_buffer => EN_Buffer_A, buffer_in => Buffer_A_in, buffer_out => Buffer_A_out);

    Buffer_B_inst: buffer_ual
        port map ( clk => CLK100MHZ, reset => btn(0),
                    enable_buffer => EN_Buffer_B, buffer_in => Buffer_B_in, buffer_out => Buffer_B_out);

    MEM_CACHE_1_inst: buffer_cmd
        port map ( clk => CLK100MHZ, reset => btn(0),
                    enable_buffer => EN_MEM_CACHE_1, buffer_in => MEM_CACHE_1_in, buffer_out => MEM_CACHE_1_out);

    MEM_CACHE_2_inst: buffer_cmd
        port map ( clk => CLK100MHZ, reset => btn(0),
                    enable_buffer => EN_MEM_CACHE_2, buffer_in => MEM_CACHE_2_in, buffer_out => MEM_CACHE_2_out);

    UAL_SelRoute_inst: ual_selroute
        port map ( SEL_ROUTE => SEL_ROUTE, A_IN => A_in, B_IN => B_in, S => S,
                    MEM_CACHE_1_IN => MEM_CACHE_1_out, MEM_CACHE_2_IN => MEM_CACHE_2_out,
                    Buffer_A => Buffer_A_in, Buffer_B => Buffer_B_in,
                    MEM_CACHE_1_OUT => MEM_CACHE_1_in, MEM_CACHE_2_OUT => MEM_CACHE_2_in,
                    EN_Buffer_A => EN_Buffer_A, EN_Buffer_B => EN_Buffer_B,
                    EN_MEM_CACHE_1 => EN_MEM_CACHE_1, EN_MEM_CACHE_2 => EN_MEM_CACHE_2);

    UAL_SelOut_inst: ual_selout
        port map ( SEL_OUT => SEL_OUT, S => S,
                    MEM_CACHE_1_IN => MEM_CACHE_1_out, MEM_CACHE_2_IN => MEM_CACHE_2_out,
                    RES_OUT => RES_OUT);

    Mem_Control_inst: mem_control
        port map ( clk => CLK100MHZ, INST_out => INST_out,
                    INST_addr => INST_addr, INST_CE => INST_CE);

    -- Routage dynamique
    SEL_fct <= INST_out(3 downto 0);
    SEL_ROUTE <= INST_out(7 downto 4);
    SEL_OUT <= INST_out(9 downto 8);

    -- Entrées A et B fixes (pour test, ici via switches)
    A_in <= sw;
    B_in <= sw;

    -- FSM de pilotage des instructions
    process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            if btn(0)='1' then
                INST_addr <= (others => '0');
                INST_CE <= '0';
                state <= Idle;
                last_instr_addr <= (others => '0');
                led0_r <= '0'; led0_g <= '0'; led0_b <= '0';
            else
                case state is
                    when Idle =>
                        if btn <= "0001" then -- Fct1: instr0 à 2
                            last_instr_addr <= "0000010";
                            INST_CE <= '1';
                            state <= Exec;
                        elsif btn <= "0010" then -- Fct2: instr3 à 9
                            last_instr_addr <= "0001001";
                            INST_addr <= "0000011";
                            INST_CE <= '1';
                            state <= Exec;
                        elsif btn <= "001" then -- Fct3: instr10 à 16
                            last_instr_addr <= "0010000";
                            INST_addr <= "0001010";
                            INST_CE <= '1';
                            state <= Exec;
                        end if;
                    when Exec =>
                        if INST_addr = last_instr_addr then
                            INST_CE <= '0';
                            state <= Idle;
                            led0_g <= '1'; -- Indicateur exécution finie
                        else
                            INST_addr <= std_logic_vector(unsigned(INST_addr)+1);
                        end if;
                end case;
            end if;
        end if;
    end process;

    -- Résultat final : 4 bits de poids faibles
    led <= RES_OUT(3 downto 0);

    -- LEDs RGB pour debug (exemple)
    led0_r <= '0';
    led0_b <= '0';
    led1_r <= '0'; led1_g <= '0'; led1_b <= '0';
    led2_r <= '0'; led2_g <= '0'; led2_b <= '0';
    led3_r <= '0'; led3_g <= '0'; led3_b <= '0';

end Behavioral;
