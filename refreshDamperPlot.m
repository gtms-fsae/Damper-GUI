function refreshDamperPlot(app,ax,dataObj)
type = app.DamperGraphTemplatesDropDown.Value;
cla(ax)
reset(ax)
legend(ax,'hide')
switch type
    case 'Histogram Raw'
        %         title(frAx,'Front Right Histogram (raw)');
        %         subplot(2,2,[1 3]);
        z=.1; % bin width
        %         x =dataObj.dam_fl_speedins;
        %         y =dataObj.dam_fr_speedins;
        %         h1 = histogram(x,'Normalization','probability','EdgeColor','r');
        %         h1.BinWidth=z;
        %         hold on
        %         h2 = histogram(y,'Normalization','probability','EdgeColor','b');
        %         h2.BinWidth=z;
        %         xlabel('Shaft Velocity (In/s)')
        %         ylabel('Frequency')
        %         title('Front Left & Right Damper Velocity')
        %         legend('FL Damper','FR Damper')
        
        %creating the front left damper veloctiy histogram
        title(ax,'Damper Velocity');
        xlabel(ax,'Shaft Velocity (In/s)')
        ylabel(ax,'Frequency')
        hold(ax,'on')
        
        if app.FLDamper.Value
            h3 = histogram(ax,dataObj.dam_fl_speedins,'Normalization','probability',...
                'displayName','Front Left');
            h3.BinWidth=z;
        end
        %plot(conv(h3.BinEdges, [0.5 0.5], 'valid'), h3.BinCounts)
                
        %creating the front right damper veloctiy histogram
        if app.FRDamper.Value
            h4=histogram(ax,dataObj.dam_fr_speedins,'Normalization','probability',...
                'displayName','Front Right');
            h4.BinWidth=z;
        end
        
        if app.RRDamper.Value
            h1=histogram(ax,dataObj.dam_rr_speedins,'Normalization','probability',...
                'displayName','Rear Right');
            h1.BinWidth=z;            
        end
        
        if app.RLDamper.Value
            h1=histogram(ax,dataObj.dam_rl_speedins,'Normalization','probability',...
                'displayName','Rear Left');
            h1.BinWidth=z;            
        end
        
        legend(ax,'Show','location','best')
        hold(ax,'off')
    case 'Histogram Trimmed'
        m= (dataObj.dam_fr_speedins>dataObj.lower_quartile_fr_dam-1.5*dataObj.iqr_damper_fr) & (dataObj.dam_fr_speedins<dataObj.upper_quartile_fr_dam+1.5*dataObj.iqr_damper_fr);
        n= (dataObj.dam_fl_speedins>dataObj.lower_quartile_fl_dam-1.5*dataObj.iqr_damper_fl) & (dataObj.dam_fl_speedins<dataObj.upper_quartile_fl_dam+1.5*dataObj.iqr_damper_fl);
        o= (dataObj.dam_rr_speedins>dataObj.lower_quartile_rr_dam-1.5*dataObj.iqr_damper_rr) & (dataObj.dam_rr_speedins<dataObj.upper_quartile_rr_dam+1.5*dataObj.iqr_damper_rr);
        p= (dataObj.dam_rl_speedins>dataObj.lower_quartile_rl_dam-1.5*dataObj.iqr_damper_rl) & (dataObj.dam_rl_speedins<dataObj.upper_quartile_rl_dam+1.5*dataObj.iqr_damper_rl);
        %         title(frAx,'Front Right Histogram (raw)');
        %         subplot(2,2,[1 3]);
        z=.1; % bin width
        %         x =dataObj.dam_fl_speedins;
        %         y =dataObj.dam_fr_speedins;
        %         h1 = histogram(x,'Normalization','probability','EdgeColor','r');
        %         h1.BinWidth=z;
        %         hold on
        %         h2 = histogram(y,'Normalization','probability','EdgeColor','b');
        %         h2.BinWidth=z;
        %         xlabel('Shaft Velocity (In/s)')
        %         ylabel('Frequency')
        %         title('Front Left & Right Damper Velocity')
        %         legend('FL Damper','FR Damper')
        
        %creating the front left damper veloctiy histogram
        title(ax,'Front Damper Velocity');
        xlabel(ax,'Shaft Velocity (In/s)')
        ylabel(ax,'Frequency')
        hold(ax,'on')
        
        if app.FLDamper.Value
            h3 = histogram(ax,dataObj.dam_fl_speedins(n),'Normalization','probability',...
                'displayName','Front Left');
            h3.BinWidth=z;
        end
        %plot(conv(h3.BinEdges, [0.5 0.5], 'valid'), h3.BinCounts)
        
        %creating the front right damper veloctiy histogram
        if app.FRDamper.Value
            h4=histogram(ax,dataObj.dam_fr_speedins(m),'Normalization','probability',...
                'displayName','Front Right');
            h4.BinWidth=z;
        end
        
        if app.RRDamper.Value
            h1=histogram(ax,dataObj.dam_rr_speedins(o),'Normalization','probability',...
                'displayName','Rear Right');
            h1.BinWidth=z;
        end
        
        if app.RLDamper.Value
            h1=histogram(ax,dataObj.dam_rl_speedins(p),'Normalization','probability',...
                'displayName','Rear Left');
            h1.BinWidth=z;
        end
        
        legend(ax,'Show','location','best')
        hold(ax,'off')
end

%% Refreshing the table
app.FrontDamperTable.ColumnName = {'FL','FR'};
app.FrontDamperTable.RowName = fieldnames(dataObj.tableData.front);
frontData = zeros(length(fieldnames(dataObj.tableData.front)),2);
parfor i = 1:length(frontData(:,1))
    
end
app.FrontDamperTable.Data = dataObj.tableData.front;
app.RearDamperTable.ColumnName = {'RL','RR'};
app.RearDamperTable.RowName = fieldnames(dataObj.tableData.rear);
end