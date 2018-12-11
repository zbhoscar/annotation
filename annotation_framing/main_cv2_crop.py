import cv2
import os

orig = r'D:\Desktop\5D.d1.orig'
sav1 = r'D:\Desktop\5D.d1.save1'
sav2 = r'D:\Desktop\5D.d1.save2'

for i in os.listdir(orig):
    if not os.path.exists(os.path.join(sav1, i)):
        os.makedirs(os.path.join(sav1, i))
    if not os.path.exists(os.path.join(sav2, i)):
        os.makedirs(os.path.join(sav2, i))
     # l.split('(')[1].split(')')[0]
    list_out = sorted(os.listdir(os.path.join(orig, i)), key=lambda x: int(x.split('(')[1].split(')')[0]))
    for k, j in enumerate(list_out):
        ks = ("%03d" % (k+1) ) + '.png'
        xiangdui = os.path.join(i,ks)
        readpath = os.path.join(orig,xiangdui)
        savepath1 = os.path.join(sav1,xiangdui)
        savepath2 = os.path.join(sav2,xiangdui)

        print(xiangdui, j)
        print(readpath)
        print(savepath1)
        print(savepath2)

        img = cv2.imread(readpath)
        img1 = img[1020-967:1020,1314-1305:1314]
        img2 = img[217-138:217,1855-537:1855]
        cv2.imwrite(savepath1, img1)
        cv2.imwrite(savepath2, img2)
        # print('test')

        # # if show:
        # cv2.namedWindow('image')
        # cv2.imshow('image', img)
        # cv2.waitKey(1000/25)
        # cv2.destroyAllWindows()

print('dan')







