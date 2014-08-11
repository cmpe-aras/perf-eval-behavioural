function [dataStruct] = prepHouseA()

load sensorStructHouseA.mat
load actStructHouseA.mat
load senseandactLabelsHouseA.mat

dataStruct.name = 'HouseA';
dataStruct.ss = sensorStructure;
dataStruct.as = activityStructure;
dataStruct.sensor_labels = sensor_labels;
dataStruct.activity_labels = activity_labels;

