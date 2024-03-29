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