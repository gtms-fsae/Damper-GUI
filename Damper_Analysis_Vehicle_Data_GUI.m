function dataObj = Damper_Analysis_Vehicle_Data_GUI(fileName)
dataObj = struct;
%%Damper Analysis Georgia Tech Motorsports #64

    %The goal of this script is to tune the vehicle through analysis of test
    %data from sensors such as accelerometer, damper position (& derived speed),
    %steering input, wheel speed, throttle position, brake pressure, brake temperature, and tire temperature.
%This vehicle analysis is more VD and suspension based. Powertrain is doing their own analysis.

%% Import data from spreadsheet


%% Setup the Import Options
opts = spreadsheetImportOptions("NumVariables", 22);
%% dustin's test section
% [num, text, raw] = xlsread(fileName);
%%
% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A7";

% Specify column names and types
opts.VariableNames = ["times1", "udam_flV", "udam_frV", "dam_flin", "dam_frin", "dam_fl_speedins", "dam_fr_speedins", "udam_rlV", "udam_rrV", "dam_rlin", "dam_rrin", "dam_rl_speedins", "dam_rr_speedins", "accxgLongitudinal", "accygLateral", "acczgVertical", "steer", "vwheel_flkmh", "vwheel_frkmh", "vwheel_rlkmh", "vwheel_rrkmh", "yaw"];
opts.VariableTypes = ["double", "string", "string", "double", "double", "double", "double", "string", "string", "double", "double", "double", "double", "string", "string", "string", "string", "string", "string", "string", "string", "string"];
opts = setvaropts(opts, [2, 3, 8, 9, 14, 15, 16, 17, 18, 19, 20, 21, 22], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [2, 3, 8, 9, 14, 15, 16, 17, 18, 19, 20, 21, 22], "EmptyFieldRule", "auto");

% Import the data
tbl = readtable(fileName, opts, "UseExcel", false);

%% Convert to output type
dataObj.times1 = tbl.times1;
dataObj.udam_flV = tbl.udam_flV;
dataObj.udam_frV = tbl.udam_frV;
dataObj.dam_flin = tbl.dam_flin;
dataObj.dam_frin = tbl.dam_frin;
dataObj.dam_fl_speedins = tbl.dam_fl_speedins;
dataObj.dam_fr_speedins = tbl.dam_fr_speedins;
dataObj.udam_rlV = tbl.udam_rlV;
dataObj.udam_rrV = tbl.udam_rrV;
dataObj.dam_rlin = tbl.dam_rlin;
dataObj.dam_rrin = tbl.dam_rrin;
dataObj.dam_rl_speedins = tbl.dam_rl_speedins;
dataObj.dam_rr_speedins = tbl.dam_rr_speedins;
dataObj.accxgLongitudinal = tbl.accxgLongitudinal;
dataObj.accygLateral = tbl.accygLateral;
dataObj.acczgVertical = tbl.acczgVertical;
dataObj.steer = tbl.steer;
dataObj.vwheel_flkmh = tbl.vwheel_flkmh;
dataObj.vwheel_frkmh = tbl.vwheel_frkmh;
dataObj.vwheel_rlkmh = tbl.vwheel_rlkmh;
dataObj.vwheel_rrkmh = tbl.vwheel_rrkmh;
dataObj.yaw = tbl.yaw;

%% Clear temporary variables
clear opts tbl

%% Full Extension Percent
%calculating how long the dampers are at full extension/ the tire is
%leaving the ground
dataObj.number_of_samples=numel(dataObj.dam_frin);
    %Front Dampers
    dataObj.fr_full_extension=dataObj.dam_frin(dataObj.dam_frin>3.6);
    dataObj.fl_full_extension=dataObj.dam_flin(dataObj.dam_flin>3.6);
    dataObj.count_fr_extended=numel(dataObj.fr_full_extension);
    dataObj.count_fl_extended=numel(dataObj.fl_full_extension);
    dataObj.fr_percent_full_extension=(dataObj.count_fr_extended/dataObj.number_of_samples)*100;
    dataObj.fl_percent_full_extension=(dataObj.count_fl_extended/dataObj.number_of_samples)*100;
    %Rear Dampers
    dataObj.rr_full_extension=dataObj.dam_rrin(dataObj.dam_rrin>3.6);
    dataObj.rl_full_extension=dataObj.dam_rlin(dataObj.dam_rlin>3.5);
    dataObj.count_rr_extended=numel(dataObj.rr_full_extension);
    dataObj.count_rl_extended=numel(dataObj.rl_full_extension);
    dataObj.rr_percent_full_extension=(dataObj.count_rr_extended/dataObj.number_of_samples)*100;
    dataObj.rl_percent_full_extension=(dataObj.count_rl_extended/dataObj.number_of_samples)*100;
    
%% Compression and Rebound Segregation
%Front Dampers
%Segregating the data to have compression and rebound seperately.
dataObj.fr_speed_compression=dataObj.dam_fr_speedins(dataObj.dam_fr_speedins>=0);
dataObj.fl_speed_compression=dataObj.dam_fl_speedins(dataObj.dam_fl_speedins>=0);
dataObj.fr_speed_rebound=dataObj.dam_fr_speedins(dataObj.dam_fr_speedins<0);
dataObj.fl_speed_rebound=dataObj.dam_fl_speedins(dataObj.dam_fl_speedins<0);

%Rear Dampers
%Segregating the data to have compression and rebound seperately.
dataObj.rr_speed_compression=dataObj.dam_rr_speedins(dataObj.dam_rl_speedins>=0);
dataObj.rl_speed_compression=dataObj.dam_rl_speedins(dataObj.dam_rl_speedins>=0);
dataObj.rr_speed_rebound=dataObj.dam_rr_speedins(dataObj.dam_rr_speedins<0);
dataObj.rl_speed_rebound=dataObj.dam_rl_speedins(dataObj.dam_rl_speedins<0);

%% Maximum,Minimum,AVG, Standard Deviation, Skewness, Kurtosis, Upper and Lower Quartile
%Front Dampers    %Average speed (Full Dataset)
    dataObj.fr_avg_speed=mean(dataObj.dam_fr_speedins);
    dataObj.fl_avg_speed=mean(dataObj.dam_fl_speedins);
    %Max Speed Compression
    dataObj.max_fr_comp=max(dataObj.dam_fr_speedins);
    dataObj.max_fl_comp=max(dataObj.dam_fl_speedins);
    %Min Speed Rebound
    dataObj.min_fr_comp=min(dataObj.dam_fr_speedins);
    dataObj.min_fl_comp=min(dataObj.dam_fl_speedins);
    %Median
    dataObj.fr_damper_median_speed=median(dataObj.dam_fr_speedins);
    dataObj.fl_damper_median_speed=median(dataObj.dam_fl_speedins);
    %Standard Deviation (S)
        %Front Dampers
        dataObj.S_fr_speed=std(dataObj.dam_fr_speedins);
        dataObj.S_fl_speed=std(dataObj.dam_fl_speedins);
        %Rear Dampers
        dataObj.S_rr_speed=std(dataObj.dam_rr_speedins);
        dataObj.S_rl_speed=std(dataObj.dam_rl_speedins);
    %Skewness
    %If the value is greater than one or less than negative one it is
    %highly skewed. If it is between -1 and -0.5 or between 1 and 0.5 then
    %it is moderately skewed. If it is between -0.5 and 0.5 then it is
    %approximately symmetric (https://brownmath.com/stat/shape.htm)
        %Front Dampers
        dataObj.skewness_fr_speed=skewness(dataObj.dam_fr_speedins);
        dataObj.skewness_fl_speed=skewness(dataObj.dam_fl_speedins);
        %Rear Dampers
        dataObj.skewness_rr_speed=skewness(dataObj.dam_rr_speedins);
        dataObj.skewness_rl_speed=skewness(dataObj.dam_rl_speedins);
    %Kurtosis
        %Front Dampers
        dataObj.kurtosis_fr_speed=kurtosis(dataObj.dam_fr_speedins);
        dataObj.kurtosis_fl_speed=kurtosis(dataObj.dam_fl_speedins);
        %Rear Dampers
        dataObj.kurtosis_rr_speed=kurtosis(dataObj.dam_rr_speedins);
        dataObj.kurtosis_rl_speed=kurtosis(dataObj.dam_rl_speedins);
    %Quartile Ranges
        %Upper range(median- Q3)
        dataObj.fr_upper_range=dataObj.dam_fr_speedins(dataObj.dam_fr_speedins>dataObj.fr_damper_median_speed);
        dataObj.fl_upper_range=dataObj.dam_fl_speedins(dataObj.dam_fl_speedins>dataObj.fl_damper_median_speed);
        %Lower Range (Median- Q1)
        dataObj.fr_lower_range=dataObj.dam_fr_speedins(dataObj.dam_fr_speedins<dataObj.fr_damper_median_speed);
        dataObj.fl_lower_range=dataObj.dam_fl_speedins(dataObj.dam_fl_speedins<dataObj.fl_damper_median_speed);
    %Upper Quartile Q3
    dataObj.upper_quartile_fr_dam=median(dataObj.fr_upper_range);
    dataObj.upper_quartile_fl_dam=median(dataObj.fl_upper_range);
    %Lower Quartile Q1
    dataObj.lower_quartile_fr_dam=median(dataObj.fr_lower_range);
    dataObj.lower_quartile_fl_dam=median(dataObj.fl_lower_range);
    %IQR Internal Quartile Range
    dataObj.iqr_damper_fr=dataObj.upper_quartile_fr_dam- dataObj.lower_quartile_fr_dam;
    dataObj.iqr_damper_fl=dataObj.upper_quartile_fl_dam- dataObj.lower_quartile_fl_dam;

%Rear Dampers
    %Average speed (Full Dataset)
    dataObj.rr_avg_speed=mean(dataObj.dam_rr_speedins);
    dataObj.rl_avg_speed=mean(dataObj.dam_rl_speedins);
    %Max Speed Compression
    dataObj.max_rr_comp=max(dataObj.dam_rr_speedins);
    dataObj.max_rl_comp=max(dataObj.dam_rl_speedins);
    %Min Speed Rebound
    dataObj.min_rr_comp=min(dataObj.dam_rr_speedins);
    dataObj.min_rl_comp=min(dataObj.dam_rl_speedins);
    %Median
    dataObj.rr_damper_median_speed=median(dataObj.dam_rr_speedins);
    dataObj.rl_damper_median_speed=median(dataObj.dam_rl_speedins);
    %Quartile Ranges
        %Upper range(median- Q3)
        dataObj.rr_upper_range=dataObj.dam_rr_speedins(dataObj.dam_rr_speedins>dataObj.rr_damper_median_speed);
        dataObj.rl_upper_range=dataObj.dam_rl_speedins(dataObj.dam_rl_speedins>dataObj.rl_damper_median_speed);
        %Lower Range (Median- Q1)
        dataObj.rr_lower_range=dataObj.dam_rr_speedins(dataObj.dam_rr_speedins<dataObj.rr_damper_median_speed);
        dataObj.rl_lower_range=dataObj.dam_rl_speedins(dataObj.dam_rl_speedins<dataObj.rl_damper_median_speed);
    %Upper Quartile Q3
    dataObj.upper_quartile_rr_dam=median(dataObj.rr_upper_range);
    dataObj.upper_quartile_rl_dam=median(dataObj.rl_upper_range);
    %Lower Quartile Q1
    dataObj.lower_quartile_rr_dam=median(dataObj.rr_lower_range);
    dataObj.lower_quartile_rl_dam=median(dataObj.rl_lower_range);
    %IQR Internal Quartile Range
    dataObj.iqr_damper_rr=dataObj.upper_quartile_rr_dam- dataObj.lower_quartile_rr_dam;
    dataObj.iqr_damper_rl=dataObj.upper_quartile_rl_dam- dataObj.lower_quartile_rl_dam;
    
%% Percent Time in Bump and Rebound
    %Front Dampers
        %Front Right Bump
            %This count applies to all four corners
            F=3.5; %in/s
            G=-3.5; %in/s
            dataObj.number_of_speed_samples=numel(dataObj.dam_fr_speedins);
            dataObj.fr_low_speed_bump_speedins=dataObj.fr_speed_compression(dataObj.fr_speed_compression<=F);
            dataObj.fr_high_speed_bump_speedins=dataObj.fr_speed_compression(dataObj.fr_speed_compression>F);
            dataObj.number_low_speed_bump_fr_raw=numel(dataObj.fr_low_speed_bump_speedins);
            dataObj.number_high_speed_bump_fr_raw=numel(dataObj.fr_high_speed_bump_speedins);
            dataObj.percent_low_speed_bump_fr_raw=(dataObj.number_low_speed_bump_fr_raw/dataObj.number_of_speed_samples)*100;
            dataObj.percent_high_speed_bump_fr_raw=(dataObj.number_high_speed_bump_fr_raw/dataObj.number_of_speed_samples)*100;
        %Front Left Bump
            dataObj.fl_low_speed_bump_speedins=dataObj.fl_speed_compression(dataObj.fl_speed_compression<=F);
            dataObj.fl_high_speed_bump_speedins=dataObj.fl_speed_compression(dataObj.fl_speed_compression>F);
            dataObj.number_low_speed_bump_fl_raw= numel(dataObj.fl_low_speed_bump_speedins);
            dataObj.number_high_speed_bump_fl_raw= numel(dataObj.fl_high_speed_bump_speedins);
            dataObj.percent_low_speed_bump_fl_raw=(dataObj.number_low_speed_bump_fl_raw/dataObj.number_of_speed_samples)*100;
            dataObj.percent_high_speed_bump_fl_raw=(dataObj.number_high_speed_bump_fl_raw/dataObj.number_of_speed_samples)*100;
        %Front Right Rebound
            dataObj.fr_low_speed_rebound_speedins=dataObj.fr_speed_rebound(dataObj.fr_speed_rebound>=G);
            dataObj.fr_high_speed_rebound_speedins=dataObj.fr_speed_rebound(dataObj.fr_speed_rebound<G);
            dataObj.number_low_speed_rebound_fr_raw=numel(dataObj.fr_low_speed_rebound_speedins);
            dataObj.number_high_speed_rebound_fr_raw=numel(dataObj.fr_high_speed_rebound_speedins);
            dataObj.percent_low_speed_rebound_fr_raw=(dataObj.number_low_speed_rebound_fr_raw/dataObj.number_of_speed_samples)*100;
            dataObj.percent_high_speed_rebound_fr_raw=(dataObj.number_high_speed_rebound_fr_raw/dataObj.number_of_speed_samples)*100;
        %Front Left Rebound
            dataObj.fl_low_speed_rebound_speedins=dataObj.fl_speed_rebound(dataObj.fl_speed_rebound>=G);
            dataObj.fl_high_speed_rebound_speedins=dataObj.fl_speed_rebound(dataObj.fl_speed_rebound<G);
            dataObj.number_low_speed_rebound_fl_raw= numel(dataObj.fl_low_speed_rebound_speedins);
            dataObj.number_high_speed_rebound_fl_raw= numel(dataObj.fl_high_speed_rebound_speedins);
            dataObj.percent_low_speed_rebound_fl_raw=(dataObj.number_low_speed_rebound_fl_raw/dataObj.number_of_speed_samples)*100;
            dataObj.percent_high_speed_rebound_fl_raw=(dataObj.number_high_speed_rebound_fl_raw/dataObj.number_of_speed_samples)*100;
            
    %Rear Dampers
        %Rear Right Bump
            dataObj.rr_low_speed_bump_speedins=dataObj.rr_speed_compression(dataObj.rr_speed_compression<=F);
            dataObj.rr_high_speed_bump_speedins=dataObj.rr_speed_compression(dataObj.rr_speed_compression>F);
            dataObj.number_low_speed_bump_rr_raw=numel(dataObj.rr_low_speed_bump_speedins);
            dataObj.number_high_speed_bump_rr_raw=numel(dataObj.rr_high_speed_bump_speedins);
            dataObj.percent_low_speed_bump_rr_raw=(dataObj.number_low_speed_bump_rr_raw/dataObj.number_of_speed_samples)*100;
            dataObj.percent_high_speed_bump_rr_raw=(dataObj.number_high_speed_bump_rr_raw/dataObj.number_of_speed_samples)*100;
        %Rear Left Bump
            dataObj.rl_low_speed_bump_speedins=dataObj.rl_speed_compression(dataObj.rl_speed_compression<=F);
            dataObj.rl_high_speed_bump_speedins=dataObj.rl_speed_compression(dataObj.rl_speed_compression>F);
            dataObj.number_low_speed_bump_rl_raw= numel(dataObj.rl_low_speed_bump_speedins);
            dataObj.number_high_speed_bump_rl_raw= numel(dataObj.rl_high_speed_bump_speedins);
            dataObj.percent_low_speed_bump_rl_raw=(dataObj.number_low_speed_bump_rl_raw/dataObj.number_of_speed_samples)*100;
            dataObj.percent_high_speed_bump_rl_raw=(dataObj.number_high_speed_bump_rl_raw/dataObj.number_of_speed_samples)*100;
        %Rear Right Rebound
            dataObj.rr_low_speed_rebound_speedins=dataObj.rr_speed_rebound(dataObj.rr_speed_rebound>=G);
            dataObj.rr_high_speed_rebound_speedins=dataObj.rr_speed_rebound(dataObj.rr_speed_rebound<G);
            dataObj.number_low_speed_rebound_rr_raw=numel(dataObj.rr_low_speed_rebound_speedins);
            dataObj.number_high_speed_rebound_rr_raw=numel(dataObj.rr_high_speed_rebound_speedins);
            dataObj.percent_low_speed_rebound_rr_raw=(dataObj.number_low_speed_rebound_rr_raw/dataObj.number_of_speed_samples)*100;
            dataObj.percent_high_speed_rebound_rr_raw=(dataObj.number_high_speed_rebound_rr_raw/dataObj.number_of_speed_samples)*100;
        %Rear Left Rebound
            dataObj.rl_low_speed_rebound_speedins=dataObj.rl_speed_rebound(dataObj.rl_speed_rebound>=G);
            dataObj.rl_high_speed_rebound_speedins=dataObj.rl_speed_rebound(dataObj.rl_speed_rebound<G);
            dataObj.number_low_speed_rebound_rl_raw= numel(dataObj.rl_low_speed_rebound_speedins);
            dataObj.number_high_speed_rebound_rl_raw= numel(dataObj.rl_high_speed_rebound_speedins);
            dataObj.percent_low_speed_rebound_rl_raw=(dataObj.number_low_speed_rebound_rl_raw/dataObj.number_of_speed_samples)*100;
            dataObj.percent_high_speed_rebound_rl_raw=(dataObj.number_high_speed_rebound_rl_raw/dataObj.number_of_speed_samples)*100;

%% Front Damper Shaft Speed Histograms (Raw)
% figure('Name','Front Damper Histograms (Raw)','NumberTitle','off');
% subplot(2,2,[1 3]);
% z=.1; % bin width
% x =dam_fl_speedins;
% y =dam_fr_speedins;
% h1 = histogram(x,'Normalization','probability','EdgeColor','r');
% h1.BinWidth=z;
% hold on
% h2 = histogram(y,'Normalization','probability','EdgeColor','b');
% h2.BinWidth=z;
% xlabel('Shaft Velocity (In/s)')
% ylabel('Frequency')
% title('Front Left & Right Damper Velocity')
% legend('FL Damper','FR Damper')
% 
% %creating the front left damper veloctiy histogram
% subplot(2,2,2);    
% h3 = histogram(dam_fl_speedins,'Normalization','probability');
% h3.BinWidth=z;
% xlabel('Shaft Velocity (In/s)')
% ylabel('Frequency')
% title('Front Left Damper Velocity')
% %plot(conv(h3.BinEdges, [0.5 0.5], 'valid'), h3.BinCounts)
% 
% %creating the front right damper veloctiy histogram
% subplot(2,2,4);    
% h4=histogram(dam_fr_speedins,'Normalization','probability');
% h4.BinWidth=z;
% xlabel('Shaft Velocity (In/s)')
% ylabel('Frequency')
% title('Front Right Damper Velocity')
% 
% hold off
% 
%% Front Damper Shaft Speed Histograms (Trimmed)
% %This is trimming the data at 1.5 times the interquratile range (IQR) above the
% %upper quartile and 1.5 times the IQR below the lower quartile.
% figure('Name','Front Damper Histograms (Trimmed)','NumberTitle','off');
% m= (dam_fr_speedins>lower_quartile_fr_dam-1.5*iqr_damper_fr) & (dam_fr_speedins<upper_quartile_fr_dam+1.5*iqr_damper_fr);
% n= (dam_fl_speedins>lower_quartile_fl_dam-1.5*iqr_damper_fl) & (dam_fl_speedins<upper_quartile_fl_dam+1.5*iqr_damper_fl);
% subplot(2,2,[1 3]);
% h5 = histogram(dam_fl_speedins(n),'Normalization','probability','EdgeColor','r');
% h5.BinWidth=z;
% hold on
% h6 = histogram(dam_fr_speedins(m),'Normalization','probability','EdgeColor','b');
% h6.BinWidth=z;
% xlabel('Shaft Velocity (In/s)')
% ylabel('Frequency')
% title('Front Left & Right Damper Velocity')
% legend('FL Damper','FR Damper')
% 
% %creating the front left damper veloctiy histogram
% subplot(2,2,2);    
% h7 = histogram(dam_fl_speedins(n),'Normalization','probability');
% h7.BinWidth=z;
% xlabel('Shaft Velocity (In/s)')
% ylabel('Frequency')
% title('Front Left Damper Velocity')
% 
% %creating the front right damper veloctiy histogram
% subplot(2,2,4);    
% h8=histogram(dam_fr_speedins(m),'Normalization','probability');
% h8.BinWidth=z;
% xlabel('Shaft Velocity (In/s)')
% ylabel('Frequency')
% title('Front Right Damper Velocity')
% hold off
% 
%% Plotting Statistics Table Front Dampers
% Corner={'FR' ; 'FL'};
% Percent_Full_Extension=[fr_percent_full_extension; fl_percent_full_extension];
% Front_Skewness=[skewness_fr_speed; skewness_fl_speed];
% Front_Kurtosis=[kurtosis_fr_speed; kurtosis_fl_speed];
% Front_Median=[fr_damper_median_speed; fl_damper_median_speed];
% Front_AVG=[fr_avg_speed; fl_avg_speed];
% Front_Percent_High_Speed_Bump=[percent_high_speed_bump_fr_raw; percent_high_speed_bump_fl_raw];
% Front_Percent_Low_Speed_Bump=[percent_low_speed_bump_fr_raw; percent_low_speed_bump_fl_raw];
% Front_Percent_High_Speed_Rebound=[percent_high_speed_rebound_fr_raw; percent_high_speed_rebound_fl_raw];
% Front_Percent_Low_Speed_Rebound=[percent_low_speed_rebound_fr_raw; percent_low_speed_rebound_fl_raw];
% T_Speed_Front = table(Percent_Full_Extension, Front_Skewness,Front_Kurtosis,Front_Median,Front_AVG,Front_Percent_High_Speed_Bump,Front_Percent_Low_Speed_Bump,Front_Percent_High_Speed_Rebound,Front_Percent_Low_Speed_Rebound,'RowNames',Corner);
% 
%% Rear Damper Shaft Speed Histograms (Raw)
% figure('Name','Rear Damper Histograms (Raw)','NumberTitle','off');
% subplot(2,2,[1 3]);
% r =dam_rl_speedins;
% s =dam_rr_speedins;
% h9 = histogram(r,'Normalization','probability','EdgeColor','r');
% h9.BinWidth=z;
% hold on
% h10 = histogram(s,'Normalization','probability','EdgeColor','b');
% h10.BinWidth=z;
% xlabel('Shaft Velocity (In/s)')
% ylabel('Frequency')
% title('Rear Left & Right Damper Velocity')
% legend('RL Damper','RR Damper')
% 
% %creating the rear left damper veloctiy histogram
% subplot(2,2,2);    
% h11 = histogram(dam_rl_speedins,'Normalization','probability');
% h11.BinWidth=z;
% xlabel('Shaft Velocity (In/s)')
% ylabel('Frequency')
% title('Rear Left Damper Velocity')
% 
% %creating the rear right damper veloctiy histogram
% subplot(2,2,4);    
% h12=histogram(dam_rr_speedins,'Normalization','probability');
% h12.BinWidth=z;
% xlabel('Shaft Velocity (In/s)')
% ylabel('Frequency')
% title('Rear Right Damper Velocity')
% 
% hold off
% 
%% Rear Damper Shaft Speed Histograms (Trimmed)
% %This is trimming the data at 1.5 times the interquratile range (IQR) above the
% %upper quartile and 1.5 times the IQR below the lower quartile.
% figure('Name','Rear Damper Histograms (Trimmed)','NumberTitle','off');
% o= (dam_rr_speedins>lower_quartile_rr_dam-1.5*iqr_damper_rr) & (dam_rr_speedins<upper_quartile_rr_dam+1.5*iqr_damper_rr);
% p= (dam_rl_speedins>lower_quartile_rl_dam-1.5*iqr_damper_rl) & (dam_rl_speedins<upper_quartile_rl_dam+1.5*iqr_damper_rl);
% subplot(2,2,[1 3]);
% h13 = histogram(dam_rl_speedins(p),'Normalization','probability','EdgeColor','r');
% h13.BinWidth=z;
% hold on
% h14 = histogram(dam_rr_speedins(o),'Normalization','probability','EdgeColor','b');
% h14.BinWidth=z;
% xlabel('Shaft Velocity (In/s)')
% ylabel('Frequency')
% title('Rear Left & Right Damper Velocity')
% legend('RL Damper','RR Damper')
% 
% %creating the rear left damper veloctiy histogram
% subplot(2,2,2);    
% h15 = histogram(dam_rl_speedins(p),'Normalization','probability');
% h15.BinWidth=z;
% xlabel('Shaft Velocity (In/s)')
% ylabel('Frequency')
% title('Rear Left Damper Velocity')
% 
% %creating the rear right damper veloctiy histogram
% subplot(2,2,4);    
% h16=histogram(dam_rr_speedins(o),'Normalization','probability');
% h16.BinWidth=z;
% xlabel('Shaft Velocity (In/s)')
% ylabel('Frequency')
% title('Rear Right Damper Velocity')
% hold off
% 
% %Plotting Statistics Table Rear Dampers
% Corner={'RR' ; 'RL'};
% Percent_Full_Extension=[rr_percent_full_extension; rl_percent_full_extension];
% Rear_Skewness=[skewness_rr_speed; skewness_rl_speed];
% Rear_Kurtosis=[kurtosis_rr_speed; kurtosis_rl_speed];
% Rear_Median=[rr_damper_median_speed; rl_damper_median_speed];
% Rear_AVG=[rr_avg_speed; rl_avg_speed];
% Rear_Percent_High_Speed_Bump=[percent_high_speed_bump_rr_raw; percent_high_speed_bump_rl_raw];
% Rear_Percent_Low_Speed_Bump=[percent_low_speed_bump_rr_raw; percent_low_speed_bump_rl_raw];
% Rear_Percent_High_Speed_Rebound=[percent_high_speed_rebound_rr_raw; percent_high_speed_rebound_rl_raw];
% Rear_Percent_Low_Speed_Rebound=[percent_low_speed_rebound_rr_raw; percent_low_speed_rebound_rl_raw];
% T_Speed_Rear= table(Percent_Full_Extension, Rear_Skewness, Rear_Kurtosis,Rear_Median,Rear_AVG,Rear_Percent_High_Speed_Bump,Rear_Percent_Low_Speed_Bump,Rear_Percent_High_Speed_Rebound,Rear_Percent_Low_Speed_Rebound,'RowNames',Corner);

end