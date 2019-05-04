import matplotlib.pyplot as plt

plt.figure(figsize=(3, 3))


plt.subplot(111)
x = ["a", "b", "c"]
y = [10, 50, 40]
err = [[1, 3, 2], [4, 2, 5]]
plt.xlabel = 'xaxis'
plt.ylabel = 'xaxis'
plt.bar(x, y, yerr=err, capsize=10, ecolor='#28C315')
plt.show()
