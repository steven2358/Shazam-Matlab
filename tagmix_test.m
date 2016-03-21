% A small Matlab implementation of the Shazam audio recognition algorithm
% by Dr. Avery Wang.
% 
% The code in this package can be used for academic purposes only. The author
% cannot be held liable for any side effects of the use of this package.
% 
% Programmed by Steven Van Vaerenbergh (January 2005).
% ----------------------------------------------------------------------------

% RECOGNITION PROGRAM - IDENTIFIES TWO MIXED AUDIO FRAGMENTS

clear all
close all

%---------------- PARAMETERS
songdir = 'songs/';
hashdir = 'hash/';
load songnames;		% contains 'songnames'
sampsec = 10;		% length of sample sound (seconds)
snr_db = -5;

%---------------------------

tic
load program_constants

rand('seed',cputime);
num_s = 10;%length(songnames);
samplen = sampsec*fs;


% choose song 1
good_songind1 = round(rand*num_s + 0.5);
filename1 = sprintf('%s%s.wav',songdir,songnames{good_songind1});
s1 = wavread(filename1);
slen1 = length(s1);
num_win1 = floor((slen1-olen)/(wlen-olen));

% choose sample 1
sampstart1 = floor(rand*(slen1-samplen-1)+1);
ss1 = s1(sampstart1:sampstart1+samplen-1);



% choose song 2
good_songind2 = round(rand*num_s + 0.5);
filename2 = sprintf('%s%s.wav',songdir,songnames{good_songind2});
s2 = wavread(filename2);
slen2 = length(s2);
num_win2 = floor((slen2-olen)/(wlen-olen));

% choose sample 2
sampstart2 = floor(rand*(slen2-samplen-1)+1);
ss2 = s2(sampstart2:sampstart2+samplen-1);


% % generate noise
% pows = var(ss);
% pown = pows/(10^(snr_db/10));
% noise = sqrt(pown)*randn(samplen,1);

sample = ss1 + ss2;
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

score_temp = score;
detected = zeros(num_s,1);
fprintf(1,'Detected songs:\n');
for s_ind = 1:20,
	[maxscore,detected_songind] = max(score_temp);
	score_temp(detected_songind) = 0;
	detected(s_ind) = detected_songind;
	fprintf(1,'%4d - %s\n',maxscore,songnames{detected_songind});
end
fprintf(1,'\n');

fprintf(1,'Good songs:\n')
fprintf(1,'%s\n',songnames{good_songind1});
fprintf(1,'%s\n',songnames{good_songind2});
fprintf(1,'\n');

soundsc(sample,fs);
pause(samplen/fs+0.3)
soundsc(ss1,fs)
pause(samplen/fs+0.3)
soundsc(ss2,fs)


t = toc;
