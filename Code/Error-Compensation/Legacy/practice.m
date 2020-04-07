[x,t] = simplefit_dataset;
net = feedforwardnet([10 10]);
net = train(net,x,t)
view(net)