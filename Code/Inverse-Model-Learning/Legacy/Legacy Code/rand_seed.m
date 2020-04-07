function [nmbr] = rand_seed(t)
    global rand_seeds;
    global TIME;    
    pos = find(TIME==t);
    nmbr = rand_seeds(pos, 1);
end