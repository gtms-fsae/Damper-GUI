%% Tire and Grip Analysis Georgia Tech Motorsports #64

%% Import data from spreadsheet

% Setup the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 22);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A7:V64126";

% Specify column names and types
opts.VariableNames = ["times1", "udam_flV", "udam_frV", "dam_flin", "dam_frin", "dam_fl_speedins", "dam_fr_speedins", "udam_rlV", "udam_rrV", "dam_rlin", "dam_rrin", "dam_rl_speedins", "dam_rr_speedins", "accxgLongitudinal", "accygLateral", "acczgVertical", "steer", "vwheel_flkmh", "vwheel_frkmh", "vwheel_rlkmh", "vwheel_rrkmh", "yaw"];
opts.VariableTypes = ["string", "string", "string", "double", "double", "double", "double", "string", "string", "double", "double", "double", "double", "string", "string", "string", "string", "string", "string", "string", "string", "string"];

% Specify variable properties
opts = setvaropts(opts, ["times1", "udam_flV", "udam_frV", "udam_rlV", "udam_rrV", "accxgLongitudinal", "accygLateral", "acczgVertical", "steer", "vwheel_flkmh", "vwheel_frkmh", "vwheel_rlkmh", "vwheel_rrkmh", "yaw"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["times1", "udam_flV", "udam_frV", "udam_rlV", "udam_rrV", "accxgLongitudinal", "accygLateral", "acczgVertical", "steer", "vwheel_flkmh", "vwheel_frkmh", "vwheel_rlkmh", "vwheel_rrkmh", "yaw"], "EmptyFieldRule", "auto");

% Import the data
tbl = readtable("E:\GT Motorsports\Vehicle Data\1_4_20 Test1 Data Mike (processed).xlsx", opts, "UseExcel", false);

% Convert to output type
times1 = tbl.times1;
udam_flV = tbl.udam_flV;
udam_frV = tbl.udam_frV;
dam_flin = tbl.dam_flin;
dam_frin = tbl.dam_frin;
dam_fl_speedins = tbl.dam_fl_speedins;
dam_fr_speedins = tbl.dam_fr_speedins;
udam_rlV = tbl.udam_rlV;
udam_rrV = tbl.udam_rrV;
dam_rlin = tbl.dam_rlin;
dam_rrin = tbl.dam_rrin;
dam_rl_speedins = tbl.dam_rl_speedins;
dam_rr_speedins = tbl.dam_rr_speedins;
accxgLongitudinal = tbl.accxgLongitudinal;
accygLateral = tbl.accygLateral;
acczgVertical = tbl.acczgVertical;
steer = tbl.steer;
vwheel_flkmh = tbl.vwheel_flkmh;
vwheel_frkmh = tbl.vwheel_frkmh;
vwheel_rlkmh = tbl.vwheel_rlkmh;
vwheel_rrkmh = tbl.vwheel_rrkmh;
yaw = tbl.yaw;

% Clear temporary variables
clear opts tbl

%% Vehicle Characteristics
front_spring_rate=115; %units lb/in
rear_spring_rate=125; %units lb/in

damper_full_extension=3.62; %units inches.  There is a possibilty of there being binding issues not allowing it 
                            %to reach full extension.  Also, if spring preload is applied this will disrupt some of the calculations.  No preload is intended.
motion_ratio_front=1.682;
motion_ratio_rear=1.644;
trackwidth=48; %units inches
cg_height=13.25; %units inches (Math and data can be found in CG.xlsx sheet in folder 'Vehicle Data'.

%% Wheel Speed 
%This calculation is done using the average of the front left and right
%wheels in order to try and reduce error from wheel slip.
wheel_speed_frkmh=str2double(vwheel_frkmh);
wheel_speed_flkmh=str2double(vwheel_flkmh);
samples_time=str2double(times1);
sample_time=samples_time(2);
sample_rate=1/(sample_time); %units hertz
average_front_wheel_speed=(wheel_speed_frkmh+wheel_speed_flkmh)/2;
%canceling out hours and converting to feet
vehicle_displacement_feet=(average_front_wheel_speed).*sample_time*0.9113444444; %feet
summed_displacement_feet=cumsum(vehicle_displacement_feet);
miles_displacement=summed_displacement_feet/5280;

%% Segregation of Turning Acceleration
steer_angle=str2double(steer);
%converting to strings
a_x_g_longitudinal=str2double(accxgLongitudinal);
a_y_g_lateral=str2double(accygLateral);
a_z_g_vertical=str2double(acczgVertical);
resulting_accel_forward=sqrt(a_y_g_lateral.^2+a_x_g_longitudinal.^2);
a_y_turning=a_y_g_lateral(a_y_g_lateral>=0.5);
a_x_turning=a_x_g_longitudinal(a_y_g_lateral>=0.5);
vehicle_displacement_miles=vehicle_displacement_feet/5280;
miles_displacement_turn_vector=vehicle_displacement_miles(a_y_g_lateral>=0.5);
miles_displacement_turn=cumsum(miles_displacement_turn_vector);

%% Turning Grip
resulting_accel_turn=sqrt(a_y_turning.^2+a_x_turning.^2);
figure('Name','Tire Grip Turning (Raw)','NumberTitle','off');
plot(miles_displacement_turn,resulting_accel_turn)
title('Tire Turning Grip')
xlabel('Displacement (miles)')
ylabel('Acceleration Turning (g)')
area_under_the_curve_turning=trapz(miles_displacement_turn,resulting_accel_turn)

%% Grip Levels

area_under_the_curve_total_grip=trapz(miles_displacement,resulting_accel_forward)
%Plotting Grip
resulting_accel=sqrt(a_x_g_longitudinal.^2+a_y_g_lateral.^2);
figure('Name','Tire Grip Raw','NumberTitle','off');
plot(miles_displacement,resulting_accel)
title('Tire Used Grip')
xlabel('Displacement (miles)')
ylabel('Acceleration (g)')

figure('Name','Tire Grip Frequency (Raw)','NumberTitle','off');
h9=histogram(resulting_accel);
h9.BinWidth = 0.1;
xlabel('Resultant Acceleration (g)')
ylabel('Frequency')
title('Tire Grip Frequency')

%% Chassis Roll
    %Front of Vehicle
    abs_suspension_movement_front=abs(dam_flin-dam_frin);
    front_suspension_rolldeg=atan((abs_suspension_movement_front*(1/motion_ratio_front))/trackwidth)*57.3;
    max_front_rolldeg=max(front_suspension_rolldeg);
    avg_front_rolldeg=mean(front_suspension_rolldeg);
    %Rear of Vehicle
    abs_suspension_movement_rear=abs(dam_rrin-dam_rlin);
    rear_suspension_rolldeg=atan((abs_suspension_movement_rear*(1/motion_ratio_rear))/trackwidth)*57.3;
    max_rear_rolldeg=max(rear_suspension_rolldeg);
    avg_rear_rolldeg=mean(rear_suspension_rolldeg);
    %Full Vehicle Roll
    total_vehicle_rolldeg=atan(((abs_suspension_movement_front*(1/motion_ratio_front))+(abs_suspension_movement_rear*(1/motion_ratio_rear)))/(2*trackwidth))*57.3;
    max_total_vehicle_rolldeg=max(total_vehicle_rolldeg);
    avg_total_vehicle_rolldeg=mean(total_vehicle_rolldeg);
    
%% Roll Gradient
abs_a_y_g_lateral=abs(a_y_g_lateral);
% Fit: 'Roll Gradient Full Car'.
[xData, yData] = prepareCurveData( abs_a_y_g_lateral, total_vehicle_rolldeg );
ft = fittype( 'poly1' );
[fitresult, gof] = fit( xData, yData, ft );
% Plot fit with data.
figure('Name','Roll Gradient','NumberTitle','off');
h = plot( fitresult, xData, yData );
legend( h, 'total_vehicle_rolldeg vs. abs_a_y_g_lateral', 'Roll Gradient', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'Lateral Acceleration (g)', 'Interpreter', 'none' );
ylabel( 'Chassis Roll (Degrees)', 'Interpreter', 'none' );
grid on
curve_fit_values=coeffvalues(fitresult);
roll_gradient_total_vehicle= fitresult.p1
    
%% Wheel Loads
    %Loads created by the compression of the springs and then manipulated
    %by the motion ratio.  Attempting to gain ranges in which the tire is
    %loaded for theoretical calculations.
    %Front Tires
fr_spring_load=abs((damper_full_extension-dam_frin))*(1/motion_ratio_front)*front_spring_rate*motion_ratio_front^2;
fl_spring_load=abs((damper_full_extension-dam_flin))*(1/motion_ratio_front)*front_spring_rate*motion_ratio_front^2;
    %Rear Tires
rr_spring_load=abs((damper_full_extension-dam_rrin))*(1/motion_ratio_rear)*rear_spring_rate*motion_ratio_rear^2;
rl_spring_load=abs((damper_full_extension-dam_rlin))*(1/motion_ratio_rear)*rear_spring_rate*motion_ratio_rear^2;  

%% Wheel Load Statistics
    %creating a table of wheel load statistics based on force produced by
    %springs.

    %Front Calcs (units lbf)
fr_avg_wheel_load_spring=mean(fr_spring_load);
fl_avg_wheel_load_spring=mean(fl_spring_load);
fr_max_load=max(fr_spring_load);
fl_max_load=max(fl_spring_load);
    %Rear Calcs (units lbf)
rr_avg_wheel_load_spring=mean(rr_spring_load);
rl_avg_wheel_load_spring=mean(rl_spring_load);
rr_max_load=max(rr_spring_load);
rl_max_load=max(rl_spring_load);

%Ouput Table Tire Load Statistics
Corner={'FR' ;'FL' ; 'RR'; 'RL'};
AVG_Wheel_Load=[fr_avg_wheel_load_spring; fl_avg_wheel_load_spring; rr_avg_wheel_load_spring; rl_avg_wheel_load_spring];
Max_Tire_Load=[fr_max_load;fl_max_load;rr_max_load;rl_max_load];
T_Tire_Load_Spring= table(AVG_Wheel_Load , Max_Tire_Load,'RowNames',Corner);
    
%Tire Load Histogram
    %Front Tires
figure('Name','Front Tire Load (lbf)','NumberTitle','off');
subplot(2,2,[1 3]);
z=25; % bin width
x =fr_spring_load;
y =fl_spring_load;
h1 = histogram(x,'Normalization','probability','EdgeColor','r');
h1.BinWidth=z;
hold on
h2 = histogram(y,'Normalization','probability','EdgeColor','b');
h2.BinWidth=z;
xlabel('Tire Load (lbf)')
ylabel('Percent Time')
title('Front Right & Left Tire Load')
legend('FR Tire','FL Tire')

%creating the front left damper veloctiy histogram
subplot(2,2,2);    
h3 = histogram(fr_spring_load,'Normalization','probability');
h3.BinWidth=z;
xlabel('Tire Load (lbf)')
ylabel('Percent Time')
title('Front Right Tire Load')

%creating the front right damper veloctiy histogram
subplot(2,2,4);    
h4=histogram(fl_spring_load,'Normalization','probability');
h4.BinWidth=z;
xlabel('Tire Load (lbf)')
ylabel('Percent Time')
title('Front Left Tire Load')

hold off

    %Rear Tires
figure('Name','Rear Tire Load (lbf)','NumberTitle','off');
subplot(2,2,[1 3]);
z=25; % bin width
x =rr_spring_load;
y =rl_spring_load;
h5 = histogram(x,'Normalization','probability','EdgeColor','r');
h5.BinWidth=z;
hold on
h6 = histogram(y,'Normalization','probability','EdgeColor','b');
h6.BinWidth=z;
xlabel('Tire Load (lbf)')
ylabel('Percent Time')
title('Rear Right & Left Tire Load')
legend('RR Tire','RL Tire')

%creating the front left damper veloctiy histogram
subplot(2,2,2);    
h7 = histogram(rr_spring_load,'Normalization','probability');
h7.BinWidth=z;
xlabel('Tire Load (lbf)')
ylabel('Percent Time')
title('Rear Right Tire Load')

%creating the front right damper veloctiy histogram
subplot(2,2,4);    
h8=histogram(rl_spring_load,'Normalization','probability');
h8.BinWidth=z;
xlabel('Tire Load (lbf)')
ylabel('Percent Time')
title('Rear Left Tire Load')

hold off

%% G-G Diagram
 %Creating a full vehicle G-G diagram. 

figure('Name','G-G Diagram','NumberTitle','off');
plot(a_y_g_lateral,a_x_g_longitudinal,'.');
legend( {'G-G Diagram'});
% Label axes
xlabel( 'Lateral Acceleration (g)' );
ylabel( 'Longitudinal Acceleration (g)' );
grid on









