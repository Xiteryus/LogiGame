library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TopLevel is
    Port (
        CLK100MHZ : in STD_LOGIC;
        sw        : in STD_LOGIC_VECTOR(3 downto 0);
        btn       : in STD_LOGIC_VECTOR(3 downto 0);
        led       : out STD_LOGIC_VECTOR(3 downto 0);

        led0_r : out STD_LOGIC; led0_g : out STD_LOGIC; led0_b : out STD_LOGIC;                
        led1_r : out STD_LOGIC; led1_g : out STD_LOGIC; led1_b : out STD_LOGIC;
        led2_r : out STD_LOGIC; led2_g : out STD_LOGIC; led2_b : out STD_LOGIC;                
        led3_r : out STD_LOGIC; led3_g : out STD_LOGIC; led3_b : out STD_LOGIC
    );
end TopLevel;

architecture TopLevel_Arch of TopLevel is

    -- Déclaration du composant game_controller
    component game_controller is
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
    end component;

    -- Signaux internes
    signal led_color_internal : std_logic_vector(2 downto 0);
    signal game_over_signal   : std_logic;

begin

    -- Instanciation du contrôleur de jeu
    GameCtrl : game_controller
        port map (
            clk         => CLK100MHZ,
            reset       => btn(0),         -- BTN0 = reset
            start_btn   => btn(1),         -- BTN1 = start
            btn_r       => btn(3),         -- BTN3 = bouton rouge
            btn_g       => btn(2),         -- BTN2 = bouton vert
            btn_b       => btn(1),         -- BTN1 = bouton bleu
            sw_level    => sw(3 downto 2), -- SW3:SW2 = niveau difficulté
            led_color   => led_color_internal,
            score_out   => led,
            game_over   => game_over_signal,
            led3_r      => led3_r,
            led3_g      => led3_g,
            led3_b      => led3_b
        );

    -- Gestion de la LED de fin de partie (led0) en fonction du score
    led0_r <= '1' when game_over_signal = '1' and led < "0111" else '0';  -- score < 7 → rouge
    led0_g <= '1' when game_over_signal = '1' and led = "1111" else '0';  -- score = 15 → vert
    led0_b <= '1' when game_over_signal = '1' and led >= "0111" and led < "1111" else '0'; -- 7–14 → bleu (orange en combinant R+G si besoin)

    -- Autres LEDs RGB éteintes
    led1_r <= '0'; led1_g <= '0'; led1_b <= '0';
    led2_r <= '0'; led2_g <= '0'; led2_b <= '0';

end TopLevel_Arch;
