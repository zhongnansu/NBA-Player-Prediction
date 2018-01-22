from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import KFold
import numpy
from numpy import genfromtxt
import os
import thread


def torrentsHandler(path, name, list):
    if not os.path.exists(path):
        os.makedirs(path)
    spath = path + "/" + name + ".csv"
    with open(spath, "a") as fp:
        for s in list:
            fp.write("%s\n" %s)

def randomForest(train, target, nTree, maxFeatures):
    kfold = KFold(n_splits=20, shuffle=True)

    accuracy = []
    percision = []
    for trainIndex, testIndex in kfold.split(train):
        trainSample, testSample = train[trainIndex], train[testIndex]
        trainTarget, testTarget = target[trainIndex], target[testIndex]

        rf = RandomForestClassifier(n_estimators=nTree , max_features=maxFeatures)
        rf.fit(trainSample, trainTarget)
        predict = rf.predict(testSample)

        correctPrediction = 0
        for i in range(len(testTarget)):
            if predict[i] == testTarget[i]:
                correctPrediction += 1

        accuracy.append(float(correctPrediction)/len(predict))

    return numpy.mean(accuracy)







if __name__ == "__main__":
    train = genfromtxt(open('SFdataAfterPCA.csv', 'r'), delimiter=',', dtype='f8')
    target = genfromtxt(open('SFlabel.csv', 'r'), delimiter=',', dtype='f8')
    accruacy = []
    count = 1
    for i in range(1, 301, 3):
        iac =  randomForest(train, target, i, "auto")
        accruacy.append(iac)
        print "attmpt " + str(count) + ": " + str(iac)
        count += 1

    torrentsHandler(".","SFaccruacy", accruacy)

