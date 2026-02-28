-- Name: Arion Stern
-- Section #: 10972
-- PI Name: Newman Waters
-- Description: TB for col_addr_gen. Sweeps Hcount 0..H_MAX.
--              Cycles through all positions once and then ends.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity col_addr_gen_tb is
end col_addr_gen_tb;

architecture TB of col_addr_gen_tb is

    signal Hcount   : std_logic_vector(9 downto 0) := (others => '0');
    signal pos      : std_logic_vector(2 downto 0) := "000";
    signal Col_Addr : std_logic_vector(5 downto 0);
    signal Col_En   : std_logic;

begin

    DUT : entity work.col_addr_gen
        port map (
            Hcount   => Hcount,
            pos      => pos,
            Col_Addr => Col_Addr,
            Col_En   => Col_En
        );

    process
        variable h : integer;
    begin

        -- loop through all 5 positions
        for p in 0 to 4 loop

            pos <= std_logic_vector(to_unsigned(p, 3));

            -- one full horizontal sweep
            for h in 0 to H_MAX loop
                Hcount <= std_logic_vector(to_unsigned(h, 10));
                wait for 20 ns;
            end loop;

        end loop;

        report "All position combinations tested." severity note;
        wait;  -- stop simulation

    end process;

end TB;