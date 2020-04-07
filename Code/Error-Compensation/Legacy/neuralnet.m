function [vPcmd,wPcmd] = neuralnet(vQ, wQ, vref, wref)
    X = [vref; wref; vQ; wQ];
    m = load('model.mat');
    model = m.model
    Y_pred = predict(model, X);
    vPcmd = Y_pred(1);
    wPcmd = Y_pred(2);
end