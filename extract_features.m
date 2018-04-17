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
clear

param = local_settings();
songdir = param.songdir;
hashdir = param.hashdir;

% get songnames
d = dir(songdir);
dlen = length(d);
songnames = cell(dlen-2,1);
for d_ind = 3:dlen,
    sn = d(d_ind).name;
    songnames{d_ind-2} = sn(1:length(sn));
end

save songnames songnames;

num_s = length(songnames);

for s_ind = 1:num_s,
    % load song
    filename = fullfile(songdir,songnames{s_ind});
    sname_i = strrep(songnames{s_ind},'.','_');
    hashname = fullfile(hashdir,sprintf('hashtable %s.mat',sname_i));
    
    if exist(hashname,'file')~=2 % skip files that have been processed
        s = audioread(filename);
        slen = length(s);
        fprintf('Creating hash table for "%s"...\n',songnames{s_ind});
        
        % extract hash table
        localhash = get_fingerprints(s);
        save(hashname,'localhash','slen');
    else
        fprintf('Hash table for "%s" already processed.\n',songnames{s_ind})
    end
end
