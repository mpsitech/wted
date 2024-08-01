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
use work.Tidk.all;

entity State is
	port (
		reset: in std_logic;
		mclk: in std_logic;
		tkclk: in std_logic;

		getTixVTidkState: out std_logic_vector(7 downto 0);

		commok: in std_logic;
		trafgenRng: in std_logic;
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

	constant tixVTidkStateNc: std_logic_vector(7 downto 0) := x"00";
	constant tixVTidkStateReady: std_logic_vector(7 downto 0) := x"01";
	constant tixVTidkStateActive: std_logic_vector(7 downto 0) := x"02";

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
	type stateOp_t is (
		stateOpRunA, stateOpRunB
	);
	signal stateOp: stateOp_t := stateOpRunA;

	signal trafgenRng_capt: std_logic;

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

	-- IP impl.led.wiring --- BEGIN
	-- IP impl.led.wiring --- END

	-- IP impl.led.rising --- BEGIN
	process (reset, mclk, stateLed)
		-- IP impl.led.vars --- BEGIN
		-- IP impl.led.vars --- END

	begin
		if reset='1' then
			-- IP impl.led.asyncrst --- BEGIN
			stateLed <= stateLedRunA;
			ixSeq <= 0;

			-- IP impl.led.asyncrst --- END

		elsif rising_edge(mclk) then
			if stateLed=stateLedRunA then
				if tkclk='1' then
					-- IP impl.led.runA --- INSERT

					stateLed <= stateLedRunB;
				end if;

			elsif stateLed=stateLedRunB then
				if tkclk='0' then
					-- IP impl.led.runB --- INSERT

					stateLed <= stateLedRunA;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.led.rising --- END

	------------------------------------------------------------------------
	-- implementation: main operation (op)
	------------------------------------------------------------------------

	-- IP impl.op.wiring --- BEGIN
	-- IP impl.op.wiring --- END

	-- IP impl.op.rising --- BEGIN
	process (reset, mclk, stateOp)
		-- IP impl.op.vars --- BEGIN
		-- IP impl.op.vars --- END

	begin
		if reset='1' then
			-- IP impl.op.asyncrst --- BEGIN
			stateOp <= stateOpRunA;
			trafgenRng_capt <= '0';

			-- IP impl.op.asyncrst --- END

		elsif rising_edge(mclk) then
		-- IP impl.op.ext --- INSERT

			if stateOp=stateOpRunA then
				if tkclk='1' then
					-- IP impl.op.runA --- INSERT

					stateOp <= stateOpRunB;
				end if;

			elsif stateOp=stateOpRunB then
				if tkclk='0' then
					-- IP impl.op.runB --- INSERT

					stateOp <= stateOpRunA;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.op.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end Rtl;
