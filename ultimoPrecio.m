function varargout = ultimoPrecio(varargin)

% Author     : Fernando Esteves
% e-mail     : esteves9876@gmail.com
% Cretaed    : 5/12/2014
% Last Change: 9/12/2014
% 
% With this function you can get the last stocks data of every Yahoo listed
% ticker, with auto update every minute or whatever time you want. 
% 
% The tickers listed are read from a txt file, which you can edit to download 
% the data you need.
% 
% 


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ultimoPrecio_OpeningFcn, ...
                   'gui_OutputFcn',  @ultimoPrecio_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Outputs from this function are returned to the command line.
function varargout = ultimoPrecio_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes just before ultimoPrecio is made visible.
function ultimoPrecio_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Hour timer
timer_obj = timer(...
    'TimerFcn',         {@actualizar_hora, hObject}, ...  % timer function, has to specific the handle to the GUI,
    'ExecutionMode',    'fixedRate', ...                    %
    'Period',           1, ...                           % updates every xx seconds
    'TasksToExecute',   inf, ...
    'BusyMode',         'drop');
start(timer_obj);        % start the timer object
setappdata(hObject, 'timer_obj', timer_obj');  % save the timer object as app data
set(handles.fecha, 'string', datestr(now, 1)); % Set date



fileID = fopen('emisoras.txt');
tickers = transpose(textscan(fileID,'%s'));
precios=fetch(yahoo,tickers{1});
precios.Date=datestr(precios.Date, 29);
porcentaje=(precios.Last*100./(precios.Last-precios.Change))-100;
datos=table(precios.Symbol, precios.Last, precios.Change, porcentaje, precios.High, precios.Low, precios.Volume);
datos=table2cell(datos);
set(handles.tablaDatosPrecios, 'data', datos);
mensaje= strcat('Última actualización:',  datestr(now, 14));
set(handles.cuadroMensaje, 'string', mensaje);


guidata(hObject, handles);




% Set the hour every second
function actualizar_hora(src,evt, fig_handle)
handles = guihandles(fig_handle);
set(handles.hora, 'string', datestr(now, 14));

function tablaDatosPrecios_CellEditCallback(hObject, eventdata, handles)
function hora_Callback(hObject, eventdata, handles)
function hora_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function fecha_Callback(hObject, eventdata, handles)
function fecha_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% popupmenuActualizar -> set the update frequency in seconds
function popupmenuActualizar_Callback(hObject, eventdata, handles)
tiempo=get(hObject,'Value');
switch tiempo
    case 1 % In case you don't want to update the prices, it delete the timer that update the stocks data
        stop(getappdata(hObject, 'timer_periodo'))
        delete(getappdata(hObject, 'timer_periodo'));
        periodo=0;
    case 2
        periodo=60; % Update every 60 seconds
    case 3
        periodo=180;% Update every 180 seconds
    case 4
        periodo=300;% Update every x seconds
    case 5
        periodo=480;% Update every x seconds
    case 6
        periodo=780;% Update every x seconds
    case 7
        periodo=1260;% Update every x seconds
    case 8
        periodo=2040;% Update every x seconds
    case 9
        periodo=3300;% Update every x seconds
end
if periodo~=0 % Only run this if you want to update prices data
delete(getappdata(hObject, 'timer_periodo'));  % delete the timer object 
timer_periodo = timer(...
    'TimerFcn',         {@actualizar_datos, hObject}, ...  % timer function, has to specific the handle to the GUI,
    'ExecutionMode',    'fixedRate', ...                    %
    'Period',           periodo, ...                           % updates every xx seconds
    'TasksToExecute',   inf, ...
    'BusyMode',         'drop');
start(timer_periodo);        % start the timer object
setappdata(hObject, 'timer_periodo', timer_periodo');  % save the timer object as app data
end


function popupmenuActualizar_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function actualizar_datos(src,evt, fig_handle)

handles = guihandles(fig_handle);
fileID = fopen('emisoras.txt'); % Read the txt file hat contain the list with the tickers
tickers = transpose(textscan(fileID,'%s'));
precios=fetch(yahoo,tickers{1}); % fetch function contained in Datafeed Toolbox, download last Yahoo prices
precios.Date=datestr(precios.Date, 29);
porcentaje=(precios.Last*100./(precios.Last-precios.Change))-100; % Get the % 

% Convert all data to cell and string
ticker=cellstr((precios.Symbol));
porcentajeDatos=cellstr(num2str(porcentaje));
last=cellstr(num2str(precios.Last));
change=cellstr(num2str(precios.Change));
high=cellstr(num2str(precios.High));
low=cellstr(num2str(precios.Low));
volumen=cellstr(num2str(precios.Volume));

datos=[ticker, last, change porcentajeDatos, high, low, volumen]; % Create the table

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Change color data
negativeIndex=[];
positiveIndex=[];
for i=1:length(porcentaje) % this loop separate the increasing and decreasing price tickets and get the index
    if porcentaje(i)<0
        negativeIndex = [negativeIndex; find(ismember(datos,porcentajeDatos(i)))];
    end
    if porcentaje(i)>0
        positiveIndex = [positiveIndex; find(ismember(datos,porcentajeDatos(i)))];
    end
end

% get the index of the same row 
negativeIndex2=negativeIndex-length(datos);
negativeIndex3=negativeIndex-length(datos)*2;
negativeIndex4=negativeIndex-length(datos)*3;
negativeIndex5=negativeIndex+length(datos);
negativeIndex6=negativeIndex+length(datos)*2;
negativeIndex7=negativeIndex+length(datos)*3;

% get the index of the same row 
positiveIndex2=positiveIndex-length(datos);
positiveIndex3=positiveIndex-length(datos)*2;
positiveIndex4=positiveIndex-length(datos)*3;
positiveIndex5=positiveIndex+length(datos);
positiveIndex6=positiveIndex+length(datos)*2;
positiveIndex7=positiveIndex+length(datos)*3;

% Create a vector with all  the indexes that will change the color
negativeIndex=[negativeIndex; negativeIndex2; negativeIndex3; negativeIndex4;...
    negativeIndex5; negativeIndex6; negativeIndex7];
positiveIndex=[positiveIndex; positiveIndex2; positiveIndex3; positiveIndex4;...
    positiveIndex5; positiveIndex6; positiveIndex7];

% Change the color
datos(negativeIndex) = strcat('<html><div style="width:35px" align="center"><span style="color: #FF0000; font-weight: bold;">', ...
   datos(negativeIndex), '</span></div></html>');   
datos(positiveIndex) = strcat('<html><div style="width:35px" align="center"><span style="color: #0B610B; font-weight: bold;">', ...
   datos(positiveIndex), '</span></div></html>'); 
% based on  http://matlabgeeks.com/tips-tutorials/building-a-gui-in-matlab-part-ii-tables/
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% Set the table data
set(handles.tablaDatosPrecios, 'data', datos);
% message 
mensaje= strcat('Última actualización:',  datestr(now, 14));
set(handles.cuadroMensaje, 'string', mensaje);
beep


function cuadroMensaje_Callback(hObject, eventdata, handles)
function cuadroMensaje_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
stop(getappdata(hObject, 'timer_obj')); % stops the timer 
delete(getappdata(hObject, 'timer_obj'));  % delete the timer object 
delete(timerfindall)
delete(hObject);
