module iic_uart(
	   clk,
		rst,
		data_32_1,
		data_32_2,
		data_32_3,
		data_16_1,
		data_16_2,
		data_16_3,
		uart_data,
		is_send,
		is_done
		);
	input clk,rst,is_done;
	input [31:0]data_32_1;
	input [31:0]data_32_2;
	input [31:0]data_32_3;
	input [15:0]data_16_1;
	input [15:0]data_16_2;
	input [15:0]data_16_3;
	output [7:0]uart_data;
	output is_send;
	reg [31:0]fclk;
	  /******************发送数据到串口32位，发四次*********/
	 
	 reg [31:0]Count_BPS;
	 reg q;
	 reg [7:0]rdata;
	 reg [4:0]i;
	 always @ ( posedge clk or negedge rst )
	    if(!rst )
		     begin Count_BPS <= 32'd0;i<=5'd0;fclk <= 32'd499999 ; end
		 else if( Count_BPS == fclk )	 
		     case (i)		  
			  0:
			  begin Count_BPS <= 32'd0;q<=1'b1;rdata<=data_16_1[15:8];i<=i+1'b1;Count_BPS <= 32'd0;end    // AX静止值  0x0F18		  
			  1:
			  begin Count_BPS <= 32'd0;q<=1'b1;rdata<=data_16_1[7:0];i<=i+1'b1;Count_BPS <= 32'd0;end  
			  2:
			  begin Count_BPS <= 32'd0;q<=1'b1;rdata<=data_16_2[15:8];i<=i+1'b1;Count_BPS <= 32'd0;end   //AZ  37FE
			  3:
			  begin Count_BPS <= 32'd0;q<=1'b1;rdata<=data_16_2[7:0];i<=i+1'b1;Count_BPS <= 32'd0;end
			  4:
			  begin Count_BPS <= 32'd0;q<=1'b1;rdata<=data_16_3[15:8];i<=i+1'b1;Count_BPS <= 32'd0;end    // AX静止值  0x0F18		  
			  5:
			  begin Count_BPS <= 32'd0;q<=1'b1;rdata<=data_16_3[7:0];i<=i+1'b1;Count_BPS <= 32'd0;end  
			  6:
			  begin Count_BPS <= 32'd0;q<=1'b1;rdata<= 8'hFF;i<=i+1'b1;Count_BPS <= 32'd0;end   //AZ  37FE
			  7:
			  begin Count_BPS <= 32'd0;q<=1'b1;rdata<= 8'hFF;i<=5'd0;Count_BPS <= 32'd0;end
				
			  endcase
		 else
		     begin Count_BPS <= Count_BPS + 1'b1;q<=1'b0;end
		  
 /********************************/
 
 reg ris_send;
 
 always@(posedge clk or negedge rst)
	  if(!rst)
		  ris_send<=1'b0;
		else 
			if(q)              //计算完成后，才发送出去
				ris_send<=1'b1;
			else if(is_done)           //串口发送完毕后就把发送信号关闭
				ris_send<=1'b0;
	
 assign is_send=ris_send;
 assign uart_data=rdata;

			
endmodule 