function [dataStruct] = prepHouseC()

load sensorStructHouseC.mat
load actStructHouseC.mat
load senseandactLabelsHouseC.mat

dataStruct.name = 'HouseC';
dataStruct.ss = sensorStructure;
dataStruct.as = activityStructure;
dataStruct.sensor_labels = sensor_labels;
dataStruct.activity_labels = activity_labels;