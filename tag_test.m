% A small Matlab implementation of the Shazam audio recognition algorithm
% by Dr. Avery Wang.
%
% The code in this package can be used for academic purposes only. The author
% cannot be held liable for any side effects of the use of this package.
%
% Programmed by Steven Van Vaerenbergh (January 2005).
% ----------------------------------------------------------------------------

% RECOGNITION PROGRAM - IDENTIFIES A SINGLE AUDIO FRAGMENT WITH NOISE

close all
clear
% rng('default'); rng(1); % reproducibility

%---------------- PARAMETERS
param = local_settings();
songdir = param.songdir;
hashdir = param.hashdir;
fs = param.fs;

load songnames;		% contains 'songnames'
sampsec = 5;		% length of sample sound (seconds)
snr_db = -5;

%---------------------------

tic
wlen = param.wlen;
olen = param.olen;
t_mindelta = param.t_mindelta;
t_maxdelta = param.t_maxdelta;
t_freqdiff = param.t_freqdiff;

num_s = length(songnames);
samplen = sampsec*fs;

% choose song
good_songind = round(rand*num_s + 0.5);
filename = fullfile(songdir,songnames{good_songind});
s = audioread(filename);
s = s(:);
slen = length(s);
num_win = floor((slen-olen)/(wlen-olen));

% choose sample
sampstart = floor(rand*(slen-samplen-1)+1);
ss = s(sampstart:sampstart+samplen-1);
% generate noise
pows = var(ss);
pown = pows/(10^(snr_db/10));
noise = sqrt(pown)*randn(samplen,1);

sample = ss + noise;
soundsc(sample,fs);

%------------------------- DO THE TEST --------------
score = zeros(num_s,1);

fprintf('Matching hash tables');
for s_ind = 1:num_s,
    if ~mod(s_ind,floor(num_s/10)), fprintf('.'); end
    % get hash table
    sname_i = strrep(songnames{s_ind},'.','_');
    hashname = fullfile(hashdir,sprintf('hashtable %s.mat',sname_i));
    load(hashname); % contains 'localhash' and 'slen'
    num_win = floor((slen-olen)/(wlen-olen));
    
    score(s_ind) = trymatch(sample,localhash,num_win);
end
fprintf('\n')

[maxscore,detected_songind] = max(score);

soundsc(sample,fs);
pause(samplen/fs+0.3)
soundsc(ss,fs)

fprintf(1,'Detected song: %s\n',songnames{detected_songind});
fprintf(1,'Correct song:  %s\n\n',songnames{good_songind});

t = toc;
