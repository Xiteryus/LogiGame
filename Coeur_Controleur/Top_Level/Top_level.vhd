library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_level is
    Port (
        CLK100MHZ : in STD_LOGIC; -- CLK
        sw : in STD_LOGIC_VECTOR(3 downto 0); -- A & B
        btn : in STD_LOGIC_VECTOR(3 downto 0); -- SEL_FCT
        led : out STD_LOGIC_VECTOR(3 downto 0); -- S 
        led0_r : out STD_LOGIC; led0_g : out STD_LOGIC; led0_b : out STD_LOGIC;                
        led1_r : out STD_LOGIC; led1_g : out STD_LOGIC; led1_b : out STD_LOGIC;
        led2_r : out STD_LOGIC; led2_g : out STD_LOGIC; led2_b : out STD_LOGIC;                
        led3_r : out STD_LOGIC; led3_g : out STD_LOGIC; led3_b : out STD_LOGIC
    );
end Top_level;

architecture Behavioral of Top_level is
    -- DECLARATION DES COMPOSANTS
    --UAL
    component ual
        port(
            A : in std_logic_vector (4-1 downto 0);
            B : in std_logic_vector (4-1 downto 0);
            SR_IN_L : in std_logic;
            SR_IN_R : in std_logic;
            SEL_fct : in std_logic_vector (4-1 downto 0);
            S : out std_logic_vector (7 downto 0);  
            SR_OUT_L : out std_logic;
            SR_OUT_R : out std_logic
        );
    end component;
    --BUFFER_UAL
    component buffer_ual
        port(
        clk            : in  std_logic;
        reset              : in  std_logic;
        
        enable_buffer_A     : in  std_logic;
        enable_buffer_B     : in  std_logic;
       
        e1 : in  std_logic_vector(3 downto 0);
        
        buffer_A_out   : out std_logic_vector(3 downto 0);
        buffer_B_out   : out std_logic_vector(3 downto 0)
    );
    end component;
    --BUFFER_CMD
    component buffer_cmd
        port(
        clk           : in  std_logic;
        reset         : in  std_logic;
        
        enable_fct    : in  std_logic;
        enable_route  : in  std_logic;
        enable_out    : in  std_logic;

        sel_fct_in    : in  std_logic_vector(3 downto 0);
        sel_route_in  : in  std_logic_vector(3 downto 0);
        sel_out_in    : in  std_logic_vector(1 downto 0);

        sel_fct_out   : out std_logic_vector(3 downto 0);
        sel_route_out : out std_logic_vector(3 downto 0);
        sel_out_out   : out std_logic_vector(1 downto 0)
        );
    end component;
    --UAL_SEL_OUT
    component ual_selout
        port(
        SEL_OUT : in  std_logic_vector(1 downto 0);
        S : in  std_logic_vector(7 downto 0);
        MEM_CACHE_1_IN : in  std_logic_vector(7 downto 0);
        MEM_CACHE_2_IN : in  std_logic_vector(7 downto 0);
        RES_OUT : out std_logic_vector(7 downto 0)
        );
    end component;
    --UAL_SEL_ROUTE
    component ual_selroute
        port(
        SEL_ROUTE      : in  std_logic_vector(3 downto 0);
        A_IN           : in  std_logic_vector(3 downto 0);
        B_IN           : in  std_logic_vector(3 downto 0);
        S              : in  std_logic_vector(7 downto 0);
        MEM_CACHE_1_IN : in  std_logic_vector(7 downto 0);
        MEM_CACHE_2_IN : in  std_logic_vector(7 downto 0);

        Buffer_A       : out std_logic_vector(3 downto 0);
        Buffer_B       : out std_logic_vector(3 downto 0);
        MEM_CACHE_1_OUT : out std_logic_vector(7 downto 0);
        MEM_CACHE_2_OUT : out std_logic_vector(7 downto 0);

        EN_Buffer_A    : out std_logic;
        EN_Buffer_B    : out std_logic;
        EN_MEM_CACHE_1 : out std_logic;
        EN_MEM_CACHE_2 : out std_logic
        );
    end component;
    -- MEM_CONTROL
    component mem_control
        port (
            clk : in std_logic;
            reset : in std_logic;

            INST_in : in std_logic_vector(9 downto 0);
            INST_out : out std_logic_vector(9 downto 0);
            INST_addr: in std_logic_vector(3 downto 0);
            INST_CE: in std_logic;
        );
    end component;

    -- SIGNAUX 
    -- POUR AUTOMATE : 
        type type_etat is (s_Idle, s_Funct_1, s_Funct_2, s_Funct_3);
        signal FSM_Main : type_etat;

        -- Compteur pour la temporisation dans chaque état
        signal MyCounter1 : unsigned(7 downto 0);  -- 8 bits suffisent pour atteindre 73

        -- Signal pour LED de confirmation
        signal led0_q : std_logic;  -- utilisé pour reset dans l'automate 
    -- POUR LIASON : 

    begin
    -- LIASON 
        UAL1: ual
            port map (
                A => sw,
                B => sw,
                SR_IN_L => 
                SR_IN_R => 
                SEL_fct => btn,
                S => led
                SR_OUT_L => 
                SR_OUT_R => 
            );
        BUFF_UAL: buffer_ual
            port map (
                clk => CLK100MHZ,
                reset => 
                enable_buffer_A => 
                enable_buffer_B => 
                e1 => sw,  -- probleme ? 
                buffer_A_out => 
                buffer_B_out => 
            );
        BUFF_CMD: buffer_cmd
            port map (
                clk => CLK100MHZ,
                reset => 
                enable_fct => 
                enable_route => 
                enable_out => 
                sel_fct_in => btn, -- 
                sel_route_in => 
                sel_out_in => 
                sel_fct_out => 
                sel_route_out =>,
                sel_out_out => 
            );
        SEL_ROUTE1: ual_selroute
            port map (
                SEL_ROUTE => 
                A_IN => sw,
                B_IN => sw,
                S => led,
                MEM_CACHE_1_IN => 
                MEM_CACHE_2_IN => 
                Buffer_A => 
                Buffer_B => 
                MEM_CACHE_1_OUT => 
                MEM_CACHE_2_OUT => 
                EN_Buffer_A => 
                EN_Buffer_B => 
                EN_MEM_CACHE_1 => 
                EN_MEM_CACHE_2 => 
            );
        SEL_OUT1: ual_selout
            port map (
                SEL_OUT => 
                S => led,
                MEM_CACHE_1_IN => 
                MEM_CACHE_2_IN => 
                RES_OUT => 
            );


    -- Automate qui réalise les 3 fonctions (multiplication, xnor et or)
        MyAlgoProc : process (btn(3 downto 0),CLK100MHZ)
            begin
            if (btn(0)= '1') then
                MyCounter1 <= (others => '0');
                led0_q <= '0';
                FSM_Main <= s_Idle;
            elsif rising_edge(CLK100MHZ) then
                case FSM_Main is 
                when s_Idle =>
                        if(btn(3) = '1') then
                            MyCounter1 <= "1000000";FSM_Main <= s_Funct_3; led0_g <= '0';
                        elsif (btn(2) = '1') then
                            MyCounter1 <= "0100000";FSM_Main <= s_Funct_2; led0_g <= '0';
                        elsif (btn(1) = '1') then
                            MyCounter1 <= (others => '0');FSM_Main <= s_Funct_1; led0_g <= '0';
                        else
                            MyCounter1 <= (others => '0');FSM_Main <= s_Idle; led0_g <= '0';
                        end if;
                    when s_Funct_1 =>
                            if(btn(1) = '1') then
                                FSM_Main <= s_Funct_1;
                                if MyCounter1= 3 then 
                                    MyCounter1 <= MyCounter1;
                                    led0_g <= '1';
                                else
                                    MyCounter1 <= MyCounter1 + 1;
                                    led0_g <= '0';
                                end if;
                            else
                                MyCounter1 <= (others => '0');led0_g <= '0';
                                FSM_Main <= s_Idle; 
                            end if;
                        when s_Funct_2 =>
                            if (btn(2) = '1') then
                                FSM_Main <= s_Funct_2;
                                if MyCounter1=37 then 
                                    MyCounter1 <= MyCounter1;
                                    led0_g <= '1';
                                else
                                    MyCounter1 <= MyCounter1 + 1;
                                    led0_g <= '0';
                                end if;
                            else
                                MyCounter1 <= (others => '0');led0_g <= '0';
                                FSM_Main <= s_Idle; 
                            end if;
                        when s_Funct_3 =>
                            if (btn(3) = '1') then
                                FSM_Main <= s_Funct_3;
                                if MyCounter1= 73 then 
                                    MyCounter1 <= MyCounter1;
                                    led0_g <= '1';
                                else
                                    MyCounter1 <= MyCounter1 + 1;
                                    led0_g <= '0';
                                end if;
                            else
                                MyCounter1 <= (others => '0');led0_g <= '0';
                                FSM_Main <= s_Idle; 
                            end if;
                        when others =>
                            FSM_Main <= s_Idle;
                    end case;
                end if;
            end process MyAlgoProc;
        
end Behavioral;

    