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