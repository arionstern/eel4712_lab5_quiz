-- Name: Arion Stern
-- Section #: 10972
-- PI Name: Newman Waters
-- Description: Generic clock divider that generates a single-cycle
--              enable pulse at a lower frequency from an input clock.
--              Go from 50 MHz board clk to 25 MHz pixel_clk (ratio = 2)
--              Hardcoded divide by 2

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_div is
    port (
        clk       : in  std_logic;
        rst       : in std_logic;
        pixel_clk : out std_logic
    );
end clk_div;

architecture bhv of clk_div is
    signal 
    pix_ff : std_logic := '0';
begin
    process(clk, rst)
    begin
        if rst = '1' then
            pix_ff <= '0';
        elsif rising_edge(clk) then
            pix_ff <= not pix_ff;   -- divide-by-2 clock
        end if;
    end process;

    pixel_clk <= pix_ff;

end bhv;

