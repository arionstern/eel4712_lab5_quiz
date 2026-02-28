-- Name: Arion Stern
-- Section #: 10972
-- PI Name: Newman Waters
-- Description: TB for row_addr_gen. Sweeps Vcount continuously 0..V_MAX.
--              Changes pos at a few known times so the wave looks like a real frame.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity row_addr_gen_tb is
end row_addr_gen_tb;

architecture TB of row_addr_gen_tb is

    signal Vcount   : std_logic_vector(9 downto 0) := (others => '0');
    signal pos      : std_logic_vector(2 downto 0) := "000"; -- start centered
    signal Row_Addr : std_logic_vector(5 downto 0);
    signal Row_En   : std_logic;

begin

    DUT : entity work.row_addr_gen
        port map (
            Vcount   => Vcount,
            pos      => pos,
            Row_Addr => Row_Addr,
            Row_En   => Row_En
        );

    -- "frame" sweep: Vcount 0..V_MAX over and over
    v_sweep : process
        variable v : integer := 0;
    begin
        v := 0;
        while true loop
            Vcount <= std_logic_vector(to_unsigned(v, 10));
            wait for 20 ns;  -- just a sim step (not a real pixel clock)
            if v = V_MAX then
                v := 0;
            else
                v := v + 1;
            end if;
        end loop;
    end process;

    -- change pos at known times (so you can see different windows)
    stim : process
    begin
        -- centered
        pos <= "000";
        wait for 12 us;

        -- top-left
        pos <= "001";
        wait for 12 us;

        -- top-right
        pos <= "010";
        wait for 12 us;

        -- bottom-left
        pos <= "011";
        wait for 12 us;

        -- bottom-right
        pos <= "100";
        wait for 12 us;

        wait;
    end process;

end TB;