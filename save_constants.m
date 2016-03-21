% A small Matlab implementation of the Shazam audio recognition algorithm
% by Dr. Avery Wang.
% 
% The code in this package can be used for academic purposes only. The author
% cannot be held liable for any side effects of the use of this package.
% 
% Programmed by Steven Van Vaerenbergh (January 2005).
% ----------------------------------------------------------------------------

% PRELIMINARY CONSTANTS FILE

fs = 8000;

% window length: 20 ms, but in samples
wlen = fs*0.02;
% overlap:
olen = wlen/2;

% define target window
t_mindelta = 1;
t_maxdelta = 20;
t_freqdiff = 10;		% maximum difference in index

save program_constants fs wlen olen t_mindelta t_maxdelta t_freqdiff
