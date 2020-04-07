function [vPcmd, wPcmd] = NeuralNetworkController[vref, wref, vQ, wQ]
    
    eta = 0.001;
    
    In = 2;
    H1 = 4;
    H2 = 3;
    Out = 2;
    
    errorV = 0;
    errorW = 0;
    % Initialise Weights
    W1 = 2*(rand(H1, 3) - rand(H1, 3));
    W2 = 2*(rand(H2, H1+1) - rand(H2, H1+1);
    W3 = 2*(rand(No, H2+1) - rand(No, H2+1);
    
    % Forward Process
    X = [1; vref; wref]
    E = [vref - vQ ; wref - wQ];
    % Hidden 1
    for i = 1:H1
        V1(i) = W1(i,:)*X(:);
        O1(i) = tansig(V1(i));
    end
    
    % Hidden 2 
    for i = 1:H2
        V2(i) = W2(i, :)*[1;O1'];
        O2(i) = tansig(V2(i));
    end
        
    %Output 
    for i = 1:Out
        V3(i) = W3(i, :)*[1;O2'];
        Y(i) = V3(i);
    end
    
    vPcmd = Y(1);
    wPcmd = Y(2);
    
    % Backward Process
    for i=1:Out
        De3(i) = E(i)
    end
    for i=1:H2
        De2(i) = (1-O2(i)^2)*W3(:,i+1)*De3
    end
    for i=1:H1
        De1(i) = (1-O2(i)^2)*(W2(;,i+1)*De2);
    end
    
    % Update
    W3 = W3 +eta*De3*[1;O2']';
    for i=1:H2
        W2(i,:)=W2(i,:) + eta*De2*[1;O1']';
    end
    for i=1:H1
        W1(i,:)=W1(i,:) + eta*De1*X(:)';
    end
end