%%% This program will add all the files of the previous directory
%%% to the current directory

current_directory = cd;
cd ..;
parent_directory = cd; % this is the path that needs to be included
cd(current_directory); % change the path to the working directory
addpath(parent_directory);




 