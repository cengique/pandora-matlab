function a_mesh = mesh_amira(filename, id, props)

% mesh_amira - Contains 3D mesh data imported from the Amira software.
%
% Usage:
% a_mesh = mesh_amira(filename, id, props)
%
% Parameters:
%   filename: Amira mesh file (*.am).
%   id: Identification string.
%   props: A structure with any optional properties.
%     isVerbose: If 1, produce verbose info while loading Amira file (for
%     		 debugging).
%
% Returns a structure object with the following fields:
%   nVertices, nEdges, nOrigins: Number of vertices, edges and origins, resp.,
%   vertices: 3D coordinates of each vertex,
%   neighborCount: Number of neighbors for each vertex,
%   raddi: Radius of each vertex,
%   neighborList: Index of vertices that are neighboring to each vertex,
%   Origins: Indices of vertices marked as 'origin',
%   origFilename, id, props
%
% Description:
%   By default it reads an ASCII formatted v2 type Amira file and expects
% only vertex and edge information for representing 3D reconstructions
% of neurons.
%
% General methods of mesh_amira objects:
%   mesh_amira		- Construct a new mesh_amira object.
%
% Additional methods:
%   See methods('mesh_amira')
%
% See also: private/loadAmiraMesh
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2012/02/03

% Copyright (c) 2012 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
  a_mesh = struct;
  a_mesh.nVertices = 0;
  a_mesh.nEdges = 0;
  a_mesh.nOrigins = 0;
  a_mesh.vertices = [];
  a_mesh.neighborCount = [];
  a_mesh.radii = [];
  a_mesh.neighborList = [];
  a_mesh.origins = [];
  a_mesh.origFilename = '';  
  a_mesh.id = '';
  a_mesh.props = struct;
  a_mesh = class(a_mesh, 'mesh_amira');
elseif isa(filename, 'mesh_amira') % copy constructor?
  a_mesh = filename;
else
  if ~ exist('props', 'var')
    props = struct;
  end

  a_mesh = ...
      loadAmiraMesh(filename, getFieldDefault(props, 'isVerbose', 0));
  
  a_mesh.origFilename = filename;
  a_mesh.id = id;
  a_mesh.props = props;

  a_mesh = class(a_mesh, 'mesh_amira');
end
