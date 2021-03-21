##
import numpy as np
import networkx as nx
print("Hello world")

# 对称网络


G_symmetric = nx.Graph()
G_symmetric.add_edge('Amitabh Bachchan', 'Abhishek Bachchan')
G_symmetric.add_edge('Amitabh Bachchan', 'Aamir Khan')
G_symmetric.add_edge('Amitabh Bachchan', 'Akshay Kumar')
G_symmetric.add_edge('Amitabh Bachchan', 'Dev Anand')
G_symmetric.add_edge('Abhishek Bachchan', 'Aamir Khan')
G_symmetric.add_edge('Abhishek Bachchan', 'Akshay Kumar')
G_symmetric.add_edge('Abhishek Bachchan', 'Dev Anand')
G_symmetric.add_edge('Dev Anand', 'Aamir Khan')
