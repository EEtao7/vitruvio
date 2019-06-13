%% compute and visualize the optimal design
% takes task and robot selection to load corresponding towr motion data
% then computes motion of EE relative to hip, and evolves the link lengths
% to minimize sum of joint torques over full motion for this relative
% motion

% this function calls evolveOptimalLeg which runs the simulation
% runFastJointTorqueSim for each set of link lengths 

function [jointTorqueOpt, qOpt, qdotOpt, qdotdotOpt, rOpt, jointPowerOpt, linkLengthsOpt, hipAttachmentOffsetOpt, penaltyMin, elapsedTime, elapsedTimePerFuncEval, output, linkMassOpt, totalLinkMassOpt] = evolveAndVisualizeOptimalLeg(actuateJointsDirectly, hipAttachmentOffset, linkCount, optimizationProperties, EEselection, meanCyclicMotionHipEE, quadruped, configSelection, dt, taskSelection, hipParalleltoBody, Leg, meanTouchdownIndex)
if (EEselection == 'LF') | (EEselection == 'RF')
    selectFrontHind = 1;
    else selectFrontHind = 2;
end
%% initialize link length values
% link lengths in cm so that optimizer can consider only integer values 
initialLinkLengths(1) = quadruped.hip(selectFrontHind).length*100; 
initialLinkLengths(2) = quadruped.thigh(selectFrontHind).length*100;
initialLinkLengths(3) = quadruped.shank(selectFrontHind).length*100;
if (linkCount == 3) || (linkCount == 4)
    initialLinkLengths(4) = quadruped.foot(selectFrontHind).length*100;
end
if (linkCount == 4)
    initialLinkLengths(5) = quadruped.phalanges(selectFrontHind).length*100;
end
initialHipAttachmentOffset = hipAttachmentOffset*100;

%% print statement
upperBnd = [round(optimizationProperties.bounds.upperBoundMultiplier(1:linkCount+1).*initialLinkLengths)/100, round(optimizationProperties.bounds.upperBoundMultiplier(linkCount+2)*initialHipAttachmentOffset)/100];
lowerBnd = [round(optimizationProperties.bounds.lowerBoundMultiplier(1:linkCount+1).*initialLinkLengths)/100, round(optimizationProperties.bounds.lowerBoundMultiplier(linkCount+2)*initialHipAttachmentOffset)/100];
fprintf('\nLower bound on link lengths [m]:')
disp(lowerBnd);
fprintf('Upper bound on link lengths [m]:')
disp(upperBnd);

%% evolve optimal link lengths by running ga
tic;
[legDesignParameters, penaltyMin, output] = evolveOptimalLeg(upperBnd, lowerBnd, actuateJointsDirectly, hipAttachmentOffset, linkCount, optimizationProperties, initialLinkLengths, taskSelection, quadruped, configSelection, EEselection, dt, meanCyclicMotionHipEE, hipParalleltoBody, Leg, meanTouchdownIndex);
elapsedTime = toc;
elapsedTimePerFuncEval = elapsedTime/output.funccount;
fprintf('Optimized leg design parameters [m]:')
disp(legDesignParameters/100);

%% convert back from cm to m and save the final link lengths into quadruped
linkLengths = legDesignParameters(1:linkCount+1)/100;
hipAttachmentOffset = legDesignParameters(linkCount+2)/100;
% Update link lengths, unit in meters
quadruped.hip(selectFrontHind).length = linkLengths(1);
quadruped.thigh(selectFrontHind).length = linkLengths(2);
quadruped.shank(selectFrontHind).length = linkLengths(3);
if (linkCount == 3) || (linkCount == 4)
    quadruped.foot(selectFrontHind).length = linkLengths(4);
end
if linkCount == 4
    quadruped.phalanges(selectFrontHind).length = linkLengths(5);
end

% Update link mass with assumption of constant density cylinder
quadruped.hip(selectFrontHind).mass = quadruped.legDensity * pi*(quadruped.hip(selectFrontHind).radius)^2   * linkLengths(1);
quadruped.thigh(selectFrontHind).mass = quadruped.legDensity * pi*(quadruped.thigh(selectFrontHind).radius)^2 * linkLengths(2);
quadruped.shank(selectFrontHind).mass = quadruped.legDensity * pi*(quadruped.shank(selectFrontHind).radius)^2 * linkLengths(3);
if (linkCount == 3) || (linkCount == 4)
    quadruped.foot(selectFrontHind).mass = quadruped.legDensity * pi*(quadruped.foot(selectFrontHind).radius)^2 * linkLengths(4);
end
if (linkCount ==4)
    quadruped.phalanges(selectFrontHind).mass = quadruped.legDensity * pi*(quadruped.phalanges(selectFrontHind).radius)^2 * linkLengths(5);
end
%% visualize the optimized design
numberOfLoopRepetitions = 3;
viewVisualization = optimizationProperties.viz.viewVisualization;
% Compute qAFE and qDFE based on heuristics when applicable.
if (linkCount > 2)
    if linkCount == 3
        tempLeg.(EEselection).q(:,4) = computeqFinalJoint(Leg, EEselection, configSelection);
    elseif linkCount == 4
        tempLeg.(EEselection).q(:,5) = computeqFinalJoint(Leg, EEselection, configSelection);
    end
end

% inverse kinematics
[tempLeg.(EEselection).q, tempLeg.(EEselection).r.HAA, tempLeg.(EEselection).r.HFE, tempLeg.(EEselection).r.KFE, tempLeg.(EEselection).r.AFE, tempLeg.(EEselection).r.DFE, tempLeg.(EEselection).r.EE] = inverseKinematics(hipAttachmentOffset, linkCount, meanCyclicMotionHipEE, quadruped, EEselection, taskSelection, configSelection, hipParalleltoBody, Leg);
% build rigid body model
tempLeg.(EEselection).rigidBodyModel = buildRobotRigidBodyModel(actuateJointsDirectly, hipAttachmentOffset, linkCount, quadruped, tempLeg, meanCyclicMotionHipEE, EEselection, numberOfLoopRepetitions, viewVisualization, hipParalleltoBody);

%% get joint torques of optimal design
% finite difference to compute qdot
[tempLeg.(EEselection).qdot, tempLeg.(EEselection).qdotdot] = getJointVelocitiesUsingFiniteDifference(linkCount, EEselection, meanCyclicMotionHipEE, tempLeg, quadruped, dt);
% inverse dynamics
tempLeg.(EEselection).jointTorque = inverseDynamics(EEselection, tempLeg, meanCyclicMotionHipEE, linkCount);

%% get joint power for optimal design
tempLeg.(EEselection).jointPower = tempLeg.(EEselection).jointTorque .* tempLeg.(EEselection).qdot(:,1:end-1);

%% get link mass for optimal design
[linkMassOpt, ~, totalLinkMassOpt] = getLinkMass(tempLeg, EEselection, linkCount);

%% return joint data
linkLengthsOpt = linkLengths;
hipAttachmentOffsetOpt = hipAttachmentOffset;
rOpt = tempLeg.(EEselection).r;
qOpt = tempLeg.(EEselection).q;
qdotOpt = tempLeg.(EEselection).qdot;
qdotdotOpt = tempLeg.(EEselection).qdotdot;
jointTorqueOpt = tempLeg.(EEselection).jointTorque;
jointPowerOpt = tempLeg.(EEselection).jointPower;