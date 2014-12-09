last_Yahoo_stocks_data
======================

Matlab Gui for download the last data from Yahoo Finance of every ticker in a personalized list.

Author     : Fernando Esteves
e-mail     : esteves9876@gmail.com
Cretaed    : 5/12/2014
Last Change: 9/12/2014
 
With this function you can get the last stocks data of every Yahoo listed
ticker, with auto update every minute or whatever time you want. 
 
The tickers listed are read from a txt file, which you can edit to download 
the data you need. 

For run this file just click run button.

If you want to create your personalized ticker list, just modified the .txt provided.

This Matlab code needs the Datafeed Toolbox.
Gui and code creted on Matlab R2014a.





HELP:
1.- I need to run the "actualizar_datos(src,evt, fig_handle)" function from start
"ultimoPrecio_OpeningFcn" function, to automatically mark with color red or green every row.

2.- I don't know why the fetch function doesn't download all the tickers in my example list, I think it could be because the length of the ticker. With long tickers Yahoo retrieve me with NaN's.

If anybody know how to solve this please e-mail me, and if you have any contribution please e-mail me too.





To Do:
Create a .exe copy for those who don't have Datafeed Toolbox.




