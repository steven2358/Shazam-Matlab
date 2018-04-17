function hashtable = get_fingerprints(s)
% extract the fingerprint hastable of an audio fragment
%
% Programmed by Steven Van Vaerenbergh (January 2005).

s = s(:); % Force column format. Sound must be mono.

slen = length(s);

param = local_settings();

% locally copy the configurations
wlen = param.wlen;
olen = param.olen;
t_mindelta = param.t_mindelta;
t_maxdelta = param.t_maxdelta;
t_freqdiff = param.t_freqdiff;

% number of windows:
num_win = floor((slen-olen)/(wlen-olen));

specpeaks = zeros(num_win,1);
fprintf(' Calculating peaks');
for w_ind = 1:num_win,
    if ~mod(w_ind,floor(num_win/10)), fprintf('.'); end
    wstart = (w_ind-1)*(wlen-olen)+1;
    wend = wstart + wlen - 1;
    
    win = s(wstart:wend).*hamming(wlen);
    fwin = abs(fft(win));
    [~,maxind] = max(fwin);
    specpeaks(w_ind) = maxind;
end
fprintf('\n')

% hash table, indices: original freq, freq diff, time diff
% t_diffrange = t_maxdelta-t_mindelta+1;
hashtable = cell(wlen/2+1,2*t_freqdiff+1,t_maxdelta);

% fill hash table
fprintf(' Filling hash table');
for w_ind = 1:num_win,
    if ~mod(w_ind,floor(num_win/10)), fprintf('.'); end
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
fprintf('\n')
