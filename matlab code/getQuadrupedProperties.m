%% Nominal robot classes
% the link lengths need to be updated during the optimization so this data
% cannot be saved into a .mat file like the motion data

function quadruped = getQuadrupedProperties(robotSelection);

 %% Universal
robot.universal.mass.total = 39.53; % with payload

% offset from CoM to each hip
robot.universal.xNom = 0.34;
robot.universal.yNom = 0.19;
robot.universal.zNom = -0.566+0.4695; % offset from CoM to hip attachment

% row order:    LF LH RF RH
% column order: x, y, z
robot.universal.nomHipPos(1,:) = [robot.universal.xNom, robot.universal.yNom, robot.universal.zNom];
robot.universal.nomHipPos(2,:) = [-robot.universal.xNom, robot.universal.yNom, robot.universal.zNom];
robot.universal.nomHipPos(3,:) = [robot.universal.xNom, -robot.universal.yNom, robot.universal.zNom];
robot.universal.nomHipPos(4,:) = [-robot.universal.xNom, -robot.universal.yNom, robot.universal.zNom];

% link lengths [m]
% fore, hind
robot.universal.hip(1).length = 0.05;
robot.universal.hip(2).length = 0.05;
robot.universal.thigh(1).length = 0.332;
robot.universal.thigh(2).length = 0.332;
robot.universal.shank(1).length = 0.332;
robot.universal.shank(2).length = 0.332;
robot.universal.foot(1).length = 0.05;
robot.universal.foot(2).length = 0.05;

% link radius [m]
% update these values
robot.universal.hip(1).radius = 0.05;
robot.universal.hip(2).radius = 0.05;
robot.universal.thigh(1).radius = 0.05;
robot.universal.thigh(2).radius = 0.05;
robot.universal.shank(1).radius = 0.05;
robot.universal.shank(2).radius = 0.05;
robot.universal.foot(1).radius = 0.05;
robot.universal.foot(2).radius = 0.05;

robot.universal.legDensity = 100; %kg/m^3

%link mass [kg] based on cylindrical link with constant density
link = {'hip','thigh' 'shank' 'foot'};
for i = 1:length(link)
    for j = 1:2
        robot.universal.(link{i})(j).mass = pi()*robot.universal.(link{i})(j).radius^2*robot.universal.(link{i})(j).length*robot.universal.legDensity;
        robot.universal.(link{i})(j).inertia = (1/3)*robot.universal.(link{i})(j).mass*robot.universal.(link{i})(j).length^2;
    end
end


%% Speedy 

robot.speedy.mass.total = 22.52;

% offset from CoM to each hip
robot.speedy.xNom = 0.31;
robot.speedy.yNomFore = 0.1;
robot.speedy.yNomHind = 0.14;
robot.speedy.zNom = -0.304 + 0.47;

% row order:    LF LH RF RH
% column order: x, y, z
robot.speedy.nomHipPos(1,:) = [robot.speedy.xNom, robot.speedy.yNomFore, robot.speedy.zNom];
robot.speedy.nomHipPos(2,:) = [-robot.speedy.xNom, robot.speedy.yNomHind, robot.speedy.zNom];
robot.speedy.nomHipPos(3,:) = [robot.speedy.xNom, -robot.speedy.yNomFore, robot.speedy.zNom];
robot.speedy.nomHipPos(4,:) = [-robot.speedy.xNom, -robot.speedy.yNomHind, robot.speedy.zNom];

% link lengths [m]
% fore, hind
robot.speedy.hip(1).length = 0.05;
robot.speedy.hip(2).length = 0.05;
robot.speedy.thigh(1).length = 1*0.33234;
robot.speedy.thigh(2).length = 1*0.33234;
robot.speedy.shank(1).length = 1.6*0.3;
robot.speedy.shank(2).length = 1.6*0.3;
robot.speedy.foot(1).length = 0.05;
robot.speedy.foot(2).length = 0.05;

% link radius [m]
robot.speedy.hip(1).radius = 0.02;
robot.speedy.hip(2).radius = 0.02;
robot.speedy.thigh(1).radius = 0.02;
robot.speedy.thigh(2).radius = 0.03;
robot.speedy.shank(1).radius = 0.03;
robot.speedy.shank(2).radius = 0.03;
robot.speedy.foot(1).radius = 0.03;
robot.speedy.foot(2).radius = 0.03;

robot.speedy.legDensity = 100; %kg/m^3

%link mass [kg] based on cylindrical link with constant density
for i = 1:length(link)
    for j = 1:2
        robot.speedy.(link{i})(j).mass = pi()*robot.speedy.(link{i})(j).radius^2*robot.speedy.(link{i})(j).length*robot.speedy.legDensity;
        robot.speedy.(link{i})(j).inertia = (1/3)*robot.speedy.(link{i})(j).mass*robot.speedy.(link{i})(j).length^2;
    end
end


%% Massivo 
robot.massivo.mass.total = 80;

% offset from CoM to each hip
robot.massivo.xNom = 0.276;
robot.massivo.yNom = 0.3;
robot.massivo.zNom = -0.553 + 0.5043;

% row order:    LF LH RF RH
% column order: x, y, z
robot.massivo.nomHipPos(1,:) = [robot.massivo.xNom, robot.massivo.yNom, robot.massivo.zNom];
robot.massivo.nomHipPos(2,:) = [-robot.massivo.xNom, robot.massivo.yNom, robot.massivo.zNom];
robot.massivo.nomHipPos(3,:) = [robot.massivo.xNom, -robot.massivo.yNom, robot.massivo.zNom];
robot.massivo.nomHipPos(4,:) = [-robot.massivo.xNom, -robot.massivo.yNom, robot.massivo.zNom];

% link lengths [m]
% fore, hind
robot.massivo.hip(1).length = 0.05;
robot.massivo.hip(2).length = 0.05;
robot.massivo.thigh(1).length = 0.3;
robot.massivo.thigh(2).length = 0.3;
robot.massivo.shank(1).length = 0.3;
robot.massivo.shank(2).length = 0.3;
robot.massivo.foot(1).length = 0.05;
robot.massivo.foot(2).length = 0.05;

% link radius [m]
robot.massivo.hip(1).radius = 0.02;
robot.massivo.hip(2).radius = 0.02;
robot.massivo.thigh(1).radius = 0.02;
robot.massivo.thigh(2).radius = 0.03;
robot.massivo.shank(1).radius = 0.03;
robot.massivo.shank(2).radius = 0.03;
robot.massivo.foot(1).radius = 0.03;
robot.massivo.foot(2).radius = 0.03;

robot.massivo.legDensity = 100; %kg/m^3

%link mass [kg] based on cylindrical link with constant density
for i = 1:length(link)
    for j = 1:2
        robot.massivo.(link{i})(j).mass = pi()*robot.massivo.(link{i})(j).radius^2*robot.massivo.(link{i})(j).length*robot.massivo.legDensity;
        robot.massivo.(link{i})(j).inertia = (1/3)*robot.massivo.(link{i})(j).mass*robot.massivo.(link{i})(j).length^2;
    end
end

%% Centaur 
robot.centaur.mass.total = 80;

% offset from CoM to each hip
robot.centaur.xNomFore = 0.1451;
robot.centaur.xNomHind = 0.407;
robot.centaur.yNom = 0.3;
robot.centaur.zNom = -0.553 + 0.5043;

% row order:    LF LH RF RH
% column order: x, y, z
robot.centaur.nomHipPos(1,:) = [robot.centaur.xNomFore, robot.centaur.yNom, robot.centaur.zNom];
robot.centaur.nomHipPos(2,:) = [-robot.centaur.xNomHind, robot.centaur.yNom, robot.centaur.zNom];
robot.centaur.nomHipPos(3,:) = [robot.centaur.xNomFore, -robot.centaur.yNom, robot.centaur.zNom];
robot.centaur.nomHipPos(4,:) = [-robot.centaur.xNomHind, -robot.centaur.yNom, robot.centaur.zNom];

% link lengths [m]
% fore, hind
robot.centaur.hip(1).length = 0.05;
robot.centaur.hip(2).length = 0.05;
robot.centaur.thigh(1).length = 0.3;
robot.centaur.thigh(2).length = 0.3;
robot.centaur.shank(1).length = 0.3;
robot.centaur.shank(2).length = 0.3;
robot.centaur.foot(1).length = 0.05;
robot.centaur.foot(2).length = 0.05;

% link radius [m]
robot.centaur.hip(1).radius = 0.02;
robot.centaur.hip(2).radius = 0.02;
robot.centaur.thigh(1).radius = 0.02;
robot.centaur.thigh(2).radius = 0.03;
robot.centaur.shank(1).radius = 0.03;
robot.centaur.shank(2).radius = 0.03;
robot.centaur.foot(1).radius = 0.03;
robot.centaur.foot(2).radius = 0.03;

robot.centaur.legDensity = 100; %kg/m^3

%link mass [kg] based on cylindrical link with constant density
for i = 1:length(link)
    for j = 1:2
        robot.centaur.(link{i})(j).mass = pi()*robot.centaur.(link{i})(j).radius^2*robot.centaur.(link{i})(j).length*robot.centaur.legDensity;
        robot.centaur.(link{i})(j).inertia = (1/3)*robot.centaur.(link{i})(j).mass*robot.centaur.(link{i})(j).length^2;
    end
end

%% Mini 

robot.mini.mass.total = 10;

robot.mini.xNom = 0.18;
robot.mini.yNom = 0.1;
robot.mini.zNom = -0.186 + 0.198;

% row order:    LF LH RF RH
% column order: x, y, z
robot.mini.nomHipPos(1,:) = [robot.mini.xNom, robot.mini.yNom, robot.mini.zNom];
robot.mini.nomHipPos(2,:) = [-robot.mini.xNom, robot.mini.yNom, robot.mini.zNom];
robot.mini.nomHipPos(3,:) = [robot.mini.xNom, -robot.mini.yNom, robot.mini.zNom];
robot.mini.nomHipPos(4,:) = [-robot.mini.xNom, -robot.mini.yNom, robot.mini.zNom];

% link lengths [m]
% fore, hind
robot.mini.hip(1).length = 0.05;
robot.mini.hip(2).length = 0.05;
robot.mini.thigh(1).length = 0.14;
robot.mini.thigh(2).length = 0.14;
robot.mini.shank(1).length = 0.14;
robot.mini.shank(2).length = 0.14;
robot.mini.foot(1).length = 0.05;
robot.mini.foot(2).length = 0.05;

% link radius [m]
robot.mini.hip(1).radius = 0.02;
robot.mini.hip(2).radius = 0.02;
robot.mini.thigh(1).radius = 0.02;
robot.mini.thigh(2).radius = 0.03;
robot.mini.shank(1).radius = 0.03;
robot.mini.shank(2).radius = 0.03;
robot.mini.foot(1).radius = 0.03;
robot.mini.foot(2).radius = 0.03;

robot.mini.legDensity = 100; %kg/m^3

%link mass [kg] based on cylindrical link with constant density
for i = 1:length(link)
    for j = 1:2
        robot.mini.(link{i})(j).mass = pi()*robot.mini.(link{i})(j).radius^2*robot.mini.(link{i})(j).length*robot.mini.legDensity;
        robot.mini.(link{i})(j).inertia = (1/3)*robot.mini.(link{i})(j).mass*robot.mini.(link{i})(j).length^2;
    end
end

quadruped = robot.(robotSelection);