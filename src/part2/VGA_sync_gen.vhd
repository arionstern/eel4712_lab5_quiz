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

    --define signals
    signal pixel_clk : std_logic;
    signal hcount_reg, vcount_reg : unsigned(9 downto 0);
begin


    --clk_div
    U_DIV : entity work.clk_div
    port map (
      clk  => clk,
      rst     => rst,
      pixel_clk => pixel_clk
    );

    --Hcount
--    Continually counts up to the horizontal period (H_MAX – See vga_lib.vhd) and then starts over at 0, using the 25 MHz pixel clock.
--    A value of zero on Hcount corresponds to the beginning of section D in Figure 1.

    --Vcount
    -- Counts up to the vertical period (V_MAX -- See vga_lib.vhd). 
    -- It will increment at a particular point in the horizontal counters count
    -- (Hcount = H_VERT_INC – See vga_lib.vhd).

    --counter/sequential process
    process(pixel_clk, rst)
    begin

        if (rst = '1') then 
            hcount_reg <= (others => '0');
            vcount_reg <= (others => '0');

        elsif(rising_edge(pixel_clk)) then

            if(hcount_reg =  to_unsigned(H_MAX, 10)) then
                hcount_reg <= (others => '0');
            else 
                hcount_reg <= hcount_reg + 1;
            end if;


            if(hcount_reg = to_unsigned(H_VERT_INC, 10)) then

                if(vcount_reg =  to_unsigned(V_MAX, 10)) then
                vcount_reg <= (others => '0');
                else
                    vcount_reg <= vcount_reg + 1;
                end if;
            end if;

        end if;
    end process;

Hcount <= std_logic_vector(hcount_reg);
Vcount <= std_logic_vector(vcount_reg);






-- A value of zero on Vcount corresponds to the beginning of section R in Figure 2.
-- The values of Video_On, Horiz_Sync and Vert_Sync are determined by decoding the values
--  of Hcount and Vcount and comparing the counter values to the constants provided in vga_lib.vhd.

--combinational process
process(hcount_reg, vcount_reg)
begin

    --default values
    Video_On   <= '0';
    Horiz_Sync <= '1';
    Vert_Sync  <= '1'; 


    if((hcount_reg <= to_unsigned(H_DISPLAY_END, 10)) AND (vcount_reg <= to_unsigned(V_DISPLAY_END, 10))) then
        Video_On <= '1';
    end if;
    
    if((to_unsigned(HSYNC_BEGIN, 10) <= hcount_reg) AND (hcount_reg <= to_unsigned(HSYNC_END, 10))) then
        Horiz_Sync <= '0';
    end if;
   
    if((to_unsigned(VSYNC_BEGIN, 10) <= vcount_reg) AND (vcount_reg <= to_unsigned(VSYNC_END, 10))) then
        Vert_Sync <= '0';
    end if;

end process; 



end bhv;