function myslider
% global x
% global hplot
% global h

x = 1:10;
hplot = plot(x,0*x)
h = uicontrol('style','slider','units','pixel','position',[20 20 300 20],'Callback',@makeplot);
%set(hplot,'ydata',x.^1);

% addlistener(h,'ActionEvent',@(hObject, event) makeplot(hObject, event,x,hplot));
function makeplot(source,event)
    hplot
% n = get(h,'Value');
n=source.Value;
set(hplot,'ydata',x.^n);
disp(n)
drawnow;
end
end
% 
%  function myui
%     % Create a figure and axes
%     f = figure('Visible','off');
%     ax = axes('Units','pixels');
%     pl=plot([1:100],sin(1:100));
%     
%    
%    % Create slider
%     sld = uicontrol('Style', 'slider',...
%         'Min',1,'Max',50,'Value',41,...
%         'Position', [400 20 120 20],...
%         'Callback', @surfzlim); 
% 					
%     % Make figure visble after adding all components
%     f.Visible = 'on';
%     % This code uses dot notation to set properties. 
%     % Dot notation runs in R2014b and later.
%     % For R2014a and earlier: set(f,'Visible','on');
%     
%     function surfzlim(source,event)
%         val = 51 - source.Value;
%         % For R2014a and earlier:
%         % val = 51 - get(source,'Value');
%         set(pl,'ydata',val.*sin(1:100))
%     end
% end