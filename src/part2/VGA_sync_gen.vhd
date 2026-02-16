-- Name: 
-- Section #:
-- PI Name: 
-- Description:

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity VGA_sync_gen is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        Hcount     : out std_logic_vector(9 downto 0);
        Vcount     : out std_logic_vector(9 downto 0);
        Horiz_Sync : out std_logic;
        Vert_Sync  : out std_logic;
        Video_On   : out std_logic
    );
end VGA_sync_gen;

architecture bhv of VGA_sync_gen is

end bhv;