import subprocess

# Testing speed of Beagle with different thread and memory sizes

threads = input("Number of threads to use: ")
mem = input("Amount of memory to use: ")

command = ['bash', 'beagle55test.sh', str(mem), '10280', str(threads)]

print("Running for small scaffold")
result = subprocess.run(command, capture_output=True, text=True)
print(result.stdout)

# print("Running for medium scaffold")
# command[3] = '733'
# result = subprocess.run(command, capture_output=True, text=True)
# print(result.stdout)

# print("Running for large scaffold")
# command[3] = '444'
# result = subprocess.run(command, capture_output=True, text=True)
# print(result.stdout)

# print("Running for Xl scaffold")
# command[3] = '807'
# result = subprocess.run(command, capture_output=True, text=True)
# print(result.stdout)

