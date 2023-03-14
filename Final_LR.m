y = detrend('bristol_bridge.csv');



m1 = fitlm(y(:,1:12),'Pedestrian~TEMPC+GUSTMph+AVGMph+HUM_+BAROMb+TRENDMb+RAINDAYMm+RAINMTHMm+RATEMm_hr+SOLARW_m2+UV');
disp(m1)



figure
subplot(2,2,1)
plotResiduals(m1,'histogram');
subplot(2,2,2)
plotResiduals(m1,"probability")
subplot(2,2,3)
plotResiduals(m1,"lagged")
subplot(2,2,4)
plotResiduals(m1,"fitted")

corr = corrcoef(table2array(y));

%Gust and AVG have correaltion coefficent 0.76, so they can't be included
%in a same model; Solar and UV have coefficient 0.83,so they shouldn't be
%included in the same model to avoid multicolinearity.

%y0 = array2table(table2array(y)+1000,"VariableNames",{'TEMPC','GUSTMph','AVGMph','HUM_','BAROMb','TRENDMb','RAINDAYMm','RAINMTHMm','RATEMm_hr','SOLARW_m2','UV','Pedestrian'});
m2 = fitlm(y(:,1:12),'Pedestrian~TEMPC+GUSTMph+HUM_+BAROMb+TRENDMb+RAINDAYMm+RAINMTHMm+RATEMm_hr+UV');
disp(m2)


figure
subplot(2,2,1)
plotResiduals(m2,'histogram');
subplot(2,2,2)
plotResiduals(m2,"probability")
subplot(2,2,3)
plotResiduals(m2,"lagged")
subplot(2,2,4)
plotResiduals(m2,"fitted")



