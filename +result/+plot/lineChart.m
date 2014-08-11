function lineChart( resultCell, pars)
% resultCell is a M x N cell structure
% M is the number of different experiment cofigs
% N is the number of folds
% take average, min, max, std over N
% draw M lines

for i=1:

i=1;
C1 = mean(res{i}{1}.statHMM.FMesDays,1);
C2 = mean(res{i}{2}.statHMM.FMesDays,1);
C3 = mean(res{i}{3}.statHMM.FMesDays,1);
C4 = mean(res{i}{4}.statHMM.FMesDays,1);

X=1:1:length(C1);

if i==1
    C5 = 0.706738086060970; %House A
elseif i==2
    C5 = 0.540935370963185; %House B
elseif i==3
    C5 = 0.445687552344516; %House C
end
C5= repmat(C5,1,length(C1));

C=[ C1
    C2
    C3
    C4
    C5
];

% Create figure
figure1 = figure('Name',...
    'House A');

% Create axes
axes1 = axes('Parent',figure1,...
    'XTickLabel',{'500','1000','1500','2000','2500','3000','3500','4000','4500','5000'},...
    'XTick',[6 11 16 21 26 31 36 41 46 51]);
% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[1 51]);
%ylim(axes1,[0 0.5]);
box(axes1,'on');
hold(axes1,'all');
%axis(axes1,[1 25 0 0.7]);
% Create multiple lines using matrix input to plot
plot1 = plot(X,C,'Parent',axes1,'LineWidth',1);

set(plot1(1),'DisplayName','0.5');
set(plot1(2),'LineStyle',':','DisplayName','0.01');
set(plot1(3),'LineStyle','--','DisplayName','Semisupervised (no weighting)');
set(plot1(4),'LineStyle','-.','DisplayName','Supervised');
set(plot1(5),'LineWidth',2,'DisplayName','Upper Bound');

% Create xlabel
xlabel('Number of Labeled Datapoints');

% Create ylabel
ylabel('F-measure');

% Create legend
legend1 = legend(axes1,'show','Location','SouthEast');
end