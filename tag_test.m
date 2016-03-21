% A small Matlab implementation of the Shazam audio recognition algorithm
% by Dr. Avery Wang.
% 
% The code in this package can be used for academic purposes only. The author
% cannot be held liable for any side effects of the use of this package.
% 
% Programmed by Steven Van Vaerenbergh (January 2005).
% ----------------------------------------------------------------------------

% RECOGNITION PROGRAM - IDENTIFIES A SINGLE AUDIO FRAGMENT WITH NOISE

clear all
close all

%---------------- PARAMETERS
songdir = 'songs/';
hashdir = 'hash/';
load songnames;		% contains 'songnames'
sampsec = 5;		% length of sample sound (seconds)
snr_db = -5;

%---------------------------

tic
load program_constants

rand('seed',cputime);
num_s = 10;%length(songnames);
samplen = sampsec*fs;


% choose song
good_songind = round(rand*num_s + 0.5);
filename = sprintf('%s%s.wav',songdir,songnames{good_songind});
s = wavread(filename);
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

h = waitbar(0,'Matching hash tables...');
for s_ind = 1:num_s,
	waitbar(s_ind/num_s,h);
	% get hash table
	hashname = sprintf('%shashtable %s',hashdir,songnames{s_ind});
	load(hashname);			% contains 'localhash' and 'slen'
	num_win = floor((slen-olen)/(wlen-olen));

	score(s_ind) = trymatch(sample,localhash,num_win);
end
close(h)

[maxscore,detected_songind] = max(score);

soundsc(sample,fs);
pause(samplen/fs+0.3)
soundsc(ss,fs)

fprintf(1,'Detected song: %s\n',songnames{detected_songind});
fprintf(1,'Good song:     %s\n\n',songnames{good_songind});

t = toc;
