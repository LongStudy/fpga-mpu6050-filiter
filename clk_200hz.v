module clk_200hz(
	clk,rst,is_read,init_done
    );
	 
input clk,rst,init_done;
output reg is_read;//5ms中断信号，开始采集数据，处理 5ms一个高脉冲

 /* --------5ms读取一次---------*/  
reg [20:0]Count;          
always @ ( posedge clk or negedge rst )
	if( !rst )
		Count<= 20'd0;
	else if(Count==25'd250_000)
		begin Count <= 20'd0;is_read<=1'b1;end
	else if(init_done==1'd1)
		begin Count <= Count + 1'b1;is_read<=1'b0;end
	else 
		Count <= 1'b0;
endmodule
