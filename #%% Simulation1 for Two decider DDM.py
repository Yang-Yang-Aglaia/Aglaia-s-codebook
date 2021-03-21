#%% Simulation1 for Two decider DDM
import math
import numpy as np
import matplotlib.pyplot as plt
#def ProDensity(D, miu1, miu2, theta1, theta2, m):

#%% 求解微分方程
h = miu# 步长，是不是就是漂移率?!
C = zeros([2*theta+1],[m+1])
Space = arange(-theta,(2*theta+1)*h, h)  # 构建空间
### 边界条件
for i in arange(0,m):
    C[0,m] = 0.0
    C[2theta,m] = 0.0
    t = t + dt

#%% 解出的关于x和t的函数
def c_function(D, miu, theta, m, x):  #傅里叶解
    opt1 = math.exp((miu * x)/(2*D))
    if (t != 0) & (x != theta):
        for mi in range(1, m):
            w = ((2*mi-1)*math.pi)/(2*theta),
            # print(w)
            k = pow(miu, 2)/(4*D) + D * pow(w, 2),
            # print(k)
            opt2 = pow(-1, (mi+1)),
            # print(opt2)
            opt3 = math.exp((-k) * t),
            # print(opt3)
            opt4 = math.sin((w*(x + theta)),
            # print(opt4)
            opt5 = (opt1/(2*theta)) * (opt2) * (opt3) * (opt4),
            opt_data = opt_data.append(opt5),
            final_outcome = sum(opt_data),
    return final_outcome
#print(Sumcxt)
    # elif x == theta:
    # Sumcxt = 0









#%%
D=1
miu = 0.75
miu2 = - o.75
theta =  1
theta2 = 1
m = 100
x = [-1,1]
aaaa = c_function(1, 0.75, 1, 100, x)



# %%
def