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
    -- Composants
    component buffer_ual -- sur 4 bits pour Buff A et B
        Port ( 
            clk : in std_logic;
            reset : in std_logic;
            enable_buffer : in std_logic;
            buffer_in : in std_logic_vector(3 downto 0);
            buffer_out : out std_logic_vector(3 downto 0)
            );
    end component;
    
    component buffer_cmd -- sur 8 bits pour mem1 et 2 
        Port ( 
            clk : in std_logic;
            reset : in std_logic;
            enable_buffer : in std_logic;
            buffer_in : in std_logic_vector(7 downto 0);
            buffer_out : out std_logic_vector(7 downto 0)
            );
    end component;
    
    component mem_control -- Memoire d'instruction
        port ( 
            clk : in std_logic;
           INST_out : out std_logic_vector(9 downto 0);
           INST_addr : in std_logic_vector(6 downto 0);
           INST_CE : in std_logic
           );
    end component;
    
    component ual
        generic (N : integer := 4);
        port ( 
            A, B : in std_logic_vector(N-1 downto 0);
            SR_IN_L, SR_IN_R : in std_logic;
            SEL_fct : in std_logic_vector(3 downto 0);
            S : out std_logic_vector(7 downto 0);
            SR_OUT_L, SR_OUT_R : out std_logic
            );
    end component;
    
    component ual_selroute
        port ( 
            SEL_ROUTE : in std_logic_vector(3 downto 0);
            A_IN, B_IN : in std_logic_vector(3 downto 0);
            S : in std_logic_vector(7 downto 0);
            MEM_CACHE_1_IN, MEM_CACHE_2_IN : in std_logic_vector(7 downto 0);
            Buffer_A, Buffer_B : out std_logic_vector(3 downto 0);
            MEM_CACHE_1_OUT, MEM_CACHE_2_OUT : out std_logic_vector(7 downto 0);
            EN_Buffer_A, EN_Buffer_B : out std_logic;
            EN_MEM_CACHE_1, EN_MEM_CACHE_2 : out std_logic
            );
    end component;
    
    component ual_selout
        port ( 
            SEL_OUT : in std_logic_vector(1 downto 0);
            S : in std_logic_vector(7 downto 0);
            MEM_CACHE_1_IN : in std_logic_vector(7 downto 0);
            MEM_CACHE_2_IN : in std_logic_vector(7 downto 0);
            RES_OUT : out std_logic_vector(7 downto 0));
    end component;

    -- Signaux internes

    -- Instruction en memoire
    signal RES_OUT : std_logic_vector(7 downto 0);
    signal INST_out : std_logic_vector(9 downto 0);
    signal INST_addr : std_logic_vector(6 downto 0) := (others => '0');
    signal INST_CE : std_logic := '0';
    
    -- UAL
    signal A_ual, B_ual : std_logic_vector(3 downto 0);
    signal SR_IN_L, SR_IN_R : std_logic := '0';
    signal SEL_fct : std_logic_vector(3 downto 0);
    signal S_ual : std_logic_vector(7 downto 0);
    signal SR_OUT_L, SR_OUT_R : std_logic;
    
    -- Selroute
    signal SEL_ROUTE : std_logic_vector(3 downto 0);
    signal MEM_CACHE_1_IN, MEM_CACHE_2_IN : std_logic_vector(7 downto 0) := (others => '0');
    signal MEM_CACHE_1_OUT, MEM_CACHE_2_OUT : std_logic_vector(7 downto 0);
    signal EN_Buffer_A, EN_Buffer_B : std_logic;
    signal EN_MEM_CACHE_1, EN_MEM_CACHE_2 : std_logic;
    
    -- Buffers
    signal Buffer_A_out, Buffer_B_out : std_logic_vector(3 downto 0);
    
    -- Selout
    signal SEL_OUT : std_logic_vector(1 downto 0);
    
    -- Automate
    type state_type is (s_Idle, s_Funct_1, s_Funct_2, s_Funct_3); -- Chaque fonction correspond aux 3 3 fonctions 
    signal FSM_Main : state_type := s_Idle;
    signal MyCounter1 : unsigned(6 downto 0) := (others => '0');
    
begin
    -- Liason
    mem_ctrl : mem_control
    port map (
        clk => CLK100MHZ,
        INST_out => INST_out,
        INST_addr => INST_addr,
        INST_CE => INST_CE
    );
    
    ual_inst : ual
    generic map (N => 4)
    port map (
        A => A_ual,
        B => B_ual,
        SR_IN_L => SR_IN_L,
        SR_IN_R => SR_IN_R,
        SEL_fct => SEL_fct,
        S => S_ual,
        SR_OUT_L => SR_OUT_L,
        SR_OUT_R => SR_OUT_R
    );
    
    selroute_inst : ual_selroute
    port map (
        SEL_ROUTE => SEL_ROUTE,
        A_IN => sw(3 downto 0),
        B_IN => sw(3 downto 0),
        S => S_ual,
        MEM_CACHE_1_IN => MEM_CACHE_1_IN,
        MEM_CACHE_2_IN => MEM_CACHE_2_IN,
        Buffer_A => A_ual,
        Buffer_B => B_ual,
        MEM_CACHE_1_OUT => MEM_CACHE_1_OUT,
        MEM_CACHE_2_OUT => MEM_CACHE_2_OUT,
        EN_Buffer_A => EN_Buffer_A,
        EN_Buffer_B => EN_Buffer_B,
        EN_MEM_CACHE_1 => EN_MEM_CACHE_1,
        EN_MEM_CACHE_2 => EN_MEM_CACHE_2
    );
    
    buffer_A : buffer_ual
    port map (
        clk => CLK100MHZ,
        reset => btn(0),
        enable_buffer => EN_Buffer_A,
        buffer_in => A_ual,
        buffer_out => Buffer_A_out
    );
    
    buffer_B : buffer_ual
    port map (
        clk => CLK100MHZ,
        reset => btn(0),
        enable_buffer => EN_Buffer_B,
        buffer_in => B_ual,
        buffer_out => Buffer_B_out
    );
    
    mem_cache_1 : buffer_cmd
    port map (
        clk => CLK100MHZ,
        reset => btn(0),
        enable_buffer => EN_MEM_CACHE_1,
        buffer_in => MEM_CACHE_1_OUT,
        buffer_out => MEM_CACHE_1_IN
    );
    
    mem_cache_2 : buffer_cmd
    port map (
        clk => CLK100MHZ,
        reset => btn(0),
        enable_buffer => EN_MEM_CACHE_2,
        buffer_in => MEM_CACHE_2_OUT,
        buffer_out => MEM_CACHE_2_IN
    );
    
    selout_inst : ual_selout
    port map (
        SEL_OUT => SEL_OUT,
        S => S_ual,
        MEM_CACHE_1_IN => MEM_CACHE_1_IN,
        MEM_CACHE_2_IN => MEM_CACHE_2_IN,
        RES_OUT => RES_OUT
    );
    
    -- Extraction des signaux de contrôle depuis l'instruction du code en dur 
    SEL_fct <= INST_out(9 downto 6);
    SEL_ROUTE <= INST_out(5 downto 2);
    SEL_OUT <= INST_out(1 downto 0);
    

    -- Automate (récupérer depuis les photos prises lors du cours de VHDL) puis réajuster à notre code
    -- Automate (qui ne marche pas) 
    process (btn, CLK100MHZ)
    begin
        if (btn <= "0000") then
            MyCounter1 <= (others => '0');
            INST_CE <= '0';
            FSM_Main <= s_Idle;
        elsif rising_edge(CLK100MHZ) then
            case FSM_Main is 
                when s_Idle =>
                    INST_CE <= '0';
                    if (btn <= "0011") then
                        MyCounter1 <= "0001010"; 
                        FSM_Main <= s_Funct_3;
                        INST_CE <= '1';
                    elsif (btn <= "0010") then
                        MyCounter1 <= "0000011"; 
                        FSM_Main <= s_Funct_2;
                        INST_CE <= '1';
                    elsif (btn <= "0001") then
                        MyCounter1 <= (others => '0'); 
                        FSM_Main <= s_Funct_1;
                        INST_CE <= '1';
                    else
                        MyCounter1 <= (others => '0');
                        FSM_Main <= s_Idle;
                        INST_CE <= '0';
                    end if;
                
                when s_Funct_1 =>
                    if (btn <= "0001") then
                        INST_CE <= '1';
                        if MyCounter1 = 2 then -- 3 premiere instruction pour la A*B 
                            MyCounter1 <= MyCounter1;
                            INST_addr <= std_logic_vector(MyCounter1);
                        else
                            MyCounter1 <= MyCounter1 + 1;
                            INST_addr <= std_logic_vector(MyCounter1);
                        end if;
                    else
                        MyCounter1 <= (others => '0');
                        FSM_Main <= s_Idle;
                        INST_CE <= '0';
                    end if;
                
                when s_Funct_2 =>
                    if (btn <= "0010") then
                        INST_CE <= '1';
                        if MyCounter1 = 9 then 
                            MyCounter1 <= MyCounter1;
                            INST_addr <= std_logic_vector(MyCounter1);
                        else
                            MyCounter1 <= MyCounter1 + 1;
                            INST_addr <= std_logic_vector(MyCounter1);
                        end if;
                    else
                        MyCounter1 <= (others => '0');
                        FSM_Main <= s_Idle;
                        INST_CE <= '0';
                    end if;
                
                when s_Funct_3 =>
                    if (btn <= "0011") then
                        INST_CE <= '1';
                        if MyCounter1 = 16 then 
                            MyCounter1 <= MyCounter1;
                            INST_addr <= std_logic_vector(MyCounter1);
                        else
                            MyCounter1 <= MyCounter1 + 1;
                            INST_addr <= std_logic_vector(MyCounter1);
                        end if;
                    else
                        MyCounter1 <= (others => '0');
                        FSM_Main <= s_Idle;
                        INST_CE <= '0';
                    end if;
                
                when others =>
                    FSM_Main <= s_Idle;
            end case;
        end if;
        
    -- Affichage des résultats sur les LEDs
    led <= RES_OUT(3 downto 0); -- 4 bits LSB sur les LEDs standard
    
    -- Affichage étendu sur les LEDs RVB pour tester mais rien ne s'affiche sauf led1_r
    led0_r <= RES_OUT(0);
    led0_g <= RES_OUT(1);
    led0_b <= RES_OUT(2);
    
    led1_r <= RES_OUT(3);
    led1_g <= RES_OUT(4);
    led1_b <= RES_OUT(5);
    
    led2_r <= RES_OUT(6);
    led2_g <= RES_OUT(7);

    led2_b <= '0'; -- Non utilisé donc mis à 0 
    led3_r <= '0';
    led3_g <= '0';
    led3_b <= '0';

    end process;

end Behavioral;