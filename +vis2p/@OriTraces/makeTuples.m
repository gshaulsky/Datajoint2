function makeTuples( obj, key )

import vis2p.*

% params
shuffle = fetch1(OriTracesParams(key),'shuffle');

% continue only if there are at least 8 directions shown
oris = unique(fetchn(OriTrials(key),'ori_num'));
if length(oris)<8;return;end

% get traces [oriOut oriIn cells trials]
[traces,oris] = getTraces(OriTraces,'key',key,'compute',1);

% control error
if isempty(traces)
    display('Nothing to compute!')
    return
elseif size(traces,1)<8
    display('<8 orientations shown, not enought for tunning calculation!')
    return
end

% make sure everything is greater than zero
baseline = min(traces(:));
traces = traces - baseline;

m = double(mean(traces,2));

% fit Von Mises with the true data
orientations = oris/360 * 2 * pi;
[FitVonMisses,res] = fitVonMises(m,orientations);
[~,~,~,Pdm] = opticalProperties(FitVonMisses);

% calculate weighted sum of squared errors of the fit
v = var(traces,[],2);
wsse = sum(res.^2./v);

% Calciulate
[~, dm] = max(m);
[dm,~,dm90,dm270] = circOri(orientations,dm);
otiRaw = (m(dm)-mean(m([dm90 dm270]))) ./(m(dm)+mean(m([dm90 dm270])));

% Fit Von Mises for the shuffled data
binAreaMean = traces(:);
condIdxSfl = zeros(numel(binAreaMean),shuffle);
conditionIndexNum = numel(binAreaMean);

% shuffle the index
conditionIndexNumShuffled = 1:conditionIndexNum;
for i = 1:shuffle
    conditionIndexNumShuffled = conditionIndexNumShuffled(randperm(conditionIndexNum));
    condIdxSfl(:,i) = conditionIndexNumShuffled;
end

% generate randomly shuffled data
randBinArea = binAreaMean(condIdxSfl);
randBinArea = reshape(randBinArea,size(traces,1),size(traces,2),shuffle);

% mean
areaMeanShfl = squeeze(mean(randBinArea,2));

% compute tuning indexes
[~, dm] = max(areaMeanShfl);
dm90 = zeros(1,shuffle);dm270 = dm90;
for i = 1:shuffle
    [dm(i), ~,dm90(i),dm270(i)] = circOri(orientations,dm(i));
end

% convert to linear indicies
dm = sub2ind(size(areaMeanShfl),dm,1:size(areaMeanShfl,2));
dm90 = sub2ind(size(areaMeanShfl),dm90,1:size(areaMeanShfl,2));
dm270 = sub2ind(size(areaMeanShfl),dm270,1:size(areaMeanShfl,2));

pref = areaMeanShfl(dm);
orthPref = mean([areaMeanShfl(dm90); areaMeanShfl(dm270)]);
prefMorthPref = pref - orthPref;
oti = prefMorthPref ./(pref + orthPref);

key.fitVM = FitVonMisses;
key.pdm = Pdm;
key.Poti = mean( oti > otiRaw );
key.oti = otiRaw;
key.wsse = wsse;

% insert data
insert( obj, key );



