function gen_environment(arg)
% Functions for generating warehouse environment for calling from any code
% file
hold on
axis equal
    if arg == 1
        axis([0 25 -12 12])
        plot([0 10],[2 2],'-k')
        plot([10 10],[2 12],'-k')
        plot([0 14],[-2 -2],'-k')
        plot([14 14],[-2 8],'-k')
        plot([10 25],[12 12],'-k')
        plot([14 25],[8 8],'-k')
    elseif arg == 2
        axis([0 25 -23 2])
        plot([2 2],[-2 -12],'-k')
        plot([6 6],[-2 -8],'-k')
        plot([2 24],[-12 -12],'-k')
        plot([6 20],[-8 -8],'-k')
        plot([24 24],[-12 -2],'-k')
        plot([20 20],[-8 -2],'-k')
    elseif arg == 3
        axis([0 40 -2 23])
        plot([0 10],[2 2],'-k')
        plot([10 10],[2 12],'-k')
        plot([0 14],[-2 -2],'-k')
        plot([14 14],[-2 8],'-k')
        plot([10 29],[12 12],'-k')
        plot([14 25],[8 8],'-k')
        plot([25 25],[8 -2],'-k')
        plot([29 29],[12 2],'-k')
        plot([25 25],[8 -2],'-k')
        plot([29 39],[2 2],'-k')
        plot([25 39],[-2 -2],'-k')
    %elseif arg == ?
    %   axis([... ...])
    %   plot([...] [...], '-k') % skeleton function for environment making
    end
end
