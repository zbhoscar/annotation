import numpy as np
import os
import warnings
import pickle
import random
import math
import platform
from collections import Counter

s = 1042141
print(s)
random.seed(s)
warnings.filterwarnings("ignore")


class Database():
    def __init__(self, path_person, path_time):
        super(Database, self).__init__()
        self.TimeList = self.getTimeList(path_time)
        self.Labelmap = self.LabelMap()
        if not hasattr(self, 'DataMorning'):
            self.Morning_Low, self.Morning_High, self.Night_Low, self.Night_High = self.ReadDataFromAnno(path_person)
        if not hasattr(self, 'MorningByClass'):
            self.MLByClass = self.splitByClass('Morning', 'Low')
            self.MHByClass = self.splitByClass('Morning', 'High')
            self.NLByClass = self.splitByClass('Night', 'Low')
            self.NHByClass = self.splitByClass('Night', 'High')
        if not hasattr(self, 'MorningByTraject') or not hasattr(self, 'MorningTrajectLength'):
            self.MLByTrajectL, self.MLByTraject = self.splitByTraject('Morning', 'Low', CarThred=5, PedThred=10)
            self.MHByTrajectL, self.MHByTraject = self.splitByTraject('Morning', 'High', CarThred=5, PedThred=10)
            self.NLByTrajectL, self.NLByTraject = self.splitByTraject('Night', 'Low', CarThred=5, PedThred=10)
            self.NHByTrajectL, self.NHByTraject = self.splitByTraject('Night', 'High', CarThred=5, PedThred=10)

    def RePair(self, TrainRatio = 0.6):
        list1 = []
        list2 = []
        list3 = []
        list4 = []
        # MH NH ML NL：白高，黑高，白低，黑低： 0, 1, 2, 3
        TrajectDatabase, TrajectSetname, TrajectLength, SetListMH = self.splitTrainTest('Morning', 'High', TrainRatio)
        list1.append(TrajectDatabase)
        list2.append(TrajectSetname)
        list3.append(TrajectLength)
        list4.append(SetListMH)
        # print('Morning,High')
        # print(TrajectLength[0][0].__len__())
        # print(TrajectLength[1][0].__len__())
        # print(TrajectLength[0][1].__len__())
        # print(TrajectLength[1][1].__len__())
        # print(TrajectLength[0][2].__len__())
        # print(TrajectLength[1][2].__len__())
        # print(sum(TrajectLength[0][0]))
        # print(sum(TrajectLength[1][0]))
        # print(sum(TrajectLength[0][1]))
        # print(sum(TrajectLength[1][1]))
        # print(sum(TrajectLength[0][2]))
        TrajectDatabase, TrajectSetname, TrajectLength, SetListNH = self.splitTrainTest('Night', 'High', TrainRatio)
        list1.append(TrajectDatabase)
        list2.append(TrajectSetname)
        list3.append(TrajectLength)
        list4.append(SetListNH)
        # print('Night,High')
        # print(TrajectLength[0][0].__len__())
        # print(TrajectLength[1][0].__len__())
        # print(TrajectLength[0][1].__len__())
        # print(TrajectLength[1][1].__len__())
        # print(TrajectLength[0][2].__len__())
        # print(TrajectLength[1][2].__len__())
        # print(sum(TrajectLength[0][0]))
        # print(sum(TrajectLength[1][0]))
        # print(sum(TrajectLength[0][1]))
        # print(sum(TrajectLength[1][1]))
        # print(sum(TrajectLength[0][2]))
        # print(sum(TrajectLength[1][2]))
        TrajectDatabase, TrajectSetname, TrajectLength, SetListML = self.splitTrainTest('Morning', 'Low', TrainRatio)
        list1.append(TrajectDatabase)
        list2.append(TrajectSetname)
        list3.append(TrajectLength)
        list4.append(SetListML)
        # print('Morning,Low')
        # print(TrajectLength[0][0].__len__())
        # print(TrajectLength[1][0].__len__())
        # print(TrajectLength[0][1].__len__())
        # print(TrajectLength[1][1].__len__())
        # print(TrajectLength[0][2].__len__())
        # print(TrajectLength[1][2].__len__())
        # print(sum(TrajectLength[0][0]))
        # print(sum(TrajectLength[1][0]))
        # print(sum(TrajectLength[0][1]))
        # print(sum(TrajectLength[1][1]))
        # print(sum(TrajectLength[0][2]))
        # print(sum(TrajectLength[1][2]))
        TrajectDatabase, TrajectSetname, TrajectLength, SetListNL = self.splitTrainTest('Night', 'Low', TrainRatio)
        list1.append(TrajectDatabase)
        list2.append(TrajectSetname)
        list3.append(TrajectLength)
        list4.append(SetListNL)
        print('Night Low')
        # print(TrajectLength[0][0].__len__())
        # print(TrajectLength[1][0].__len__())
        # print(TrajectLength[0][1].__len__())
        # print(TrajectLength[1][1].__len__())
        # print(TrajectLength[0][2].__len__())
        # print(TrajectLength[1][2].__len__())
        # print(sum(TrajectLength[0][0]))
        # print(sum(TrajectLength[1][0]))
        # print(sum(TrajectLength[0][1]))
        # print(sum(TrajectLength[1][1]))
        # print(sum(TrajectLength[0][2]))
        # print(sum(TrajectLength[1][2]))
        # print(sum(TrajectLength[1][2]))
        # 总轨迹数目
        # print(TrajectLength[1][0].__len__() + TrajectLength[0][0].__len__())
        # print(TrajectLength[1][1].__len__() + TrajectLength[0][1].__len__())
        # print(TrajectLength[1][2].__len__() + TrajectLength[0][2].__len__())
        # 总轨迹长度
        # print(sum(TrajectLength[0][0]) + sum(TrajectLength[1][0]))
        # print(sum(TrajectLength[0][1]) + sum(TrajectLength[1][1]))
        # print(sum(TrajectLength[0][2]) + sum(TrajectLength[1][2]))
        f1 = open('morning_high_train.txt', 'w')
        s = [i + '\n' for i in SetListMH[0]]
        f1.writelines(s)
        f1.close()
        # return TrajectDatabase, TrajectSetname, TrajectLength, SetListNH
        return list1, list2, list3, list4

    def ReadDataFromAnno(self, path_person):
        Morning_Low, Morning_High, Night_Low, Night_High = {}, {}, {}, {}
        for setPerson in os.listdir(path_person):
            subsetPath = os.path.join(path_person, setPerson)
            for subsetPerson in os.listdir(subsetPath):
                setPath = os.path.join(subsetPath, subsetPerson)
                for subset in os.listdir(setPath):

                    if subset == '4_255':
                        s = 1
                    try:
                        int(subset[0])
                    except:
                        continue
                    print(setPath, subset)
                    setLabelPath = os.path.join(setPath, subset, 'Label')
                    labelfile = np.zeros((0, 14))
                    consider = True
                    if not os.path.isdir(setLabelPath):  # 部分没有目标的序列没有Label文件夹
                        continue
                    for label_name in os.listdir(setLabelPath):
                        try:
                            frame_idx = int(label_name[:6])
                        except:
                            continue
                        try:
                            label = np.genfromtxt(os.path.join(setLabelPath, label_name), delimiter='')
                        except:
                            s = 1
                        if label.size < 13:
                            # 不含目标
                            continue
                        if label.size == 13:
                            label = label.reshape((label.size // 13, 13))
                        '''
                        if label[0,1]==2 or label[0,1]==5 or label[0,1]==7:
                        #自车非直行任务
                            consider=False
                            break
                        if label[0,2]!=2 and label[0,2]!=5 and label[0,2]!=1:
                            #自车非直行行为
                            consider=False
                            break
                        '''
                        frame_idx = np.ones((label.shape[0], 1)) * frame_idx
                        # add frame number
                        # 帧号 序号，任务，自主车辆行为，类别，行为，中心（ground），长，宽，方向，高度
                        label = np.concatenate((frame_idx, label), 1)
                        labelfile = np.append(labelfile, label, 0)
                    t = int(subset[0])
                    if subset in self.List_morning and consider:
                        if t == 1 or t == 2 or t == 4:  # 低密度
                            exec('Morning_Low[' + "'" + subset + "'" + '] = labelfile')
                        else:
                            exec('Morning_High[' + "'" + subset + "'" + '] = labelfile')
                    else:
                        if t == 1 or t == 2 or t == 4:  # 低密度
                            exec('Night_Low[' + "'" + subset + "'" + '] = labelfile')
                        else:
                            exec('Night_High[' + "'" + subset + "'" + '] = labelfile')

        return Morning_Low, Morning_High, Night_Low, Night_High

    def splitByTraject(self, Time, Density, CarThred=10, PedThred=5):
        if Time == 'Morning':
            if Density == 'Low':
                DataSet = self.MLByClass
            else:
                DataSet = self.MHByClass
        elif Time == 'Night':
            if Density == 'Low':
                DataSet = self.NLByClass
            else:
                DataSet = self.NHByClass
        TrajectSet = [[], [], []]
        TrajectLength = [[], [], []]
        for objectClass, datasets in enumerate(DataSet):  # objectclass=0,1,2
            if objectClass == 0:
                LengthThred = PedThred
            else:
                LengthThred = CarThred

            for set in datasets.keys():
                setData = datasets[set]
                idList = np.unique(setData[:, 1]).tolist()
                for ind, obji in enumerate(idList):
                    # Extract trajectories of one object
                    Trajectory_obj = setData[setData[:, 1] == obji, :]
                    if Trajectory_obj.shape[0] > LengthThred:
                        Trajectory_obj = Trajectory_obj[:, [0, 1, 3, 5, 6, 7]]
                        TrajectSet[objectClass].append(Trajectory_obj)
                        TrajectLength[objectClass].append(Trajectory_obj.shape[0])
        return TrajectSet, TrajectLength

    def splitByClass(self, Time, Density):
        if Time == 'Morning':
            if Density == 'Low':
                DataSet = self.Morning_Low
            else:
                DataSet = self.Morning_High
        elif Time == 'Night':
            if Density == 'Low':
                DataSet = self.Night_Low
            else:
                DataSet = self.Night_High

        DataSetByClass = [{}, {}, {}]
        for seti in DataSet.keys():
            data = DataSet[seti]
            dataCar = data[data[:, 4] == 2, :]
            dataPed = data[data[:, 4] == 1, :]
            dataCycle = data[data[:, 4] == 3, :]
            if dataCar.size > 0:
                DataSetByClass[1][seti] = dataCar
            if dataPed.size > 0:
                DataSetByClass[0][seti] = dataPed
            if dataCycle.size > 0:
                DataSetByClass[2][seti] = dataCycle
        return DataSetByClass

    def splitTrainTest(self, Time, Density, TrainRatio=0.5, LengthThred=10):
        print(self.Morning_Low)
        def txt_read_in_lines(ppp, split=' '):
            arr = []
            # file = open(filepath)
            with open(ppp) as file:
                contents = file.readlines()
                for item in contents:
                    content = item.strip()
                    temp = content.split(split)
                    arr.append(temp)
            return arr
        SetList = {}
        DataSet = {**self.Morning_Low, **self.Morning_High, **self.Night_Low, **self.Night_High}
        if Time == 'Morning':
            if Density == 'Low':

                SetList[0] = [i[0] for i in txt_read_in_lines('morning_low_train.txt', split=' ')]
                SetList[1] = [i[0] for i in txt_read_in_lines('morning_low_test.txt', split=' ')]
            else:

                SetList[0] = [i[0] for i in txt_read_in_lines('morning_high_train.txt', split=' ')]
                SetList[1] = [i[0] for i in txt_read_in_lines('morning_high_test.txt', split=' ')]
        elif Time == 'Night':
            if Density == 'Low':

                SetList[0] = [i[0] for i in txt_read_in_lines('night_low_train.txt', split=' ')]
                SetList[1] = [i[0] for i in txt_read_in_lines('night_low_test.txt', split=' ')]
            else:

                SetList[0] = [i[0] for i in txt_read_in_lines('night_high_train.txt', split=' ')]
                SetList[1] = [i[0] for i in txt_read_in_lines('night_high_test.txt', split=' ')]
        # SetList = {}
        # key_list = sorted(DataSet)
        # # key_list = list(DataSet)
        # random.shuffle(key_list)
        # random.shuffle(key_list)
        # random.shuffle(key_list)
        # split = math.ceil(len(key_list) * TrainRatio)
        # SetList[0] = key_list[:split]  # train set name
        # SetList[1] = key_list[split:]  # test set name
        TrajectSetname = [[[], [], []], [[], [], []]]
        TrajectDatabase = [[[], [], []], [[], [], []]]
        TrajectLength = [[[], [], []], [[], [], []]]
        for seti in range(2):  # train test
            for setname in SetList[seti]:
                if setname in DataSet.keys():
                    data = DataSet[setname]
                    for objclass in range(3):
                        setdata = data[data[:, 4] == objclass + 1, :]
                        if not setdata.size > 0:
                            continue
                        idList = np.unique(setdata[:, 1]).tolist()
                        for ind, obji in enumerate(idList):
                            # Extract trajectories of one object
                            Trajectory_obj = setdata[setdata[:, 1] == obji, :]
                            if Trajectory_obj.shape[0] > LengthThred:
                                Trajectory_obj = Trajectory_obj[:, [0, 1, 3, 5, 6, 7]]
                                TrajectDatabase[seti][objclass].append(Trajectory_obj)
                                TrajectSetname[seti][objclass].append(setname)
                                TrajectLength[seti][objclass].append(Trajectory_obj.shape[0])
                else:
                    print(setname)
        return TrajectDatabase, TrajectSetname, TrajectLength, SetList

    def getTimeList(self, pathtime):
        file_morning = open(pathtime + 'morning.txt')
        self.List_morning = file_morning.read().splitlines()
        file_night = open(pathtime + 'night.txt')
        self.List_night = file_night.read().splitlines()

    class LabelMap():
        def __init__(self):
            self.Task = dict(zip([1, 2, 3, 4, 5, 6, 7],
                    ['高速低密直行', '高速低密超车', '高速高密直行', '城区低密直行', '城区低密超车', '高速高密直行', '十字路口']))
            self.Behavior = dict(zip([1, 2, 3, 4, 5, 6, 7, 8],
                    ['直行减速', '直行加速', '左转', '右转', '匀速直行', '左换道', '右换道', '停车']))
            self.Class = dict(zip([1, 2, 3],
                    ['行人', '车', '骑行者']))
            self.ActionCar = dict(zip([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
                    ['左超车', '右超车', '正前方车辆减速', '向左驶离车道', '向右驶离车道',
                     '向左驶入车道', '向右驶入车道', '加速直行', '匀速直行', '左平行', '右平行',
                     '驻停','其他']))
            self.ActionPed = dict(zip([1, 2, 3, 4, 5, 6, 7, 8],
                    ['背沿边直行靠近', '面沿边直行靠近', '向左跑步横穿', '向左漫步横穿', '向右跑步横穿',
                     '向右漫步横穿', '驻停', '其他']))
            self.ActionCycle = dict(zip([1, 2, 3, 4, 5, 6, 7],
                    ['背沿边直行靠近', '背沿边直行远离', '面沿边直行靠近', '向左骑行横穿', '向右骑行横穿', '驻停', '其他']))


if __name__ == '__main__':
    if platform.system() == 'Windows':
        path_person = r'D:\Desktop\数据-5D-train'
        path_time = r'D:\Dropbox\CodeZ\annotation_counting\datapreprocess_zp\databydate/'
        path_save = r'D:\Dropbox\CodeZ\annotation_counting\datapreprocess_zp\Database013567t.cpkl'
    elif platform.system() == 'Darwin':
        path_person = r'D:\Desktop\数据-5D'
        path_time = r'/Users/zhangbohua/Dropbox/CodeZ/annotation_counting/datapreprocess_zp/databydate/'
        path_save = r'/Users/zhangbohua/Dropbox/CodeZ/annotation_counting/datapreprocess_zp/Database013567.cpkl'
    if not os.path.exists(path_save):
        database = Database(path_person, path_time)
        f = open(path_save, "wb")
        pickle.dump(database, f, protocol=2)
    else:
        f = open(path_save, "rb")
        database = pickle.load(f)
        database.RePair()
    f.close()


    def self_action_counting(test):
        sudict = {}
        for i in test:  # 0\1\2
            for key in i.keys():
                if key not in sudict.keys():
                    sudict[key] = i[key]
                else:
                    sudict[key] = np.vstack((sudict[key], i[key]))
        return sudict


    def get_np_dict(y, min_len=8):
        key = np.unique(y)
        result = {}
        for k in key:
            mask = (y == k)
            mask = mask.tolist()
            mask.append(False)
            fine = [1 if mask[i] != mask[i - 1] else 0 for i in range(len(mask))]
            wz = [i for (i, j) in enumerate(fine) if j == 1]
            chang_list = [wz[2*i+1]-wz[2*i] for i in range(int(len(wz)/2))]
            chang_list = [j for j in chang_list if j >= min_len]
            result[k] = chang_list
        return result

    def get_np_dict_old(y):
        key = np.unique(y)
        result = {}
        for k in key:
            mask = (y == k)
            y_new = y[mask]
            v = y_new.size
            result[k] = v
        return result


    def print_act_sp_fm(dbMHetc):
        check = self_action_counting(dbMHetc)
        tong_ji = {}
        for key in check.keys():
            temp = check[key]
            arry = temp[temp[:, 0].argsort()]
            pr_frame = -1
            del_list = []
            for i in range(len(arry)):
                if arry[i][0] == pr_frame:
                    del_list.append(i)
                pr_frame = arry[i][0]
            arryf = np.delete(arry, del_list, axis=0)
            # check[key] = arryf
            self_act = get_np_dict(arryf[:, 3])
            kk = str(list(self_act.keys()))
            if kk not in tong_ji.keys():
                tong_ji[kk] = {key: self_act}
            else:
                tong_ji[kk] = {**tong_ji[kk], **{key: self_act}}
        for i in range(1, 11):
            name = str(i) + '.0'
            sp_sum = 0
            fm_sum = 0
            for ke in tong_ji.keys():
                if name in ke:
                    sp_sum = sp_sum + len(tong_ji[ke])
                    for fm in tong_ji[ke].keys():
                        fm_sum = fm_sum + sum(tong_ji[ke][fm][float(name)])
            print(int(float(name)), sp_sum, fm_sum)
        return tong_ji


    def list_to_consec(ilist):
        out_list = []
        count = 1
        for i in range(1, len(ilist)):
            if ilist[i] == ilist[i - 1]:
                count = count + 1
            else:
                out_list.append(count)
                count = 1
        out_list.append(count)
        return out_list


    def wash_traj_act(inp, max_num=100, min_len=5):
        nplist = inp.tolist()
        colist = list_to_consec(nplist)
        wash_done = False
        while wash_done == False:
            tmp = nplist
            mi = min(colist)
            if mi == 1:
                cosmp = [i for i, v in enumerate(colist) if v == mi]
                for wh in cosmp:
                    if wh != 0 and wh != len(colist) - 1:
                        tmp[sum(colist[:wh])] = tmp[sum(colist[:wh - 1])]
                    elif wh == 0:
                        tmp[sum(colist[:wh])] = tmp[sum(colist[:wh + 1])]
                    elif wh == len(colist) - 1:
                        tmp[sum(colist[:wh])] = tmp[sum(colist[:wh - 1])]
            elif mi <= min_len:
                cosmp = [i for i, v in enumerate(colist) if v == mi]
                for wh in cosmp:
                    if wh != 0 and wh != len(colist) - 1:
                        if tmp[sum(colist[:wh - 1])] == tmp[sum(colist[:wh + 1])]:
                            tmp[sum(colist[:wh]):sum(colist[:wh + 1])] = [tmp[sum(colist[:wh - 1])] for i in range(mi)]
            if tmp == nplist:
                wash_done = True
            nplist = tmp
        oput = [min(i, max_num) for i in nplist]
        oput = np.array(oput, float)
        return oput


    def other_act(datatrajl, num):
        output = {}
        for i in range(0, len(datatrajl)):
            tmp = get_np_dict(wash_traj_act(datatrajl[i][:, 3], max_num=num, min_len=3))
            wt_key = str(list(tmp.keys()))
            if wt_key not in output.keys():
                output[wt_key] = {i: tmp}
            else:
                output[wt_key] = {**output[wt_key], **{i: tmp}}
        print_thing = []
        for i in range(1, num + 1):
            name = str(i) + '.0'  # 2.0
            sp_sum = 0
            fm_sum = 0
            list_len = []
            for ke in output.keys():
                if name in ke.strip('[').strip(']').split(', '):  # ['[1.0, 4.0, 12.0]', '[4.0]'...
                    sp_sum = sp_sum + sum([len(output[ke][i][float(name)]) for i in output[ke]])
                    fm_sum = fm_sum + sum([sum(output[ke][i][float(name)]) for i in output[ke]])
                    for kek in output[ke].keys():
                        list_len.extend(output[ke][kek][float(name)])
            list_len = [int((i - 1) / 10) for i in list_len]
            list_len_dict = get_np_dict_old(np.array(list_len))
            # print(int(float(name)), sp_sum, fm_sum, list_len_dict)
            print_thing.append([int(float(name)), sp_sum, fm_sum, list_len_dict])
        return output, print_thing


    # see_what_act(database.MHByClass[1], num=1)
    def see_what_act(inp, num=1):
        for key in inp.keys():
            if num in inp[key][:, 5]:
                print(key)


    def counting_sum(act_in_mnhl, idd=[2, 3]):  # index=[0,1] or [2,3]
        # print('summing')
        inthis = [v for i, v in enumerate(act_in_mnhl) if i in idd]
        for k in range(len(inthis[0])):
            list_dict = [i[k][3] for i in inthis]
            test = Counter(list_dict[0])
            if len(list_dict) > 1:
                for z in range(1, len(list_dict)):
                    test = test + Counter(list_dict[z])
            # Counter(list_dict[0]) + Counter(list_dict[1])
            abcd = [test[m] for m in range((-1 if len(test.keys()) == 0 else max(test.keys())) + 2)]
            print(sum([i[k][0] for i in inthis]) / len(idd),
                  sum([i[k][1] for i in inthis]),
                  sum([i[k][2] for i in inthis]),
                  ' '.join([str(y) for y in abcd]))


    def other_act_all(i=0):
        if i == 0:
            j = 8
        elif i == 1:
            j = 13
        elif i == 2:
            j = 7
        else:
            j = 8888
            exit('wrong i')
        list_MNHL = [other_act(database.MHByTrajectL[i], j), other_act(database.NHByTrajectL[i], j),
                     other_act(database.MLByTrajectL[i], j), other_act(database.NLByTrajectL[i], j)]
        trajectorytype_dict_MH_NH_ML_NL = [i[0] for i in list_MNHL]
        act_counting_dict_MH_NH_ML_NL = [i[1] for i in list_MNHL]
        return trajectorytype_dict_MH_NH_ML_NL, act_counting_dict_MH_NH_ML_NL

    # abc = print_act_sp_fm(database.MHByClass)
    # fine = other_act(database.MHByTrajectL[0], )

    [dict0, ac_of_kind0] = other_act_all(0)
    [dict1, ac_of_kind1] = other_act_all(1)
    [dict2, ac_of_kind2] = other_act_all(2)

    # MH NH ML NL：白高，黑高，白低，黑低： 0, 1, 2, 3
    def see_all(ininin):
        counting_sum(ininin, [0])
        counting_sum(ininin, [1])
        counting_sum(ininin, [2])
        counting_sum(ininin, [3])

    # counting_sum(ac_of_kind0, [0, 1])
    see_all(ac_of_kind0)

    print('Debug above line to evaluate database')
