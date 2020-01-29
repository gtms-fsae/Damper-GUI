function refreshDamperPlot(app,frontAx,rearAx,dataObj)
frontType = app.FrontGraphTemplatesDropDown.Value;
rearType = app.RearGraphTemplatesDropDown.Value;
cla(frontAx)
cla(rearAx)
reset(frontAx)
reset(rearAx)
switch frontType
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
        title(frontAx,'Front Damper Velocity');
        
        if app.FLDamper.Value
            h3 = histogram(frontAx,dataObj.dam_fl_speedins,'Normalization','probability',...
                'displayName','Front Left');
            h3.BinWidth=z;
            xlabel(frontAx,'Shaft Velocity (In/s)')
            ylabel(frontAx,'Frequency')
        end
        %plot(conv(h3.BinEdges, [0.5 0.5], 'valid'), h3.BinCounts)
        hold(frontAx,'on')
        
        %creating the front right damper veloctiy histogram
        if app.FRDamper.Value
            h4=histogram(frontAx,dataObj.dam_fr_speedins,'Normalization','probability',...
                'displayName','Front Right');
            h4.BinWidth=z;
            xlabel(frontAx,'Shaft Velocity (In/s)')
            ylabel(frontAx,'Frequency')
        end
        
        legend(frontAx,'Show','location','best')
        hold(frontAx,'off')
end
end