clc;
clear all;
sim('config5sim_KinematicController.slx');
disp('Start')

In = 4;
H1 = 10;
H2 = 8;
Out = 2;

for i = 1:100
    if i == 1
        W1_i = 0.25*(rand(H1,In+1) - rand(H1,In+1));
        W2_i = 0.25*(rand(H2,H1+1) - rand(H2, H1+1));
        W3_i = 0.25*(rand(Out, H2+1) - rand(Out, H2+1));
    else
        W1_i = W1_out(:,:, end);
        W2_i = W2_out(:,:, end);
        W3_i = W3_out(:,:, end);
    end
    sim('config5sim_KinematicController_PosCon_NetFunc.slx');
    disp(i)
end