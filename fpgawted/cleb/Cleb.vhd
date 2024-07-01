-- file Cleb.vhd
-- Lattice CrossLink-NX Evaluation Board global constants and types
-- copyright: (C) 2017-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 30 Jun 2024
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package Dbecore is
	constant fls8: std_logic_vector(7 downto 0) := x"AA";
	constant fls16: std_logic_vector(15 downto 0) := x"AAAA";
	constant fls32: std_logic_vector(31 downto 0) := x"AAAAAAAA";

	constant tru8: std_logic_vector(7 downto 0) := x"55";
	constant tru16: std_logic_vector(15 downto 0) := x"5555";
	constant tru32: std_logic_vector(31 downto 0) := x"55555555";

	constant ixOpbufBuffer: natural := 0;
	constant ixOpbufController: natural := 1;
	constant ixOpbufCmdCommand: natural := 2;
	constant ixOpbufBufxfBufxfop: natural := 2;
	constant ixOpbufLen: natural := 3;
	constant ixOpbufCrc: natural := 7;

	constant ixPollbufBufxfAvllen: natural := 0;
	constant ixPollbufCmdController: natural := 0;
	constant ixPollbufCmdCommand: natural := 1;
	constant ixPollbufCmdLen: natural := 2;
	constant ixPollbufCrc: natural := 4;

	constant tixVCmdopInv: std_logic_vector(7 downto 0) := x"00";
	constant tixVCmdopRev: std_logic_vector(7 downto 0) := x"01";
	constant tixVCmdopRet: std_logic_vector(7 downto 0) := x"02";
	constant tixVCmdopErr: std_logic_vector(7 downto 0) := x"03";

	constant tixVBufxfopReset: std_logic_vector(7 downto 0) := x"00";
	constant tixVBufxfopPoll: std_logic_vector(7 downto 0) := x"01";
	constant tixVBufxfopXfer: std_logic_vector(7 downto 0) := x"02";
	constant tixVBufxfopXferlast: std_logic_vector(7 downto 0) := x"03";
end Dbecore;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package Cleb is
	constant tixVClebBufferCmdretToHostif: std_logic_vector(7 downto 0) := x"00";
	constant tixVClebBufferHostifToCmdinv: std_logic_vector(7 downto 0) := x"01";
	constant tixVClebBufferCntbufMfsmtrack0ToHostif: std_logic_vector(7 downto 0) := x"02";
	constant tixVClebBufferCntbufMfsmtrack1ToHostif: std_logic_vector(7 downto 0) := x"03";
	constant tixVClebBufferFstoccbufMfsmtrack0ToHostif: std_logic_vector(7 downto 0) := x"04";
	constant tixVClebBufferFstoccbufMfsmtrack1ToHostif: std_logic_vector(7 downto 0) := x"05";
	constant tixVClebBufferSeqbufMfsmtrack0ToHostif: std_logic_vector(7 downto 0) := x"06";
	constant tixVClebBufferSeqbufMfsmtrack1ToHostif: std_logic_vector(7 downto 0) := x"07";

	constant tixVClebControllerHostif: std_logic_vector(7 downto 0) := x"00";
	constant tixVClebControllerIdent: std_logic_vector(7 downto 0) := x"01";
	constant tixVClebControllerMfsmtrack0: std_logic_vector(7 downto 0) := x"02";
	constant tixVClebControllerMfsmtrack1: std_logic_vector(7 downto 0) := x"03";
	constant tixVClebControllerMgptrack: std_logic_vector(7 downto 0) := x"04";
	constant tixVClebControllerRgbled0: std_logic_vector(7 downto 0) := x"05";
	constant tixVClebControllerState: std_logic_vector(7 downto 0) := x"06";
	constant tixVClebControllerTkclksrc: std_logic_vector(7 downto 0) := x"07";

	constant tixVClebStateNc: std_logic_vector(7 downto 0) := x"00";
	constant tixVClebStateReady: std_logic_vector(7 downto 0) := x"01";

	constant tixVIdentCommandGet: std_logic_vector(7 downto 0) := x"00";
	constant tixVIdentCommandGetCfg: std_logic_vector(7 downto 0) := x"02";

	constant tixVMfsmtrack0CommandGetInfo: std_logic_vector(7 downto 0) := x"00";
	constant tixVMfsmtrack0CommandSelect: std_logic_vector(7 downto 0) := x"01";
	constant tixVMfsmtrack0CommandSet: std_logic_vector(7 downto 0) := x"02";

	constant tixVMfsmtrack1CommandGetInfo: std_logic_vector(7 downto 0) := x"00";
	constant tixVMfsmtrack1CommandSelect: std_logic_vector(7 downto 0) := x"01";
	constant tixVMfsmtrack1CommandSet: std_logic_vector(7 downto 0) := x"02";

	constant tixVMgptrackCommandGetInfo: std_logic_vector(7 downto 0) := x"00";
	constant tixVMgptrackCommandSelect: std_logic_vector(7 downto 0) := x"01";
	constant tixVMgptrackCommandSet: std_logic_vector(7 downto 0) := x"02";

	constant tixVStateCommandGet: std_logic_vector(7 downto 0) := x"00";

	constant tixVTkclksrcCommandGetTkst: std_logic_vector(7 downto 0) := x"00";
	constant tixVTkclksrcCommandSetTkst: std_logic_vector(7 downto 0) := x"01";

	-- IP Cleb.cust --- INSERT
end Cleb;
