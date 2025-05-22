library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity buffer_cmd is
    Port (
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
end buffer_cmd;

architecture Behavioral of buffer_cmd is
begin

    -- Buffer SEL_FCT
    Buffer_SEL_FCT: process(clk, reset)
    begin
        if reset = '1' then
            sel_fct_out <= (others => '0');
        elsif rising_edge(clk) then
            if enable_fct = '1' then
                sel_fct_out <= sel_fct_in;
            end if;
        end if;
    end process;

    -- Buffer SEL_ROUTE
    Buffer_SEL_ROUTE: process(clk, reset)
    begin
        if reset = '1' then
            sel_route_out <= (others => '0');
        elsif rising_edge(clk) then
            if enable_route = '1' then
                sel_route_out <= sel_route_in;
            end if;
        end if;
    end process;

    -- Buffer SEL_OUT
    buffer_SEL_OUT: process(clk, reset)
    begin
        if reset = '1' then
            sel_out_out <= (others => '0');
        elsif rising_edge(clk) then
            if enable_out = '1' then
                sel_out_out <= sel_out_in;
            end if;
        end if;
    end process;

end Behavioral;
