-- file Axislave_v1_0.vhd
-- Axislave_v1_0 module implementation
-- copyright: (C) 2023 MPSI Technologies GmbH
-- author: Alexander Wirthmueller
-- date created: 15 Feb 2023
-- date modified: 24 Apr 2023
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Axislave_v1_0 is
	generic(
		fMclk: natural := 50000; -- in kHz

		wA: natural := 32;
		wD: natural := 32
	);
	port(
		reset: in std_logic;
		mclk: in std_logic;

		req: in std_logic;
		ack: out std_logic;
		dne: out std_logic;

		sendNotRecv: in std_logic;
		len: in std_logic_vector(31 downto 0); -- minus one

		recvAXIS_tready: in std_logic;
		recvAXIS_tvalid: out std_logic;
		recvAXIS_tdata: out std_logic_vector(wD-1 downto 0);
		recvAXIS_tlast: out std_logic;

		sendAXIS_tready: out std_logic;
		sendAXIS_tvalid: in std_logic;
		sendAXIS_tdata: in std_logic_vector(wD-1 downto 0);
		sendAXIS_tlast: in std_logic;

		-- FPGA to host
		AXIL_araddr: in std_logic_vector(wA-1 downto 0);
		AXIL_arprot: in std_logic_vector(2 downto 0);
		AXIL_arready: out std_logic;
		AXIL_arvalid: in std_logic;
		AXIL_rdata: out std_logic_vector(wD-1 downto 0);
		AXIL_rready: in std_logic;
		AXIL_rresp: out std_logic_vector(1 downto 0);
		AXIL_rvalid: out std_logic;
		AXIL_rlast: out std_logic;

		-- host to FPGA
		AXIL_awaddr: in std_logic_vector(wA-1 downto 0);
		AXIL_awprot: in std_logic_vector(2 downto 0);
		AXIL_awready: out std_logic;
		AXIL_awvalid: in std_logic;
		AXIL_wdata: in std_logic_vector(wD-1 downto 0);
		AXIL_wready: out std_logic;
		AXIL_wstrb: in std_logic_vector(wD/8-1 downto 0);
		AXIL_wvalid: in std_logic;
		AXIL_bready: in std_logic;
		AXIL_bresp: out std_logic_vector(1 downto 0);
		AXIL_bvalid: out std_logic
	);
end Axislave_v1_0;

architecture Rtl of Axislave_v1_0 is

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	constant ixSetWrite: natural := 0;
	constant ixWrite: natural := 1;
	constant ixSetRead: natural := 2;
	constant ixRead: natural := 3; -- blk(ixRead) effectively never used

	constant msbABlk: natural := 5; -- implies 0x10 increments for block addresses, sufficient for wD = 128
	constant lsbABlk: natural := 4;

	---- host to FPGA AXI channel operation (write)
	signal AXIL_awready_sig: std_logic;
	signal AXIL_awaddr_sig: std_logic_vector(wA-1 downto 0);

	signal AXIL_wready_sig: std_logic;
	signal AXIL_wdata_sig: std_logic_vector(wD-1 downto 0);

	signal AXIL_bvalid_sig: std_logic;
	signal AXIL_bresp_sig: std_logic_vector(1 downto 0);

	signal ixBlkWrite: natural range 0 to 3;

	signal strbWrite: std_logic;

	---- FPGA to host AXI channel operation (read)
	signal AXIL_arready_sig: std_logic;
	signal AXIL_araddr_sig: std_logic_vector(wA-1 downto 0);

	signal AXIL_rresp_sig: std_logic_vector(1 downto 0);
	signal AXIL_rvalid_sig: std_logic;

	signal ixBlkRead: natural range 0 to 3;

	signal strbRead: std_logic;

	---- recv (receive operation)
	type stateRecv_t is (
		stateRecvInit,
		stateRecvWaitStart,
		stateRecvAckStart,
		stateRecvXferA, stateRecvXferB,
		stateRecvWaitStop,
		stateRecvDone,
		stateRecvTimeout
	);
	signal stateRecv: stateRecv_t := stateRecvInit;

	signal recvAck: std_logic;
	signal recvDne: std_logic;

	signal recvAXIL_rdata: std_logic_vector(wD-1 downto 0);

	signal recvAXIS_tdata_sig: std_logic_vector(wD-1 downto 0);
	signal recvAXIS_tlast_sig: std_logic;

	signal recvStrbToStart: std_logic;
	signal recvStrbToStop: std_logic;

	---- send (send operation)
	type stateSend_t is (
		stateSendInit,
		stateSendWaitStart,
		stateSendAckStart,
		stateSendXferA, stateSendXferB,
		stateSendWaitStop,
		stateSendDone,
		stateSendTimeout
	);
	signal stateSend: stateSend_t := stateSendInit;

	signal sendAck: std_logic;
	signal sendDne: std_logic;

	signal sendAXIL_rdata: std_logic_vector(wD-1 downto 0);

	signal sendStrbToStart: std_logic;
	signal sendStrbToStop: std_logic;

	---- timeout (to)
	type stateTo_t is (
		stateToInit,
		stateToReady,
		stateToWait,
		stateToDone
	);
	signal stateTo: stateTo_t := stateToInit;

	signal timeout: std_logic;

	---- other
	signal resetn: std_Logic;

	signal len_nat: natural;

	------------------------------------------------------------------------
	-- functions
	------------------------------------------------------------------------

	function isTrue
		parameter (
			vec: std_logic_vector(wD-1 downto 0)
		)
	return boolean is

		variable chk: boolean := true;

	begin
		for i in 0 to wD/2-1 loop
			if vec(2*(i+1)-1 downto 2*i)/="01" then
				chk := false;
			end if;
		end loop;

		return chk;
	end function;

	function isFalse
		parameter (
			vec: std_logic_vector(wD-1 downto 0)
		)
	return boolean is

		variable chk: boolean := true;

	begin
		for i in 0 to wD/2-1 loop
			if vec(2*(i+1)-1 downto 2*i)/="10" then
				chk := false;
			end if;
		end loop;

		return chk;
	end function;

begin

	------------------------------------------------------------------------
	-- implementation: write (host to FPGA AXI channel operation)
	------------------------------------------------------------------------

	-- write channel
	AXIL_awready <= AXIL_awready_sig;
	ixBlkWrite <= to_integer(unsigned(AXIL_awaddr_sig(msbABlk downto lsbABlk)));

	AXIL_wready	<= AXIL_wready_sig;

	AXIL_bresp	<= AXIL_bresp_sig;
	AXIL_bvalid	<= AXIL_bvalid_sig;

	strbWrite <= '1' when AXIL_bready='1' and AXIL_bvalid_sig='1' else '0';

	process (mclk)

	begin
		if rising_edge(mclk) then
			if resetn='0' then
				AXIL_awready_sig <= '0';
				AXIL_awaddr_sig <= (others => '0');

				AXIL_wready_sig <= '0';
				AXIL_wdata_sig <= (others => '0');

				AXIL_bvalid_sig <= '0';
				AXIL_bresp_sig <= "00";

			else
				if (AXIL_awready_sig='0' and AXIL_awvalid='1' and AXIL_wvalid='1') then
					AXIL_awready_sig <= '1';
					AXIL_awaddr_sig <= AXIL_awaddr;
				else
					AXIL_awready_sig <= '0';
				end if;

				if (AXIL_wready_sig='0' and AXIL_wvalid='1' and AXIL_awvalid='1') then
					AXIL_wready_sig <= '1';
				else
					AXIL_wready_sig <= '0';
				end if;

				if (AXIL_awready_sig='1' and AXIL_awvalid='1' and AXIL_wready_sig='1' and AXIL_wvalid='1' and AXIL_bvalid_sig='0') then
					AXIL_bvalid_sig <= '1';
					AXIL_bresp_sig <= "00";
				elsif (AXIL_bready='1' and AXIL_bvalid_sig='1') then
					AXIL_bvalid_sig <= '0';
				end if;

				if (AXIL_awready_sig='1' and AXIL_awvalid='1' and AXIL_wready_sig='1' and AXIL_wvalid='1') then
					for i in 0 to (wD/8-1) loop -- this implies that strb(0) is for data(7 downto 0)
						if AXIL_wstrb(i)='1' then
							AXIL_wdata_sig((i+1)*8-1 downto i*8) <= AXIL_wdata((i+1)*8-1 downto i*8);
						end if;
					end loop;
				end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: read (FPGA to host AXI channel operation)
	------------------------------------------------------------------------

	-- read channel
	AXIL_arready	<= AXIL_arready_sig;
	ixBlkRead <= to_integer(unsigned(AXIL_araddr_sig(msbABlk downto lsbABlk)));

	AXIL_rdata <= sendAXIL_rdata when sendNotRecv='1' else recvAXIL_rdata;

	AXIL_rresp	<= AXIL_rresp_sig;
	AXIL_rvalid	<= AXIL_rvalid_sig;

	strbRead <= '1' when AXIL_arready_sig='1' and AXIL_arvalid='1' else '0';

	process (mclk)

	begin
		if rising_edge(mclk) then
			if resetn='0' then
				AXIL_arready_sig <= '0';
				AXIL_araddr_sig <= (others => '0');

				AXIL_rvalid_sig <= '0';
				AXIL_rresp_sig	<= "00";

			else
				if (AXIL_arready_sig='0' and AXIL_arvalid='1') then
					AXIL_arready_sig <= '1';
					AXIL_araddr_sig	<= AXIL_araddr;
				else
					AXIL_arready_sig <= '0';
				end if;

				if (AXIL_arready_sig='1' and AXIL_arvalid='1') then
					AXIL_rvalid_sig <= '1';
					AXIL_rresp_sig	<= "00";
				elsif (AXIL_rvalid_sig='1' and AXIL_rready='1') then
					AXIL_rvalid_sig <= '0';
				end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: receive operation (recv)
	------------------------------------------------------------------------

	recvAck <= '1' when stateRecv=stateRecvAckStart or stateRecv=stateRecvXferA or stateRecv=stateRecvXferB or stateRecv=stateRecvWaitStop or stateRecv=stateRecvDone else '0';
	recvDne <= '1' when stateRecv=stateRecvDone else '0';

	recvAXIS_tvalid <= '1' when stateRecv=stateRecvXferB else '0';

	recvAXIS_tdata <= recvAXIS_tdata_sig;
	recvAXIS_tlast <= recvAXIS_tlast_sig;

	process (reset, mclk, stateRecv)
		variable wordcnt: natural;

	begin
		if reset='1' then
			stateRecv <= stateRecvInit;
			recvAXIS_tdata_sig <= (others => '0');
			recvAXIS_tlast_sig <= '0';
			recvAXIL_rdata <= (others => '0');
			recvStrbToStart <= '0';
			recvStrbToStop <= '0';

		elsif rising_edge(mclk) then
			if stateRecv=stateRecvInit or req='0' or sendNotRecv='1' or (stateRecv/=stateRecvTimeout and timeout='1') then
				recvAXIS_tdata_sig <= (others => '0');
				recvAXIS_tlast_sig <= '0';
				recvAXIL_rdata <= (others => '0');
				recvStrbToStart <= '0';
				recvStrbToStop <= '0';

				if req='0' or sendNotRecv='1' then
					stateRecv <= stateRecvInit;
				elsif timeout='1' then
					stateRecv <= stateRecvTimeout;
				else
					stateRecv <= stateRecvWaitStart;
				end if;

			elsif stateRecv=stateRecvWaitStart then
				if strbWrite='1' and ixBlkWrite=ixSetWrite and isFalse(AXIL_wdata_sig) then
					recvStrbToStart <= '1';

					stateRecv <= stateRecvAckStart;
				end if;

			elsif stateRecv=stateRecvAckStart then
				if strbRead='1' and ixBlkRead=ixSetWrite then
					for i in 0 to wD/2-1 loop
						recvAXIL_rdata(2*(i+1)-1 downto 2*i) <= "10"; -- false
					end loop;

					wordcnt := 0;

					recvStrbToStart <= '1';

					stateRecv <= stateRecvXferA;

				else
					recvStrbToStart <= '0';
				end if;

			elsif stateRecv=stateRecvXferA then
				recvStrbToStart <= '0';

				if strbWrite='1' and ixBlkWrite=ixWrite then
					recvAXIS_tdata_sig <= AXIL_wdata_sig;

					if wordcnt=len_nat then -- words received minus one
						recvAXIS_tlast_sig <= '1';
					end if;

					recvStrbToStop <= '1';

					stateRecv <= stateRecvXferB;
				end if;

			elsif stateRecv=stateRecvXferB then -- recvAXIS_tvalid='1'
				recvStrbToStop <= '0';

				if recvAXIS_tready='1' then
					recvStrbToStart <= '1';

					if recvAXIS_tlast_sig='1' then
						stateRecv <= stateRecvWaitStop;

					else
						wordcnt := wordcnt + 1; -- words received
						stateRecv <= stateRecvXferA;
					end if;
				end if;
			
			elsif stateRecv=stateRecvWaitStop then
				recvStrbToStart <= '0';

				if strbWrite='1' and ixBlkWrite=ixSetWrite and isTrue(AXIL_wdata_sig) then
					recvStrbToStop <= '1';

					stateRecv <= stateRecvDone;
				end if;

			elsif stateRecv=stateRecvDone then
				recvStrbToStop <= '0';

				--if req='0' then
				--	stateRecv <= stateRecvInit;
				--end if;

			elsif stateRecv=stateRecvTimeout then
				--if req='0' then
				--	stateRecv <= stateRecvInit;
				--end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: send operation (send)
	------------------------------------------------------------------------

	sendAck <= '1' when stateSend=stateSendAckStart or stateSend=stateSendXferA or stateSend=stateSendXferB or stateSend=stateSendWaitStop or stateSend=stateSendDone else '0';
	sendDne <= '1' when stateSend=stateSendDone else '0';

	sendAXIS_tready <= '1' when stateSend=stateSendXferA else '0';

	process (reset, mclk, stateSend)
		variable wordcnt: natural;

	begin
		if reset='1' then
			stateSend <= stateSendInit;
			sendAXIL_rdata <= (others => '0');
			sendStrbToStart <= '0';
			sendStrbToStop <= '0';

		elsif rising_edge(mclk) then
			if stateSend=stateSendInit or req='0' or sendNotRecv='0' or (stateSend/=stateSendTimeout and timeout='1') then
				sendAXIL_rdata <= (others => '0');
				sendStrbToStart <= '0';
				sendStrbToStop <= '0';

				if req='0' or sendNotRecv='0' then
					stateSend <= stateSendInit;
				elsif timeout='1' then
					stateSend <= stateSendTimeout;
				else
					stateSend <= stateSendWaitStart;
				end if;

			elsif stateSend=stateSendWaitStart then
				if strbWrite='1' and ixBlkWrite=ixSetRead and isFalse(AXIL_wdata_sig) then
					sendStrbToStart <= '1';

					stateSend <= stateSendAckStart;
				end if;

			elsif stateSend=stateSendAckStart then
				sendStrbToStart <= '0';

				if strbRead='1' and ixBlkRead=ixSetRead then
					for i in 0 to wD/2-1 loop
						sendAXIL_rdata(2*(i+1)-1 downto 2*i) <= "10"; -- false
					end loop;

					wordcnt := 0;

					sendStrbToStop <= '1';

					stateSend <= stateSendXferA;
				end if;

			elsif stateSend=stateSendXferA then -- sendAXIS_tready='1'
				sendStrbToStop <= '0';

				if sendAXIS_tvalid='1' then
					sendAXIL_rdata <= sendAXIS_tdata;

					sendStrbToStart <= '1';

					stateSend <= stateSendXferB;
				end if;

			elsif stateSend=stateSendXferB then
				if strbRead='1' and ixBlkRead=ixRead then
					if wordcnt=len_nat then -- words sent minus one
						sendStrbToStart <= '1';

						stateSend <= stateSendWaitStop;
					
					else
						wordcnt := wordcnt + 1; -- words sent

						sendStrbToStart <= '0';
						sendStrbToStop <= '1';

						stateSend <= stateSendXferA;
					end if;

				else
					sendStrbToStart <= '0';
				end if;
			
			elsif stateSend=stateSendWaitStop then
				sendStrbToStart <= '0';

				if strbWrite='1' and ixBlkWrite=ixSetRead and isTrue(AXIL_wdata_sig) then
					sendStrbToStop <= '1';

					stateSend <= stateSendDone;
				end if;

			elsif stateSend=stateSendDone then
				sendStrbToStop <= '0';

				--if req='0' then
				--	stateSend <= stateSendInit;
				--end if;

			elsif stateSend=stateSendTimeout then
				--if req='0' then
				--	stateSend <= stateSendInit;
				--end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: timeout (to)
	------------------------------------------------------------------------

	timeout <= '1' when stateTo=stateToDone else '0';

	process (reset, mclk)
		constant twait: natural := fMclk/5; -- 200us
		variable i: natural range 0 to twait;

	begin
		if reset='1' then
			stateTo <= stateToInit;
			i := 0;

		elsif rising_edge(mclk) then
			if (stateTo=stateToInit or req='0') then
				i := 0;

				if req='0' then
					stateTo <= stateToInit;
				else
					stateTo <= stateToReady;
				end if;

			elsif stateTo=stateToReady then
				if recvStrbToStart='1' or sendStrbToStart='1' then
					i := 0;

					stateTo <= stateToWait;
				end if;

			elsif stateTo=stateToWait then
				if recvStrbToStart='1' or sendStrbToStart='1' then
					i := 0;

				elsif recvStrbToStop='1' or sendStrbToStop='1' then
					stateTo <= stateToReady;
				
				else
					i := i + 1;

					if i=twait then
						stateTo <= stateToDone;
					end if;
				end if;

			elsif stateTo=stateToDone then
				--if req='0' then
				--	stateTo <= stateToInit;
				--end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: other
	------------------------------------------------------------------------

	resetn <= not reset;

	ack <= sendAck when sendNotRecv='1' else recvAck;
	dne <= sendDne when sendNotRecv='1' else recvDne;

	AXIL_rlast <= '1';

	len_nat <= to_integer(unsigned(len));

end Rtl;
