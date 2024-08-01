-- file Tkclksrc_Easy_v1_0.vhd
-- Tkclksrc_Easy_v1_0 module implementation
-- copyright: (C) 2017-2018 MPSI Technologies GmbH
-- author: Alexander Wirthmueller
-- date created: 15 Dec 2017
-- date modified: 11 Apr 2018
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Tkclksrc_Easy_v1_0 is
	generic (
		fMclk: natural := 50000
	);
	port (
		reset: in std_logic;
		mclk: in std_logic;
		tkclk: out std_logic;

		getTkstTkst: out std_logic_vector(31 downto 0);

		reqInvSetTkst: in std_logic;
		ackInvSetTkst: out std_logic;

		setTkstTkst: in std_logic_vector(31 downto 0);

		stateOp_dbg: out std_logic_vector(7 downto 0)
	);
end Tkclksrc_Easy_v1_0;

architecture Rtl of Tkclksrc_Easy_v1_0 is

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- main operation (op)
	type stateOp_t is (
		stateOpInit,
		stateOpInv,
		stateOpRun
	);
	signal stateOp: stateOp_t := stateOpInit;

	signal tkclk_sig: std_logic;
	signal tkst: std_logic_vector(31 downto 0);

begin

	------------------------------------------------------------------------
	-- implementation: main operation (op)
	------------------------------------------------------------------------

	tkclk <= tkclk_sig;

	getTkstTkst <= tkst;

	ackInvSetTkst <= '1' when stateOp=stateOpInv else '0';

	-- IP cust --- BEGIN
	-- stateOp_dbg <= x"00" when stateOp=stateOpInit
	-- 			else x"10" when stateOp=stateOpInv
	-- 			else x"20" when stateOp=stateOpRun
	-- 			else (others => '1');
	-- IP cust --- END

	process (reset, mclk, stateOp)
		variable i: natural range 0 to (fMclk/10)/2;

	begin
		if reset='1' then
			stateOp <= stateOpInit;
			tkclk_sig <= '0';
			tkst <= (others => '0');

			i := 0;

		elsif rising_edge(mclk) then
			if (stateOp=stateOpInit or (stateOp/=stateOpInv and reqInvSetTkst='1')) then
				tkclk_sig <= '0';

				i := 0;

				if reqInvSetTkst='1' then
					tkst <= setTkstTkst;
					stateOp <= stateOpInv;
				else
					stateOp <= stateOpRun;
				end if;

			elsif stateOp=stateOpInv then
				if reqInvSetTkst='0' then
					stateOp <= stateOpRun;
				end if;

			elsif stateOp=stateOpRun then
				i := i + 1;
				if i=(fMclk/10)/2 then
					i := 0;
					if tkclk_sig='1' then
						tkst <= std_logic_vector(unsigned(tkst) + 1);
					end if;
					tkclk_sig <= not tkclk_sig;
				end if;
			end if;
		end if;
	end process;

end Rtl;
