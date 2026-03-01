-- Name: Arion Stern
-- Section #: 10972
-- PI Name: Newman Waters
-- Description: test bench for the sync gen entity to verify the timing of Horiz_Sync, Vert_Sync, and Video_ON

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity VGA_sync_gen_tb is
end VGA_sync_gen_tb;

architecture TB of VGA_sync_gen_tb is

    signal clk : std_logic := '0';
    signal rst : std_logic := '1';

    signal Hcount     : std_logic_vector(9 downto 0);
    signal Vcount     : std_logic_vector(9 downto 0);
    signal Horiz_Sync : std_logic;
    signal Vert_Sync  : std_logic;
    signal Video_On   : std_logic;

begin

    -- 50 MHz input clock
    clk <= not clk after 10 ns;

    DUT : entity work.VGA_sync_gen
        port map (
            clk        => clk,
            rst        => rst,
            Hcount     => Hcount,
            Vcount     => Vcount,
            Horiz_Sync => Horiz_Sync,
            Vert_Sync  => Vert_Sync,
            Video_On   => Video_On
        );

    stimulus : process
        variable t_start : time;
        variable t_stop  : time;
        variable t_width : time;
    begin
        -- reset
        rst <= '1';
        wait for 200 ns;
        rst <= '0';

        -- quick run to see hsync/hcount/video_on
        wait for 200 us;

        -- measure vsync low time
        wait until falling_edge(Vert_Sync);
        t_start := now;

        wait until rising_edge(Vert_Sync);
        t_stop := now;

        t_width := t_stop - t_start;
        report "VSYNC low width = " & time'image(t_width);

        -- let a full frame happen
        wait for 20 ms;

        wait;
    end process;

end TB;