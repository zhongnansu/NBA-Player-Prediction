from sklearn.ensemble import RandomForestRegressor
from numpy import genfromtxt, savetxt, mean
import os

def torrentsHandler(path, name, list):
    if not os.path.exists(path):
        os.makedirs(path)
    spath = path + "/" + name + ".csv"
    with open(spath, "a") as fp:
        for s in list:
            fp.write("%s\n" % s)

def rfReg(data, WS):
    size = len(data)



    rf = RandomForestRegressor(n_estimators=100, max_features='sqrt')
    rf.fit(data,WS)

    return rf


train = genfromtxt(open('data_train.csv', 'r'), delimiter=',', dtype='f8')
WS = genfromtxt(open('trainWS.csv', 'r'), delimiter=',', dtype='f8')
WS_test = genfromtxt(open('testWS.csv', 'r'), delimiter=',', dtype='f8')
sample = genfromtxt(open('data_test.csv', 'r'), delimiter=',', dtype='f8')

WS_prediction = []
for s in sample:
    WS_prediction.append(rfReg(train, WS).predict([s]))

WS_prediction = zip(WS_prediction, WS_test)
se = []

for prediction, real in WS_prediction:
    se.append((prediction[0] - real) ** 2)

torrentsHandler(".", "regressorResult", se)