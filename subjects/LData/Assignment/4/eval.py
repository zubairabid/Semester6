import sys
import csv
import pickle
from sklearn_crfsuite import CRF, metrics, scorers

if len(sys.argv) < 3:
    print("Format: python ", sys.argv[0], " <path to model> <path to test file>")
else:
    modelpath = sys.argv[1]
    testfilepath = sys.argv[2]

    with open(modelpath, 'rb') as model:
        crf = pickle.load(model)

    with open(testfilepath, 'rb') as testfile:
        testcases = pickle.load(testfile)

    test_sentences = testcases['sentences']
    test_ancorra = testcases['ancorra']
    test_features = testcases['features']

    pred_ancorra = crf.predict(test_features)
    print("F1 score on Test Data ")
    print(metrics.flat_f1_score(test_ancorra, pred_ancorra, average='weighted',labels=crf.classes_))
### Look at class wise score
    print(metrics.flat_classification_report(
        test_ancorra, pred_ancorra, labels=crf.classes_, digits=3
    ))

    
