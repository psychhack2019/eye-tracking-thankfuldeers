import matplotlib.pyplot as plt
import sys

plt.figure(figsize=(5, 5))


plt.subplot(111)
x = ["a", "b", "c"]
y = [10, 50, 40]
err = [[1, 3, 2], [4, 2, 5]]
plt.xlabel('xaxis')
plt.ylabel('yaxis')
plt.bar(x, y, yerr=err, capsize=10, ecolor='#28C315')
plt.tight_layout()
plt.savefig("./static/img/test.png")
print('img/test.png')
sys.stdout.flush()
