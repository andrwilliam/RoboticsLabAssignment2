%A2

clear all
clc
close all


%workspace = [-5 5 -5 5 -0.05 6];

% Load Hammer
% [faceData,vertexData] = plyread('hammer1.ply','tri');
% L1 = Link('alpha',-pi/2,'a',0,'d',0.3,'offset',0);
% model = SerialLink(L1,'name','hammer');
% model.faces = {faceData,[]};
% vertexData(:,2) = vertexData(:,2) + 0.4;
% model.points = {vertexData,[]};
% 
% q = 0;
% model.base = transl(1,2,1.5);
% model.plot(q,'workspace',[-5 5 -5 5 -0.05 6]);


%Hammer = RobotHammer();
%Hammer.Hammer{1}.base = transl(1,2,3);

%mdl_puma560
%q0 = [pi/20,0,-pi/2,0,0,0];
%p560.base = transl(0,0,2.5);
%p560.plot(q0,'workspace',[-5 5 -5 5 -0.05 6],'scale',0.5);
%hold on

%Kinova spherical 7dof DH Parameters
L1 = Link('d', 0.2755 ,'a', 0       ,'alpha', pi/2  ,'qlim', deg2rad([-350 350]));
L2 = Link('d', 0       ,'a', 0       ,'alpha', pi/2  ,'qlim', deg2rad([47 313]));
L3 = Link('d', 0.41   ,'a', 0       ,'alpha', pi/2  ,'qlim', deg2rad([-350 350]));
L4 = Link('d', 0.0098 ,'a', 0       ,'alpha', pi/2  ,'qlim', deg2rad([30 330]));
L5 = Link('d', 0.3111  ,'a', 0       ,'alpha', pi/2  ,'qlim', deg2rad([-350 350]));
L6 = Link('d', 0       ,'a', 0       ,'alpha', pi/2  ,'qlim', deg2rad([65 295]));
L7 = Link('d', 0.2638 ,'a', 0       ,'alpha', pi    ,'qlim', deg2rad([-350 350]));

Kinova= SerialLink([L1, L2, L3, L4, L5, L6, L7],'name','Kinova robot spherical 7dof');
Kinova.base = transl( 1, 0.5, 2.5);

% q0 is initial pose of Kinova 7dof
q0 = deg2rad([ 180 180 180 180 180 180 180]);
Kinova.plot(q0, 'workspace',[ -5, 5, -5, 6, -0.25, 6], 'scale', 0.5);
%Kinova.teach

hold on

% % Load Table
[f,v,data] = plyread('table1.ply','tri');
tableVertexCount = size(v,1);

% Move center point to origin
midPoint = sum(v)/tableVertexCount;
tableVerts = v - repmat(midPoint,tableVertexCount,1);

% Create a transform to describe the location (at the origin, since it's centered
tablePose = eye(4);

% Scale the colours to be 0-to-1 (they are originally 0-to-255
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
   
TableMesh_h = trisurf(f,v(:,1),v(:,2),v(:,3),'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','Flat');

 % Move the pose forward and a slight and random rotation
   tablePose = transl(1,1,0);
updatedPoints = [tablePose * [v,ones(tableVertexCount,1)]']';  

% Now update the Vertices
TableMesh_h.Vertices = updatedPoints(:,1:3);

drawnow();
 % 
% hold on
% axis equal
% 
% % Load Spanner
% [f,v,data] = plyread('spanner.ply','tri');
% vertexColours=[data.vertex.red, data.vertex.green, data.vertex.blue]/255;
% TableMesh_h = trisurf(f,v(:,1),v(:,2),v(:,3),'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','Flat');
% 
% hold on
% 
% % Load Spanner2
% [f,v,data] = plyread('spanner2.ply','tri');
% vertexColours=[data.vertex.red, data.vertex.green, data.vertex.blue]/255;
% TableMesh_h = trisurf(f,v(:,1),v(:,2),v(:,3),'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','Flat');
% 
% hold on
% 
% surf([-6,-6;6,6],[-6,6;-6,6],[0.01,0.01;0.01,0.01],'CData',imread('unsplash.jpg'),'FaceColor','texturemap');
% 
% hold on
% 


%%
% Load Hammer
[f,v,data] = plyread('Hammer1.ply','tri');
hammerVertexCount = size(v,1);

% Move center point to origin
midPoint = sum(v)/hammerVertexCount;
hammerVerts = v - repmat(midPoint,hammerVertexCount,1);

% Create a transform to describe the location (at the origin, since it's centered
hammerPose = eye(4);

% Scale the colours to be 0-to-1 (they are originally 0-to-255
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
   
hammerMesh_h = trisurf(f,v(:,1),v(:,2),v(:,3),'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','Flat');

 % Move the pose forward and a slight and random rotation
   hammerPose = transl(1,1,2);
updatedPoints = [hammerPose * [v,ones(hammerVertexCount,1)]']';  

% Now update the Vertices
hammerMesh_h.Vertices = updatedPoints(:,1:3);

drawnow();

%% Move robot

p1 = hammerPose;
p2 = transl(1.25,1,2.5);
p3 = transl(1.5,1,2);

q1 = Kinova.ikcon(p1);
q2 = Kinova.ikcon(p2);
q3 = Kinova.ikcon(p3);

steps = 30

s = lspb(0,1,steps); 
qMatrix = nan(steps,6); 

for i = 1:steps; 
    Qmatrix(i,:)= (1-s(i))*q0 + s(i)*q1;
    Kinova.plot(Qmatrix(i,:))
end

for i = 1:steps; 
    Qmatrix(i,:)= (1-s(i))*q1 + s(i)*q2;
    Kinova.plot(Qmatrix(i,:))
end

for i = 1:steps;
     Qmatrix(i,:)= (1-s(i))*q2 + s(i)*q3;
     Kinova.plot(Qmatrix(i,:))
 end




    
    