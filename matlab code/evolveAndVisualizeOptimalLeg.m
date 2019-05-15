%% compute and visualize the optimal design
% takes task and robot selection to load corresponding towr motion data
% then computes motion of EE relative to hip, and evolves the link lengths
% to minimize sum of joint torques over full motion for this relative
% motion

% this function calls evolveOptimalLeg which runs the simulation
% runFastJointTorqueSim for each set of link lengths 

clear all 
close all

% select task and robot, configuration and end effector which is to be optimized
taskSelection = 'speedyGallop';
robotSelection = 'speedy';
[removalRatioStart, removalRatioEnd] = getSuggestedRemovalRatios(taskSelection);
load(taskSelection);
dt = t(2) - t(1);
configSelection = 'X'; % unreliable
EEselection = 'LH';
jointCount = 4; %for forward dynamics EE position computation (only works for =4)and counts EE as a joint

% genetic algorithm parameters
upperBoundMultiplier = 3.3;
lowerBoundMultiplier = 0.3;
maxGenerations = 10;
populationSize = 10;


if (EEselection == 'LF') | (EEselection == 'RF')
    selectFrontHind = 1;
    else selectFrontHind = 2;
end


%% get quadruped properties
quadruped = getQuadrupedProperties(robotSelection);

%% get the relative motion of the end effectors to the hips
[relativeMotionHipEE, IF_hip, C_IBody] = getRelativeMotionEEHips(quat, quadruped, base, EE, dt);

%% get the liftoff and touchdown timings for each end effector
[tLiftoff, tTouchdown, minStepCount] = getEELiftoffTouchdownTimings(t, EE);

%% get the mean cyclic position and forces
[meanCyclicMotionHipEE, cyclicMotionHipEE, meanCyclicC_IBody, samplingStart, samplingEnd] = getHipEECyclicData(tLiftoff, tTouchdown, relativeMotionHipEE, EE, removalRatioStart, removalRatioEnd, dt, minStepCount, C_IBody);                  

%% initialize link length values
% link lengths in cm
initialLinkLengths(1) = quadruped.hip(selectFrontHind).length*100; 
initialLinkLengths(2) = quadruped.thigh(selectFrontHind).length*100;
initialLinkLengths(3) = quadruped.shank(selectFrontHind).length*100;

%% compute joint torques for initial leg parameters

% numberOfLoopRepetitions = 1;
% viewVisualization = 0;
% 
% initialq.(EEselection).angle = inverseKinematics(meanCyclicMotionHipEE.LF.position, quadruped, EEselection, taskSelection, configSelection);
% [initialRobotConfig, config] = buildRobotRigidBodyModel(quadruped, initialq, EE, meanCyclicMotionHipEE, EEselection, numberOfLoopRepetitions, viewVisualization);
% [initialq.(EEselection).angVel, initialq.(EEselection).angAccel] = getJointVelocitiesUsingJacobian(EE, meanCyclicMotionHipEE, initialq, quadruped, 1, dt, EEselection);
% initialJointTorque.(EEselection) = getInverseDynamics(EEselection, initialq, meanCyclicMotionHipEE, initialRobotConfig, config);


%% print statement
disp('Dimensions given in cm')
initialLinkLengths
upperBnd = round(upperBoundMultiplier*initialLinkLengths)
lowerBnd = round(lowerBoundMultiplier*initialLinkLengths)
            
%% evolve optimal link lengths by running ga
[linkLengths, penaltyMin] = evolveOptimalLeg(maxGenerations, populationSize, initialLinkLengths, upperBoundMultiplier, lowerBoundMultiplier, taskSelection, robotSelection, configSelection, EEselection, removalRatioStart, removalRatioEnd, base, quat, t, EE, dt, jointCount)

%% convert back from cm to m and save the final link lengths
quadruped.hip(selectFrontHind).length = linkLengths(1)/100;
quadruped.thigh(selectFrontHind).length = linkLengths(2)/100;
quadruped.shank(selectFrontHind).length = linkLengths(3)/100;

%% visualize the optimized design
numberOfLoopRepetitions = 3;
viewVisualization = 1;

q.(EEselection).angle = inverseKinematics(meanCyclicMotionHipEE.LF.position, quadruped, EEselection, taskSelection, configSelection);
[robotConfig, config] = buildRobotRigidBodyModel(quadruped, q, EE, meanCyclicMotionHipEE, EEselection, numberOfLoopRepetitions, viewVisualization);

%% get joint torques of optimal design
[q.(EEselection).angVel, q.(EEselection).angAccel] = getJointVelocitiesUsingJacobian(EEselection, meanCyclicMotionHipEE, q, quadruped, dt);
optimizedJointTorque.(EEselection) = getInverseDynamics(EEselection, q, meanCyclicMotionHipEE, robotConfig, config);