function exportFrameFig(drawP,drawN,name,data)
    angle = 25;
    clf;
    hAx1 = axes('Position',[0.05 0.65 0.8 0.3]); bar(hAx1, drawP,'stacked')
    hAx2 = axes('Position',[0.05 0.18 0.8 0.3]); bar(hAx2, drawN,'stacked')
    colormap(flipud(colormap('bone')));
    lenLabels = length(data.actLabels);
    xlim(hAx1,[0 lenLabels+1]);
    xlim(hAx2,[0 lenLabels+1]);
    ylim(hAx1,[0 1]);
    ylim(hAx2,[0 1]);
    set(hAx1,'XTick',1:lenLabels);
    set(hAx2,'XTick',1:lenLabels);
    set(hAx1,'xticklabel',data.actLabels' ); 
    set(hAx2,'xticklabel',data.actLabels' ); 
%     box(hAx1,'off');
%     box(hAx2,'off');
    rotateXLabels(hAx1, angle );
    rotateXLabels(hAx2, angle );

    h1 = legend(hAx1,{'TP','U_\omega','U_a','F','D'}); 
    pos = get(h1,'position');
    set(h1, 'position',[0.82 pos(2:4)]);

    h2 = legend(hAx2,{'TN','O_\omega','O_a','M','I'}); 
    pos = get(h2,'position');
    set(h2, 'position',[0.82 pos(2:4)]);

    saveas(gcf(), strcat(name,'.png'),'png');
    
end