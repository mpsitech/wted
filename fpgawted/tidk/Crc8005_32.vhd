-- file Crc8005_32.vhd
-- Crc8005_32 crcspec_v3_0 implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 30 Jun 2024
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Crc8005_32 is
	port (
		reset: in std_logic;
		mclk: in std_logic;

		AXIS_tready: out std_logic;
		AXIS_tvalid: in std_logic;
		AXIS_tdata: in std_logic_vector(31 downto 0);
		AXIS_tkeep: in std_logic_vector(3 downto 0);
		AXIS_tlast: in std_logic;

		crc: out std_logic_vector(15 downto 0);
		validCrc: out std_logic
	);
end Crc8005_32;

architecture Rtl of Crc8005_32 is

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- main operation (op)
	type stateOp_t is (
		stateOpInit,
		stateOpCapt,
		stateOpDone
	);
	signal stateOp: stateOp_t := stateOpInit;

	signal crc_sig: std_logic_vector(15 downto 0);
	signal validCrc_sig: std_logic;

begin

	------------------------------------------------------------------------
	-- implementation: main operation (op)
	------------------------------------------------------------------------

	AXIS_tready <= '1' when stateOp=stateOpCapt or stateOp=stateOpDone else '0';

	crc <= crc_sig;
	validCrc <= validCrc_sig;
	
	process (reset, mclk, stateOp)
		variable first: boolean;

	begin
		if reset='1' then
			stateOp <= stateOpInit;

			crc_sig <= (others => '0');
			validCrc_sig <= '0';

			first := true;

		elsif rising_edge(mclk) then
			if stateOp=stateOpInit then
				crc_sig <= (others => '0');
				validCrc_sig <= '0';

				first := true;

				stateOp <= stateOpCapt;

			elsif stateOp=stateOpCapt then
				if AXIS_tvalid='1' and (first or validCrc_sig='1') then
					case AXIS_tkeep is
						when "1111" =>
							crc_sig(15) <= AXIS_tdata(7) xor AXIS_tdata(6) xor AXIS_tdata(5) xor AXIS_tdata(2) xor AXIS_tdata(1) xor AXIS_tdata(0) xor AXIS_tdata(15) xor AXIS_tdata(14) xor AXIS_tdata(13) xor AXIS_tdata(12) xor AXIS_tdata(11) xor AXIS_tdata(10) xor AXIS_tdata(9) xor AXIS_tdata(8) xor AXIS_tdata(23) xor AXIS_tdata(22) xor AXIS_tdata(20) xor AXIS_tdata(19) xor AXIS_tdata(18) xor AXIS_tdata(17) xor AXIS_tdata(16) xor AXIS_tdata(31) xor AXIS_tdata(30) xor AXIS_tdata(29) xor AXIS_tdata(28) xor AXIS_tdata(27) xor AXIS_tdata(26) xor AXIS_tdata(25) xor AXIS_tdata(24) xor crc_sig(0) xor crc_sig(1) xor crc_sig(2) xor crc_sig(3) xor crc_sig(4) xor crc_sig(5) xor crc_sig(6) xor crc_sig(7) xor crc_sig(8) xor crc_sig(9) xor crc_sig(10) xor crc_sig(13) xor crc_sig(14) xor crc_sig(15);
							crc_sig(14) <= AXIS_tdata(4) xor AXIS_tdata(2) xor AXIS_tdata(21) xor AXIS_tdata(20) xor crc_sig(10) xor crc_sig(12);
							crc_sig(13) <= AXIS_tdata(3) xor AXIS_tdata(1) xor AXIS_tdata(20) xor AXIS_tdata(19) xor crc_sig(9) xor crc_sig(11);
							crc_sig(12) <= AXIS_tdata(2) xor AXIS_tdata(0) xor AXIS_tdata(19) xor AXIS_tdata(18) xor crc_sig(8) xor crc_sig(10);
							crc_sig(11) <= AXIS_tdata(1) xor AXIS_tdata(15) xor AXIS_tdata(18) xor AXIS_tdata(17) xor crc_sig(7) xor crc_sig(9);
							crc_sig(10) <= AXIS_tdata(0) xor AXIS_tdata(14) xor AXIS_tdata(17) xor AXIS_tdata(16) xor crc_sig(6) xor crc_sig(8);
							crc_sig(9) <= AXIS_tdata(15) xor AXIS_tdata(13) xor AXIS_tdata(16) xor AXIS_tdata(31) xor crc_sig(5) xor crc_sig(7);
							crc_sig(8) <= AXIS_tdata(14) xor AXIS_tdata(12) xor AXIS_tdata(31) xor AXIS_tdata(30) xor crc_sig(4) xor crc_sig(6);
							crc_sig(7) <= AXIS_tdata(13) xor AXIS_tdata(11) xor AXIS_tdata(30) xor AXIS_tdata(29) xor crc_sig(3) xor crc_sig(5);
							crc_sig(6) <= AXIS_tdata(12) xor AXIS_tdata(10) xor AXIS_tdata(29) xor AXIS_tdata(28) xor crc_sig(2) xor crc_sig(4);
							crc_sig(5) <= AXIS_tdata(7) xor AXIS_tdata(11) xor AXIS_tdata(9) xor AXIS_tdata(28) xor AXIS_tdata(27) xor crc_sig(1) xor crc_sig(3) xor crc_sig(15);
							crc_sig(4) <= AXIS_tdata(7) xor AXIS_tdata(6) xor AXIS_tdata(10) xor AXIS_tdata(8) xor AXIS_tdata(27) xor AXIS_tdata(26) xor crc_sig(0) xor crc_sig(2) xor crc_sig(14) xor crc_sig(15);
							crc_sig(3) <= AXIS_tdata(7) xor AXIS_tdata(6) xor AXIS_tdata(5) xor AXIS_tdata(9) xor AXIS_tdata(23) xor AXIS_tdata(26) xor AXIS_tdata(25) xor crc_sig(1) xor crc_sig(13) xor crc_sig(14) xor crc_sig(15);
							crc_sig(2) <= AXIS_tdata(7) xor AXIS_tdata(6) xor AXIS_tdata(5) xor AXIS_tdata(4) xor AXIS_tdata(8) xor AXIS_tdata(22) xor AXIS_tdata(25) xor AXIS_tdata(24) xor crc_sig(0) xor crc_sig(12) xor crc_sig(13) xor crc_sig(14) xor crc_sig(15);
							crc_sig(1) <= AXIS_tdata(7) xor AXIS_tdata(4) xor AXIS_tdata(3) xor AXIS_tdata(2) xor AXIS_tdata(1) xor AXIS_tdata(0) xor AXIS_tdata(15) xor AXIS_tdata(14) xor AXIS_tdata(13) xor AXIS_tdata(12) xor AXIS_tdata(11) xor AXIS_tdata(10) xor AXIS_tdata(9) xor AXIS_tdata(8) xor AXIS_tdata(22) xor AXIS_tdata(21) xor AXIS_tdata(20) xor AXIS_tdata(19) xor AXIS_tdata(18) xor AXIS_tdata(17) xor AXIS_tdata(16) xor AXIS_tdata(31) xor AXIS_tdata(30) xor AXIS_tdata(29) xor AXIS_tdata(28) xor AXIS_tdata(27) xor AXIS_tdata(26) xor AXIS_tdata(25) xor crc_sig(0) xor crc_sig(1) xor crc_sig(2) xor crc_sig(3) xor crc_sig(4) xor crc_sig(5) xor crc_sig(6) xor crc_sig(7) xor crc_sig(8) xor crc_sig(9) xor crc_sig(10) xor crc_sig(11) xor crc_sig(12) xor crc_sig(15);
							crc_sig(0) <= AXIS_tdata(7) xor AXIS_tdata(6) xor AXIS_tdata(3) xor AXIS_tdata(2) xor AXIS_tdata(1) xor AXIS_tdata(0) xor AXIS_tdata(15) xor AXIS_tdata(14) xor AXIS_tdata(13) xor AXIS_tdata(12) xor AXIS_tdata(11) xor AXIS_tdata(10) xor AXIS_tdata(9) xor AXIS_tdata(8) xor AXIS_tdata(23) xor AXIS_tdata(21) xor AXIS_tdata(20) xor AXIS_tdata(19) xor AXIS_tdata(18) xor AXIS_tdata(17) xor AXIS_tdata(16) xor AXIS_tdata(31) xor AXIS_tdata(30) xor AXIS_tdata(29) xor AXIS_tdata(28) xor AXIS_tdata(27) xor AXIS_tdata(26) xor AXIS_tdata(25) xor AXIS_tdata(24) xor crc_sig(0) xor crc_sig(1) xor crc_sig(2) xor crc_sig(3) xor crc_sig(4) xor crc_sig(5) xor crc_sig(6) xor crc_sig(7) xor crc_sig(8) xor crc_sig(9) xor crc_sig(10) xor crc_sig(11) xor crc_sig(14) xor crc_sig(15);
							validCrc_sig <= '1';
						when "0111" =>
							crc_sig(15) <= AXIS_tdata(7) xor AXIS_tdata(6) xor AXIS_tdata(5) xor AXIS_tdata(4) xor AXIS_tdata(3) xor AXIS_tdata(2) xor AXIS_tdata(1) xor AXIS_tdata(0) xor AXIS_tdata(15) xor AXIS_tdata(14) xor AXIS_tdata(12) xor AXIS_tdata(11) xor AXIS_tdata(10) xor AXIS_tdata(9) xor AXIS_tdata(8) xor AXIS_tdata(23) xor AXIS_tdata(22) xor AXIS_tdata(21) xor AXIS_tdata(20) xor AXIS_tdata(19) xor AXIS_tdata(18) xor AXIS_tdata(17) xor AXIS_tdata(16) xor crc_sig(0) xor crc_sig(1) xor crc_sig(2) xor crc_sig(3) xor crc_sig(4) xor crc_sig(6) xor crc_sig(7) xor crc_sig(8) xor crc_sig(9) xor crc_sig(10) xor crc_sig(11) xor crc_sig(12) xor crc_sig(13) xor crc_sig(14) xor crc_sig(15);
							crc_sig(14) <= AXIS_tdata(13) xor AXIS_tdata(12) xor crc_sig(4) xor crc_sig(5);
							crc_sig(13) <= AXIS_tdata(12) xor AXIS_tdata(11) xor crc_sig(3) xor crc_sig(4);
							crc_sig(12) <= AXIS_tdata(11) xor AXIS_tdata(10) xor crc_sig(2) xor crc_sig(3);
							crc_sig(11) <= AXIS_tdata(7) xor AXIS_tdata(10) xor AXIS_tdata(9) xor crc_sig(1) xor crc_sig(2) xor crc_sig(15);
							crc_sig(10) <= AXIS_tdata(6) xor AXIS_tdata(9) xor AXIS_tdata(8) xor crc_sig(0) xor crc_sig(1) xor crc_sig(14);
							crc_sig(9) <= AXIS_tdata(7) xor AXIS_tdata(5) xor AXIS_tdata(8) xor AXIS_tdata(23) xor crc_sig(0) xor crc_sig(13) xor crc_sig(15);
							crc_sig(8) <= AXIS_tdata(6) xor AXIS_tdata(4) xor AXIS_tdata(23) xor AXIS_tdata(22) xor crc_sig(12) xor crc_sig(14);
							crc_sig(7) <= AXIS_tdata(5) xor AXIS_tdata(3) xor AXIS_tdata(22) xor AXIS_tdata(21) xor crc_sig(11) xor crc_sig(13);
							crc_sig(6) <= AXIS_tdata(4) xor AXIS_tdata(2) xor AXIS_tdata(21) xor AXIS_tdata(20) xor crc_sig(10) xor crc_sig(12);
							crc_sig(5) <= AXIS_tdata(3) xor AXIS_tdata(1) xor AXIS_tdata(20) xor AXIS_tdata(19) xor crc_sig(9) xor crc_sig(11);
							crc_sig(4) <= AXIS_tdata(2) xor AXIS_tdata(0) xor AXIS_tdata(19) xor AXIS_tdata(18) xor crc_sig(8) xor crc_sig(10);
							crc_sig(3) <= AXIS_tdata(1) xor AXIS_tdata(15) xor AXIS_tdata(18) xor AXIS_tdata(17) xor crc_sig(7) xor crc_sig(9);
							crc_sig(2) <= AXIS_tdata(0) xor AXIS_tdata(14) xor AXIS_tdata(17) xor AXIS_tdata(16) xor crc_sig(6) xor crc_sig(8);
							crc_sig(1) <= AXIS_tdata(7) xor AXIS_tdata(6) xor AXIS_tdata(5) xor AXIS_tdata(4) xor AXIS_tdata(3) xor AXIS_tdata(2) xor AXIS_tdata(1) xor AXIS_tdata(0) xor AXIS_tdata(14) xor AXIS_tdata(13) xor AXIS_tdata(12) xor AXIS_tdata(11) xor AXIS_tdata(10) xor AXIS_tdata(9) xor AXIS_tdata(8) xor AXIS_tdata(23) xor AXIS_tdata(22) xor AXIS_tdata(21) xor AXIS_tdata(20) xor AXIS_tdata(19) xor AXIS_tdata(18) xor AXIS_tdata(17) xor crc_sig(0) xor crc_sig(1) xor crc_sig(2) xor crc_sig(3) xor crc_sig(4) xor crc_sig(5) xor crc_sig(6) xor crc_sig(8) xor crc_sig(9) xor crc_sig(10) xor crc_sig(11) xor crc_sig(12) xor crc_sig(13) xor crc_sig(14) xor crc_sig(15);
							crc_sig(0) <= AXIS_tdata(7) xor AXIS_tdata(6) xor AXIS_tdata(5) xor AXIS_tdata(4) xor AXIS_tdata(3) xor AXIS_tdata(2) xor AXIS_tdata(1) xor AXIS_tdata(0) xor AXIS_tdata(15) xor AXIS_tdata(13) xor AXIS_tdata(12) xor AXIS_tdata(11) xor AXIS_tdata(10) xor AXIS_tdata(9) xor AXIS_tdata(8) xor AXIS_tdata(23) xor AXIS_tdata(22) xor AXIS_tdata(21) xor AXIS_tdata(20) xor AXIS_tdata(19) xor AXIS_tdata(18) xor AXIS_tdata(17) xor AXIS_tdata(16) xor crc_sig(0) xor crc_sig(1) xor crc_sig(2) xor crc_sig(3) xor crc_sig(4) xor crc_sig(5) xor crc_sig(7) xor crc_sig(8) xor crc_sig(9) xor crc_sig(10) xor crc_sig(11) xor crc_sig(12) xor crc_sig(13) xor crc_sig(14) xor crc_sig(15);
							validCrc_sig <= '1';
						when "0011" =>
							crc_sig(15) <= AXIS_tdata(7) xor AXIS_tdata(6) xor AXIS_tdata(4) xor AXIS_tdata(3) xor AXIS_tdata(2) xor AXIS_tdata(1) xor AXIS_tdata(0) xor AXIS_tdata(15) xor AXIS_tdata(14) xor AXIS_tdata(13) xor AXIS_tdata(12) xor AXIS_tdata(11) xor AXIS_tdata(10) xor AXIS_tdata(9) xor AXIS_tdata(8) xor crc_sig(0) xor crc_sig(1) xor crc_sig(2) xor crc_sig(3) xor crc_sig(4) xor crc_sig(5) xor crc_sig(6) xor crc_sig(7) xor crc_sig(8) xor crc_sig(9) xor crc_sig(10) xor crc_sig(11) xor crc_sig(12) xor crc_sig(14) xor crc_sig(15);
							crc_sig(14) <= AXIS_tdata(5) xor AXIS_tdata(4) xor crc_sig(12) xor crc_sig(13);
							crc_sig(13) <= AXIS_tdata(4) xor AXIS_tdata(3) xor crc_sig(11) xor crc_sig(12);
							crc_sig(12) <= AXIS_tdata(3) xor AXIS_tdata(2) xor crc_sig(10) xor crc_sig(11);
							crc_sig(11) <= AXIS_tdata(2) xor AXIS_tdata(1) xor crc_sig(9) xor crc_sig(10);
							crc_sig(10) <= AXIS_tdata(1) xor AXIS_tdata(0) xor crc_sig(8) xor crc_sig(9);
							crc_sig(9) <= AXIS_tdata(0) xor AXIS_tdata(15) xor crc_sig(7) xor crc_sig(8);
							crc_sig(8) <= AXIS_tdata(15) xor AXIS_tdata(14) xor crc_sig(6) xor crc_sig(7);
							crc_sig(7) <= AXIS_tdata(14) xor AXIS_tdata(13) xor crc_sig(5) xor crc_sig(6);
							crc_sig(6) <= AXIS_tdata(13) xor AXIS_tdata(12) xor crc_sig(4) xor crc_sig(5);
							crc_sig(5) <= AXIS_tdata(12) xor AXIS_tdata(11) xor crc_sig(3) xor crc_sig(4);
							crc_sig(4) <= AXIS_tdata(11) xor AXIS_tdata(10) xor crc_sig(2) xor crc_sig(3);
							crc_sig(3) <= AXIS_tdata(7) xor AXIS_tdata(10) xor AXIS_tdata(9) xor crc_sig(1) xor crc_sig(2) xor crc_sig(15);
							crc_sig(2) <= AXIS_tdata(6) xor AXIS_tdata(9) xor AXIS_tdata(8) xor crc_sig(0) xor crc_sig(1) xor crc_sig(14);
							crc_sig(1) <= AXIS_tdata(6) xor AXIS_tdata(5) xor AXIS_tdata(4) xor AXIS_tdata(3) xor AXIS_tdata(2) xor AXIS_tdata(1) xor AXIS_tdata(0) xor AXIS_tdata(15) xor AXIS_tdata(14) xor AXIS_tdata(13) xor AXIS_tdata(12) xor AXIS_tdata(11) xor AXIS_tdata(10) xor AXIS_tdata(9) xor crc_sig(1) xor crc_sig(2) xor crc_sig(3) xor crc_sig(4) xor crc_sig(5) xor crc_sig(6) xor crc_sig(7) xor crc_sig(8) xor crc_sig(9) xor crc_sig(10) xor crc_sig(11) xor crc_sig(12) xor crc_sig(13) xor crc_sig(14);
							crc_sig(0) <= AXIS_tdata(7) xor AXIS_tdata(5) xor AXIS_tdata(4) xor AXIS_tdata(3) xor AXIS_tdata(2) xor AXIS_tdata(1) xor AXIS_tdata(0) xor AXIS_tdata(15) xor AXIS_tdata(14) xor AXIS_tdata(13) xor AXIS_tdata(12) xor AXIS_tdata(11) xor AXIS_tdata(10) xor AXIS_tdata(9) xor AXIS_tdata(8) xor crc_sig(0) xor crc_sig(1) xor crc_sig(2) xor crc_sig(3) xor crc_sig(4) xor crc_sig(5) xor crc_sig(6) xor crc_sig(7) xor crc_sig(8) xor crc_sig(9) xor crc_sig(10) xor crc_sig(11) xor crc_sig(12) xor crc_sig(13) xor crc_sig(15);
							validCrc_sig <= '1';
						when "0001" =>
							crc_sig(15) <= AXIS_tdata(7) xor AXIS_tdata(6) xor AXIS_tdata(5) xor AXIS_tdata(4) xor AXIS_tdata(3) xor AXIS_tdata(2) xor AXIS_tdata(1) xor AXIS_tdata(0) xor crc_sig(7) xor crc_sig(8) xor crc_sig(9) xor crc_sig(10) xor crc_sig(11) xor crc_sig(12) xor crc_sig(13) xor crc_sig(14) xor crc_sig(15);
							crc_sig(14) <= crc_sig(6);
							crc_sig(13) <= crc_sig(5);
							crc_sig(12) <= crc_sig(4);
							crc_sig(11) <= crc_sig(3);
							crc_sig(10) <= crc_sig(2);
							crc_sig(9) <= AXIS_tdata(7) xor crc_sig(1) xor crc_sig(15);
							crc_sig(8) <= AXIS_tdata(7) xor AXIS_tdata(6) xor crc_sig(0) xor crc_sig(14) xor crc_sig(15);
							crc_sig(7) <= AXIS_tdata(6) xor AXIS_tdata(5) xor crc_sig(13) xor crc_sig(14);
							crc_sig(6) <= AXIS_tdata(5) xor AXIS_tdata(4) xor crc_sig(12) xor crc_sig(13);
							crc_sig(5) <= AXIS_tdata(4) xor AXIS_tdata(3) xor crc_sig(11) xor crc_sig(12);
							crc_sig(4) <= AXIS_tdata(3) xor AXIS_tdata(2) xor crc_sig(10) xor crc_sig(11);
							crc_sig(3) <= AXIS_tdata(2) xor AXIS_tdata(1) xor crc_sig(9) xor crc_sig(10);
							crc_sig(2) <= AXIS_tdata(1) xor AXIS_tdata(0) xor crc_sig(8) xor crc_sig(9);
							crc_sig(1) <= AXIS_tdata(7) xor AXIS_tdata(6) xor AXIS_tdata(5) xor AXIS_tdata(4) xor AXIS_tdata(3) xor AXIS_tdata(2) xor AXIS_tdata(1) xor crc_sig(9) xor crc_sig(10) xor crc_sig(11) xor crc_sig(12) xor crc_sig(13) xor crc_sig(14) xor crc_sig(15);
							crc_sig(0) <= AXIS_tdata(7) xor AXIS_tdata(6) xor AXIS_tdata(5) xor AXIS_tdata(4) xor AXIS_tdata(3) xor AXIS_tdata(2) xor AXIS_tdata(1) xor AXIS_tdata(0) xor crc_sig(8) xor crc_sig(9) xor crc_sig(10) xor crc_sig(11) xor crc_sig(12) xor crc_sig(13) xor crc_sig(14) xor crc_sig(15);
							validCrc_sig <= '1';
					when others =>
							validCrc_sig <= '0';
					end case;

					first := false;

					if AXIS_tlast='1' then
						stateOp <= stateOpDone;
					end if;
				end if;

			elsif stateOp=stateOpDone then
				if AXIS_tlast='0' then
					stateOp <= stateOpInit;
				end if;
			end if;
		end if;
	end process;

end Rtl;
