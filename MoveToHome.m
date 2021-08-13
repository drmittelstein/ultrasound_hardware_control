% Author: David Reza Mittelstein (drmittelstein@gmail.com)
% Medical Engineering, California Institute of Technology, 2020

% Moves every motor of the Velmex stage to their home position
% (defined by Velmex as triggering the negative bumper on the rail)
% and then zeroes the position internally and in the params file at that 
% location.  This can be useful if you wish to move the Velmex stage to an 
% absolute position.
%
% NOTE: if anything is attached to the Velmex stage, this motion may cause
% the attached items to collide with water-bath, etc, so use with caution

clc;
disp('This command moves the stage to the negative most point on all axes')
disp('Confirm that everything is disconnected from the motor stage')
disp(' ');
if strcmp(lower(input('Type CONFIRM to begin: ','s')),'confirm')

    % Connect to Velmex motor stage
    sub_Close_All_Connections;
    params = sub_AllSettings('MoveToHome');
    params = sub_Stage_Initialize(params);

    % Retrieve Serial Object to send motor stage commands
    s = params.Stages.Serial_Object;
    
    % Send commands to home each motor
    % F = enable online mode (ensures that Velmex is not locked in manual)
    % C = clear all comamnds (prevents any stacked commands from executing)
    % ImM-0 = moves motor #m to negative zero position, m = (1,2,3,4)
    % R = run program
    disp('-> Homing x motor')
    fprintf(s,['F,C,I' num2str(params.Stages.x_motor) 'M-0,R']);
    params = sub_Stage_Wait_Until_Ready(params);
    disp('---> Complete')

    disp('-> Homing y motor')
    fprintf(s,['F,C,I' num2str(params.Stages.y_motor) 'M-0,R']);
    params = sub_Stage_Wait_Until_Ready(params);
    disp('---> Complete')
    
    disp('-> Homing z motor')
    fprintf(s,['F,C,I' num2str(params.Stages.z_motor) 'M-0,R']);
    params = sub_Stage_Wait_Until_Ready(params);
    disp('---> Complete')
   
    disp('-> Zeroing Position Registers')
    % N = null position registries
    fprintf(s,'F,C,N,R');
    params = sub_Stage_Wait_Until_Ready(params);
    
    % Update Positions and Origin in Matlab params file
    params = sub_Stage_Update_Positions(params);
    params.Stages.Origin = params.Stages.Position;
    disp('---> Complete')
    
else
    disp('CANCELLED')
    disp(' ')
end


