% % function d_in = read_image(filename)
% filename = 'samiul.jpg';
% 
% [path, name, ext] = fileparts(filename);
% try
%    fid = fopen(filename, 'r'); 
%    d_in = fread(fid); 
% catch exception
% 
%    % Did the read fail because the file could not be found?
%    if ~exist(filename, 'file')
% 
%       % Yes. Try modifying the filename extension.
%       switch ext
%       case '.jpg'    % Change jpg to jpeg 
%           altFilename = strrep(filename, '.jpg', '.jpeg')
%       case '.jpeg'   % Change jpeg to jpg 
%           altFilename = strrep(filename, '.jpeg', '.jpg')
%       case '.tif'    % Change tif to tiff 
%           altFilename = strrep(filename, '.tif', '.tiff')
%       case '.tiff'   % Change tiff to tif 
%           altFilename = strrep(filename, '.tiff', '.tif')
%       otherwise 
%          rethrow(exception);
%       end 
% 
%       % Try again, with modifed filename.
%       try
%          fid = fopen(altFilename, 'r'); 
%          d_in = fread(fid);
%       catch
%          rethrow(exception)
%       end 
%    end 
% end


clear all
clc
% function data = read_it(filename);
filename = 'samiul.jpg';

try
   % Attempt to open and read from a file.
   fid = fopen(filename, 'r');
   data = fread(fid);
catch exception1
   % If the error was caused by an invalid file ID, try 
   % reading from another location.
   if strcmp(exception1.identifier, 'MATLAB:FileIO:InvalidFid')
      msg = sprintf( ...
         '\nCannot open file %s. Try another location?  ', ...
         filename);
      reply = input(msg, 's')
      if reply(1) == 'y'
          newFolder = input('Enter folder name:  ', 's');
      else
          throw(exception1);
      end
      oldpath = addpath(newFolder);
      try
         fid = fopen(filename, 'r');
         data = fread(fid);
      catch exception2
         exception3 = addCause(exception2, exception1)
         path(oldpath);
         throw(exception3);
      end
      path(oldpath);
   end
end
fclose(fid);