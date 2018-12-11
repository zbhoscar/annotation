function mouse_draw(f)
% f = figure(1);
% axis([0 10 0 10 0 10]);
f
hold on;
view(2);
set(f,'WindowButtonDownFcn',@DrawPoint);
% set(f,'WindowButtonMotionFcn',@DrawLine);
set(f,'DeleteFcn',@dd);
end

function DrawPoint(src,event)
if strcmp(get(src,'SelectionType'),'normal')
for i = 1:4
% pt = get(gca,'CurrentPoint');
pt = ginput(1);
X(i,1) = pt(1,1);
X(i,2) = pt(1,2);
if i<3
Pt(i) = plot(X(i,1),X(i,2),'o');
end
if i == 2
    %%
    % 
L(1) = line([X(i,1),X(i-1,1)],[X(i,2),X(i-1,2)]);
end
if i == 3
 Y(1,:) = X(3,:)+(X(1,:)-X(2,:))*((X(3,:)-X(2,:))*(X(2,:)-X(1,:))')/((X(2,:)-X(1,:))*(X(2,:)-X(1,:))');
 Pt(3) = plot(Y(1,1),Y(1,2),'o');
 Y(2,:) = Y(1,:)+(X(1,:)-X(2,:));
 Pt(4) = plot(Y(2,1),Y(2,2),'o');
 L(2) = line([Y(1,1),Y(2,1)],[Y(1,2),Y(2,2)]);
 L(3) = line([Y(1,1),X(2,1)],[Y(1,2),X(2,2)]);
 L(4) = line([Y(2,1),X(1,1)],[Y(2,2),X(1,2)]);
%  (Y(1,:)-X(2,:))*(X(2,:)-X(1,:))'
end
if i==4
    O(1,:) = (X(2,:)+Y(1,:))/2+(X(1,:)-X(2,:))/2;
    Pt(5) = plot(O(1,1),O(1,2),'o');
    flag1 = (X(2,:)-O(1,:))*(X(4,:)-O(1,:))';
    flag2 = (Y(1,:)-O(1,:))*(X(4,:)-O(1,:))';
    if flag1>0  
       if flag2>0
           O(2,:) = O(1,:)+3/4*(X(2,:)-X(1,:));
       else 
           O(2,:) = O(1,:)+3/4*(X(2,:)-Y(1,:));
       end
    else
        if flag2>0
           O(2,:) = O(1,:)-3/4*(X(2,:)-Y(1,:));
        else
           O(2,:) = O(1,:)-3/4*(X(2,:)-X(1,:));
        end
    end
    L(5) = line(O(:,1),O(:,2));
end
end
Point = getappdata(src,'Point');
Point = [Point,Pt];
setappdata(src,'Point',Point);
Line = getappdata(src,'Line');
Line = [Line,L];
setappdata(src,'Line',Line);
Direct = getappdata(src,'Direct');
Direct = [Direct;O];
setappdata(src,'Direct',Direct);
end
if strcmp(get(src,'SelectionType'),'alt')
    Pttemp = getappdata(src,'Point');
    Ltemp = getappdata(src,'Line');
    Otemp = getappdata(src,'Direct');
    if ~isempty(Pttemp) 
        delete(Pttemp(end-4:end));
        Pttemp(end-4:end) = [];
        setappdata(src,'Point',Pttemp);
    end
    if ~isempty(Ltemp)
        delete(Ltemp(end-4:end));
        Ltemp(end-4:end) = [];
        setappdata(src,'Line',Ltemp);
    end
    if ~isempty(Otemp)
        Otemp(end-1:end,:) = [];
        setappdata(src,'Direct',Otemp);
    end
end
end

% function DrawLine(src,event)
% X = getappdata(src,'X');
% if ~isempty(X)
% temp = getappdata(src,'TempLine');
% if ~isempty(temp)
% delete(temp);
% end
% pt = get(gca,'CurrentPoint');
% Y = pt(1,1:2);
% tline = line([X(1),Y(1)],[X(2),Y(2)]);
% drawnow;
% setappdata(src,'TempLine',tline);
% % delete(tline);
% % drawnow;
% pause(0.01);
% end
% end

function dd(src,event)
set(src,'WindowButtonDownFcn','');
set(src,'WindowButtonMotionFcn','');
close all;
close gcf;
end

