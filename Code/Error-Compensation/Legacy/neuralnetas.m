function [vPcmd,wPcmd] = neuralnetas(vQ, wQ, vref, wref)
    X = [vref; wref; vQ; wQ];
    vPcmd = 0;
    wPcmd = 0;
    model = coder.loadDeepLearningNetwork('model.mat');
    Y_pred = predict(model, X);
    vPcmd = double(Y_pred(1));
    wPcmd = double(Y_pred(2));
end