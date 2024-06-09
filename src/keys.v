module keys(
    input CLOCK_50,
    input [3:0] keys,
    output reg [3:0] keysout
);
    reg [32:0] contador0;
    reg [32:0] contador1;
    reg [32:0] contador2;
    reg [32:0] contador3;

    always @(posedge CLOCK_50) begin
 
        if (!keys[0]) begin 
            contador0 = contador0 + 1;
            if (contador0 >= 500000) begin  
                contador0 = 0;
                keysout[0] = 1;
            end else begin
                keysout[0] = 0;
            end
        end else if (keys[0]) begin
            keysout[0] = 0;
        end 
        /*___________________________*/

        if (!keys[1]) begin
            contador1 = contador1 + 1;
            if (contador1 >= 500000) begin
                contador1 = 0;
                keysout[1] = 1;
            end
            else begin
                keysout[1] = 0;
            end
        end else if (keys[1]) begin
            keysout[1] = 0;
        end
        
        /*___________________________*/


        if (!keys[2]) begin
            contador2 = contador2 + 1;
            if (contador2 >= 500000) begin
                contador2 = 0;
                keysout[2] = 1;
            end
            else begin
                keysout[2] = 0;
            end
        end else if (keys[2]) begin
            keysout[2] = 0;
        end 
        
        /*___________________________*/


        if (!keys[3]) begin
            contador3 = contador3 + 1;
            if (contador3 >= 500000) begin
                contador3 = 0;
                keysout[3] = 1;
            end
            else begin
                keysout[3] = 0;
            end
        end else if (keys[3]) begin
            keysout[3] = 0;
        end  

    end
    
endmodule