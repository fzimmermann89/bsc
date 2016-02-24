 clear all; close all; clc;

 [X,Y] = meshgrid(linspace(-10,10,25));
 Z = sinc(sqrt((X/pi).^2+(Y/pi).^2));

 [F,V]=mesh2tri(X,Y,Z,'f');

