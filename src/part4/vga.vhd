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
       sw        : in  std_logic_vector(2 downto 0);
       red, green, blue : out std_logic_vector(3 downto 0);
       h_sync, v_sync   : out std_logic);
end vga;

architecture str of vga is

--define signals 
signal Horiz_Sync, Vert_Sync, Video_On, Col_En, Row_En, wren : std_logic;
signal Hcount, Vcount       : std_logic_vector(9 downto 0);
-- signal pos    :      std_logic_vector(2 downto 0);
signal Row_Addr, Col_Addr      : std_logic_vector(5 downto 0);
signal rom_address, data, rom_q : STD_LOGIC_VECTOR (11 DOWNTO 0);


begin

       --define components
       --VGA SYNC GEN
       U_vga_sync_gen : entity work.VGA_sync_gen
        port map (
            clk        => clk,
            rst        => rst,
            Hcount     => Hcount,
            Vcount     => Vcount,
            Horiz_Sync => h_sync,
            Vert_Sync  => v_sync,
            Video_On   => Video_On
        );

       --COL GEN
       U_col_addr_gen : entity work.col_addr_gen
        port map (
            Hcount   => Hcount,
            pos      => sw,
            Col_Addr => Col_Addr,
            Col_En   => Col_En
        );

       --ROW GEN
       U_row_addr_gen : entity work.row_addr_gen
        port map (
            Vcount   => Vcount,
            pos      => sw,
            Row_Addr => Row_Addr,
            Row_En   => Row_En
        );

       
       --ROM
       U_ROM  : entity work.vga_rom
        port map(
              address => rom_address,
              clock => clk,
              data => (others => '0'), --read only 
              wren => '0', --read only
              q =>  rom_q    
              );

       --ROM ADDRESS LOGIC
       --address = rowaddr * width(=64) + coladdr
       -- multiplying by 64 (2^6) is the same as shifting left by 6, addr = (rowaddr << 6) + coladdr 
       -- 6 msb = row addr and 6 lsb = col addr in 12 bit address addr = rowaddr concatenated wiht coladdr
       -- address <= row_addr & col_addr 
       --adding different versions of logic below in case i want to reuse code for different sized images
       -- rom_address <= std_logic_vector(resize(unsigned(row_addr) * to_unsigned(64, 7), 12)  + resize(unsigned(col_addr), 12)); -- did not test if this is right
       --rom_address <= std_logic_vector(shift_left(resize(unsigned(Row_Addr), 12), 6) +resize(unsigned(Col_Addr), 12));
       rom_address <= Row_Addr & Col_Addr;

       --RGB LOGIC: q is 12 bit vector (11-8 = r,7-4 = g, 3-0 = b)
       --turn on if in image and video on is true 
       --else send black
       process(video_on, Row_En, Col_En, rom_q)
       begin
              if((video_on = '1') and (Row_En = '1') and (Col_En = '1')) then
                     red <= rom_q(11 downto 8);
                     green <= rom_q(7 downto 4);
                     blue <= rom_q(3 downto 0);
              else
                     red <= (others => '0');
                     green <= (others => '0');
                     blue <= (others => '0');

              end if;
       end process;






end str;