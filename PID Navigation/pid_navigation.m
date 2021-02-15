%%%Controlling motor and testing camera
vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
vrep.simxFinish(-1); % just in case, close all opened connections
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
left_base = 1;
right_base = 1;
distance = @(a,b) sqrt((a(1)-b(1))^2 + (a(2)-b(2))^2);  %calculate distance (inline function)

%if matlab is connected with vrep environment then it will return >-1
if(clientID>-1)
   disp('connected');
   %handle code
   [returnCode,left_motor]=vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_leftMotor',vrep.simx_opmode_blocking);
   [returnCode,right_motor]=vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_rightMotor',vrep.simx_opmode_blocking);
  
   des = [1,1];  %destination point
   kp = 0.8;
   kd = 0.4;
   
   prev_error = 0;
   %[returnCode,camera]=vrep.simxGetObjectHandle(clientID,'Vision_sensor',vrep.simx_opmode_blocking);
   while(1)
   %other code
   [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_motor,0.1,vrep.simx_opmode_blocking);  %left motor will run in 0.1 speed
   [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_motor,0.1,vrep.simx_opmode_blocking);  %left motor will run in 0.1 speed
   
   [returnCode,detectionState,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,front_sensor,vrep.simx_opmode_streaming);
   [returnCode,detectionState,detectedPoint1,~,~]=vrep.simxReadProximitySensor(clientID,front_sensor1,vrep.simx_opmode_streaming);
   [returnCode,detectionState,detectedPoint2,~,~]=vrep.simxReadProximitySensor(clientID,front_sensor2,vrep.simx_opmode_streaming);
   [ ~,dummy]=vrep.simxGetObjectHandle(clientID,'Dummy',vrep.simx_opmode_blocking);  %for reference coordinate point in vrep
   [ ~,bot]=vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx',vrep.simx_opmode_blocking);
   %here ~ means matlab won't save this 
   %[returnCode,resolution,image]=vrep.simxGetVisionSensorImage2(clientID,camera,1,vrep.simx_opmode_streaming);
   
   [~,pos]=vrep.simxGetObjectPosition(clientID, bot,dummy,vrep.simx_opmode_blocking)
   % Getting Orientation
   [~,theta]=vrep.simxGetObjectOrientation(clientID, bot,dummy,vrep.simx_opmode_blocking);
   % Calculationg Orientation from Path
   newxtheta = atan2((des(2) - pos(2)),(des(1) - pos(1)));
   error = (abs(theta(3))-abs(newxtheta));  %error

   p = kp*error;
   d = kd*(error-prev_error);

   pid = p + d;  %pd is used here
   prev_error = error;  %for Differential error
   
   base = 1; %base speed of both wheel
   ul = base + pid; %left wheel speed
   ur = base - pid;  %right wheel speed
   [r1]=vrep.simxSetJointTargetVelocity( clientID,left_motor, ul,vrep.simx_opmode_blocking);  
   [r2]=vrep.simxSetJointTargetVelocity( clientID,right_motor, ur,vrep.simx_opmode_blocking);
   pause(0.01);
       
   if(distance(des,pos(1:2)) <= 0.05)  %if this robot reaches the radius of 0.05 around the destination then it stops
       [r1]=vrep.simxSetJointTargetVelocity( clientID,left_motor, 0,vrep.simx_opmode_blocking);  
       [r2]=vrep.simxSetJointTargetVelocity( clientID,right_motor, 0,vrep.simx_opmode_blocking); 
       break
   end
   end
   
   vrep.simxFinish(-1); % just in case, close all opened connections
end

vrep.delete()
