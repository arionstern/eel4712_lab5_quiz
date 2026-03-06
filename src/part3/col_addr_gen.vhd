-- Name: Arion Stern
-- Section #: 10972
-- PI Name: Newman Waters
-- Description: Generates a col address to be used in the ROM address logic. Also outputs a col enable to be used in ROM enable logic.
-- Col address of img is determined by the relative position using the buttons and Vcount. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity col_addr_gen is
    port (
        Hcount   : in  std_logic_vector(9 downto 0);
        pos      : in  std_logic_vector(2 downto 0);  -- 0..4
        Col_Addr : out std_logic_vector(6 downto 0);
        Col_En   : out std_logic
    );
end col_addr_gen;

architecture bhv of col_addr_gen is
    --define signals
begin
    process(Hcount, pos)
        variable h_unsigned : unsigned(9 downto 0);
        variable x0     : integer;
        variable x1     : integer;
        variable rel_x    : unsigned(9 downto 0);
        variable col_unsigned : unsigned(6 downto 0);
    begin
        h_unsigned := unsigned(Hcount);

        --default
        x0 := 0;
        x1 := -1; --invalid
        Col_En <= '0';
        Col_Addr <= (others => '0');

        --x window based on pos
        case pos is 
            when "000" => 
                x0 := CENTERED_X_START;
                x1 := CENTERED_X_END;
            when "001" =>
                x0 := TOP_LEFT_X_START;
                x1 := TOP_LEFT_X_END;
            when "010" =>
                x0 := TOP_RIGHT_X_START;
                x1 := TOP_RIGHT_X_END;
            when "011" =>
                x0 := BOTTOM_LEFT_X_START;
                x1 := BOTTOM_LEFT_X_END;
            when "100" =>
                x0 := BOTTOM_RIGHT_X_START;
                x1 := BOTTOM_RIGHT_X_END;
            when others =>
                x0 := 0;
                x1 := -1;
        end case;

    -- inside the image horizontally?
        if (x1 >= 0) then
            if ((h_unsigned >= to_unsigned(x0, 10)) AND(h_unsigned <= to_unsigned(x1,10))) then
                Col_En <= '1';

                -- rel = Hcount - x0, range 0..127
                rel_x := h_unsigned - to_unsigned(x0, 10);

                -- each block is 2 pixels wide => divide by 2
                -- col_unsigned := resize(shift_right(rel_x, 1), 6);
                col_unsigned := resize(rel_x, 7);

                Col_Addr <= std_logic_vector(col_unsigned);
            end if;
        end if;
    end process;

end bhv;