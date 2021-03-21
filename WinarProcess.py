#%%
import numpy as np
from matplotlib import pyplot as plt



T=10
mu, sigma = 0.002, 0.1 # 均值和标准差

N=int(T/sigma)

s = np.random.normal(mu, np.sqrt(sigma), N)

z=np.cumsum(s)*np.sqrt(sigma)

t=list(range(N))

plt.plot(t,z)

# %%
