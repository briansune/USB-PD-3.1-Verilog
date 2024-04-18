// ====================================================
				fsm_snk_efail_srst: begin
					if(!bmc_rd_busy)begin
						wr_hrst <= 1'b0;
						wr_num <= 3'd0;
						
						// software reset
						wr_type <= 4'hD;
						
						if(delay_abit >= oh_us_delay)begin
							if(cc_io_ctrl)
								main_fsm <= fsm_src_efsrst_w;
							bmc_wen <= 1'b1;
						end else begin
							delay_abit <= delay_abit + 1'b1;
						end
					end
				end
				
				fsm_src_efsrst_w: begin
					bmc_wen <= 1'b0;
					
					if(!cc_io_ctrl & bmc_rd_busy)begin
						main_fsm <= fsm_ck_crc_good2;
					end
					
					delay_abit <= 28'd0;
				end
				
				
				fsm_ck_crc_good2: begin
					
					if(
						crc_valid & pkg_valid &
						rd_type == 4'd1 &
						rd_num == 3'd0
					)begin
						main_fsm <= fsm_ck_src_srst_acp;
					end
					
					delay_abit <= 28'd0;
				end
				
				fsm_ck_src_srst_acp: begin
					if(
						crc_valid & pkg_valid &
						rd_type == 4'd3 &
						rd_num == 3'd0
					)begin
						main_fsm <= fsm_ssrst_acp_crc;
					end
					
					delay_abit <= 28'd0;
				end
				
				fsm_ssrst_acp_crc: begin
					if(!bmc_rd_busy)begin
						wr_hrst <= 1'b0;
						wr_num <= 3'd0;
						wr_type <= 4'd1;
						
						if(delay_abit >= oh_us_delay)begin
							if(cc_io_ctrl)
								main_fsm <= fsm_idle;
							bmc_wen <= 1'b1;
						end else begin
							delay_abit <= delay_abit + 1'b1;
						end
					end
				end