## (1) How to compile and execute your program
把東西import然後直接simulation就好了
file structure長這樣
```txt=
./project_1.srcs
├── sources_1
│   └── imports
│   └── news
│      └── Buffer.v
│      └── counter.v
│      └── MUX_8to1.v
│      └── race_arbitar.v
│      └── ring_osi.v
│      └── scrambler.v
│      └── top_PUF.v
├── sim_1
│   └── imports
│   └── news
│      └── tb_PUF.v
```
:::danger
啊記得把tb_PUF設為TOP，不然牠會有問題。
:::

## (2) Describe your design philosophy and every module
### design philosophy
![SmartSelect_20240329_231720_Samsung Notes](https://hackmd.io/_uploads/SkCaj84yA.jpg)
其實應該跟老師上面畫得差不多，我這邊把他大至會go through甚麼寫過。首先，會有一個8 bits 的challenge經過scrambler，每個cycle都會產生一個新的prng。接著，我們拿個prng的前後各三碼來當成mux的sel。同時選取相對應的ring osi的instance，並且將相對應的output傳到counter裡面。同時，如果input signal為1的話，我們就會將counter + 1。當counter達到一定數字以後我們就會將done raise，arbitar會接到這個done並且將對應的數字傳回給buffer。當buffer裡面的數字共有八個以後，就會將challenge reset。
### every module

#### scrambler
```verilog=
module scrambler(input_challenge, clk, global_rst ,rst, output_challenge);
    input [7:0] input_challenge;
    input clk, rst;
    input global_rst;
    output reg [7:0] output_challenge;

    reg [7:0] lfsr_out;
    reg xnor_value;

    // 吃進去input_challenge 每次產生一個新的prng 並將其設為output challenge

endmodule
```

#### Mux
```verilog=
module MUX_8to1(a,b,c,d,e,f,g,h,sel,mux_out);
input a,b,c,d,e,f,g,h;
input [2:0] sel;	//from the output of scrambler
output reg mux_out;
// 就...mux
endmodule

```

#### counter
```verilog=
module counter(clk, rst, global_rst , signal, finished);
input signal;		//signal is the output from ring_osc_i
input clk, rst;
input global_rst;
output reg finished;   
// 當有signal就會把counter升上去，當到達37就直接raise finish
if(signal) begin
    if(count == 8'd37) begin
        count <= 8'b0;
        finished <= 1'b1;
    end
    else begin
        count <= count + 1;
        finished <= 1'b0;
    end

endmodule

```
#### race_arbiter
```verilog=
module race_arbiter(finished1, finished2, rst , global_rst , done , out);
input rst, finished1, finished2;
input global_rst;
output out;
output done;
// 收到counter的信號，就會將done傳給buffer，並且會將收到的訊號一並傳出去
endmodule
```

#### top_PUF

```verilog=
module top_PUF(clk, en, rst, chall_in, response, ready);
input clk, en, rst;
input[7:0] chall_in;
output[7:0] response;
output ready;
// 繁雜的接線
endmodule
```
#### ring_osc_i
```verilog=
module ring_osc_i(enable, rst, delay , out);
input enable, rst;
input [5:0] delay;// Parameter for delay time between stages
output out;
reg [14:0] ring_osc; // 14 inverters

// 收delay的input當成delay，同時用array 的reg來代表每次經過inverter的訊號

assign out = ring_osc[0];

endmodule
```

#### Buffer
```verilog=
module buffer(clk, rst, winner, done, response, ready_to_read , counter_rst, scrambler_rst, arbiter_rst);
input clk, rst;
input winner;	 //output of race_arbiter
input done;	 //output of race_arbiter
output reg[7:0] response;
output ready_to_read;	//ready to read response

//reset signal:pay attention to the order of resetting of these three
output counter_rst;	//reset counter while generating response
output scrambler_rst;	//reset scrambler while generating response 
output arbiter_rst;	//reset arbiter while generating response 

// 好的時候將ready設為1，其餘時間依據之前講過的方式將特定幾個rst設為true

endmodule
```

## (3) Please capture your simulation waveform and explain it
### overall 
![image](https://hackmd.io/_uploads/ryEcQP4kC.png)

他在同一個challenge的時候，response會逐漸變好，若是八個都好的時候就會raise ready。同時testbench就會吃進下一個Input challenge。

### scrambler
![image](https://hackmd.io/_uploads/rJTVVw4kR.png)
在同樣的input下面，他會一直跑，直到換下一個Input才重新換一個，並且重新開始generate prng。

### ring oscillator
![image](https://hackmd.io/_uploads/HJr5EDEy0.png)

ring oscillator會依據時間flip。

## (4) Show your calculation about Uniformity and Uniqueness and your discussion

:::    success
以下是我的parameter setting for delay
set 1 
(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
set 2
(10,4,8,15,9,7,2,3,13,1,16,5,14,6,11,12)
set 3 
(5,15,16,2,14,1,10,13,4,3,7,12,8,11,6,9)
set 4
(15,12,7,14,16,1,8,2,4,13,5,9,11,3,6,10)
set 5 
(12,3,1,7,16,11,9,6,10,13,5,14,4,8,15,2)
set 6
(11,12,4,2,15,8,3,13,6,1,14,5,16,9,10,7)
set 7
(16,14,8,10,7,9,13,3,12,15,5,11,4,2,1,6)
set 8
(2,9,5,12,10,4,15,6,7,3,1,11,13,16,8,14)
:::

### uniformity: 
![image](https://hackmd.io/_uploads/B1E8HPV1A.png)

#### generating of graph 
```python=
import matplotlib.pyplot as plt

def uniform(n : int):
    # Read the text file
    n_str = str(n)
    file_name = (f'set_{n_str}_out.txt')
    with open(file_name, "r") as file:
        lines = file.readlines()

    # Initialize dictionary to store counts of ratios
    ratio_counts = {}

    # Iterate through each line in the file
    for line in lines:
        # Extract the response number and the binary string
        parts = line.strip().split(" with response: ")
        response_number = parts[0].strip().split()[-1]
        binary_string = parts[1].strip()
        response_number = int(response_number.strip())
        binary_string = binary_string.strip()

        # Calculate the ratio of 1s in the binary string
        ratio = binary_string.count("1") / len(binary_string)

        # Update the dictionary with the ratio counts
        if ratio in ratio_counts:
            ratio_counts[ratio] += 1
        else:
            ratio_counts[ratio] = 1

    # Extract x and y values for plotting
    x_values = list(ratio_counts.keys())
    y_values = list(ratio_counts.values())
    uniform = 0
    for idx,val in enumerate(y_values):
        y_values[idx] = val/255
        uniform += y_values[idx]*x_values[idx]
    
    print(uniform)
    # Plot the graph
    plt.bar(x_values, y_values,width=0.1, color='blue')
    plt.xlabel('Ratio of 1s in the Response')
    plt.ylabel('Frequency')
    plt.title('Distribution of 1s in Responses')
    plt.savefig(f'set_{n_str}.png')
    
    
if __name__ == "__main__":
    for i in range(1, 9):
        uniform(i)
```
以下為兩張我生出來的graph，我認為他們的誤差是可以接受的，同時，根據整體運算來說，這八個set的uniform幾乎接近完美。
0.5315826330532212 - set 1
0.5181372549019608 - set 2
0.5078431372549019 - set 3
0.5166666666666666 - set 4
0.5254901960784314 - set 5
0.515686274509804 - set 6
0.5200980392156863 - set 7
0.5372549019607843 - set 7

![set_4](https://hackmd.io/_uploads/rJL2BDN10.png)

![set_7](https://hackmd.io/_uploads/Bk8pHw410.png)

### uniqueness
上面為每個request的response的uniqueness
![uniqueness](https://hackmd.io/_uploads/BJ--Dv4JR.png)
Total uniqueness is **0.4985119047619046**
我認為也是很好的
以下為python script
```python=
import matplotlib.pyplot as plt

storage = [[''] * 256 for _ in range(9)]
unique = [0] * 256

def gen_storage(n : int):
    global storage
    # Read the text file
    n_str = str(n)
    file_name = (f'set_{n_str}_out.txt')
    with open(file_name, "r") as file:
        lines = file.readlines()

    # Iterate through each line in the file
    for line in lines:
        # Extract the response number and the binary string
        parts = line.strip().split(" with response: ")
        response_number = parts[0].strip().split()[-1]
        binary_string = parts[1].strip()
        response_number = int(response_number.strip())
        binary_string = binary_string.strip()
        storage[n][response_number] = binary_string
        #print(f'n being {n} and num {response_number} with string {binary_string}')

def hamming_distance(s1, s2):
    return sum(c1 != c2 for c1, c2 in zip(s1, s2))

def uniqueness_cal():
    for num_response in range(1,256): # response number
        unique_in_res = 0
        for i in range(1,9-1): # i in k-1
            for j in range(i+1,9): # j in i+1 to k
                hamming_num =  hamming_distance(storage[i][num_response], storage[j][num_response])
                hamming_num /= 8 # 8 bit
                unique_in_res += hamming_num
        unique_in_res /= 28 # (k-1)k/2
        #print(f'Response {num_response} has uniqueness {unique_in_res}')
        unique[num_response] = unique_in_res

def print_storage():
    for i in range(1,9):
        print(f"Set {i}")
        for j in range(256):
            print(f"Response {j}: {storage[i][j]}")
        print()
    
if __name__ == "__main__":
    for i in range(1, 9):
        gen_storage(i)
        
    uniqueness_cal()
    # Create a list of indices for the x-axis
    indices = list(range(len(unique)))
    total_uniqueness = 0
    for element in unique:
        total_uniqueness += element
    total_uniqueness /= 255
    print(f'Total uniqueness is {total_uniqueness}')
    # Plot the bar graph
    plt.bar(indices, unique)

    # Set labels and title
    plt.xlabel('Response Number')
    plt.ylabel('Uniqeness')
    plt.title('Bar Graph of Uniqueness Values')
    # Set y-axis limit from 0 to 1
    plt.ylim(0, 1)
    plt.savefig('uniqueness.png')
```