# cmd: 
# for /R D:\Desktop\数据-5D %i in (Label) do @echo %i >> D:\Dropbox\CodeZ\annotation_counting\list0904.txt
import os
import shutil

def txt_read_in_lines(filepath, split=' '):
    arr = []
    # file = open(filepath)
    with open(filepath) as file:
        contents = file.readlines()
        for item in contents:
            content = item.strip()
            temp = content.split(split)
            arr.append(temp)
    return arr


def get_ext_list(path, extension='.txt'):
    file_list = os.listdir(path)
    out = []
    for i in file_list:
        if os.path.splitext(i)[1] == extension:
            out.append(i)
    # out = sorted(out, key=lambda x: x.split('.')[0])
    return out

label_txt = r'D:\Dropbox\CodeZ\annotation_counting\list0904.txt'
le = r'D:\Dropbox\CodeZ\annotation_counting\Train.txt'

label_list = txt_read_in_lines(label_txt)
train_list = txt_read_in_lines(le)

org = 'D:\\Desktop\\数据-5D\\'
new = 'D:\\Desktop\\数据-5D-train\\'

list_real = []
for l_folder_raw in label_list:
    l_folder = l_folder_raw[0]
    d_folder = os.path.split(l_folder)[0]
    if os.path.exists(l_folder) and get_ext_list(d_folder, '.jpg') and get_ext_list(d_folder, '.txt'):
        # find correct Label folder and count something
        list_real.append(l_folder)
# str(list_real)

for l_folder_raw in train_list:
    name = os.path.join(l_folder_raw[0].split('/')[0],l_folder_raw[0].split('/')[1])
    for m in list_real:
        if name in m:
            dir = os.path.join(new, m[len(org):])
            shutil.copytree(m, dir)
    # if/
    #     txt_list = get_ext_list(l_folder, '.txt')
    #
    #     for i in txt_list:
    #         with open(os.path.join(l_folder, i)) as file:
    #             contents = file.readlines()
    #             for item in contents:
    #                 content = item.strip()
    #                 temp = content.split()
    #                 if len(temp)%12 != 1:
    #                     print(l_folder, i, len(temp)%12, temp)




print('this')