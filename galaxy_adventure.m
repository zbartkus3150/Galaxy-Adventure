function galaxy_adventure()
%Bartomiej ¯y³a
%simple game where Player(Blue Ball) has to avoid asteroids(White balls)
%which collide with each other and change their trajectory.

%Controls: 
%arrow keys - move player
%"q" - quit game

%general settings
screen = [640, 480];

%player variables
player = [0 0 1 1; 0 1 0 1];
px = screen(1)/2;
py = screen(2)/2;
player(1,:) = player(1,:)+px;
player(2,:) = player(2,:)+py;
pspeed = 8;

%asteroids' variables
N = 40;
rng('shuffle')
x = rand(1,N) * screen(1);
y = rand(1,N) * screen(2);
vx = rand(1,N) * 10 - 5;
vy = rand(1,N) * 10 - 5;

%window
f = figure('color', 'white', 'Resize', 'off');
set(f, 'Menu', 'none', 'Position', [100 100 560 500]);
ax = axes('NextPlot', 'add');
set(ax, 'XTick', [], 'YTick', [], 'Xcolor', 'black', 'Ycolor', 'black');
axis(ax, [0 screen(1) 0 screen(2)]);
set(gca, 'color', 'black');
e = plot(x,y,'ow','MarkerSize',5,'MarkerFaceColor','w');
p = plot(player(1,:), player(2,:), 'ob','MarkerSize',4,'MarkerFaceColor','b');

%key = get(f, 'keypressfcn');
set(f, 'keypressfcn', @keypress);

pause(0.5);

%main game loop
while ishandle(f)
    set(p, 'XData', player(1,:), 'YData', player(2,:));
    for i = 1:N
        for j = 1:N
            if(i ~= j)
                %asteroids collision with each other
                if(x(i)>= x(j)-7 && x(i) <= x(j)+7 && y(i) >= y(j)-7 && y(i) <= y(j)+7)
                    tmpi = vx(i);
                    tmpj = vx(j);
                    vx(i) = -vy(i);
                    vy(i) = -tmpi;
                    vx(j) = -vy(j);
                    vy(j) = -tmpj;
                end
            end
        end
        %asteroid movement
        x(i) = x(i) + vx(i);
        y(i) = y(i) + vy(i);
        if x(i) > screen(1)
            x(i) = 0;
        
        elseif x(i) < 0
            x(i) = screen(1);
        end
        if y(i) > screen(2)
            y(i) = 0;
        elseif y(i) < 0
            y(i) = screen(2);
        end
        %player collision
        if ((x(i) >= player(1,1)-4 && x(i) <= player(1,2)+4) && (y(i) >= player(2,1)-4 && y(i) <= player(2,2)+4))
            waitfor(msgbox('You lost', 'modal'));
            close all;
            return;
        end
    end
    set(e, 'XData', x, 'YData', y);
    
    drawnow;
end

%function for handling controls
function keypress(varargin)
key = get(gcbf, 'CurrentKey');
if strcmp(key, '')
%leftarrow
elseif strcmp(key, 'leftarrow')
    %moving player left.
    if player(1,1)-pspeed >= 0
        player(1,:) = player(1,:)-pspeed;
    else
        player(1,:) = screen(1);
    end
%rightarrow
elseif strcmp(key, 'rightarrow')
    %moving player right.
     if player(1,2)+pspeed < screen(1)-1
        player(1,:) = player(1,:)+pspeed;
     else
         player(1,:) = 0;
     end
%uparrow
elseif strcmp(key, 'uparrow')
    %moving player up.
     if player(2,2)+pspeed <= screen(2)-1
        player(2,:) = player(2,:)+pspeed;
     else
         player(2,:) = 0;
     end
%downarrow
elseif strcmp(key, 'downarrow')
    %moving player down.
     if player(2,1)-pspeed >= 0
        player(2,:) = player(2,:)-pspeed;
     else
         player(2,:) = screen(2);
     end
%q
elseif strcmp(key, 'q')
    %Exit game.
    waitfor(msgbox('Bye', 'modal'));
    close all;
    return;
end
end
end