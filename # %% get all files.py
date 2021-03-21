# %% get all files
def get_filename(path, filetype):  # 输入路径、文件类型例如'.csv'
    name = []
    for root, dirs, files in os.walk(path):
        for i in files:
            if os.path.splitext(i)[1]==filetype:
                name.append(i)
    return name            # 输出由有后缀的文件名组成的列表



data_path = 'E:\\ScholarFight\\Experiment design\\Exp1\\Exp_procedure_PRE\\NorepPic'
filetype = '.jpg'
aab = get_filename(data_path,filetype)
