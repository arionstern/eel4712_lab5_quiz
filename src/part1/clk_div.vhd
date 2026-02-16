-- Name: 
-- Section #:
-- PI Name: 
-- Description:

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


end bhv;