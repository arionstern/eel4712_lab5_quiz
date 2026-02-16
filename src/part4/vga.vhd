-- Name: 
-- Section #:
-- PI Name: 
-- Description:

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity vga is 
port ( clk              : in  std_logic;
       rst              : in  std_logic;
       buttons_n        : in  std_logic_vector(3 downto 0);
       red, green, blue : out std_logic_vector(3 downto 0);
       h_sync, v_sync   : out std_logic);
end vga;

architecture str of vga is

end str;