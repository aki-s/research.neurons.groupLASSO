function [RFp0n RFIp RFIn] = get_conMat(RFIntensity,intensityTHRESH)

RFIp = ( RFIntensity - intensityTHRESH ) >0; % intensityTHRESH >= 0
RFIn = ( RFIntensity + intensityTHRESH ) <0;
RFp0n = RFIp - RFIn;

