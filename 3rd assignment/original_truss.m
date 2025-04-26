%% Problem parameters

AEM = 6821;

% Constants
D = mod(AEM,10); % Last digit of AEM
C = floor(mod(AEM,100)/10); % Second to last digit of AEM
DC = (D*10 + C);

L = 3 * (1 + DC/100); % meters
A_0 = 6 * (0.5 + DC/100) * 1e-4; % meters^2
F1 = -100000*9.80665; % N (converted from kgf)
F2 = -100000*9.80665; % N (converted from kgf)
E = 206010000000; % N/m^2 (converted from kgf/mm^2 to N/m^2)
rho = 7930;
mass_0 = rho*L*A_0*(1 +  1 + 1*2^(0.5) + 1*2^0.5 + 1 + 1 + 1 + 1*2^0.5 + 1*2^(0.5) + 1);


%% Geometry definition

% Truss geometry [X Y]
nodes = [2*L L; 2*L 0; L L; L 0; 0 L; 0 0];
elements = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4; 3 5; 3 6; 4 5; 4 6];

% degrees of freedom, [x, y] 12x12 matrix
% nodes 5, 6 are y = 0
% nodes 2, 4 have F2 and F1 applied

numNodes = size(nodes, 1);
numElements = size(elements, 1);

%% K matrix

% Initialize global K and M matrices
K = zeros(numNodes*2); % 2 DOFs per node
elementLength = zeros(10,1);

for i = 1:numElements
    n1 = elements(i, 1);
    n2 = elements(i, 2);
    
    % Compute the length of the element
    elementLength(i) = sqrt((nodes(n2,1) - nodes(n1,1))^2 + (nodes(n2,2) - nodes(n1,2))^2);
    coselx = (nodes(n2, 1) - nodes(n1, 1))/elementLength(i);
    cosely = (nodes(n2, 2) - nodes(n1, 2))/elementLength(i);
    
    % Local stiffness matrix for element
    k_local = (E * A_0 / elementLength(i)) * [1 -1; -1 1];
    Te = [coselx cosely 0 0; 0 0 coselx cosely];

    Kelement = Te'*k_local*Te;

    % Global DOF indices
    globalDofIndices = [2*n1-1 2*n1 2*n2-1 2*n2];

    % Assemble global K matrix
    K(globalDofIndices, globalDofIndices) = K(globalDofIndices, globalDofIndices) + Kelement;
end

%% BC and loading

% Apply boundary conditions (assuming fixed at nodes 5 and 6)
fixedDofs = [2*5-1, 2*5, 2*6-1, 2*6]; % DOFs of nodes 5 and 6
freeDofs = setdiff(1:numNodes*2, fixedDofs);

% Reduced stiffness matrix (after applying boundary conditions)
K_reduced = K(freeDofs, freeDofs);

% Apply loads
F = zeros(numNodes*2, 1); % Initialize force vector
F(2*2) = F1; % Force at node 2
F(2*4) = F2; % Force at node 4

% Reduced force vector
F_reduced = F(freeDofs);

%% solver 

% Solve for displacements
u = zeros(numNodes*2, 1);
u(freeDofs) = K_reduced \ F_reduced;

%% Calculate Element Stresses

stresses = zeros(numElements, 1); % Initialize stress vector for each element

for i = 1:numElements
    n1 = elements(i, 1);
    n2 = elements(i, 2);

    % Nodal displacements for the current element
    u1 = u(2*n1-1:2*n1);
    u2 = u(2*n2-1:2*n2);

    % Change in length (Delta L) of the element
    deltaL = sqrt((nodes(n2,1) + u2(1) - nodes(n1,1) - u1(1))^2 + (nodes(n2,2) + u2(2) - nodes(n1,2) - u1(2))^2) - elementLength(i);

    % Strain in the element
    strain = deltaL / elementLength(i);

    % Stress in the element
    stresses(i) = E * strain / A_0;
end

%stresses = 1e-5.*stresses;


 %% post processor

% Display results
disp('Nodal Displacements:');
disp(u);

% Plot the original structure
figure;
hold on;
grid on;
title('Original Structure');
xlabel('X Coordinate');
ylabel('Y Coordinate');
for i = 1:numElements
    n1 = elements(i, 1);
    n2 = elements(i, 2);
    x = [nodes(n1, 1), nodes(n2, 1)];
    y = [nodes(n1, 2), nodes(n2, 2)];
    plot(x, y, 'b-o'); % Blue lines with node markers
end
axis equal;
hold off;





%% Plot the deformed structure with displacement-induced colors
displacementScale = 1; % Adjust as needed
figure;
hold on;
grid on;
title('Deformed Structure');
xlabel('X Coordinate');
ylabel('Y Coordinate');
cmap = jet(numElements); % Color map

% Calculate the magnitude of displacement for each element
elementDisplacementsMagnitude = zeros(numElements, 1);
for i = 1:numElements
    n1 = elements(i, 1);
    n2 = elements(i, 2);
    displacement1 = [u(2*n1-1); u(2*n1)];
    displacement2 = [u(2*n2-1); u(2*n2)];
    elementDisplacementsMagnitude(i) = max(norm(displacement1), norm(displacement2));
end

% Normalize displacement magnitudes for color mapping
maxDisplacement = max(elementDisplacementsMagnitude);
normalizedDisplacements = elementDisplacementsMagnitude / maxDisplacement;

% Plot each element with color based on displacement magnitude
for i = 1:numElements
    n1 = elements(i, 1);
    n2 = elements(i, 2);
    x = [nodes(n1, 1) + displacementScale * u(2*n1-1), nodes(n2, 1) + displacementScale * u(2*n2-1)];
    y = [nodes(n1, 2) + displacementScale * u(2*n1), nodes(n2, 2) + displacementScale * u(2*n2)];
    plot(x, y, 'Color', cmap(round(normalizedDisplacements(i)*size(cmap,1)),:), 'LineWidth', 2);
end
clim([0 0.4705]);
colorbar;
axis equal;
hold off;



%% Plotting the Deformed Truss with Stress Colormap

% Create a figure
figure;
hold on;

% Define the colormap
cmap = jet(64); % You can change the number of colors or choose different colormaps
caxis([min(stresses), max(stresses)]); % Set the color axis scaling
colorbar; % Show the color scale

% Exaggeration factor for the displacements
exaggeration_factor = 1; % Adjust this factor as needed for visibility

% Loop over each element to plot
for i = 1:numElements
    n1 = elements(i, 1);
    n2 = elements(i, 2);

    % Original coordinates of the nodes
    x_original = [nodes(n1, 1), nodes(n2, 1)];
    y_original = [nodes(n1, 2), nodes(n2, 2)];

    % Exaggerated deformed coordinates of the nodes
    x_deformed = x_original + exaggeration_factor * [u(2*n1-1), u(2*n2-1)];
    y_deformed = y_original + exaggeration_factor * [u(2*n1), u(2*n2)];

    % Determine the color for the current stress level
    colorIndex = interp1(linspace(min(stresses), max(stresses), size(cmap, 1)), 1:size(cmap, 1), stresses(i));
    color = cmap(round(colorIndex), :);

    % Plotting the element in its deformed state
    line(x_deformed, y_deformed, 'LineWidth', 3, 'Color', color);
end

% Beautify the plot
title('Deformed Truss with Axial Stresses');
xlabel('X Coordinate (m)');
ylabel('Y Coordinate (m)');
axis equal;
grid on;

hold off;


