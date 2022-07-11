%INTERPSINC Interpolate a sampled function using sin(x)/x (a.k.a. sinc function) 
%   yi = INTERPSINC(xi,f,xd,nref,nrefx)
%   Use the sinc function to interpolate the function 
%   f(x) sampled at regular intervals to the points xi 
%   xi are the x values to which you want to interpolate, can be any nd-array
%   f is a vector of values of f(x) evaluated at evenly spaced intervals
%      if f is not a row or column vector a warning is 
%      issued and the data is vectorized by columns
%   xd is the sample spacing of the elements of f
%      optional, assumed to be 1 if not present
%   nref is the reference element of vector f, 
%      optional, assumed to be zero if ommitted
%      (the first element of f is labeled element 1)
%   nrefx is the x value assigned to element nref
%      optional, assumed to be 0 if omitted
%
%   If all three arguments are omitted the vector f is assumed to be f(x) evaluated
%   at x=1,2,3 ... length(f)
%
% EXAMPLE, interpolate values for a sine wave sampled at twice Nyqhuist frequency

%   f=sin(0:pi/4:20*pi) % "f" is a vector of samples of a sine wave sampled every pi/4 radians (90 degrees)
%   interp([71/8*pi:pi/4:89/8*pi],f,pi/4,1,0) % estimate sine wave at some points halfway between samples
%   sin([71/8*pi:pi/4:89/8*pi]) % compare to true value of sine waves at these points
 
%REF: Discrete-Time Signal Processing, Oppenheim and Schafer, 1989, Pages: 89-91
%Author: Michael Minardi Ph.D., email: minardi2@mbvlab.wpafb.af.mil, October 1999

function yi = interpsinc(xi,f,varargin)
% Use cell array varargin to set optional input values xd, nref and nrefx
d={1,0,0};d(1:length(varargin))=varargin;
xd=d{1};nref=d{2};nrefx=d{3};
%convert xi from units of x to fractional index values
ni=nref+(xi-nrefx)/xd;
% convert ni to a row vector
ni=ni(:)';
% convert f to a row vector
% if prod(size(f))>max(size(f));
%    warning('input function "f" is not a vector, will vectorize by columns')
% end
f=f(:)';
% Check to see if some requested interpolation points are outside the range of the sampled function
% if min(ni)<1|max(ni)>length(f)
%    warning('some points are outside the range of the input function,') 
%    warning('you are EXTRAPOLATING not INTERPOLATING, results are likely to stink!')
% end
% create interpolation weights using the sinc function
NI=sinc([1:length(f)]'*ones(size(ni))-ones(size(f'))*ni);
% create interpolated values
yi=f*NI;
% convert answer (yi) back to original shape of input xi
yi=reshape(yi,size(xi));


