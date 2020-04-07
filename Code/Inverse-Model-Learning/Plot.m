W = load('wind');
xlim = [min(W.x(:)) max(W.x(:))];
ylim = [min(W.y(:)) max(W.y(:))];
sx = rand(100,1)*diff(xlim) + xlim(1);
sy = rand(100,1)*diff(ylim) + ylim(1);               
quiver(W.x(:,:,1), W.y(:,:,1), W.u(:,:,1), W.v(:,:,1));
hold on;
hl = streamline(W.x(:,:,1), W.y(:,:,1), W.u(:,:,1), W.v(:,:,1), ...
    sx(:), sy(:));
set(hl, 'color', 'r');