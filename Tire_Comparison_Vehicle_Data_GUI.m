%% Tire Comparison Georgia Tech Motorsports #64
% The goal of this script is to compare tires that are being considered for
% this season, competing at FSAE Michigan, being the Hoosier LC0 (6" wide) 
%and the R25B (7.5" wide) tires.

%To modify this script only change the name of the Excel File and the
%vector length.

%% Loading Data Set 1

% Setup the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 22);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A7:V73412";

% Specify column names and types
opts.VariableNames = ["times1", "udam_flV", "udam_frV", "dam_flin", "dam_frin", "dam_fl_speedins", "dam_fr_speedins", "udam_rlV", "udam_rrV", "dam_rlin", "dam_rrin", "dam_rl_speedins", "dam_rr_speedins", "accxgLongitudinal", "accygLateral", "acczgVertical", "steer", "vwheel_flkmh", "vwheel_frkmh", "vwheel_rlkmh", "vwheel_rrkmh", "yaw"];
opts.VariableTypes = ["string", "string", "string", "double", "double", "double", "double", "string", "string", "double", "double", "double", "double", "string", "string", "string", "string", "string", "string", "string", "string", "string"];

% Specify variable properties
opts = setvaropts(opts, ["times1", "udam_flV", "udam_frV", "udam_rlV", "udam_rrV", "accxgLongitudinal", "accygLateral", "acczgVertical", "steer", "vwheel_flkmh", "vwheel_frkmh", "vwheel_rlkmh", "vwheel_rrkmh", "yaw"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["times1", "udam_flV", "udam_frV", "udam_rlV", "udam_rrV", "accxgLongitudinal", "accygLateral", "acczgVertical", "steer", "vwheel_flkmh", "vwheel_frkmh", "vwheel_rlkmh", "vwheel_rrkmh", "yaw"], "EmptyFieldRule", "auto");

% Import the data
tbl = readtable("E:\GT Motorsports\Vehicle Data\12_15_19 Test1 Data (Processed).xlsx", opts, "UseExcel", false);

% Convert to output type
a_times1 = tbl.times1;
a_udam_flV = tbl.udam_flV;
a_udam_frV = tbl.udam_frV;
a_dam_flin = tbl.dam_flin;
a_dam_frin = tbl.dam_frin;
a_dam_fl_speedins = tbl.dam_fl_speedins;
a_dam_fr_speedins = tbl.dam_fr_speedins;
a_udam_rlV = tbl.udam_rlV;
a_udam_rrV = tbl.udam_rrV;
a_dam_rlin = tbl.dam_rlin;
a_dam_rrin = tbl.dam_rrin;
a_dam_rl_speedins = tbl.dam_rl_speedins;
a_dam_rr_speedins = tbl.dam_rr_speedins;
a_accxgLongitudinal = tbl.accxgLongitudinal;
a_accygLateral = tbl.accygLateral;
a_acczgVertical = tbl.acczgVertical;
a_steer = tbl.steer;
a_vwheel_flkmh = tbl.vwheel_flkmh;
a_vwheel_frkmh = tbl.vwheel_frkmh;
a_vwheel_rlkmh = tbl.vwheel_rlkmh;
a_vwheel_rrkmh = tbl.vwheel_rrkmh;
a_yaw = tbl.yaw;

% Clear temporary variables
clear opts tbl

%% Loading Data Set 2
% Setup the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 22);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A7:V43863";

% Specify column names and types
opts.VariableNames = ["times1", "udam_flV", "udam_frV", "dam_flin", "dam_frin", "dam_fl_speedins", "dam_fr_speedins", "udam_rlV", "udam_rrV", "dam_rlin", "dam_rrin", "dam_rl_speedins", "dam_rr_speedins", "accxgLongitudinal", "accygLateral", "acczgVertical", "steer", "vwheel_flkmh", "vwheel_frkmh", "vwheel_rlkmh", "vwheel_rrkmh", "yaw"];
opts.VariableTypes = ["string", "string", "string", "double", "double", "double", "double", "string", "string", "double", "double", "double", "double", "string", "string", "string", "string", "string", "string", "string", "string", "string"];

% Specify variable properties
opts = setvaropts(opts, ["times1", "udam_flV", "udam_frV", "udam_rlV", "udam_rrV", "accxgLongitudinal", "accygLateral", "acczgVertical", "steer", "vwheel_flkmh", "vwheel_frkmh", "vwheel_rlkmh", "vwheel_rrkmh", "yaw"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["times1", "udam_flV", "udam_frV", "udam_rlV", "udam_rrV", "accxgLongitudinal", "accygLateral", "acczgVertical", "steer", "vwheel_flkmh", "vwheel_frkmh", "vwheel_rlkmh", "vwheel_rrkmh", "yaw"], "EmptyFieldRule", "auto");

% Import the data
tbl = readtable("E:\GT Motorsports\Vehicle Data\11_25_19 Test2 Data (Processed).xlsx", opts, "UseExcel", false);

% Convert to output type
b_times1 = tbl.times1;
b_udam_flV = tbl.udam_flV;
b_udam_frV = tbl.udam_frV;
b_dam_flin = tbl.dam_flin;
b_dam_frin = tbl.dam_frin;
b_dam_fl_speedins = tbl.dam_fl_speedins;
b_dam_fr_speedins = tbl.dam_fr_speedins;
b_udam_rlV = tbl.udam_rlV;
b_udam_rrV = tbl.udam_rrV;
b_dam_rlin = tbl.dam_rlin;
b_dam_rrin = tbl.dam_rrin;
b_dam_rl_speedins = tbl.dam_rl_speedins;
b_dam_rr_speedins = tbl.dam_rr_speedins;
b_accxgLongitudinal = tbl.accxgLongitudinal;
b_accygLateral = tbl.accygLateral;
b_acczgVertical = tbl.acczgVertical;
b_steer = tbl.steer;
b_vwheel_flkmh = tbl.vwheel_flkmh;
b_vwheel_frkmh = tbl.vwheel_frkmh;
b_vwheel_rlkmh = tbl.vwheel_rlkmh;
b_vwheel_rrkmh = tbl.vwheel_rrkmh;
b_yaw = tbl.yaw;

% Clear temporary variables
clear opts tbl

%% Converting Strings
a_a_y_g_lateral=str2double(a_accygLateral);
a_a_x_g_longitudinal=str2double(a_accxgLongitudinal);

b_a_y_g_lateral=str2double(b_accygLateral);
b_a_x_g_longitudinal=str2double(b_accxgLongitudinal);

%% Combined G-G Diagram
figure('Name','Tire Comparison G-G Diagram','NumberTitle','off');
plot(a_a_y_g_lateral,a_a_x_g_longitudinal,'.',b_a_y_g_lateral,b_a_x_g_longitudinal,'.')
legend( {'A Tire','B Tire'});
xlabel( 'Lateral Acceleration (g)' );
ylabel( 'Longitudinal Acceleration (g)' );
grid on

%% Wheel Speed 
%This calculation is done using the average of the front left and right
%wheels in order to try and reduce error from wheel slip.

% A-Tire
a_wheel_speed_frkmh=str2double(a_vwheel_frkmh);
a_wheel_speed_flkmh=str2double(a_vwheel_flkmh);
a_samples_time=str2double(a_times1);
a_sample_time=a_samples_time(2);
a_sample_rate=1/(a_sample_time); %units hertz
a_average_front_wheel_speed=(a_wheel_speed_frkmh+a_wheel_speed_flkmh)/2;
%canceling out hours and converting to feet
a_vehicle_displacement_feet=(a_average_front_wheel_speed).*a_sample_time*0.9113444444; %feet
a_summed_displacement_feet=cumsum(a_vehicle_displacement_feet);
a_miles_displacement=a_summed_displacement_feet/5280;

% B-Tire
b_wheel_speed_frkmh=str2double(b_vwheel_frkmh);
b_wheel_speed_flkmh=str2double(b_vwheel_flkmh);
b_samples_time=str2double(b_times1);
b_sample_time=b_samples_time(2);
b_sample_rate=1/(b_sample_time); %units hertz
b_average_front_wheel_speed=(b_wheel_speed_frkmh+b_wheel_speed_flkmh)/2;
%canceling out hours and converting to feet
b_vehicle_displacement_feet=(b_average_front_wheel_speed).*b_sample_time*0.9113444444; %feet
b_summed_displacement_feet=cumsum(b_vehicle_displacement_feet);
b_miles_displacement=b_summed_displacement_feet/5280;

%% Segregation of Turning Acceleration

% A-Tire
a_resulting_accel_forward=sqrt(a_a_y_g_lateral.^2+a_a_x_g_longitudinal.^2);
a_a_y_turning=a_a_y_g_lateral(a_a_y_g_lateral>=0.5);
a_a_x_turning=a_a_x_g_longitudinal(a_a_y_g_lateral>=0.5);
a_vehicle_displacement_miles=a_vehicle_displacement_feet/5280;
a_miles_displacement_turn_vector=a_vehicle_displacement_miles(a_a_y_g_lateral>=0.5);
a_miles_displacement_turn=cumsum(a_miles_displacement_turn_vector);

% B-Tire
b_resulting_accel_forward=sqrt(b_a_y_g_lateral.^2+b_a_x_g_longitudinal.^2);
b_a_y_turning=b_a_y_g_lateral(b_a_y_g_lateral>=0.5);
b_a_x_turning=b_a_x_g_longitudinal(b_a_y_g_lateral>=0.5);
b_vehicle_displacement_miles=b_vehicle_displacement_feet/5280;
b_miles_displacement_turn_vector=b_vehicle_displacement_miles(b_a_y_g_lateral>=0.5);
b_miles_displacement_turn=cumsum(b_miles_displacement_turn_vector);

%% Turning Grip

% A-Tire
%The miles displaced is capped at .75 miles in order to keep the amount of
%data being compared even, otherwise the area under the curve would
%obviously be larger for a larger data set.
a_resulting_accel_turn=sqrt(a_a_y_turning.^2+a_a_x_turning.^2);
a_area_under_the_curve_turning=trapz(a_miles_displacement_turn(a_miles_displacement_turn<=.75),a_resulting_accel_turn(a_miles_displacement_turn<=.75));

% B-Tire
b_resulting_accel_turn=sqrt(b_a_y_turning.^2+b_a_x_turning.^2);
b_area_under_the_curve_turning=trapz(b_miles_displacement_turn(b_miles_displacement_turn<=.75),b_resulting_accel_turn(b_miles_displacement_turn<=.75));

%% Total Grip

% A-Tire
a_area_under_the_curve_total_grip=trapz(a_miles_displacement(a_miles_displacement<=.75),a_resulting_accel_forward(a_miles_displacement<=.75));

% B-Tire
b_area_under_the_curve_total_grip=trapz(b_miles_displacement(b_miles_displacement<=.75),b_resulting_accel_forward(b_miles_displacement<=.75));

%% Tire Comparison Chart
Tire={'A Tire' ; 'B Tire'};
Turning_Grip=[a_area_under_the_curve_turning; b_area_under_the_curve_turning];
Total_Grip=[a_area_under_the_curve_total_grip; b_area_under_the_curve_total_grip];
T_Tire_Comparison = table(Turning_Grip, Total_Grip,'RowNames',Tire);
