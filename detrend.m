function Y = detrend(X)

table = readtable(X);
X = table(5113:13848,2:end);

Residuals = [];
label = ["TEMP(C)";"GUST(Mph)";"AVG(Mph)";"HUM";"BARO(Mb)";"TREND(Mb)";"RAINDAY(Mm)";"RAINMTH(Mm)";"RATE(Mm/hr)";"SOLAR(W/m2)";"UV";"Pedestrian count"];
for t = 1:12

%mean for 5 weekdays
Weekday0 = [];
for i = 0:119
   hour = mean(table2array(X(1+i:168:end,t)));
   Weekday0 = [Weekday0;hour];
end

% only weekdays data
only_weekday = [];
for i = 0:51
   hour = table2array(X(1+i*168:120+i*168,t));
   only_weekday = [only_weekday;hour];
end


% mean for weekends
Weekend0 = [];
for i = 120:167
   hour = mean(table2array(X(1+i:168:end,t)));
   Weekend0 = [Weekend0;hour];
end

%only weekend
only_weekend = [];
for i = 0:51
   hour = table2array(X(121+i*168:168+i*168,t));
   only_weekend = [only_weekend;hour];
end

%raw data get rid of seasonality


seasonality_weekday = repmat(Weekday0,52,1);
seasonality_weekend = repmat(Weekend0,52,1);

Weekday  = only_weekday -  seasonality_weekday;
Weekend = only_weekend -  seasonality_weekend;

figure;
subplot(2,3,1)
plot(only_weekday)
xlabel('Time(hours)')
ylabel(label(t))
title(label(t) + ' '+ 'over a year' )

subplot(2,3,2)
plot(seasonality_weekday(1:120,:))
xlabel('Time(hours)')
ylabel(label(t))
title('Seasonality of ' + label(t) +' for a week')


subplot(2,3,3)
plot(seasonality_weekday)
xlabel('Time(hours)')
ylabel(label(t))
title('Seasonality of ' + label(t) +' for a year')



subplot(2,3,4)
plot(Weekday)
xlabel('Time(hours)')
ylabel(label(t))
title(label(t)+ ' without seasonality')



trend_weekday = movmean(Weekday,47,1);
trend_weekend = movmean(Weekend,47,1);

subplot(2,3,5)
plot(trend_weekday)
xlabel('Time(hours)')
ylabel(label(t))
title('Trend of ' + label(t)+' for a year')

Weekday = Weekday - trend_weekday;
Weekend = Weekend - trend_weekend;


subplot(2,3,6)
plot(Weekday)
xlabel('Time(hours)')
ylabel(label(t))
title(label(t) + ' without seasonality and trend')


%subplot(2,3,6)
%histogram(Weekday)

Residuals = [Residuals Weekday];
end

%residuals = Residuals(:,1:11);
%residual1 = Residuals(:,12);

%Residuals = [residuals boxcox(residual1)];


table0 = array2table(Residuals,'VariableNames',{'TEMPC','GUSTMph','AVGMph','HUM_','BAROMb','TRENDMb','RAINDAYMm','RAINMTHMm','RATEMm_hr','SOLARW_m2','UV','Pedestrian'});
Y = table0 ;
end

