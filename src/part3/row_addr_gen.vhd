-- Name: Arion Stern
-- Section #: 10972
-- PI Name: Newman Waters
-- Description: Generates a row address to be used in the ROM address logic. Also outputs a row enable to be used in ROM enable logic.
-- Row address of img is determined by the relative position using the buttons and Vcount. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vga_lib.all;

entity row_addr_gen is
    port (
        Vcount   : in  std_logic_vector(9 downto 0);
        pos      : in  std_logic_vector(2 downto 0);  -- 0..4
        Row_Addr : out std_logic_vector(5 downto 0);
        Row_En   : out std_logic
    );
end row_addr_gen;

architecture bhv of row_addr_gen is

    --define signals
begin
    process(Vcount, pos)
        variable v_unsigned : unsigned(9 downto 0);
        variable y0     : integer;
        variable y1     : integer;
        variable rel_y    : unsigned(9 downto 0);
        variable row_unsigned : unsigned(5 downto 0);
    begin
        v_unsigned := unsigned(Vcount);

        --default
        y0 := 0;
        y1 := -1; --invalid
        Row_En <= '0';
        Row_Addr <= (others => '0');

        --y window based on pos
        case pos is 
            when "000" => 
                y0 := CENTERED_Y_START;
                y1 := CENTERED_Y_END;
            when "001" =>
                y0 := TOP_LEFT_Y_START;
                y1 := TOP_LEFT_Y_END;
            when "010" =>
                y0 := TOP_RIGHT_Y_START;
                y1 := TOP_RIGHT_Y_END;
            when "011" =>
                y0 := BOTTOM_LEFT_Y_START;
                y1 := BOTTOM_LEFT_Y_END;
            when "100" =>
                y0 := BOTTOM_RIGHT_Y_START;
                y1 := BOTTOM_RIGHT_Y_END;
            when others =>
                y0 := 0;
                y1 := -1;
        end case;

    -- inside the image vertically?
        if (y1 >= 0) then
            if ((v_unsigned >= to_unsigned(y0, 10)) AND(v_unsigned <= to_unsigned(y1,10))) then
                Row_En <= '1';

                -- rel = Vcount - y0, range 0..127
                rel_y := v_unsigned - to_unsigned(y0, 10);

                -- each block is 2 pixels tall => divide by 2
                row_unsigned := resize(shift_right(rel_y, 1), 6);
                Row_Addr <= std_logic_vector(row_unsigned);
            end if;
        end if;
    end process;



end bhv;