function hashtable = get_fingerprints(s)
% extract the fingerprint hastable of an audio fragment
%
% Programmed by Steven Van Vaerenbergh (January 2005).

slen = length(s);

load program_constants

% number of windows:
num_win = floor((slen-olen)/(wlen-olen));

% voor fft
midind = wlen/2+1;

specpeaks = zeros(num_win,1);
h = waitbar(0,'Calculating peaks...');
for w_ind = 1:num_win,
	waitbar(w_ind/num_win,h);
	wstart = (w_ind-1)*(wlen-olen)+1;
	wend = wstart + wlen - 1;
	
	win = s(wstart:wend)'.*hamming(wlen);
	fwin = abs(fft(win));
	[maxpeak,maxind] = max(fwin);
	specpeaks(w_ind) = maxind;
end
close(h)

% hash table, indices: original freq, freq diff, time diff
% t_diffrange = t_maxdelta-t_mindelta+1;
hashtable = cell(wlen/2+1,2*t_freqdiff+1,t_maxdelta);



% fill hash table
h = waitbar(0,'Filling hash table...');
for w_ind = 1:num_win,
	waitbar(w_ind/num_win,h);
	thisfreq = specpeaks(w_ind);
	for delta_ind = t_mindelta:min(t_maxdelta,num_win-w_ind),
		targetfreq = specpeaks(w_ind + delta_ind);
		freqdiff = targetfreq - thisfreq;
		if (abs(freqdiff) <= t_freqdiff)
			freqdiff_ind = freqdiff + t_freqdiff + 1;
			hashtable{thisfreq,freqdiff_ind,delta_ind} = [hashtable{thisfreq,freqdiff_ind,delta_ind};w_ind];
		end
	end
end
close(h)
