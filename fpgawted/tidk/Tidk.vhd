-- file Tidk.vhd
-- Efinix Titanium Ti180 development kit global constants and types
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

package Tidk is
	constant tixVTidkBufferCmdretToHostif: std_logic_vector(7 downto 0) := x"00";
	constant tixVTidkBufferHostifToCmdinv: std_logic_vector(7 downto 0) := x"01";
	constant tixVTidkBufferCntbufMfsmtrack1ToHostif: std_logic_vector(7 downto 0) := x"02";
	constant tixVTidkBufferCntbufMfsmtrack0ToHostif: std_logic_vector(7 downto 0) := x"03";
	constant tixVTidkBufferFstoccbufMfsmtrack1ToHostif: std_logic_vector(7 downto 0) := x"04";
	constant tixVTidkBufferFstoccbufMfsmtrack0ToHostif: std_logic_vector(7 downto 0) := x"05";
	constant tixVTidkBufferGetbufClientToHostif: std_logic_vector(7 downto 0) := x"06";
	constant tixVTidkBufferSeqbufMfsmtrack1ToHostif: std_logic_vector(7 downto 0) := x"07";
	constant tixVTidkBufferSeqbufMemwrtrackToHostif: std_logic_vector(7 downto 0) := x"08";
	constant tixVTidkBufferSeqbufMemrdtrackToHostif: std_logic_vector(7 downto 0) := x"09";
	constant tixVTidkBufferSeqbufMfsmtrack0ToHostif: std_logic_vector(7 downto 0) := x"0A";
	constant tixVTidkBufferSeqbufMgptrackToHostif: std_logic_vector(7 downto 0) := x"0B";
	constant tixVTidkBufferSetbufHostifToClient: std_logic_vector(7 downto 0) := x"0C";

	constant tixVTidkControllerHostif: std_logic_vector(7 downto 0) := x"00";
	constant tixVTidkControllerIdent: std_logic_vector(7 downto 0) := x"01";
	constant tixVTidkControllerClient: std_logic_vector(7 downto 0) := x"02";
	constant tixVTidkControllerDdrif: std_logic_vector(7 downto 0) := x"03";
	constant tixVTidkControllerMfsmtrack0: std_logic_vector(7 downto 0) := x"04";
	constant tixVTidkControllerMfsmtrack1: std_logic_vector(7 downto 0) := x"05";
	constant tixVTidkControllerMgptrack: std_logic_vector(7 downto 0) := x"06";
	constant tixVTidkControllerMemrdtrack: std_logic_vector(7 downto 0) := x"07";
	constant tixVTidkControllerMemwrtrack: std_logic_vector(7 downto 0) := x"08";
	constant tixVTidkControllerRgbled0: std_logic_vector(7 downto 0) := x"09";
	constant tixVTidkControllerState: std_logic_vector(7 downto 0) := x"0A";
	constant tixVTidkControllerTkclksrc: std_logic_vector(7 downto 0) := x"0B";
	constant tixVTidkControllerTrafgen: std_logic_vector(7 downto 0) := x"0C";

	constant tixVTidkStateNc: std_logic_vector(7 downto 0) := x"00";
	constant tixVTidkStateReady: std_logic_vector(7 downto 0) := x"01";
	constant tixVTidkStateActive: std_logic_vector(7 downto 0) := x"02";

	constant tixVClientCommandLoadGetbuf: std_logic_vector(7 downto 0) := x"00";
	constant tixVClientCommandStoreSetbuf: std_logic_vector(7 downto 0) := x"01";

	constant tixVDdrifCommandGetStats: std_logic_vector(7 downto 0) := x"00";

	constant tixVIdentCommandGet: std_logic_vector(7 downto 0) := x"00";
	constant tixVIdentCommandGetCfg: std_logic_vector(7 downto 0) := x"02";

	constant tixVMemrdtrackCommandGetInfo: std_logic_vector(7 downto 0) := x"00";
	constant tixVMemrdtrackCommandSelect: std_logic_vector(7 downto 0) := x"01";
	constant tixVMemrdtrackCommandSet: std_logic_vector(7 downto 0) := x"02";

	constant tixVMemwrtrackCommandGetInfo: std_logic_vector(7 downto 0) := x"00";
	constant tixVMemwrtrackCommandSelect: std_logic_vector(7 downto 0) := x"01";
	constant tixVMemwrtrackCommandSet: std_logic_vector(7 downto 0) := x"02";

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

	constant tixVTrafgenCommandSet: std_logic_vector(7 downto 0) := x"00";

	-- IP Tidk.cust --- INSERT
end Tidk;
