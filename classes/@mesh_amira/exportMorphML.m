function a_dom = exportMorphML(a_mesh, props)

% exportMorphML - Export mesh to MorphML XML format.
%
% Usage:
% a_dom = exportMorphML(a_mesh, props)
%
% Parameters:
%   a_mesh: A mesh_amira object.
%   props: A structure with any optional properties.
%		
% Returns:
%   a_dom: A Matlab DomNode object.
%
% Description:
%
% Example:
% >> a_mesh = mesh_amira('my_amira.am', 'Neuron 1')
% >> xmlwrite('neuron.xml', exportMorphML(a_mesh))
%
% See also: 
%
% $Id: exportMorphML.m 456 2011-05-09 20:53:12Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2012/02/03

% Copyright (c) 2012 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% make a hash table for origin lookups
% (no need for a map, so info is duplicated in values)
  origins = ...
      containers.Map(num2cell(uint32(a_mesh.origins)), num2cell(a_mesh.origins));
  
% Create a MorphML XML document
% $$$   <morphml xmlns="http://morphml.org/morphml/schema"     
% $$$      xmlns:meta="http://morphml.org/metadata/schema"
% $$$      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
% $$$      xsi:schemaLocation="http://morphml.org/morphml/schema http://www.neuroml.org/NeuroMLValidator/NeuroMLFiles/Schemata/v1.8.1/Level1/MorphML_v1.8.1.xsd"
% $$$      length_units="micrometer">
  
  a_dom = com.mathworks.xml.XMLUtils.createDocument('morphml');
  docRootNode = a_dom.getDocumentElement;
  docRootNode.setAttribute('xmlns', 'http://morphml.org/morphml/schema');
  docRootNode.setAttribute('xmlns:meta', 'http://morphml.org/metadata/schema');
  docRootNode.setAttribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
  docRootNode.setAttribute('xsi:schemaLocation', 'http://morphml.org/morphml/schema http://www.neuroml.org/NeuroMLValidator/NeuroMLFiles/Schemata/v1.8.1/Level1/MorphML_v1.8.1.xsd');
  docRootNode.setAttribute('length_units', 'micrometer');
  
  % Start a cell description
  cells = a_dom.createElement('cells');
  docRootNode.appendChild(cells);
  
  cell = a_dom.createElement('cell');
  cell.setAttribute('name', a_mesh.origFilename);
  cells.appendChild(cell);

  note = a_dom.createElement('meta:notes');
  cell.appendChild(note);
  note.appendChild(a_dom.createTextNode(a_mesh.id));
  
  % skip meta:properties for now? TODO: Put Amira info.
  
  % Add segments as connected structures
  segments = a_dom.createElement('segments');
  cell.appendChild(segments);

  % keep track of vertices that already exist to appear as "parent"
  parents = containers.Map('KeyType', 'uint32', 'ValueType', 'uint32');
  
  % make first element
  create_soma();

  % loop over Vertices and follow their Edges
  edge_num = 0;
  output_num = 0;
  for vertex_num = 1:a_mesh.nVertices
    for neighbor_num = 1:a_mesh.neighborCount(vertex_num)
      % a segment from vertex to its neighbor (convert to Matlab numbering)
      to_vertex = a_mesh.neighborList(edge_num + neighbor_num) + 1;
      
      % skip backwards edges; Amira seem to create two edges between each
      % vertex
      
      % this is too simplistic:
% $$$       if to_vertex <= vertex_num
% $$$         continue;
% $$$       end
      
      % skip only if it exists as a parent
      if parents.isKey(uint32(to_vertex - 1))
        continue;
      end

      output_num = output_num + 1;
      
      % create segment
      segment = a_dom.createElement('segment');
      segment.setAttribute('id', num2str(to_vertex - 1)); % name with target
      segment.setAttribute('parent', num2str(vertex_num - 1)); % parent as vertex
      segment.setAttribute('name', [ 'SegFromVertex' num2str(vertex_num - 1) 'to' ...
                          num2str(to_vertex - 1) ]);

      % two types of "cables": Regular (1) and Origins (0)
      if origins.isKey(uint32(vertex_num - 1))
        segment.setAttribute('cable', '0');
      else
        segment.setAttribute('cable', '1');
      end
      segments.appendChild(segment);
      
      % proximal only for first edge
      dist = a_dom.createElement('distal');
      segment.appendChild(dist);

      dist.setAttribute('x', num2str(a_mesh.vertices(to_vertex, 1)));
      dist.setAttribute('y', num2str(a_mesh.vertices(to_vertex, 2)));
      dist.setAttribute('z', num2str(a_mesh.vertices(to_vertex, 3)));
      dist.setAttribute('diameter', num2str(2*a_mesh.radii(to_vertex)));

      % add segment as reprsenting vertex as a parent
      parents(uint32(to_vertex - 1)) = uint32(vertex_num - 1);
    end
    edge_num = edge_num + a_mesh.neighborCount(vertex_num); 
  end

  disp(['Exported ' num2str(output_num) ' segments to file.']);
  
  % finally insert a "cables" section describing the different sections
  cables = a_dom.createElement('cables');
  cell.appendChild(cables);
  
  cable = a_dom.createElement('cable');
  cables.appendChild(cable);
  
  cable.setAttribute('id', '0');
  cable.setAttribute('name', 'Origin');
  cable.appendChild(a_dom.createElement('meta:group').appendChild(a_dom.createTextNode('origin_group')));

  cable = a_dom.createElement('cable');
  cables.appendChild(cable);
  
  cable.setAttribute('id', '1');
  cable.setAttribute('name', 'Other');
  cable.appendChild(a_dom.createElement('meta:group').appendChild(a_dom.createTextNode('other_group')));
 
% $$$   a_dom.appendChild(a_dom.createComment('this is a comment'));

  function create_soma
  % make first segment as a sphere containing first vertex
    segment = a_dom.createElement('segment');
    segments.appendChild(segment);
    
    segment.setAttribute('id', '0'); % name with target
    segment.setAttribute('name', [ 'First' ]);
    
    if origins.isKey(uint32(0))
      segment.setAttribute('cable', '0');
    else
      segment.setAttribute('cable', '1');
    end
    
    prox = a_dom.createElement('proximal');
    segment.appendChild(prox);
    
    % prox=dist coordinates for sphere
    prox.setAttribute('x', num2str(a_mesh.vertices(1, 1)));
    prox.setAttribute('y', num2str(a_mesh.vertices(1, 2)));
    prox.setAttribute('z', num2str(a_mesh.vertices(1, 3)));
    prox.setAttribute('diameter', num2str(2*a_mesh.radii(1)));
    
    dist = a_dom.createElement('distal');
    segment.appendChild(dist);

    dist.setAttribute('x', num2str(a_mesh.vertices(1, 1)));
    dist.setAttribute('y', num2str(a_mesh.vertices(1, 2)));
    dist.setAttribute('z', num2str(a_mesh.vertices(1, 3)));
    dist.setAttribute('diameter', num2str(2*a_mesh.radii(1)));
  
    % add segment as representing vertex as a parent
    parents(uint32(0)) = uint32(0);
  end
  
end
