%% Problem parameters

AEM = 6821;

% Constants
D = mod(AEM,10); % Last digit of AEM
C = floor(mod(AEM,100)/10); % Second to last digit of AEM
DC = (D*10 + C);

%L = 3 * (1 + DC/100); % meters
%A_0 = 6 * (0.5 + DC/100) * 1e-4; % meters^2
%F1 = -100000*9.80665; % N (converted from kgf)
%F2 = -100000*9.80665; % N (converted from kgf)
%E = 206010000000; % N/m^2 (converted from kgf/mm^2 to N/m^2)
%rho = 1;

E = sym('E', [1 10], 'integer');
Len = sym('Len', 'real');
% Preallocate a symbolic row vector
A = sym('A', [1 10], 'positive');

% Assign variable names to each element
for i = 1:10
    A(i) = sym(['A', num2str(i)], 'real');
end
F1 = sym('F1', 'real');
F2 = sym('F2', 'real');
%% Geometry definition

% Truss geometry [X Y]
nodes = [2*Len Len; 2*Len 0; Len Len; Len 0; 0 Len; 0 0];
elements = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4; 3 5; 3 6; 4 5; 4 6];

% degrees of freedom, [x, y] 12x12 matrix
% nodes 5, 6 are y = 0
% nodes 2, 4 have F2 and F1 applied

numNodes = size(nodes, 1);
numElements = size(elements, 1);

%% K matrix

% Initialize global K matrix
K = sym(zeros(numNodes*2)); % 2 DOFs per node
elementLength = sym(zeros(10,1));

for i = 1:numElements
    n1 = elements(i, 1);
    n2 = elements(i, 2);
    
    % Compute the length of the element
    elementLength(i) = sqrt((nodes(n2,1) - nodes(n1,1))^2 + (nodes(n2,2) - nodes(n1,2))^2);
    coselx = (nodes(n2, 1) - nodes(n1, 1))/elementLength(i);
    cosely = (nodes(n2, 2) - nodes(n1, 2))/elementLength(i);
    
    % Local stiffness matrix for element
    k_local = (E(i) * A(i) / elementLength(i)) * [1 -1; -1 1];
    Te = [coselx cosely 0 0; 0 0 coselx cosely];

    Kelement = Te'*k_local*Te;

    % Global DOF indices
    globalDofIndices = [2*n1-1 2*n1 2*n2-1 2*n2];

    % Assemble global K matrix
    K(globalDofIndices, globalDofIndices) = K(globalDofIndices, globalDofIndices) + Kelement;
end

%% BCs and loading
% Apply boundary conditions (assuming fixed at nodes 5 and 6)
fixedDofs = [2*5-1, 2*5, 2*6-1, 2*6]; % DOFs of nodes 5 and 6
freeDofs = setdiff(1:numNodes*2, fixedDofs);

% Reduced stiffness matrix (after applying boundary conditions)
K_reduced = K(freeDofs, freeDofs);

% Apply loads
F = sym(zeros(numNodes*2, 1)); % Initialize force vector
F(2*2) = sym(F1); % Force at node 2
F(2*4) = sym(F2); % Force at node 4

% Reduced force vector
F_reduced = F(freeDofs);

%% solver bit

% Solve for displacements
u = sym(zeros(numNodes*2, 1));
K_reduced_inv = inv(K_reduced);
u(freeDofs) = K_reduced_inv * F_reduced; %#ok<MINV> 

% for every element
sigma = sym(zeros(numElements, 1));
for i = 1:numElements
    sigma(i) = 1/elementLength(i) * E * [-1, 1]*[u(elements(i,1)); u(elements(i,2))];
end

%%  turning this to something gamsable

% to translate this to gams we turn to this line
% tmp_str = ['r1..',char(A_1eq(1)),'=e=0', ';','\n']; 

% Define the path
my_path = 'C:\\Users\\dimit\\Desktop\\mhxmhx\\5th year\\optimization\\3rd assignment';

% Define the file name (assuming fileName0 is already defined)
name = 'GamsModelEguationsOptimization';
fileName = [my_path, '\\', name, '.gms']; % creates file name

fid = fopen(fileName, 'w'); % ‘w’ opens the file for writing

% Initialize tmp_str as a cell array
tmp_str = cell(12, 1);
tmp_sigma = cell(10,1);

% Loop to create strings
for i = 1:12
    tmp_str{i} = ['r', num2str(i), '.. ', 'u', num2str(i), ' =e= ', char(u(i))];
end

% Loop to write each string in the cell array to the file
fprintf(fid, 'Equations');
for i = 1:length(tmp_str)
    fprintf(fid, '%s\n', tmp_str{i});
end

fclose(fid); % Close the file


