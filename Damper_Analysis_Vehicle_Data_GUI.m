function Damper_Analysis_Vehicle_Data_GUI(fileName)

%%Damper Analysis Georgia Tech Motorsports #64

    %The goal of this script is to tune the vehicle through analysis of test
    %data from sensors such as accelerometer, damper position (& derived speed),
    %steering input, wheel speed, throttle position, brake pressure, brake temperature, and tire temperature.
%This vehicle analysis is more VD and suspension based. Powertrain is doing their own analysis.

%% Import data from spreadsheet


%% Setup the Import Options
opts = spreadsheetImportOptions("NumVariables", 22);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A7:V53727";

% Specify column names and types
opts.VariableNames = ["times1", "udam_flV", "udam_frV", "dam_flin", "dam_frin", "dam_fl_speedins", "dam_fr_speedins", "udam_rlV", "udam_rrV", "dam_rlin", "dam_rrin", "dam_rl_speedins", "dam_rr_speedins", "accxgLongitudinal", "accygLateral", "acczgVertical", "steer", "vwheel_flkmh", "vwheel_frkmh", "vwheel_rlkmh", "vwheel_rrkmh", "yaw"];
opts.VariableTypes = ["double", "string", "string", "double", "double", "double", "double", "string", "string", "double", "double", "double", "double", "string", "string", "string", "string", "string", "string", "string", "string", "string"];
opts = setvaropts(opts, [2, 3, 8, 9, 14, 15, 16, 17, 18, 19, 20, 21, 22], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [2, 3, 8, 9, 14, 15, 16, 17, 18, 19, 20, 21, 22], "EmptyFieldRule", "auto");

% Import the data
tbl = readtable(fileName, opts, "UseExcel", false);

%% Convert to output type
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

%% Clear temporary variables
clear opts tbl

%% Full Extension Percent
%calculating how long the dampers are at full extension/ the tire is
%leaving the ground
number_of_samples=numel(dam_frin);
    %Front Dampers
    fr_full_extension=dam_frin(dam_frin>3.6);
    fl_full_extension=dam_flin(dam_flin>3.6);
    count_fr_extended=numel(fr_full_extension);
    count_fl_extended=numel(fl_full_extension);
    fr_percent_full_extension=(count_fr_extended/number_of_samples)*100;
    fl_percent_full_extension=(count_fl_extended/number_of_samples)*100;
    %Rear Dampers
    rr_full_extension=dam_rrin(dam_rrin>3.6);
    rl_full_extension=dam_rlin(dam_rlin>3.5);
    count_rr_extended=numel(rr_full_extension);
    count_rl_extended=numel(rl_full_extension);
    rr_percent_full_extension=(count_rr_extended/number_of_samples)*100;
    rl_percent_full_extension=(count_rl_extended/number_of_samples)*100;
    
%% Compression and Rebound Segregation
%Front Dampers
%Segregating the data to have compression and rebound seperately.
fr_speed_compression=dam_fr_speedins(dam_fr_speedins>=0);
fl_speed_compression=dam_fl_speedins(dam_fl_speedins>=0);
fr_speed_rebound=dam_fr_speedins(dam_fr_speedins<0);
fl_speed_rebound=dam_fl_speedins(dam_fl_speedins<0);

%Rear Dampers
%Segregating the data to have compression and rebound seperately.
rr_speed_compression=dam_rr_speedins(dam_rl_speedins>=0);
rl_speed_compression=dam_rl_speedins(dam_rl_speedins>=0);
rr_speed_rebound=dam_rr_speedins(dam_rr_speedins<0);
rl_speed_rebound=dam_rl_speedins(dam_rl_speedins<0);

%% Maximum,Minimum,AVG, Standard Deviation, Skewness, Kurtosis, Upper and Lower Quartile
%Front Dampers    %Average speed (Full Dataset)
    fr_avg_speed=mean(dam_fr_speedins);
    fl_avg_speed=mean(dam_fl_speedins);
    %Max Speed Compression
    max_fr_comp=max(dam_fr_speedins);
    max_fl_comp=max(dam_fl_speedins);
    %Min Speed Rebound
    min_fr_comp=min(dam_fr_speedins);
    min_fl_comp=min(dam_fl_speedins);
    %Median
    fr_damper_median_speed=median(dam_fr_speedins);
    fl_damper_median_speed=median(dam_fl_speedins);
    %Standard Deviation (S)
        %Front Dampers
        S_fr_speed=std(dam_fr_speedins);
        S_fl_speed=std(dam_fl_speedins);
        %Rear Dampers
        S_rr_speed=std(dam_rr_speedins);
        S_rl_speed=std(dam_rl_speedins);
    %Skewness
    %If the value is greater than one or less than negative one it is
    %highly skewed. If it is between -1 and -0.5 or between 1 and 0.5 then
    %it is moderately skewed. If it is between -0.5 and 0.5 then it is
    %approximately symmetric (https://brownmath.com/stat/shape.htm)
        %Front Dampers
        skewness_fr_speed=skewness(dam_fr_speedins);
        skewness_fl_speed=skewness(dam_fl_speedins);
        %Rear Dampers
        skewness_rr_speed=skewness(dam_rr_speedins);
        skewness_rl_speed=skewness(dam_rl_speedins);
    %Kurtosis
        %Front Dampers
        kurtosis_fr_speed=kurtosis(dam_fr_speedins);
        kurtosis_fl_speed=kurtosis(dam_fl_speedins);
        %Rear Dampers
        kurtosis_rr_speed=kurtosis(dam_rr_speedins);
        kurtosis_rl_speed=kurtosis(dam_rl_speedins);
    %Quartile Ranges
        %Upper range(median- Q3)
        fr_upper_range=dam_fr_speedins(dam_fr_speedins>fr_damper_median_speed);
        fl_upper_range=dam_fl_speedins(dam_fl_speedins>fl_damper_median_speed);
        %Lower Range (Median- Q1)
        fr_lower_range=dam_fr_speedins(dam_fr_speedins<fr_damper_median_speed);
        fl_lower_range=dam_fl_speedins(dam_fl_speedins<fl_damper_median_speed);
    %Upper Quartile Q3
    upper_quartile_fr_dam=median(fr_upper_range);
    upper_quartile_fl_dam=median(fl_upper_range);
    %Lower Quartile Q1
    lower_quartile_fr_dam=median(fr_lower_range);
    lower_quartile_fl_dam=median(fl_lower_range);
    %IQR Internal Quartile Range
    iqr_damper_fr=upper_quartile_fr_dam- lower_quartile_fr_dam;
    iqr_damper_fl=upper_quartile_fl_dam- lower_quartile_fl_dam;

%Rear Dampers
    %Average speed (Full Dataset)
    rr_avg_speed=mean(dam_rr_speedins);
    rl_avg_speed=mean(dam_rl_speedins);
    %Max Speed Compression
    max_rr_comp=max(dam_rr_speedins);
    max_rl_comp=max(dam_rl_speedins);
    %Min Speed Rebound
    min_rr_comp=min(dam_rr_speedins);
    min_rl_comp=min(dam_rl_speedins);
    %Median
    rr_damper_median_speed=median(dam_rr_speedins);
    rl_damper_median_speed=median(dam_rl_speedins);
    %Quartile Ranges
        %Upper range(median- Q3)
        rr_upper_range=dam_rr_speedins(dam_rr_speedins>rr_damper_median_speed);
        rl_upper_range=dam_rl_speedins(dam_rl_speedins>rl_damper_median_speed);
        %Lower Range (Median- Q1)
        rr_lower_range=dam_rr_speedins(dam_rr_speedins<rr_damper_median_speed);
        rl_lower_range=dam_rl_speedins(dam_rl_speedins<rl_damper_median_speed);
    %Upper Quartile Q3
    upper_quartile_rr_dam=median(rr_upper_range);
    upper_quartile_rl_dam=median(rl_upper_range);
    %Lower Quartile Q1
    lower_quartile_rr_dam=median(rr_lower_range);
    lower_quartile_rl_dam=median(rl_lower_range);
    %IQR Internal Quartile Range
    iqr_damper_rr=upper_quartile_rr_dam- lower_quartile_rr_dam;
    iqr_damper_rl=upper_quartile_rl_dam- lower_quartile_rl_dam;
    
%% Percent Time in Bump and Rebound
    %Front Dampers
        %Front Right Bump
            %This count applies to all four corners
            F=3.5 %in/s
            G=-3.5 %in/s
            number_of_speed_samples=numel(dam_fr_speedins);
            fr_low_speed_bump_speedins=fr_speed_compression(fr_speed_compression<=F);
            fr_high_speed_bump_speedins=fr_speed_compression(fr_speed_compression>F);
            number_low_speed_bump_fr_raw=numel(fr_low_speed_bump_speedins);
            number_high_speed_bump_fr_raw=numel(fr_high_speed_bump_speedins);
            percent_low_speed_bump_fr_raw=(number_low_speed_bump_fr_raw/number_of_speed_samples)*100;
            percent_high_speed_bump_fr_raw=(number_high_speed_bump_fr_raw/number_of_speed_samples)*100;
        %Front Left Bump
            fl_low_speed_bump_speedins=fl_speed_compression(fl_speed_compression<=F);
            fl_high_speed_bump_speedins=fl_speed_compression(fl_speed_compression>F);
            number_low_speed_bump_fl_raw= numel(fl_low_speed_bump_speedins);
            number_high_speed_bump_fl_raw= numel(fl_high_speed_bump_speedins);
            percent_low_speed_bump_fl_raw=(number_low_speed_bump_fl_raw/number_of_speed_samples)*100;
            percent_high_speed_bump_fl_raw=(number_high_speed_bump_fl_raw/number_of_speed_samples)*100;
        %Front Right Rebound
            fr_low_speed_rebound_speedins=fr_speed_rebound(fr_speed_rebound>=G);
            fr_high_speed_rebound_speedins=fr_speed_rebound(fr_speed_rebound<G);
            number_low_speed_rebound_fr_raw=numel(fr_low_speed_rebound_speedins);
            number_high_speed_rebound_fr_raw=numel(fr_high_speed_rebound_speedins);
            percent_low_speed_rebound_fr_raw=(number_low_speed_rebound_fr_raw/number_of_speed_samples)*100;
            percent_high_speed_rebound_fr_raw=(number_high_speed_rebound_fr_raw/number_of_speed_samples)*100;
        %Front Left Rebound
            fl_low_speed_rebound_speedins=fl_speed_rebound(fl_speed_rebound>=G);
            fl_high_speed_rebound_speedins=fl_speed_rebound(fl_speed_rebound<G);
            number_low_speed_rebound_fl_raw= numel(fl_low_speed_rebound_speedins);
            number_high_speed_rebound_fl_raw= numel(fl_high_speed_rebound_speedins);
            percent_low_speed_rebound_fl_raw=(number_low_speed_rebound_fl_raw/number_of_speed_samples)*100;
            percent_high_speed_rebound_fl_raw=(number_high_speed_rebound_fl_raw/number_of_speed_samples)*100;
            
    %Rear Dampers
        %Rear Right Bump
            rr_low_speed_bump_speedins=rr_speed_compression(rr_speed_compression<=F);
            rr_high_speed_bump_speedins=rr_speed_compression(rr_speed_compression>F);
            number_low_speed_bump_rr_raw=numel(rr_low_speed_bump_speedins);
            number_high_speed_bump_rr_raw=numel(rr_high_speed_bump_speedins);
            percent_low_speed_bump_rr_raw=(number_low_speed_bump_rr_raw/number_of_speed_samples)*100;
            percent_high_speed_bump_rr_raw=(number_high_speed_bump_rr_raw/number_of_speed_samples)*100;
        %Rear Left Bump
            rl_low_speed_bump_speedins=rl_speed_compression(rl_speed_compression<=F);
            rl_high_speed_bump_speedins=rl_speed_compression(rl_speed_compression>F);
            number_low_speed_bump_rl_raw= numel(rl_low_speed_bump_speedins);
            number_high_speed_bump_rl_raw= numel(rl_high_speed_bump_speedins);
            percent_low_speed_bump_rl_raw=(number_low_speed_bump_rl_raw/number_of_speed_samples)*100;
            percent_high_speed_bump_rl_raw=(number_high_speed_bump_rl_raw/number_of_speed_samples)*100;
        %Rear Right Rebound
            rr_low_speed_rebound_speedins=rr_speed_rebound(rr_speed_rebound>=G);
            rr_high_speed_rebound_speedins=rr_speed_rebound(rr_speed_rebound<G);
            number_low_speed_rebound_rr_raw=numel(rr_low_speed_rebound_speedins);
            number_high_speed_rebound_rr_raw=numel(rr_high_speed_rebound_speedins);
            percent_low_speed_rebound_rr_raw=(number_low_speed_rebound_rr_raw/number_of_speed_samples)*100;
            percent_high_speed_rebound_rr_raw=(number_high_speed_rebound_rr_raw/number_of_speed_samples)*100;
        %Rear Left Rebound
            rl_low_speed_rebound_speedins=rl_speed_rebound(rl_speed_rebound>=G);
            rl_high_speed_rebound_speedins=rl_speed_rebound(rl_speed_rebound<G);
            number_low_speed_rebound_rl_raw= numel(rl_low_speed_rebound_speedins);
            number_high_speed_rebound_rl_raw= numel(rl_high_speed_rebound_speedins);
            percent_low_speed_rebound_rl_raw=(number_low_speed_rebound_rl_raw/number_of_speed_samples)*100;
            percent_high_speed_rebound_rl_raw=(number_high_speed_rebound_rl_raw/number_of_speed_samples)*100;

%% Front Damper Shaft Speed Histograms (Raw)
figure('Name','Front Damper Histograms (Raw)','NumberTitle','off');
subplot(2,2,[1 3]);
z=.1; % bin width
x =dam_fl_speedins;
y =dam_fr_speedins;
h1 = histogram(x,'Normalization','probability','EdgeColor','r');
h1.BinWidth=z;
hold on
h2 = histogram(y,'Normalization','probability','EdgeColor','b');
h2.BinWidth=z;
xlabel('Shaft Velocity (In/s)')
ylabel('Frequency')
title('Front Left & Right Damper Velocity')
legend('FL Damper','FR Damper')

%creating the front left damper veloctiy histogram
subplot(2,2,2);    
h3 = histogram(dam_fl_speedins,'Normalization','probability');
h3.BinWidth=z;
xlabel('Shaft Velocity (In/s)')
ylabel('Frequency')
title('Front Left Damper Velocity')
%plot(conv(h3.BinEdges, [0.5 0.5], 'valid'), h3.BinCounts)

%creating the front right damper veloctiy histogram
subplot(2,2,4);    
h4=histogram(dam_fr_speedins,'Normalization','probability');
h4.BinWidth=z;
xlabel('Shaft Velocity (In/s)')
ylabel('Frequency')
title('Front Right Damper Velocity')

hold off

%% Front Damper Shaft Speed Histograms (Trimmed)
%This is trimming the data at 1.5 times the interquratile range (IQR) above the
%upper quartile and 1.5 times the IQR below the lower quartile.
figure('Name','Front Damper Histograms (Trimmed)','NumberTitle','off');
m= (dam_fr_speedins>lower_quartile_fr_dam-1.5*iqr_damper_fr) & (dam_fr_speedins<upper_quartile_fr_dam+1.5*iqr_damper_fr);
n= (dam_fl_speedins>lower_quartile_fl_dam-1.5*iqr_damper_fl) & (dam_fl_speedins<upper_quartile_fl_dam+1.5*iqr_damper_fl);
subplot(2,2,[1 3]);
h5 = histogram(dam_fl_speedins(n),'Normalization','probability','EdgeColor','r');
h5.BinWidth=z;
hold on
h6 = histogram(dam_fr_speedins(m),'Normalization','probability','EdgeColor','b');
h6.BinWidth=z;
xlabel('Shaft Velocity (In/s)')
ylabel('Frequency')
title('Front Left & Right Damper Velocity')
legend('FL Damper','FR Damper')

%creating the front left damper veloctiy histogram
subplot(2,2,2);    
h7 = histogram(dam_fl_speedins(n),'Normalization','probability');
h7.BinWidth=z;
xlabel('Shaft Velocity (In/s)')
ylabel('Frequency')
title('Front Left Damper Velocity')

%creating the front right damper veloctiy histogram
subplot(2,2,4);    
h8=histogram(dam_fr_speedins(m),'Normalization','probability');
h8.BinWidth=z;
xlabel('Shaft Velocity (In/s)')
ylabel('Frequency')
title('Front Right Damper Velocity')
hold off

%Plotting Statistics Table Front Dampers
Corner={'FR' ; 'FL'};
Percent_Full_Extension=[fr_percent_full_extension; fl_percent_full_extension];
Front_Skewness=[skewness_fr_speed; skewness_fl_speed];
Front_Kurtosis=[kurtosis_fr_speed; kurtosis_fl_speed];
Front_Median=[fr_damper_median_speed; fl_damper_median_speed];
Front_AVG=[fr_avg_speed; fl_avg_speed];
Front_Percent_High_Speed_Bump=[percent_high_speed_bump_fr_raw; percent_high_speed_bump_fl_raw];
Front_Percent_Low_Speed_Bump=[percent_low_speed_bump_fr_raw; percent_low_speed_bump_fl_raw];
Front_Percent_High_Speed_Rebound=[percent_high_speed_rebound_fr_raw; percent_high_speed_rebound_fl_raw];
Front_Percent_Low_Speed_Rebound=[percent_low_speed_rebound_fr_raw; percent_low_speed_rebound_fl_raw];
T_Speed_Front = table(Percent_Full_Extension, Front_Skewness,Front_Kurtosis,Front_Median,Front_AVG,Front_Percent_High_Speed_Bump,Front_Percent_Low_Speed_Bump,Front_Percent_High_Speed_Rebound,Front_Percent_Low_Speed_Rebound,'RowNames',Corner);

%% Rear Damper Shaft Speed Histograms (Raw)
figure('Name','Rear Damper Histograms (Raw)','NumberTitle','off');
subplot(2,2,[1 3]);
r =dam_rl_speedins;
s =dam_rr_speedins;
h9 = histogram(r,'Normalization','probability','EdgeColor','r');
h9.BinWidth=z;
hold on
h10 = histogram(s,'Normalization','probability','EdgeColor','b');
h10.BinWidth=z;
xlabel('Shaft Velocity (In/s)')
ylabel('Frequency')
title('Rear Left & Right Damper Velocity')
legend('RL Damper','RR Damper')

%creating the rear left damper veloctiy histogram
subplot(2,2,2);    
h11 = histogram(dam_rl_speedins,'Normalization','probability');
h11.BinWidth=z;
xlabel('Shaft Velocity (In/s)')
ylabel('Frequency')
title('Rear Left Damper Velocity')

%creating the rear right damper veloctiy histogram
subplot(2,2,4);    
h12=histogram(dam_rr_speedins,'Normalization','probability');
h12.BinWidth=z;
xlabel('Shaft Velocity (In/s)')
ylabel('Frequency')
title('Rear Right Damper Velocity')

hold off

%% Rear Damper Shaft Speed Histograms (Trimmed)
%This is trimming the data at 1.5 times the interquratile range (IQR) above the
%upper quartile and 1.5 times the IQR below the lower quartile.
figure('Name','Rear Damper Histograms (Trimmed)','NumberTitle','off');
o= (dam_rr_speedins>lower_quartile_rr_dam-1.5*iqr_damper_rr) & (dam_rr_speedins<upper_quartile_rr_dam+1.5*iqr_damper_rr);
p= (dam_rl_speedins>lower_quartile_rl_dam-1.5*iqr_damper_rl) & (dam_rl_speedins<upper_quartile_rl_dam+1.5*iqr_damper_rl);
subplot(2,2,[1 3]);
h13 = histogram(dam_rl_speedins(p),'Normalization','probability','EdgeColor','r');
h13.BinWidth=z;
hold on
h14 = histogram(dam_rr_speedins(o),'Normalization','probability','EdgeColor','b');
h14.BinWidth=z;
xlabel('Shaft Velocity (In/s)')
ylabel('Frequency')
title('Rear Left & Right Damper Velocity')
legend('RL Damper','RR Damper')

%creating the rear left damper veloctiy histogram
subplot(2,2,2);    
h15 = histogram(dam_rl_speedins(p),'Normalization','probability');
h15.BinWidth=z;
xlabel('Shaft Velocity (In/s)')
ylabel('Frequency')
title('Rear Left Damper Velocity')

%creating the rear right damper veloctiy histogram
subplot(2,2,4);    
h16=histogram(dam_rr_speedins(o),'Normalization','probability');
h16.BinWidth=z;
xlabel('Shaft Velocity (In/s)')
ylabel('Frequency')
title('Rear Right Damper Velocity')
hold off

%Plotting Statistics Table Rear Dampers
Corner={'RR' ; 'RL'};
Percent_Full_Extension=[rr_percent_full_extension; rl_percent_full_extension];
Rear_Skewness=[skewness_rr_speed; skewness_rl_speed];
Rear_Kurtosis=[kurtosis_rr_speed; kurtosis_rl_speed];
Rear_Median=[rr_damper_median_speed; rl_damper_median_speed];
Rear_AVG=[rr_avg_speed; rl_avg_speed];
Rear_Percent_High_Speed_Bump=[percent_high_speed_bump_rr_raw; percent_high_speed_bump_rl_raw];
Rear_Percent_Low_Speed_Bump=[percent_low_speed_bump_rr_raw; percent_low_speed_bump_rl_raw];
Rear_Percent_High_Speed_Rebound=[percent_high_speed_rebound_rr_raw; percent_high_speed_rebound_rl_raw];
Rear_Percent_Low_Speed_Rebound=[percent_low_speed_rebound_rr_raw; percent_low_speed_rebound_rl_raw];
T_Speed_Rear= table(Percent_Full_Extension, Rear_Skewness, Rear_Kurtosis,Rear_Median,Rear_AVG,Rear_Percent_High_Speed_Bump,Rear_Percent_Low_Speed_Bump,Rear_Percent_High_Speed_Rebound,Rear_Percent_Low_Speed_Rebound,'RowNames',Corner);

end