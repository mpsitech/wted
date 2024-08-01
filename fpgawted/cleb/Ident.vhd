-- file Ident_Easy_v1_0.vhd
-- Ident_Easy_v1_0 module implementation
-- copyright: (C) 2022 MPSI Technologies GmbH
-- author: Alexander Wirthmueller
-- date created: 15 Aug 2022
-- date modified: 26 Oct 2022
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Ident is
	generic (
		fMclk: natural := 0
	);
	port (
		getVer: out std_logic_vector(63 downto 0);
		getHash: out std_logic_vector(63 downto 0);
		getWho: out std_logic_vector(63 downto 0);

		getCfgFMclk: out std_logic_vector(31 downto 0)
	);
end Ident;

architecture Rtl of Ident is

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	constant ver: string(1 to 8) := "0.1.2   ";
	constant hash: string(1 to 8) := "c20dcef ";
	constant who: string(1 to 8) := "aw.mpsi ";

begin

	------------------------------------------------------------------------
	-- implementation
	------------------------------------------------------------------------

	strToSlv: for i in 0 to 7 generate
		getVer(8*(i+1)-1 downto 8*i) <= std_logic_vector(to_unsigned(character'pos(ver(i+1)), 8));
		getHash(8*(i+1)-1 downto 8*i) <= std_logic_vector(to_unsigned(character'pos(hash(i+1)), 8));
		getWho(8*(i+1)-1 downto 8*i) <= std_logic_vector(to_unsigned(character'pos(who(i+1)), 8));
	end generate;

	getCfgFMclk <= std_logic_vector(to_unsigned(fMclk, 32));

end Rtl;
