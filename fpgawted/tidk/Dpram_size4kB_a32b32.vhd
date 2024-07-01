-- file Dpram_size4kB_a32b32.vhd
-- Dpram_size4kB_a32b32 dpram_efnx_v1_0 implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 30 Jun 2024
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library efxphysicallib;
use efxphysicallib.efxcomponents.all;

use work.Dbecore.all;
use work.Tidk.all;

entity Dpram_size4kB_a32b32 is
	port (
		resetA: in std_logic;
		clkA: in std_logic;

		enA: in std_logic;
		weA: in std_logic;

		aA: in std_logic_vector(9 downto 0);
		drdA: out std_logic_vector(31 downto 0);
		dwrA: in std_logic_vector(31 downto 0);

		resetB: in std_logic;
		clkB: in std_logic;

		enB: in std_logic;
		weB: in std_logic;

		aB: in std_logic_vector(9 downto 0);
		drdB: out std_logic_vector(31 downto 0);
		dwrB: in std_logic_vector(31 downto 0)
	);
end Dpram_size4kB_a32b32;

architecture Rtl of Dpram_size4kB_a32b32 is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- A-side multiplexing (muxA)

	signal enAm1: std_logic;
	signal aAm1: std_logic_vector(9 downto 0);

	signal enA_i0: std_logic;
	signal enA_i0m1: std_logic;

	-- IP sigs.muxA.cust --- INSERT

	---- B-side multiplexing (muxB)

	signal enBm1: std_logic;
	signal aBm1: std_logic_vector(9 downto 0);

	signal enB_k0: std_logic;
	signal enB_k0m1: std_logic;

	-- IP sigs.muxB.cust --- INSERT

	---- myRam_i0j0k0l0
	signal drdA_i0j0: std_logic_vector(7 downto 0);
	signal drdB_k0l0: std_logic_vector(7 downto 0);

	---- myRam_i0j1k0l1
	signal drdA_i0j1: std_logic_vector(7 downto 0);
	signal drdB_k0l1: std_logic_vector(7 downto 0);

	---- myRam_i0j2k0l2
	signal drdA_i0j2: std_logic_vector(7 downto 0);
	signal drdB_k0l2: std_logic_vector(7 downto 0);

	---- myRam_i0j3k0l3
	signal drdA_i0j3: std_logic_vector(7 downto 0);
	signal drdB_k0l3: std_logic_vector(7 downto 0);

	---- other
	signal drdA_i0: std_logic_vector(31 downto 0);

	signal drdB_k0: std_logic_vector(31 downto 0);
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myRam_i0j0k0l0 : EFX_DPRAM10
		generic map (
			READ_WIDTH_A => 8,
			WRITE_WIDTH_A => 8,
			READ_WIDTH_B => 8,
			WRITE_WIDTH_B => 8,

			RSTA_POLARITY => 1,
			CLKA_POLARITY => 1,
			CLKEA_POLARITY => 1,
			WEA_POLARITY => 1,
			ADDRENA_POLARITY => 1,
			RSTB_POLARITY => 1,
			CLKB_POLARITY => 1,
			CLKEB_POLARITY => 1,
			WEB_POLARITY => 1,
			ADDRENB_POLARITY => 1,

			WRITE_MODE_A => "READ_FIRST",
			RESET_RAM_A => "ASYNC",
			RESET_OUTREG_A => "ASYNC",
			WRITE_MODE_B => "READ_FIRST",
			RESET_RAM_B => "ASYNC",
			RESET_OUTREG_B => "ASYNC",

			INIT_0 => (others => '0'),
			INIT_1 => (others => '0'),
			INIT_2 => (others => '0'),
			INIT_3 => (others => '0'),
			INIT_4 => (others => '0'),
			INIT_5 => (others => '0'),
			INIT_6 => (others => '0'),
			INIT_7 => (others => '0'),
			INIT_8 => (others => '0'),
			INIT_9 => (others => '0'),
			INIT_A => (others => '0'),
			INIT_B => (others => '0'),
			INIT_C => (others => '0'),
			INIT_D => (others => '0'),
			INIT_E => (others => '0'),
			INIT_F => (others => '0'),
			INIT_10 => (others => '0'),
			INIT_11 => (others => '0'),
			INIT_12 => (others => '0'),
			INIT_13 => (others => '0'),
			INIT_14 => (others => '0'),
			INIT_15 => (others => '0'),
			INIT_16 => (others => '0'),
			INIT_17 => (others => '0'),
			INIT_18 => (others => '0'),
			INIT_19 => (others => '0'),
			INIT_1A => (others => '0'),
			INIT_1B => (others => '0'),
			INIT_1C => (others => '0'),
			INIT_1D => (others => '0'),
			INIT_1E => (others => '0'),
			INIT_1F => (others => '0'),
			INIT_20 => (others => '0'),
			INIT_21 => (others => '0'),
			INIT_22 => (others => '0'),
			INIT_23 => (others => '0'),
			INIT_24 => (others => '0'),
			INIT_25 => (others => '0'),
			INIT_26 => (others => '0'),
			INIT_27 => (others => '0')
		)
		port map (
			RSTA => resetA,

			CLKA => clkA,
			CLKEA => '1',

			WEA => enA_i0,

			ADDRA => aA(9 downto 0),
			ADDRENA => '1',

			WDATAA => dwrA(7 downto 0),
			RDATAA => drdA_i0j0,

			RSTB => resetB,

			CLKB => clkB,
			CLKEB => '1',

			WEB => enB_k0,

			ADDRB => aB(9 downto 0),
			ADDRENB => '1',

			WDATAB => dwrB(7 downto 0),
			RDATAB => drdB_k0l0
		);

	myRam_i0j1k0l1 : EFX_DPRAM10
		generic map (
			READ_WIDTH_A => 8,
			WRITE_WIDTH_A => 8,
			READ_WIDTH_B => 8,
			WRITE_WIDTH_B => 8,

			RSTA_POLARITY => 1,
			CLKA_POLARITY => 1,
			CLKEA_POLARITY => 1,
			WEA_POLARITY => 1,
			ADDRENA_POLARITY => 1,
			RSTB_POLARITY => 1,
			CLKB_POLARITY => 1,
			CLKEB_POLARITY => 1,
			WEB_POLARITY => 1,
			ADDRENB_POLARITY => 1,

			WRITE_MODE_A => "READ_FIRST",
			RESET_RAM_A => "ASYNC",
			RESET_OUTREG_A => "ASYNC",
			WRITE_MODE_B => "READ_FIRST",
			RESET_RAM_B => "ASYNC",
			RESET_OUTREG_B => "ASYNC",

			INIT_0 => (others => '0'),
			INIT_1 => (others => '0'),
			INIT_2 => (others => '0'),
			INIT_3 => (others => '0'),
			INIT_4 => (others => '0'),
			INIT_5 => (others => '0'),
			INIT_6 => (others => '0'),
			INIT_7 => (others => '0'),
			INIT_8 => (others => '0'),
			INIT_9 => (others => '0'),
			INIT_A => (others => '0'),
			INIT_B => (others => '0'),
			INIT_C => (others => '0'),
			INIT_D => (others => '0'),
			INIT_E => (others => '0'),
			INIT_F => (others => '0'),
			INIT_10 => (others => '0'),
			INIT_11 => (others => '0'),
			INIT_12 => (others => '0'),
			INIT_13 => (others => '0'),
			INIT_14 => (others => '0'),
			INIT_15 => (others => '0'),
			INIT_16 => (others => '0'),
			INIT_17 => (others => '0'),
			INIT_18 => (others => '0'),
			INIT_19 => (others => '0'),
			INIT_1A => (others => '0'),
			INIT_1B => (others => '0'),
			INIT_1C => (others => '0'),
			INIT_1D => (others => '0'),
			INIT_1E => (others => '0'),
			INIT_1F => (others => '0'),
			INIT_20 => (others => '0'),
			INIT_21 => (others => '0'),
			INIT_22 => (others => '0'),
			INIT_23 => (others => '0'),
			INIT_24 => (others => '0'),
			INIT_25 => (others => '0'),
			INIT_26 => (others => '0'),
			INIT_27 => (others => '0')
		)
		port map (
			RSTA => resetA,

			CLKA => clkA,
			CLKEA => '1',

			WEA => enA_i0,

			ADDRA => aA(9 downto 0),
			ADDRENA => '1',

			WDATAA => dwrA(15 downto 8),
			RDATAA => drdA_i0j1,

			RSTB => resetB,

			CLKB => clkB,
			CLKEB => '1',

			WEB => enB_k0,

			ADDRB => aB(9 downto 0),
			ADDRENB => '1',

			WDATAB => dwrB(15 downto 8),
			RDATAB => drdB_k0l1
		);

	myRam_i0j2k0l2 : EFX_DPRAM10
		generic map (
			READ_WIDTH_A => 8,
			WRITE_WIDTH_A => 8,
			READ_WIDTH_B => 8,
			WRITE_WIDTH_B => 8,

			RSTA_POLARITY => 1,
			CLKA_POLARITY => 1,
			CLKEA_POLARITY => 1,
			WEA_POLARITY => 1,
			ADDRENA_POLARITY => 1,
			RSTB_POLARITY => 1,
			CLKB_POLARITY => 1,
			CLKEB_POLARITY => 1,
			WEB_POLARITY => 1,
			ADDRENB_POLARITY => 1,

			WRITE_MODE_A => "READ_FIRST",
			RESET_RAM_A => "ASYNC",
			RESET_OUTREG_A => "ASYNC",
			WRITE_MODE_B => "READ_FIRST",
			RESET_RAM_B => "ASYNC",
			RESET_OUTREG_B => "ASYNC",

			INIT_0 => (others => '0'),
			INIT_1 => (others => '0'),
			INIT_2 => (others => '0'),
			INIT_3 => (others => '0'),
			INIT_4 => (others => '0'),
			INIT_5 => (others => '0'),
			INIT_6 => (others => '0'),
			INIT_7 => (others => '0'),
			INIT_8 => (others => '0'),
			INIT_9 => (others => '0'),
			INIT_A => (others => '0'),
			INIT_B => (others => '0'),
			INIT_C => (others => '0'),
			INIT_D => (others => '0'),
			INIT_E => (others => '0'),
			INIT_F => (others => '0'),
			INIT_10 => (others => '0'),
			INIT_11 => (others => '0'),
			INIT_12 => (others => '0'),
			INIT_13 => (others => '0'),
			INIT_14 => (others => '0'),
			INIT_15 => (others => '0'),
			INIT_16 => (others => '0'),
			INIT_17 => (others => '0'),
			INIT_18 => (others => '0'),
			INIT_19 => (others => '0'),
			INIT_1A => (others => '0'),
			INIT_1B => (others => '0'),
			INIT_1C => (others => '0'),
			INIT_1D => (others => '0'),
			INIT_1E => (others => '0'),
			INIT_1F => (others => '0'),
			INIT_20 => (others => '0'),
			INIT_21 => (others => '0'),
			INIT_22 => (others => '0'),
			INIT_23 => (others => '0'),
			INIT_24 => (others => '0'),
			INIT_25 => (others => '0'),
			INIT_26 => (others => '0'),
			INIT_27 => (others => '0')
		)
		port map (
			RSTA => resetA,

			CLKA => clkA,
			CLKEA => '1',

			WEA => enA_i0,

			ADDRA => aA(9 downto 0),
			ADDRENA => '1',

			WDATAA => dwrA(23 downto 16),
			RDATAA => drdA_i0j2,

			RSTB => resetB,

			CLKB => clkB,
			CLKEB => '1',

			WEB => enB_k0,

			ADDRB => aB(9 downto 0),
			ADDRENB => '1',

			WDATAB => dwrB(23 downto 16),
			RDATAB => drdB_k0l2
		);

	myRam_i0j3k0l3 : EFX_DPRAM10
		generic map (
			READ_WIDTH_A => 8,
			WRITE_WIDTH_A => 8,
			READ_WIDTH_B => 8,
			WRITE_WIDTH_B => 8,

			RSTA_POLARITY => 1,
			CLKA_POLARITY => 1,
			CLKEA_POLARITY => 1,
			WEA_POLARITY => 1,
			ADDRENA_POLARITY => 1,
			RSTB_POLARITY => 1,
			CLKB_POLARITY => 1,
			CLKEB_POLARITY => 1,
			WEB_POLARITY => 1,
			ADDRENB_POLARITY => 1,

			WRITE_MODE_A => "READ_FIRST",
			RESET_RAM_A => "ASYNC",
			RESET_OUTREG_A => "ASYNC",
			WRITE_MODE_B => "READ_FIRST",
			RESET_RAM_B => "ASYNC",
			RESET_OUTREG_B => "ASYNC",

			INIT_0 => (others => '0'),
			INIT_1 => (others => '0'),
			INIT_2 => (others => '0'),
			INIT_3 => (others => '0'),
			INIT_4 => (others => '0'),
			INIT_5 => (others => '0'),
			INIT_6 => (others => '0'),
			INIT_7 => (others => '0'),
			INIT_8 => (others => '0'),
			INIT_9 => (others => '0'),
			INIT_A => (others => '0'),
			INIT_B => (others => '0'),
			INIT_C => (others => '0'),
			INIT_D => (others => '0'),
			INIT_E => (others => '0'),
			INIT_F => (others => '0'),
			INIT_10 => (others => '0'),
			INIT_11 => (others => '0'),
			INIT_12 => (others => '0'),
			INIT_13 => (others => '0'),
			INIT_14 => (others => '0'),
			INIT_15 => (others => '0'),
			INIT_16 => (others => '0'),
			INIT_17 => (others => '0'),
			INIT_18 => (others => '0'),
			INIT_19 => (others => '0'),
			INIT_1A => (others => '0'),
			INIT_1B => (others => '0'),
			INIT_1C => (others => '0'),
			INIT_1D => (others => '0'),
			INIT_1E => (others => '0'),
			INIT_1F => (others => '0'),
			INIT_20 => (others => '0'),
			INIT_21 => (others => '0'),
			INIT_22 => (others => '0'),
			INIT_23 => (others => '0'),
			INIT_24 => (others => '0'),
			INIT_25 => (others => '0'),
			INIT_26 => (others => '0'),
			INIT_27 => (others => '0')
		)
		port map (
			RSTA => resetA,

			CLKA => clkA,
			CLKEA => '1',

			WEA => enA_i0,

			ADDRA => aA(9 downto 0),
			ADDRENA => '1',

			WDATAA => dwrA(31 downto 24),
			RDATAA => drdA_i0j3,

			RSTB => resetB,

			CLKB => clkB,
			CLKEB => '1',

			WEB => enB_k0,

			ADDRB => aB(9 downto 0),
			ADDRENB => '1',

			WDATAB => dwrB(31 downto 24),
			RDATAB => drdB_k0l3
		);

	------------------------------------------------------------------------
	-- implementation: A-side multiplexing (muxA)
	------------------------------------------------------------------------

	-- IP impl.muxA.wiring --- BEGIN
	enA_i0 <= '1' when (weA='1' and enA='1') else '0';
	enA_i0m1 <= '1' when (weA='1' and enAm1='1') else '0';
	-- IP impl.muxA.wiring --- END

	-- IP impl.muxA.rising --- BEGIN
	process (resetA, clkA)
		-- IP impl.muxA.vars --- BEGIN
		-- IP impl.muxA.vars --- END

	begin
		if resetA='1' then
			-- IP impl.muxA.asyncrst --- BEGIN
			enAm1 <= '0';
			aAm1 <= (others => '0');

			-- IP impl.muxA.asyncrst --- END

		elsif rising_edge(clkA) then
			enAm1 <= enA;
			aAm1 <= aA;
		end if;
	end process;
	-- IP impl.muxA.rising --- END

	------------------------------------------------------------------------
	-- implementation: B-side multiplexing (muxB)
	------------------------------------------------------------------------

	-- IP impl.muxB.wiring --- BEGIN
	enB_k0 <= '1' when (weB='1' and enB='1') else '0';
	enB_k0m1 <= '1' when (weB='1' and enBm1='1') else '0';
	-- IP impl.muxB.wiring --- END

	-- IP impl.muxB.rising --- BEGIN
	process (resetB, clkB)
		-- IP impl.muxB.vars --- BEGIN
		-- IP impl.muxB.vars --- END

	begin
		if resetB='1' then
			-- IP impl.muxB.asyncrst --- BEGIN
			enBm1 <= '0';
			aBm1 <= (others => '0');

			-- IP impl.muxB.asyncrst --- END

		elsif rising_edge(clkB) then
			enBm1 <= enB;
			aBm1 <= aB;
		end if;
	end process;
	-- IP impl.muxB.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	drdA_i0 <= drdA_i0j3 & drdA_i0j2 & drdA_i0j1 & drdA_i0j0;

	drdA <= drdA_i0 when enA_i0m1='1'
				else (others => '0');

	drdB_k0 <= drdB_k0l3 & drdB_k0l2 & drdB_k0l1 & drdB_k0l0;

	drdB <= drdB_k0 when enB_k0m1='1'
				else (others => '0');

end Rtl;
