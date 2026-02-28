-- Name: Arion Stern
-- Section #: 10972
-- PI Name: Newman Waters
-- Description: Testbench for clk_div verifying 50 MHz -> 25 MHz
--              divide-by-2 pixel clock. Checks:
--              1) pixel_clk held low during reset
--              2) pixel_clk toggles on every rising edge of clk after reset

library ieee;
use ieee.std_logic_1164.all;

entity clk_div_tb is
end clk_div_tb;

architecture tb of clk_div_tb is

    component clk_div
        port (
            clk       : in  std_logic;
            rst       : in  std_logic;
            pixel_clk : out std_logic
        );
    end component;

    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';
    signal pixel_clk : std_logic;

    constant CLK_PERIOD : time := 20 ns; -- 50 MHz input clock

begin

    -- DUT
    UUT : clk_div
        port map (
            clk       => clk,
            rst       => rst,
            pixel_clk => pixel_clk
        );

    -- 50 MHz clock generation
    clk <= not clk after CLK_PERIOD/2;

    process
        variable prev_pixel : std_logic := '0';
        variable expected   : std_logic := '0';
    begin

        -- Hold reset high for a few rising edges
        rst <= '1';

        for i in 0 to 5 loop
            wait until rising_edge(clk);
            wait for 0 ns; -- allow DUT to settle in same sim time

            assert pixel_clk = '0'
                report "ERROR: pixel_clk not 0 during reset. saw=" &
                       std_logic'image(pixel_clk)
                severity error;
        end loop;

        -- Release reset
        rst <= '0';

        -- After reset, pixel_clk should toggle every rising edge of clk
        -- Initialize expected from current value
        wait until rising_edge(clk);
        wait for 0 ns;
        prev_pixel := pixel_clk;

        for k in 0 to 20 loop
            wait until rising_edge(clk);
            wait for 0 ns;

            expected := not prev_pixel;

            assert pixel_clk = expected
                report "ERROR: pixel_clk did not toggle correctly. expected=" &
                       std_logic'image(expected) & " saw=" &
                       std_logic'image(pixel_clk)
                severity error;

            prev_pixel := pixel_clk;
        end loop;

        assert false report "clk_div_tb DONE (expected stop)." severity failure;
        wait;

    end process;

end tb;