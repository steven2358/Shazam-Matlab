% A small Matlab implementation of the Shazam audio recognition algorithm
% by Dr. Avery Wang.
% 
% The code in this package can be used for academic purposes only. The author
% cannot be held liable for any side effects of the use of this package.
% 
% Programmed by Steven Van Vaerenbergh (January 2005).
% ----------------------------------------------------------------------------

% FEATURE EXTRACTION FILE

close all
clear all

songdir = '';
hashdir = '';

% get songnames
d = dir(songdir);
dlen = length(d);
songnames = [];
for d_ind = 3:dlen,
	sn = d(d_ind).name;
	songnames{d_ind-2} = sn(1:length(sn)-4);
end

save songnames songnames;

num_s = length(songnames);

for s_ind = 1:num_s,
	% load song
	filename = sprintf('%s%s',songdir,songnames{s_ind});
	s = wavread(filename);
	slen = length(s);
	fprintf('Creating hash table for "%s"...\n',songnames{s_ind});

	% extract hash table
	localhash = get_fingerprints(s);
	hashname = sprintf('%shashtable %s',hashdir,songnames{s_ind});
	save(hashname,'localhash','slen');
end
