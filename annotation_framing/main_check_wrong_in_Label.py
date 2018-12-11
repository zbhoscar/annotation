import os

def get_ext_list(path, extension='.txt'):
    file_list = os.listdir(path)
    out = []
    for i in file_list:
        if os.path.splitext(i)[1] == extension:
            out.append(i)
    # out = sorted(out, key=lambda x: x.split('.')[0])
    return out

folder = r'D:\Desktop\数据-5D\徐能\m22\6_142'
l_folder = os.path.join(folder, 'Label')

txt_list = get_ext_list(l_folder, '.txt')

for i in txt_list:
    with open(os.path.join(l_folder, i)) as file:
        contents = file.readlines()
        for item in contents:
            content = item.strip()
            temp = content.split()
            if len(temp)%12 != 1:
                print(i, len(temp)%12, temp)
