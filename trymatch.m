function score = trymatch(sample,hashtable,num_win)
% calculate the hastable of one audio fragment to a given hashtable and
% calculate its score
%
% Programmed by Steven Van Vaerenbergh (January 2005).

% load configuration
param = local_settings();
olen = param.olen;
wlen = param.wlen;
t_mindelta = param.t_mindelta;
t_maxdelta = param.t_maxdelta;
t_freqdiff = param.t_freqdiff;

samplen = length(sample);

snum_win = floor((samplen-olen)/(wlen-olen));

sspecpeaks = zeros(snum_win,1);
% h = waitbar(0,'Calculating sample sound peaks...');
for w_ind = 1:snum_win,
% 	waitbar(w_ind/snum_win,h);
	wstart = (w_ind-1)*(wlen-olen)+1;
	wend = wstart + wlen - 1;
	
	win = sample(wstart:wend).*hamming(wlen);
	fwin = abs(fft(win));
	[maxpeak,maxind] = max(fwin);
	sspecpeaks(w_ind) = maxind;
end
% close(h)

histo = zeros(num_win,1);
% check matches in hash table
% h = waitbar(0,'Matching hash table...');
for sw_ind = 1:snum_win,
% 	waitbar(sw_ind/snum_win,h);
	thisfreq = sspecpeaks(sw_ind);
	
	for delta_ind = t_mindelta:min(t_maxdelta,snum_win-sw_ind),
		targetfreq = sspecpeaks(sw_ind + delta_ind);
		freqdiff = targetfreq - thisfreq;
		
		if (abs(freqdiff) <= t_freqdiff)
			freqdiff_ind = freqdiff + t_freqdiff + 1;
			% times on which the found combination occurs
			db_times = hashtable{thisfreq,freqdiff_ind,delta_ind};
			for db_ind = 1:length(db_times)
				delta = db_times(db_ind) - sw_ind; 
				if (delta>0)
					histo(delta) = histo(delta)+1;
				end
			end
		end
	end
end
% close(h)

score = max(histo);
