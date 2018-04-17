% A small Matlab implementation of the Shazam audio recognition algorithm
% by Dr. Avery Wang.
%
% The code in this package can be used for academic purposes only. The author
% cannot be held liable for any side effects of the use of this package.
%
% Programmed by Steven Van Vaerenbergh (January 2005).
% ----------------------------------------------------------------------------

% RECOGNITION PROGRAM - IDENTIFIES TWO MIXED AUDIO FRAGMENTS

close all
clear
% rng('default'); rng(1); % reproducibility

%---------------- PARAMETERS
param = local_settings();
songdir = param.songdir;
hashdir = param.hashdir;
fs = param.fs;

load songnames;		% contains 'songnames'
sampsec = 10;		% length of sample sound (seconds)
snr_db = -5;

%---------------------------

tic
wlen = param.wlen;
olen = param.olen;
t_mindelta = param.t_mindelta;
t_maxdelta = param.t_maxdelta;
t_freqdiff = param.t_freqdiff;

num_s = 10;%length(songnames);
samplen = sampsec*fs;

% choose song 1
good_songind1 = round(rand*num_s + 0.5);
filename1 = fullfile(songdir,songnames{good_songind1});
s1 = audioread(filename1);
slen1 = length(s1);
num_win1 = floor((slen1-olen)/(wlen-olen));

% choose sample 1
sampstart1 = floor(rand*(slen1-samplen-1)+1);
ss1 = s1(sampstart1:sampstart1+samplen-1);

% choose song 2
good_songind2 = round(rand*num_s + 0.5);
filename2 = fullfile(songdir,songnames{good_songind2});
s2 = audioread(filename2);
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

fprintf('Correct songs:\n');
fprintf('%s\n',songnames{good_songind1});
fprintf('%s\n',songnames{good_songind2});
fprintf('\n');

soundsc(sample,fs);
pause(samplen/fs+0.3)
soundsc(ss1,fs)
pause(samplen/fs+0.3)
soundsc(ss2,fs)

t = toc;
