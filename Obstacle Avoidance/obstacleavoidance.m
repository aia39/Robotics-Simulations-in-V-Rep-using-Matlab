%%%Controlling motor and testing camera
vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
vrep.simxFinish(-1); % just in case, close all opened connections
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);

%if matlab is connected with vrep environment then it will return >-1
if(clientID>-1)
   disp('connected');
   %handle code
   [returnCode,left_motor]=vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_leftMotor',vrep.simx_opmode_blocking);
   [returnCode,right_motor]=vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_rightMotor',vrep.simx_opmode_blocking);
   [returnCode,front_sensor]=vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_ultrasonicSensor4',vrep.simx_opmode_blocking);
   [returnCode,front_sensor1]=vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_ultrasonicSensor5',vrep.simx_opmode_blocking);
   [returnCode,front_sensor2]=vrep.simxGetObjectHandle(clientID,'Pioneer_p3dx_ultrasonicSensor3',vrep.simx_opmode_blocking);
   
   %[returnCode,camera]=vrep.simxGetObjectHandle(clientID,'Vision_sensor',vrep.simx_opmode_blocking);
   
   %other code
   [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_motor,0.1,vrep.simx_opmode_blocking);  %left motor will run in 0.1 speed
   [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_motor,0.1,vrep.simx_opmode_blocking);  %left motor will run in 0.1 speed
   
   [returnCode,detectionState,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,front_sensor,vrep.simx_opmode_streaming);
   [returnCode,detectionState,detectedPoint1,~,~]=vrep.simxReadProximitySensor(clientID,front_sensor1,vrep.simx_opmode_streaming);
   [returnCode,detectionState,detectedPoint2,~,~]=vrep.simxReadProximitySensor(clientID,front_sensor2,vrep.simx_opmode_streaming);
   %here ~ means matlab won't save this 
   %[returnCode,resolution,image]=vrep.simxGetVisionSensorImage2(clientID,camera,1,vrep.simx_opmode_streaming);
   while(1)
       [returnCode,detectionState,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,front_sensor,vrep.simx_opmode_buffer);
       [returnCode,detectionState,detectedPoint1,~,~]=vrep.simxReadProximitySensor(clientID,front_sensor1,vrep.simx_opmode_buffer);
       [returnCode,detectionState,detectedPoint2,~,~]=vrep.simxReadProximitySensor(clientID,front_sensor2,vrep.simx_opmode_buffer);
       %[returnCode,resolution,image]=vrep.simxGetVisionSensorImage2(clientID,camera,1,vrep.simx_opmode_buffer);
       disp(norm(detectedPoint2));
       %imshow(image);
       pause(0.1);
       if((norm(detectedPoint)<0.45 & norm(detectedPoint)>0.3) | (norm(detectedPoint1)<0.45 & norm(detectedPoint1)>0.3) | (norm(detectedPoint2)<0.45 & norm(detectedPoint2)>0.3))
           [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_motor,-0.05,vrep.simx_opmode_blocking);  %left motor will run in 0.1 speed
           [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_motor,-0.05,vrep.simx_opmode_blocking);  %right motor will run in 0.1 speed
           pause(2);
           [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_motor,0.05,vrep.simx_opmode_blocking);  %left motor will run in 0.1 speed
           [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_motor,-0.05,vrep.simx_opmode_blocking);  %right motor will run in 0.1 speed
           pause(2);   %acts like delay in arduino
           [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_motor,0.05,vrep.simx_opmode_blocking);  %left motor will run in 0.1 speed
           [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_motor,0.05,vrep.simx_opmode_blocking);  %right motor will run in 0.1 speed       
       end
   end
   
   vrep.simxFinish(-1); % just in case, close all opened connections
end

vrep.delete()