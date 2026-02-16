-- Name: 
-- Section #:
-- PI Name: 
-- Description:

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity col_addr_gen is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        Vcount     : in  std_logic_vector(9 downto 0);
        Col_Addr   : out std_logic_vector(5 downto 0)
    );
end col_addr_gen;

architecture bhv of col_addr_gen is

end bhv;