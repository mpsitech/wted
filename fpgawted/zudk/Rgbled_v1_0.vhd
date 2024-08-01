-- file Rgbled_v1_0.vhd
-- Rgbled_v1_0 module implementation
-- copyright: (C) 2022 MPSI Technologies GmbH
-- author: Alexander Wirthmueller
-- date created: 25 Dec 2022
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Rgbled_v1_0 is
	generic (
		fMclk: natural := 50000 -- in kHz
	);
	port (
		reset: in std_logic;

		mclk: in std_logic;

		rgb: in std_logic_vector(23 downto 0);

		r: out std_logic;
		g: out std_logic;
		b: out std_logic
	);
end Rgbled_v1_0;

architecture Rtl of Rgbled_v1_0 is

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- blue LED PWM (blue)
	type stateBlue_t is (
		stateBlueOff,
		stateBlueOn
	);
	signal stateBlue: stateBlue_t := stateBlueOff;

	---- green LED PWM (green)
	type stateGreen_t is (
		stateGreenOff,
		stateGreenOn
	);
	signal stateGreen: stateGreen_t := stateGreenOff;

	---- red LED PWM (red)
	type stateRed_t is (
		stateRedOff,
		stateRedOn
	);
	signal stateRed: stateRed_t := stateRedOff;

begin

	------------------------------------------------------------------------
	-- implementation: blue LED PWM (blue)
	------------------------------------------------------------------------

	b <= '1' when stateBlue=stateBlueOn else '0';

	process (reset, mclk, stateBlue)
		variable i: natural range 0 to 256;
		
		constant jmax: natural := fMclk/50; -- 50kHz base clock resulting in 195Hz PWM clock
		variable j: natural range 0 to jmax;

	begin
		if reset='1' then
			stateBlue <= stateBlueOff;
			
			i := 0;
			j := 0;

		elsif rising_edge(mclk) then
			j := j + 1;
			
			if j=jmax then
				j := 0;
				i := i + 1;
			end if;

			if stateBlue=stateBlueOff then
				if j=0 then
					if i=256 then
						i := 0;

						if rgb(7 downto 0)/=x"00" then
							stateBlue <= stateBlueOn;
						end if;
					end if;
				end if;

			elsif stateBlue=stateBlueOn then
				if j=0 then
					if i=256 then
						i := 0;
					elsif i >= to_integer(unsigned(rgb(7 downto 0))) then
						stateBlue <= stateBlueOff;
					end if;
				end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: green LED PWM (green)
	------------------------------------------------------------------------

	g <= '1' when stateGreen=stateGreenOn else '0';

	process (reset, mclk, stateGreen)
		variable i: natural range 0 to 256;
		
		constant jmax: natural := fMclk/50;
		variable j: natural range 0 to jmax;

	begin
		if reset='1' then
			stateGreen <= stateGreenOff;
			
			i := 0;
			j := 0;

		elsif rising_edge(mclk) then
			j := j + 1;
			
			if j=jmax then
				j := 0;
				i := i + 1;
			end if;

			if stateGreen=stateGreenOff then
				if j=0 then
					if i=256 then
						i := 0;

						if rgb(15 downto 8)/=x"00" then
							stateGreen <= stateGreenOn;
						end if;
					end if;
				end if;

			elsif stateGreen=stateGreenOn then
				if j=0 then
					if i=256 then
						i := 0;
					elsif i >= to_integer(unsigned(rgb(15 downto 8))) then
						stateGreen <= stateGreenOff;
					end if;
				end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: red LED PWM (red)
	------------------------------------------------------------------------

	r <= '1' when stateRed=stateRedOn else '0';

	process (reset, mclk, stateRed)
		variable i: natural range 0 to 256;
		
		constant jmax: natural := fMclk/50;
		variable j: natural range 0 to jmax;

	begin
		if reset='1' then
			stateRed <= stateRedOff;
			
			i := 0;
			j := 0;

		elsif rising_edge(mclk) then
			j := j + 1;
			
			if j=jmax then
				j := 0;
				i := i + 1;
			end if;

			if stateRed=stateRedOff then
				if j=0 then
					if i=256 then
						i := 0;

						if rgb(23 downto 16)/=x"00" then
							stateRed <= stateRedOn;
						end if;
					end if;
				end if;

			elsif stateRed=stateRedOn then
				if j=0 then
					if i=256 then
						i := 0;
					elsif i >= to_integer(unsigned(rgb(23 downto 16))) then
						stateRed <= stateRedOff;
					end if;
				end if;
			end if;
		end if;
	end process;

end Rtl;
