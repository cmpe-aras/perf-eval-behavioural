function exportSegmentFig(drawEAD,name,data)
    clf;
    close all;
    barh(drawEAD,'stacked');
    colormap(flipud(colormap('bone')));
    lenLabels = length(data.actLabels);
    ylim([0 lenLabels+1]);
    xlim([0 1]);
    set(gca,'YTick',1:lenLabels);
    set(gca,'yticklabel',data.actLabels' );
    legend( {'D','F','FM','M','C','M''','FM''','F''','I'''},'Location','BestOutside');
    saveas(gcf(), strcat('EAD_', name,'.png'),'png');
end




   