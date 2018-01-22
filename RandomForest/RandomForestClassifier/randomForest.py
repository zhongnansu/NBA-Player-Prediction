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
            fp.write("%s\n" % s)


def randomForest(train, target, nTree, maxFeatures):
    kfold = KFold(n_splits=20, shuffle=True)

    accuracy = []
    for trainIndex, testIndex in kfold.split(train):
        trainSample, testSample = train[trainIndex], train[testIndex]
        trainTarget, testTarget = target[trainIndex], target[testIndex]

        rf = RandomForestClassifier(n_estimators=nTree, max_features=maxFeatures)
        rf.fit(trainSample, trainTarget)
        predict = rf.predict(testSample)

        correctPrediction = 0
        temp = 0
        for i in range(len(testTarget)):
            if predict[i] == testTarget[i] :
                correctPrediction += 1


        accuracy.append(float(correctPrediction) / len(predict))

    return numpy.mean(accuracy)



def featureImportance(train, target, nTree, maxFeatures):
    global rforest
    kfold = KFold(n_splits=20, shuffle=True)


    for trainIndex, testIndex in kfold.split(train):
        trainSample, testSample = train[trainIndex], train[testIndex]
        trainTarget, testTarget = target[trainIndex], target[testIndex]

        rforest = RandomForestClassifier(n_estimators=nTree, max_features=maxFeatures)
        rforest.fit(trainSample, trainTarget)
        break

    return rforest.feature_importances_


def randomForestoof(train, target, nTree, maxFeatures):
    kfold = KFold(n_splits=20, shuffle=True)


    errorRate = []
    for trainIndex, testIndex in kfold.split(train):
        trainSample, testSample = train[trainIndex], train[testIndex]
        trainTarget, testTarget = target[trainIndex], target[testIndex]

        rf = RandomForestClassifier(n_estimators=nTree, max_features=maxFeatures, oob_score=True)
        rf.fit(trainSample, trainTarget)
        oob_error = 1 - rf.oob_score_
        errorRate.append(oob_error)






    return numpy.mean(errorRate)



if __name__ == "__main__":
    train = genfromtxt(open('dataBeforePCAstd.csv', 'r'), delimiter=',', dtype='f8')
    target = genfromtxt(open('overallLabel.csv', 'r'), delimiter=',', dtype='f8')
    accruacy = []
    count = 1
    # for i in range(1, 35):
    #     iac = randomForest(train, target, 60, i)
    #     accruacy.append(iac)
    #     print "attmpt " + str(count) + ": " + str(iac)
    #     count += 1
    #
    # torrentsHandler(".", "accruacyFordifferentM", accruacy)
    #
    # # accruacy = []
    # # count = 1
    # # for i in range(1, 301, 3):
    # #     iac = randomForest(train, target, i, "log2")
    # #     accruacy.append(iac)
    # #     print "attmpt " + str(count) + ": " + str(iac)
    # #     count += 1
    # #
    # # torrentsHandler(".", "beforePCAaccruacylog2", accruacy)

    # torrentsHandler(".", "featureImportanceByRF", featureImportance(train, target, 150, "sqrt"))


    for i in range(1, 150, 3):
        iac = randomForestoof(train, target, i, None )
        accruacy.append(iac)
        print "attmpt " + str(count) + ": " + str(iac)
        count += 1

    torrentsHandler(".", "oofErrorNone", accruacy)