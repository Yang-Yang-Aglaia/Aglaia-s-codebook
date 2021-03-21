#%%
## matplotlib inline
import pymc
import hddm  # 导入hddm模块
import matplotlib.pyplot as plt
print(hddm.__version__)   # 打印出hddm的版本号

#!head cavanagh_theta_nn.csv  # 判断是否存在这个文件？反正！表示的是非，及head后面的内容不为0则为真
# %%
import pandas as pd
import numpy as np

data = hddm.load_csv('E:\ScholarFight\Experiment design\Exp1\Data\Outcomes\Whole_Lead_data.csv')  #利用该函数导入数据
data.head(10)  #将数据以表格形式呈现
type(data)

grouped=data.groupby('SubNo')
print(grouped)

#%%
# 利用pandas’ groupby()的函数探讨每个被试的反应时分布
data = hddm.utils.flip_errors(data) # utils模块中Flip sign for lower boundary responses.
#这个方法感觉是可选的，因为该模块有其他选项

fig = plt.figure()
ax = fig.add_subplot(111, xlabel='RT', ylabel='count', title='RT distributions')
for i, subj_data in data.groupby('SubNo'):
    subj_data.rt.hist(bins=20, histtype='step', ax=ax)

plt.savefig('hddm_demo_fig_00.pdf')

# %%
# 利用pandas’ groupby()的函数探讨每个被试的反应时分布
data = hddm.utils.data_quantiles(data, quantiles=(0.1, 0.3, 0.5, 0.7, 0.9)) # utils模块中百分位数.
#这个方法感觉是可选的，因为该模块有其他选项
print(data)
type(data)  #转变后变成元组
len(data)

#print(data[1])
#type(data[1])   #numpy.ndarray
#%%
import pandas as pd

print pd.DataFrame(list(data))



#%%
fig = plt.figure()
ax = fig.add_subplot(111, xlabel='RT', ylabel='count', title='RT distributions')
for i, subj_data in data.groupby('SubNo'):
    subj_data.rt.hist(bins=20, histtype='step', ax=ax)

plt.savefig('hddm_demo_fig_01.pdf')
# 元组无法使用groupby函数


# %%
### Fitting a hierarchical model
# Instantiate model object passing it our data (no need to call flip_errors() before passing it).（实例化传递数据的模型对象（传递数据之前无需调用flip_errors（）））
# This will tailor an individual hierarchical DDM around your dataset.（这将围绕您的数据集定制单个分层DDM）
m = hddm.HDDM(data)  # Create hierarchical drift-diffusion model in which each subject has a set of parameters that are constrained by a group distribution

# find a good starting point which helps with the convergence.（找到一个帮助整合的好的起始点）
m.find_starting_values()

# start drawing 7000 samples and discarding 5000 as burn-in.（开始抽取7000个样本，然后丢掉不符合条件的5000个）
m.sample(2000, burn=20) # Sample from posterior
# 生成的结果是什么？！


#%%
# 打印出统计参数表以做分析
# m.print_stats() will print a table of summary statistics for each parameters’ posterior
stats = m.gen_stats()
stats[stats.index.isin(['a', 'a_std', 'a_subj.0', 'a_subj.1'])]
# the group mean parameter for threshold a, group variability a_std and individual subject parameters a_subj.0


# %%
# 画出autocorrelation，trace以及marginal posterior的图，以分析convergence的合适程度。
# look at is the trace, the autocorrelation, and the marginal posterior
m.plot_posteriors(['a', 't', 'v', 'a_std'])

# %%
# Gelman-Rubin统计量提供了更正式的收敛检验，该检验将链内方差与同一模型的不同run的链内方差进行比较
# a more formal test for convergence that compares the intra-chain variance to the intra-chain variance of different runs of the same model.
models = []
for i in range(5):
    m = hddm.HDDM(data)
    m.find_starting_values()
    m.sample(5000, burn=20)
    models.append(m)

hddm.analyze.gelman_rubin(models)
stats[stats.index.isin(['a', 'a_std', 'a_subj.0', 'a_subj.1'])]
# %%
# how well the model fits the data
m.plot_posterior_predictive(figsize=(14, 10))

# %%
# 讨论不同条件下的漂移率的变化。关于漂移率的获得，或许应该看一下HDDM函数本身看是怎么计算的。
m_stim = hddm.HDDM(data, depends_on={'v': 'Version'}) # Separate drift-rate parameters will be estimated for each stim
m_stim.find_starting_values()
m_stim.sample(10000, burn=1000)
# %%
# look at the posteriors of v for the different conditions，v是漂移率
v_WW, v_LL = m_stim.nodes_db.node[['v(1)', 'v(2)']]
hddm.analyze.plot_posterior_nodes([v_WW, v_LL])
plt.xlabel('drift-rate')
plt.ylabel('Posterior probability')
plt.title('Posterior of drift-rate group means')
plt.savefig('hddm_demo_fig_06.pdf')
# %%
# nodes_db which is a pandas DataFrame containing information about each distribution
# examine the proportion of the posteriors in which the drift rate for one condition is greater than the other
print "P(WW > LL) = ", (v_WW.trace() > v_LL.trace()).mean()
# %%
#
print "Lumped model DIC: %f" % m.dic
print "Stimulus model DIC: %f" % m_stim.dic
# %%
### Within-subject effects
# 讨论条件间的被试差异，即可能存在某种条件下的drift rate更大，但是单个被试的情况则不一定了
from patsy import dmatrix
dmatrix("C(Version, Treatment(1))", data.head(10))
# %%
# a descriptor that contains the string describing the linear model
m_within_subj = hddm.HDDMRegressor(data, "v ~ C(Version, Treatment(1))")
# %%
#
m_within_subj.sample(5000, burn=200)

#
v_WW, v_LL = m_within_subj.nodes_db.ix[["v_Intercept","v_C(Version, Treatment(1))[T.2]",'node']

hddm.analyze.plot_posterior_nodes([v_WW, v_LL])  #这里报错是不是因为需要三个条件？！
plt.xlabel('drift-rate')
plt.ylabel('Posterior probability')
plt.title('Group mean posteriors of within-subject drift-rate effects.')
plt.savefig('hddm_demo_fig_07.pdf')
# %%
