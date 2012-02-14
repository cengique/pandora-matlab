function obj = loadAmiraMesh(filename, isverbose)

% loadAmiraMesh - Loads AmiraMesh ASCII format neuron 3D mesh reconstructions.
%
% Usage:
% obj = loadAmiraMesh(filename, props)
%
% Parameters:
%   filename: Amira mesh file (*.am).
%   isverbose: (Optional) If 1, dispay verbose information.
%		
% Returns:
%  obj: Structure containing loaded mesh data with fileds:
%   nVertices, nEdges, nOrigins: Number of vertices, edges and origins, resp.,
%   vertices: 3D coordinates of each vertex,
%   neighborCount: Number of neighbors for each vertex,
%   raddi: Radius of each vertex,
%   neighborList: Index of vertices that are neighboring to each vertex,
%   origins: Indices of vertices marked as 'origin',
%
% Description:
%   My default it reads an ASCII formatted v2 type Amira file and expects
% only vertex and edge information for representing 3D reconstructions
% of neurons.
%
% See also: 
%
% $Id: loadAmiraMesh.m 1306 2011-07-08 19:58:45Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu> <cengique@users.sf.net>, 2012/02/03

  if ~ exist('isverbose', 'var')
    isverbose = 0;
  end
  
% Load file into string
amcontents = fileread(filename);

obj = struct;

% Read beginning of file to parse nVertices, nEdges and Origins
if isverbose
  disp('Parsing parameters...'); end
obj.nVertices = readVar('nVertices');
obj.nEdges = readVar('nEdges');
obj.nOrigins = readVar('Origins');

% Read vertices and edge definitions, or simply skip them. At least get
% which @X corresponds to which data component.

if isverbose
  disp('Parsing section defs...'); end
  
sec_Coordinates = readSectionNum('Coordinates');
sec_NeighbourCount = readSectionNum('NeighbourCount');
sec_Radii = readSectionNum('Radii');
sec_NeighbourList = readSectionNum('NeighbourList');
sec_Origins = readSectionNum('Origins');
  
% Read data
blankrows = regexp(amcontents, [ '\n\s*\n' ], 'start');

% $$$ for char_index=blankrows
% $$$   disp(amcontents(char_index:min(char_index+10, size(amcontents))));
% $$$ end

obj.vertices = readDataBlock(sec_Coordinates);
obj.neighborCount = readDataBlock(sec_NeighbourCount);
obj.radii = readDataBlock(sec_Radii);
obj.neighborList = readDataBlock(sec_NeighbourList);
obj.origins = readDataBlock(sec_Origins);

% test to make sure everything is fine
test()

% return all info


function val = readVar(varName)
% search everywhere in file for a pattern like 'nEdges 3434'
  found = regexp(amcontents, [ varName ' (\d+)'], 'tokens');
  if ~ isempty(found) 
    if isverbose
      disp([ varName ' = ' found{1}{1} ]); end
    val = str2num(found{1}{1});
  else
    warning([ 'Cannot find definition of ' varName ]);
    val = NaN;
  end
end

function num = readSectionNum(sectionName)
% search everywhere in file for a pattern like 
% 'Vertices { float[3] Coordinates } @1'
% where 'Coordinates' is the sectionName
  found = regexp(amcontents, [ '(\w+) \{ (\S+) ' sectionName ' \} @(\d+)' ], 'tokens');
  if ~ isempty(found) 
    if isverbose
      disp([ sectionName ' = ' found{1}{3} ]); end
    num = str2num(found{1}{3});
  else
    warning([ 'Cannot find definition of ' sectionName ]);
    num = NaN;
  end
end

function data = readDataBlock(secNum)
  start_index = ...
      regexp(amcontents, [ '\n@' num2str(secNum) '\n'], 'end');
  end_index = ...
      blankrows(blankrows>start_index);
  data = ...
      eval([ '[' amcontents(start_index:end_index(1)) ']' ]);

  if isverbose
    disp([ 'Size of section @' num2str(secNum) ': ']);
    size(data)
  end
end

function test
% perform simple sanity checks on data read
  assert(obj.nVertices == size(obj.vertices, 1));
  assert(obj.nVertices == size(obj.neighborCount, 1));
  assert(obj.nVertices == size(obj.radii, 1));
  assert(obj.nEdges == sum(obj.neighborCount));
  assert(obj.nOrigins == size(obj.origins, 1));
  if isverbose
    disp('Data validated.'); end
end

end % loadAmiraMesh
