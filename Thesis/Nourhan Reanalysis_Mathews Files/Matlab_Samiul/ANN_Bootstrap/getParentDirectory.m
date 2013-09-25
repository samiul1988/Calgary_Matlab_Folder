function [currentDir, parentDir] = getParentDirectory
%%% This function generates the full path strings for the current and
%%% parent working directories

currentDir = cd; % current directory
cd ..; % parent directory
parentDir = cd; 
cd(currentDir); % change the path to the working directory