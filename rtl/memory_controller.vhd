library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity memory_controller is
	port (
		-- SDRAM
		o_dram_addr  : out std_logic_vector(12 downto 0);
		o_dram_ba    : out std_logic_vector(1 downto 0);
		o_dram_cas_n : out std_logic;
		o_dram_cke   : out std_logic;
		o_dram_clk   : out std_logic;
		o_dram_cs_n  : out std_logic;
		io_dram_dq   : inout std_logic_vector(31 downto 0);
		o_dram_dqm	 : out std_logic_vector(3 downto 0);
		o_dram_ras_n : out std_logic;
		o_dram_we_n  : out std_logic;
		-- SRAM
		io_sram_dq	: inout std_logic_vector(15 downto 0);
        o_sram_addr : out std_logic_vector(19 downto 0);
        o_sram_lb	: out std_logic;  
        o_sram_ub	: out std_logic;  
        o_sram_ce	: out std_logic;  
        o_sram_oe	: out std_logic;  
        o_sram_we	: out std_logic;  
		-- PROC
		i_clk_50     : in std_logic;
		i_boot       : in std_logic;
		i_addr       : in std_logic_vector(R_XLEN);
		i_bhw        : in std_logic_vector(R_MEM_ACCS);
		i_wr_data    : in std_logic_vector(R_XLEN);
		i_ld_st      : in std_logic_vector(R_MEM_LDST);
		o_rd_data    : out std_logic_vector(R_XLEN)
	);
end memory_controller;

architecture Structure of memory_controller is

	component SDRAMController is
		port (
			clk_clk                  : in    std_logic                     := 'X';         
			reset_reset_n            : in    std_logic                     := 'X';        
			sdram_clk_clk            : out   std_logic;                                  
			sdram_addr               : out   std_logic_vector(12 downto 0);             
			sdram_ba                 : out   std_logic_vector(1 downto 0);             
			sdram_cas_n              : out   std_logic;                              
			sdram_cke                : out   std_logic;                        
			sdram_cs_n               : out   std_logic;                       
			sdram_dq                 : inout std_logic_vector(31 downto 0) := (others => 'X');
			sdram_dqm                : out   std_logic_vector(3 downto 0);                   
			sdram_ras_n              : out   std_logic;                                     
			sdram_we_n               : out   std_logic;                                    
			mm_bridge_s_waitrequest   : out   std_logic;                                  
            mm_bridge_s_readdata      : out   std_logic_vector(31 downto 0);             
            mm_bridge_s_readdatavalid : out   std_logic;                                
            mm_bridge_s_burstcount    : in    std_logic_vector(0 downto 0)  := (others => 'X');
            mm_bridge_s_writedata     : in    std_logic_vector(31 downto 0) := (others => 'X');
            mm_bridge_s_address       : in    std_logic_vector(26 downto 0) := (others => 'X');
            mm_bridge_s_write         : in    std_logic                     := 'X';           
            mm_bridge_s_read          : in    std_logic                     := 'X';          
            mm_bridge_s_byteenable    : in    std_logic_vector(3 downto 0)  := (others => 'X');
            mm_bridge_s_debugaccess   : in    std_logic
		);
	end component SDRAMController;


    component SRAMController is
        port (
            clk_clk                  : in    std_logic                     := 'X';
            reset_reset_n            : in    std_logic                     := 'X';
            sram_DQ                  : inout std_logic_vector(15 downto 0) := (others => 'X');
            sram_ADDR                : out   std_logic_vector(19 downto 0);                  
            sram_LB_N                : out   std_logic;                                     
            sram_UB_N                : out   std_logic;                                    
            sram_CE_N                : out   std_logic;                                   
            sram_OE_N                : out   std_logic;                                  
            sram_WE_N                : out   std_logic;                                 
            controller_address       : in    std_logic_vector(19 downto 0) := (others => 'X');
            controller_byteenable    : in    std_logic_vector(1 downto 0)  := (others => 'X');
            controller_read          : in    std_logic                     := 'X';           
            controller_write         : in    std_logic                     := 'X';          
            controller_writedata     : in    std_logic_vector(15 downto 0) := (others => 'X');
            controller_readdata      : out   std_logic_vector(15 downto 0);                  
            controller_readdatavalid : out   std_logic                                      
        );
    end component SRAMController;

	-- SRAM
	signal s_sram_addr  : std_logic_vector(19 downto 0);
	signal s_sram_addr0 : std_logic_vector(19 downto 0);
	signal s_sram_be	: std_logic_vector(1 downto 0);
	signal s_sram_rd	: std_logic;      
	signal s_sram_wr	: std_logic;      
	signal s_sram_wrdata : std_logic_vector(15 downto 0);  
	signal s_sram_rddata : std_logic_vector(15 downto 0);  
	signal s_sram_datavalid : std_logic;
	type sram_states_t is (LH, UH);
	signal s_sram_state : sram_states_t := LH;
	signal s_sram_read_data : std_logic_vector(31 downto 0);

	-- AVALON MM
	signal s_mm_waitrequest   :    std_logic; 
    signal s_mm_readdata      :    std_logic_vector(31 downto 0); 
    signal s_mm_readdatavalid :    std_logic;                    
    signal s_mm_burstcount    :    std_logic_vector(0 downto 0)  ;
    signal s_mm_writedata     :    std_logic_vector(31 downto 0) ;
    signal s_mm_address       :    std_logic_vector(26 downto 0) ;
    signal s_mm_write         :    std_logic                     ;
    signal s_mm_write0         :    std_logic                     ;
    signal s_mm_read0          :    std_logic                     ;
    signal s_mm_read          :    std_logic                     ;
    signal s_mm_byteenable    :    std_logic_vector(3 downto 0)  ;
    signal s_mm_byteenable0    :    std_logic_vector(3 downto 0)  ;
    signal s_mm_debugaccess   :    std_logic;


begin
	c_sdram_controller : component SDRAMController
		port map (
			clk_clk                  => i_clk_50,  
			reset_reset_n            => i_boot,   
			sdram_clk_clk            => o_dram_clk,
			sdram_addr               => o_dram_addr,
			sdram_ba                 => o_dram_ba, 
			sdram_cas_n              => o_dram_cas_n,
			sdram_cke                => o_dram_cke, 
			sdram_cs_n               => o_dram_cs_n,
			sdram_dq                 => io_dram_dq,
			sdram_dqm                => o_dram_dqm,
			sdram_ras_n              => o_dram_ras_n,
			sdram_we_n               => o_dram_we_n, 
			mm_bridge_s_waitrequest   => s_mm_waitrequest ,
            mm_bridge_s_readdata      => s_mm_readdata     ,
            mm_bridge_s_readdatavalid => s_mm_readdatavalid,
            mm_bridge_s_burstcount    => s_mm_burstcount   ,
            mm_bridge_s_writedata     => s_mm_writedata    ,
            mm_bridge_s_address       => s_mm_address      ,
            mm_bridge_s_write         => s_mm_write        ,
            mm_bridge_s_read          => s_mm_read         ,
            mm_bridge_s_byteenable    => s_mm_byteenable   ,
            mm_bridge_s_debugaccess   => s_mm_debugaccess  
		);

	
    c_sram_controller : component SRAMController
        port map (
            clk_clk                  => i_clk_50,   
            reset_reset_n            => i_boot,    
            sram_DQ                  => io_sram_dq,
            sram_ADDR                => o_sram_addr,
            sram_LB_N                => o_sram_lb, 
            sram_UB_N                => o_sram_ub,
            sram_CE_N                => o_sram_ce,
            sram_OE_N                => o_sram_oe,
            sram_WE_N                => o_sram_we,
            controller_address       => s_sram_addr,
            controller_byteenable    => s_sram_be, 
            controller_read          => s_sram_rd,
            controller_write         => s_sram_wr,
            controller_writedata     => s_sram_wrdata,
            controller_readdata      => s_sram_rddata,
            controller_readdatavalid => s_sram_datavalid
        );

	s_mm_write0  <= '1' and not s_mm_waitrequest when i_ld_st = ST_SDRAM else
				   '0'; 
	s_mm_read0   <= '1' and not s_mm_waitrequest when i_ld_st = LD_SDRAM else
				   '0';      

			s_mm_byteenable0 <= "1111" when i_bhw = W_ACCESS else
							   "0011" when i_bhw = H_ACCESS else
							   "0001" when i_bhw = B_ACCESS else
							   "0000";
	-- AVALON MM
	process(i_clk_50)
	begin
		if rising_edge(i_clk_50) then
    		s_mm_address <= i_addr(26 downto 0);

			o_rd_data <= s_mm_readdata;
			s_mm_writedata <= i_wr_data;

			s_mm_write <= s_mm_write0;
			s_mm_read <= s_mm_read0;

			s_mm_burstcount <= "1";

			-- BYTE ENABLE
			-- 1111  -> Writes full 32 bits
			-- 0011  -> Writes lower 2 bytes
			-- 1100  -> Writes upper 2 bytes
			-- 0001  -> Writes byte 0
			-- 0010  -> Writes byte 1
			-- 0100  -> Writes byte 2
			-- 1000  -> Writes byte 3
			s_mm_byteenable <= s_mm_byteenable0;
		end if;
	end process;
-- SRAM
--	process(i_boot, i_clk_50)
--	begin
--		if i_boot = '1' then
--			s_sram_be <= "11";
--			s_sram_rd <= '0';
--			s_sram_wr <= '0';
--		elsif rising_edge(i_clk_50) then
--			case s_sram_state is
--				when LH =>
--					s_sram_addr0 <= x"00000";
--					s_sram_rd <= '1';
--					s_sram_read_data(15 downto 0) <= s_sram_rddata;
--					s_sram_state <= UH;
--				when UH =>
--					s_sram_addr0 <= x"00001";
--					s_sram_rd <= '1';
--					s_sram_read_data(31 downto 16) <= s_sram_rddata;
--					s_sram_state <= LH;
--			end case;
--		end if;
--	end process;
--	s_sram_addr <= s_sram_addr0;
end Structure;
