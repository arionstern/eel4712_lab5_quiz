-- Name: 
-- Section #:
-- PI Name: 
-- Description:

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity row_addr_gen is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        Vcount     : in  std_logic_vector(9 downto 0);
        Row_Addr   : out std_logic_vector(5 downto 0)
    );
end row_addr_gen;

architecture bhv of row_addr_gen is

    --define signals
begin

--seq process
process(clk, rst)
    if(rst = '1') then
        
    elsif(rising_edge(clk)) then

    end if



end bhv;