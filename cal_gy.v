module cal_gy(
	   clk,
		rst,
		G,
		is_read,
		g_speed,
		gy
		);
    input clk,rst,is_read;
	 input [15:0]G;
	 output [31:0] g_speed;
    reg [31:0] gy_speed1;
	 output reg [15:0] gy;
	 		
always @ ( posedge clk or negedge rst )
	 if(!rst)
		gy<=16'd0;
	 else if(is_read)
		gy<=G;	 

 /* --------开始计算 陀螺仪得到的角度----------*/
    reg [3:0]i; 
	 reg [7:0]clk_100;
	 always @ ( posedge clk or negedge rst )
		 if(!rst)
		       begin 
				 i<=4'd0;
				 dataU1<=16'h0;
				 gy_speed1<=32'h0;
				 clk_100<=1'b0;
				 end
		 else
		    case (i)	 
			 0:                  // 等待一次is_read,读GY到gy
			 if(is_read) begin i<=i+1'b1;end    
			 else  i<=1'b0;
		    
			 1:                  //gy-漂移量 gy_offset 10  换成浮点数
			 if(clk_100==8'd0)     begin dataU1<=gy;clk_100<=1'b1;end
			 else if(clk_100==8'd100)   begin gy_speed1<=gyf;clk_100<=8'd0;i<=i+1'b1;end
			 else 
          clk_100<=clk_100+1'b1;
		    
			 2:
			 i<=1'b0;
			 endcase 
	 
reg[15:0] dataU1;
wire [31:0]gyf;
 

i16to32f U1(
	.clock(clk),
	.dataa(dataU1),
	.result(gyf)
	);
	

 
assign g_speed=gy_speed1;
	 
endmodule 