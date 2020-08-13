vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
vrep.simxFinish(-1); % just in case, close all opened connections
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);

if(clientID>-1)
   disp('connected');
   %handle code
   [returnCode,left_motor]=vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_rightMotor',vrep.simx_opmode_blocking);
   [returnCode,front_sensor]=vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_ultrasonicSensor13',vrep.simx_opmode_blocking);
   
   [returnCode,camera]=vrep.simxGetObjectHandle(clientID,'Vision_sensor',vrep.simx_opmode_blocking);
   
   %other code
   [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_motor,0.05,vrep.simx_opmode_blocking);  %left motor will run in 0.1 speed
   
   [returnCode,detectionState,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,front_sensor,vrep.simx_opmode_streaming);
   %here ~ means matlab won't save this 
   [returnCode,resolution,image]=vrep.simxGetVisionSensorImage2(clientID,camera,1,vrep.simx_opmode_streaming);
   
   
   for i=1:50
       [returnCode,detectionState,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,front_sensor,vrep.simx_opmode_buffer);
       [returnCode,resolution,image]=vrep.simxGetVisionSensorImage2(clientID,camera,1,vrep.simx_opmode_buffer);
       disp(norm(detectedPoint));
       imshow(image);
       pause(0.1)
   end
   %pause(3);  %immediate upper code will run for 3 seconds
   [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_motor,0,vrep.simx_opmode_blocking);    %left motor will run in 0 speed,means it will stop
   vrep.simxFinish(-1); % just in case, close all opened connections
end

vrep.delete()