-- file State.vhd
-- State easy model controller implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 30 Jun 2024
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Cleb.all;

entity State is
	port (
		reset: in std_logic;
		mclk: in std_logic;
		tkclk: in std_logic;

		getTixVClebState: out std_logic_vector(7 downto 0);

		commok: in std_logic;
		rgb: out std_logic_vector(23 downto 0)
	);
end State;

architecture Rtl of State is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	constant tixVClebStateNc: std_logic_vector(7 downto 0) := x"00";
	constant tixVClebStateReady: std_logic_vector(7 downto 0) := x"01";

	constant rgbWhite: std_logic_vector(23 downto 0) := x"555555";
	constant rgbRed: std_logic_vector(23 downto 0) := x"FF0000";
	constant rgbOrange: std_logic_vector(23 downto 0) := x"7F7F00";

	constant rgbGreen: std_logic_vector(23 downto 0) := x"00FF00";
	constant rgbGreenD1: std_logic_vector(23 downto 0) := x"00D000";
	constant rgbGreenD2: std_logic_vector(23 downto 0) := x"00A000";
	constant rgbGreenD3: std_logic_vector(23 downto 0) := x"007000";
	constant rgbGreenD4: std_logic_vector(23 downto 0) := x"004000";

	constant rgbBluegreen: std_logic_vector(23 downto 0) := x"007F7F";
	constant rgbBlue: std_logic_vector(23 downto 0) := x"0000FF";
	constant rgbPink: std_logic_vector(23 downto 0) := x"7F007F";

	---- RGB LED control (led)
	type stateLed_t is (
		stateLedRunA, stateLedRunB
	);
	signal stateLed: stateLed_t := stateLedRunA;

	constant sizeSeq: natural := 5;
	type seq_t is array (0 to sizeSeq-1) of std_logic_vector(23 downto 0);
	signal seq: seq_t;
	signal ixSeq: natural range 0 to sizeSeq-1;

	-- IP sigs.led.cust --- INSERT

	---- main operation (op)

	-- IP sigs.op.cust --- INSERT

	---- other
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	-- implementation: RGB LED control (led)
	------------------------------------------------------------------------

	-- IP impl.led.wiring --- RBEGIN
	rgb <= seq(ixSeq);
	-- IP impl.led.wiring --- REND

	-- IP impl.led.rising --- BEGIN
	process (reset, mclk, stateLed)
		-- IP impl.led.vars --- RBEGIN
		variable rgb_lcl: std_logic_vector(23 downto 0);

		constant imax: natural := 2000; -- 200ms slice time
		variable i: natural range 0 to imax;
		-- IP impl.led.vars --- REND

	begin
		if reset='1' then
			-- IP impl.led.asyncrst --- RBEGIN
			stateLed <= stateLedRunA;
			seq <= (others => (others => '0'));
			ixSeq <= 0;

			rgb_lcl := (others => '0');
			i := 0;
			-- IP impl.led.asyncrst --- REND

		elsif rising_edge(mclk) then
			if stateLed=stateLedRunA then
				if tkclk='1' then
					-- IP impl.led.runA --- IBEGIN
					if i=imax then
						i := 0;

						if ixSeq=sizeSeq-1 then
							ixSeq <= 0;

							if commok='0' then
								seq <= (rgbRed, x"000000", x"000000", x"000000", x"000000");
							
							else
								seq(0) <= rgbGreenD4;
								seq(1) <= rgbGreenD3;
								seq(2) <= rgbGreenD2;
								seq(3) <= rgbGreenD1;
								seq(4) <= rgbGreen;
							end if;

						else
							ixSeq <= ixSeq + 1;
						end if;
					end if;
					-- IP impl.led.runA --- IEND

					stateLed <= stateLedRunB;
				end if;

			elsif stateLed=stateLedRunB then
				if tkclk='0' then
					i := i + 1; -- IP impl.led.runB --- ILINE

					stateLed <= stateLedRunA;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.led.rising --- END

	------------------------------------------------------------------------
	-- implementation: main operation (op)
	------------------------------------------------------------------------

	-- IP impl.op.wiring --- RBEGIN
	getTixVClebState <= tixVClebStateNc when commok='0'
				else tixVClebStateReady;
	-- IP impl.op.wiring --- REND

	-- IP impl.op.rising --- BEGIN
	process (reset, mclk)
		-- IP impl.op.vars --- BEGIN
		-- IP impl.op.vars --- END

	begin
		if reset='1' then
			-- IP impl.op.asyncrst --- BEGIN
			-- IP impl.op.asyncrst --- END

		elsif rising_edge(mclk) then
			-- IP impl.op --- INSERT
		end if;
	end process;
	-- IP impl.op.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end Rtl;
