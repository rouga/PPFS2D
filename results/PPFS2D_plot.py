import numpy as np
import matplotlib.pyplot as plt 

file_name = input("Name of the output file to plot : ")

data = np.loadtxt(file_name, skiprows=2)
plt.plot(data[:,0],data[:,1],'-^')
plt.gca().invert_yaxis()
plt.show()
