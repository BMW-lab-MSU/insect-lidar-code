function [d]=rangefind(rb)
% Calibrated on 06/24/2022

METERS_PER_RANGE_BIN = 0.7252;
INTERCEPT = -11.0005;

d = METERS_PER_RANGE_BIN * (rb) - INTERCEPT;
