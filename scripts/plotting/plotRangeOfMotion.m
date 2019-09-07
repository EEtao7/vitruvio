function [] = plotRangeOfMotion(data, saveFiguresToPDF)

    legCount = data.basicProperties.legCount;
    EEnames  = data.basicProperties.EEnames;

    %% get reachable positions
    reachablePositions = getRangeofMotion(data);

    %% Plot mean x vs z position with reachable positions

    subplotRows = ceil(legCount/2);
    if legCount < 2
        subplotColumns = 1;
    else
        subplotColumns = 2;
    end

    figure('name', 'Range of Motion', 'units','normalized','outerposition',[0 0 1 1])
    set(gcf,'color','w')
    for i = 1:legCount
        EEselection = EEnames(i,:);
        set(gcf,'color','w')
        subplot(subplotRows,subplotColumns,i)
        hold on
        plot(reachablePositions.(EEselection)(:,1),reachablePositions.(EEselection)(:,2), 'color', [0.5843 0.8157 0.9882])
        plot(data.(EEselection).r.EEdes(:,1), data.(EEselection).r.EEdes(:,3), 'k', 'LineWidth', 1)
        plot(0,0,'o')
        hold off
        axis equal
        xlabel('x position [m]')
        ylabel('z position [m]')
        title(['Range of motion ', EEselection])
    end
    if saveFiguresToPDF
        export_fig results.pdf -nocrop -append
    end
end