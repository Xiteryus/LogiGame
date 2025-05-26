library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controleur is
    Port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        start_btn   : in  std_logic;
        sw_level    : in  std_logic_vector(1 downto 0);
        btn_r       : in  std_logic;
        btn_g       : in  std_logic;
        btn_b       : in  std_logic;
        led_color   : out std_logic_vector(2 downto 0);
        score_out   : out std_logic_vector(3 downto 0);
        game_over   : out std_logic;
        led3_r      : out std_logic;
        led3_g      : out std_logic;
        led3_b      : out std_logic
    );
end controleur;

architecture Behavioral of controleur is

    type state_type is (IDLE, NEW_ROUND, WAIT_RESP, END_GAME);
    signal state, next_state : state_type := IDLE;

    signal rnd_color    : std_logic_vector(3 downto 0);
    signal lfsr_enable  : std_logic := '0';
    signal timer_start  : std_logic := '0';
    signal timeout      : std_logic;
    signal valid_hit    : std_logic;
    signal score        : std_logic_vector(3 downto 0);

    signal internal_game_over : std_logic;

    -- composants
    component lsfr4bits is
        Port ( 
            clk : in std_logic; 
            reset : in std_logic; 
            enable : in std_logic; 
            rnd : out std_logic_vector(3 downto 0)
            );
    end component;

    component minuteur is
        generic (
            TRES_FACILE : integer := 100_000_000;
            FACILE      : integer := 50_000_000;
            MOYEN       : integer := 25_000_000;
            DIFFICILE   : integer := 12_500_000
        );
        Port ( 
            clk : in std_logic; 
            reset : in std_logic; 
            start : in std_logic;
            sw_level : in std_logic_vector(1 downto 0); 
            timeout : out std_logic
        );
    end component;

    component verificateur is
        Port ( 
            clk : in std_logic; 
            reset : in std_logic; 
            timeout : in std_logic;
            led_color : in std_logic_vector(2 downto 0); 
            btn_r, btn_g, btn_b : in std_logic;
            valid_hit : out std_logic
        );
    end component;

    component compteur is
        Port ( 
            clk : in std_logic; 
            reset : in std_logic; 
            valid_hit : in std_logic;
            score : out std_logic_vector(3 downto 0); 
            game_over : out std_logic
        );
    end component;

begin

    -- Instanciations
    lfsr_inst : lsfr4bits port map(clk, reset, lfsr_enable, rnd_color);
    timer_inst : minuteur port map(clk, reset, timer_start, sw_level, timeout);
    verifier_inst : verificateur port map(clk, reset, timeout, rnd_color(2 downto 0), btn_r, btn_g, btn_b, valid_hit);
    score_inst : compteur port map(clk, reset, valid_hit, score, internal_game_over);

    -- État suivant
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= IDLE;
            else
                state <= next_state;
            end if;
        end if;
    end process;

    -- FSM
    process(state, start_btn, timeout, valid_hit, internal_game_over)
    begin
        -- Valeurs par défaut
        lfsr_enable   <= '0';
        timer_start   <= '0';
        next_state    <= state;

        case state is
            when IDLE =>
                if start_btn = '1' then
                    next_state <= NEW_ROUND;
                end if;

            when NEW_ROUND =>
                lfsr_enable <= '1';
                timer_start <= '1';
                next_state  <= WAIT_RESP;

            when WAIT_RESP =>
                if internal_game_over = '1' then
                    next_state <= END_GAME;
                elsif valid_hit = '1' or timeout = '1' then
                    next_state <=
                        (valid_hit = '1') ? NEW_ROUND : END_GAME;
                end if;

            when END_GAME =>
                next_state <= IDLE;

        end case;
    end process;

    -- Affectations
    led_color   <= rnd_color(2 downto 0);
    score_out   <= score;
    game_over   <= internal_game_over;

    -- LED RVB pour la couleur
    led3_r <= rnd_color(2);
    led3_g <= rnd_color(1);
    led3_b <= rnd_color(0);

end Behavioral;
