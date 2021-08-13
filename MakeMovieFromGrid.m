clc

dir = 'E:\Downloads\2021-02-26\2021-02-26';
file = 'results_Scan_Grid_2021-02-26_19-23.mat';

load([dir '\' file])

wv = sub_Data_DecompressWaveform(params.Scan.Waveforms(1));
t = wv.XData;

N = numel(params.Scan.Waveforms);

maxval = 0;
for j=1:N
    maxval = max(maxval,max(abs(params.Scan.Waveforms(j).YData(:))));
end

v = VideoWriter([dir '\results_' params.Name '_' datestr(params.Time, 'yyyy-mm-dd_HH-MM') '.avi'], 'Grayscale AVI');
v.FrameRate = 30;
open(v)

o = zeros(N,1);

for i = find(t>3e-5,1,'first'):1:find(t>20e-5,1,'first');
    for j = 1:N
        o(j) = params.Scan.Waveforms(j).YData(i);
    end
    M = reshape(o, params.Scan.dim2_total, params.Scan.dim1_total);
    M = 0.5 + M / (2*maxval);
    
    M = imresize(M, [params.Scan.dim2_total params.Scan.dim1_total] * 4);
    M = insertText(M, [0,0], sprintf('%1.1f us', t(i)*1e6), 'FontSize', 10, 'BoxColor', [0 0 0], 'TextColor', 'white', 'BoxOpacity', 0);
    
    M(M<0) = 0;
    M(M>1) = 1;
    M = M(:,:,1);
    writeVideo(v,M)
    
end
close(v)
