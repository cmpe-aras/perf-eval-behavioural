function [dataStruct] = prepHouseB()

load sensorStructHouseB.mat
load actStructHouseB.mat
load senseandactLabelsHouseB.mat

dataStruct.name = 'HouseB';
dataStruct.ss = sensorStructure;
dataStruct.as = activityStructure;
dataStruct.sensor_labels = sensor_labels;
dataStruct.activity_labels = activity_labels;