library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top_level is
    Port (
        CLK100MHZ : in STD_LOGIC; -- Horloge 100 MHz
        sw : in STD_LOGIC_VECTOR(3 downto 0); -- Entrées A & B (sw(3:0))
        btn : in STD_LOGIC_VECTOR(3 downto 0); -- Boutons (0=reset, 1-3=fonctions)
        led : out STD_LOGIC_VECTOR(3 downto 0); -- Résultat final (4 bits LSB)
        led0_r, led0_g, led0_b : out STD_LOGIC; -- LEDs statut
        led1_r, led1_g, led1_b : out STD_LOGIC;
        led2_r, led2_g, led2_b : out STD_LOGIC;
        led3_r, led3_g, led3_b : out STD_LOGIC
    );
end Top_level;

architecture Behavioral of Top_level is
    -- Déclarations des composants (inchangées)
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
               SEL_fct : in std_logic_vector(3 downto 0);
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

    -- Signaux internes (inchangés)
    signal Buffer_A_in, Buffer_A_out, Buffer_B_in, Buffer_B_out : std_logic_vector(3 downto 0);
    signal MEM_CACHE_1_in, MEM_CACHE_1_out, MEM_CACHE_2_in, MEM_CACHE_2_out : std_logic_vector(7 downto 0);
    signal EN_Buffer_A, EN_Buffer_B, EN_MEM_CACHE_1, EN_MEM_CACHE_2 : std_logic;
    signal SEL_ROUTE : std_logic_vector(3 downto 0);
    signal SEL_fct : std_logic_vector(3 downto 0);
    signal SEL_OUT : std_logic_vector(1 downto 0);
    signal S, RES_OUT : std_logic_vector(7 downto 0);
    signal SR_OUT_L, SR_OUT_R, SR_IN_L, SR_IN_R : std_logic;
    signal INST_out : std_logic_vector(9 downto 0);
    signal INST_addr : std_logic_vector(6 downto 0) := (others => '0');
    signal INST_CE : std_logic := '0';
    
    -- FSM pour piloter l'exécution
    type FSM_State is (Idle, Load_Operands, Execute, Done);
    signal state : FSM_State := Idle;
    signal current_func : integer range 0 to 3 := 0;
    signal cycle_count : integer := 0;
    signal max_cycles : integer := 0;
    
    -- Constantes pour les nombres de cycles
    constant CYCLES_FUNC1 : integer := 3;
    constant CYCLES_FUNC2 : integer := 37;
    constant CYCLES_FUNC3 : integer := 73;

begin
    -- Instanciations des composants (inchangées)
    UAL_inst: ual
        port map ( 
            A => Buffer_A_out, 
            B => Buffer_B_out,
            SR_IN_L => SR_IN_L, 
            SR_IN_R => SR_IN_R,
            SEL_fct => SEL_fct,
            S => S, 
            SR_OUT_L => SR_OUT_L, 
            SR_OUT_R => SR_OUT_R
        );

    Buffer_A_inst: buffer_ual
        port map ( 
            clk => CLK100MHZ, 
            reset => btn(0),
            enable_buffer => EN_Buffer_A, 
            buffer_in => Buffer_A_in, 
            buffer_out => Buffer_A_out
        );

    Buffer_B_inst: buffer_ual
        port map ( 
            clk => CLK100MHZ, 
            reset => btn(0),
            enable_buffer => EN_Buffer_B, 
            buffer_in => Buffer_B_in, 
            buffer_out => Buffer_B_out
        );

    MEM_CACHE_1_inst: buffer_cmd
        port map ( 
            clk => CLK100MHZ, 
            reset => btn(0),
            enable_buffer => EN_MEM_CACHE_1, 
            buffer_in => MEM_CACHE_1_in, 
            buffer_out => MEM_CACHE_1_out
        );

    MEM_CACHE_2_inst: buffer_cmd
        port map ( 
            clk => CLK100MHZ, 
            reset => btn(0),
            enable_buffer => EN_MEM_CACHE_2, 
            buffer_in => MEM_CACHE_2_in, 
            buffer_out => MEM_CACHE_2_out
        );

    UAL_SelRoute_inst: ual_selroute
        port map ( 
            SEL_ROUTE => SEL_ROUTE, 
            A_IN => sw, 
            B_IN => sw, 
            S => S,
            MEM_CACHE_1_IN => MEM_CACHE_1_out, 
            MEM_CACHE_2_IN => MEM_CACHE_2_out,
            Buffer_A => Buffer_A_in, 
            Buffer_B => Buffer_B_in,
            MEM_CACHE_1_OUT => MEM_CACHE_1_in, 
            MEM_CACHE_2_OUT => MEM_CACHE_2_in,
            EN_Buffer_A => EN_Buffer_A, 
            EN_Buffer_B => EN_Buffer_B,
            EN_MEM_CACHE_1 => EN_MEM_CACHE_1, 
            EN_MEM_CACHE_2 => EN_MEM_CACHE_2
        );

    UAL_SelOut_inst: ual_selout
        port map ( 
            SEL_OUT => SEL_OUT, 
            S => S,
            MEM_CACHE_1_IN => MEM_CACHE_1_out, 
            MEM_CACHE_2_IN => MEM_CACHE_2_out,
            RES_OUT => RES_OUT
        );

    Mem_Control_inst: mem_control
        port map ( 
            clk => CLK100MHZ, 
            INST_out => INST_out,
            INST_addr => INST_addr, 
            INST_CE => INST_CE
        );

    -- Extraction des signaux de contrôle
    SEL_fct <= INST_out(3 downto 0);
    SEL_ROUTE <= INST_out(7 downto 4);
    SEL_OUT <= INST_out(9 downto 8);

    -- Machine à états principale
    process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            if btn(0) = '1' then -- Reset
                state <= Idle;
                INST_addr <= (others => '0');
                INST_CE <= '0';
                cycle_count <= 0;
                current_func <= 0;
                led0_g <= '0';
                led0_r <= '0';
            else
                case state is
                    when Idle =>
                        if btn(1) = '1' then -- Fonction 1
                            current_func <= 1;
                            max_cycles <= CYCLES_FUNC1;
                            state <= Load_Operands;
                            INST_addr <= "0000000";
                            led0_g <= '0';
                            
                        elsif btn(2) = '1' then -- Fonction 2
                            current_func <= 2;
                            max_cycles <= CYCLES_FUNC2;
                            state <= Load_Operands;
                            INST_addr <= "0000011";
                            led0_g <= '0';
                            
                        elsif btn(3) = '1' then -- Fonction 3
                            current_func <= 3;
                            max_cycles <= CYCLES_FUNC3;
                            state <= Load_Operands;
                            INST_addr <= "0001010";
                            led0_g <= '0';
                        end if;
                        cycle_count <= 0;
                        
                    when Load_Operands =>
                        INST_CE <= '1';
                        state <= Execute;
                        
                    when Execute =>
                        if cycle_count < max_cycles then
                            cycle_count <= cycle_count + 1;
                            INST_addr <= std_logic_vector(unsigned(INST_addr) + 1);
                        else
                            state <= Done;
                            INST_CE <= '0';
                        end if;
                        
                    when Done =>
                        led0_g <= '1'; -- Indique calcul terminé
                        if btn(1) = '0' and btn(2) = '0' and btn(3) = '0' then
                            state <= Idle;
                        end if;
                end case;
            end if;
        end if;
    end process;

    -- Affichage des résultats sur les LEDs
    led <= RES_OUT(3 downto 0); -- 4 bits LSB sur les LEDs standard
    
    -- Affichage étendu sur les LEDs RVB (8 bits)
    led0_r <= RES_OUT(0);
    led0_g <= RES_OUT(1);
    led0_b <= RES_OUT(2);
    
    led1_r <= RES_OUT(3);
    led1_g <= RES_OUT(4);
    led1_b <= RES_OUT(5);
    
    led2_r <= RES_OUT(6);
    led2_g <= RES_OUT(7);
    led2_b <= '0'; -- Non utilisé
    
    -- SR_OUT sur les LEDs bleues comme spécifié (page 18)
    led3_b <= '0'; -- Non utilisé
    led3_r <= '0'; -- Non utilisé
    led3_g <= '0'; -- Non utilisé
    
    -- Assignation spécifique pour SR_OUT_L et SR_OUT_R (LED5 et LED6 bleues)
    led1_b <= SR_OUT_L; -- LED5 bleue = SR_OUT_L
    led2_b <= SR_OUT_R; -- LED6 bleue = SR_OUT_R
    
    -- Retenues à 0 (non utilisées dans les fonctions)
    SR_IN_L <= '0';
    SR_IN_R <= '0';

end Behavioral;