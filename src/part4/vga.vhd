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

--define signals 
signal Horiz_Sync, Vert_Sync, Video_On, Col_En, Row_En : std_logic;
signal Hcount, Vcount       : std_logic_vector(9 downto 0);
signal pos    :      std_logic_vector(2 downto 0);
signal Row_Addr, Col_Addr      : std_logic_vector(5 downt 0);


begin

       --define components
       U_vga_sync_gen : entity work.VGA_sync_gen
        port map (
            clk        => clk,
            rst        => rst,
            Hcount     => Hcount,
            Vcount     => Vcount,
            Horiz_Sync => Horiz_Sync,
            Vert_Sync  => Vert_Sync,
            Video_On   => Video_On
        );


       U_col_addr_gen : entity work.col_addr_gen
        port map (
            Hcount   => Hcount,
            pos      => pos,
            Col_Addr => Col_Addr,
            Col_En   => Col_En
        );


       U_row_addr_gen : entity work.row_addr_gen
        port map (
            Vcount   => Vcount,
            pos      => pos,
            Row_Addr => Row_Addr,
            Row_En   => Row_En
        );


        

end str;