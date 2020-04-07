function [v, w] = controlV(t)
    a = 0.015;
    b = 0.03;
    c = 0.0035;
    d = 0.007;
    v(t>=0) = 0.4 - a + b*rand_seed(t>=0); % SPEED
    w(t<=20) = 0 - c + d*rand_seed(t<=20); % HEADING
    w(t>20 & t<=28) = 0.19 - c + d*rand_seed(t>20 & t<=28);
    w(t>28 & t<=43) = 0 - c + d*rand_seed(t>28 & t<=43);
    w(t>43 & t<=51) = -0.1925 - c + d*rand_seed(t>43 & t<=51);
    w(t>51) = 0 - c + d*rand_seed(t>51);
    
%     V = [t' v'];
%     W = [t' w'];
    
end
