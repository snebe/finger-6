% make all target files for AVMA imaging experiment
subjname = 'Alex';

tgt_path = ['C:/Users/fmri/Desktop/finger-6/misc/tfiles/',subjname,'/'];

if(~exist(tgt_path))
    mkdir(tgt_path);
end

% generate key assignments for this subject
if(~exist([tgt_path,'symbkey']));
    symbkey = [randperm(5), 5+randperm(5)];
    eval (['save ',[tgt_path 'symbkey'],' symbkey']);
else
    load symbkey;
end

numTrainingBlocks = 3;
numPracticeBlocks = 10;
numSwitchTrainingBlocks = 3;
numTRblocks = 6;

% build target files
%% Day 1 - pre-scan FreeRT

% initial training on both symbol sets
symbSet = 1;
%for blk = 1:numTrainingBlocks
    WriteRtTgt(tgt_path, 'day', 1, 'block', 1, 'swapped', 0,...
        'image_type', symbSet, 'repeats', 20, 'ind_finger', [1:5], 'ind_img',symbkey(1:5));
%end
WriteRtTgt(tgt_path, 'day', 1, 'block', 2, 'swapped', 0,...
        'image_type', symbSet, 'repeats', 20, 'ind_finger', [1:5], 'ind_img',symbkey(6:10));
    
    WriteRtTgt(tgt_path, 'day', 1, 'block', 3, 'swapped', 0,...
        'image_type', symbSet, 'repeats', 10, 'ind_finger', [1:5 1:5], 'ind_img',symbkey);

%% Day 1 - scan session
for run = 1:10
    WriteScanTgt(tgt_path,1,run,symbkey);
end

%% Day 1 - post-scan TR
for blk = 1:numTRblocks
WriteTrTgt(tgt_path, ...
                'day', 1, 'block', blk, 'swapped', 0,...
                'image_type', 1, 'repeats', 20, 'easy_block', 0,...
                'ind_finger', [1:5 1:5], 'ind_img', symbkey, 'mintime', .2, 'maxtime', .8);
end

%% Day 2-4 training
for day = 2:4
    for blk = 1:numPracticeBlocks
        WriteRtTgt(tgt_path, 'day', day, 'block', blk, 'swapped', 0,...
            'image_type', 1, 'repeats', 20, ...
                'ind_finger', [1:5], 'ind_img', symbkey(1:5));
    end
end

%% Day 5 pre-scan
for day = 2:4
    for blk = 1:numTrainingBlocks
            WriteRtTgt(tgt_path, 'day', 5, 'block', blk, 'swapped', 0,...
            'image_type', 1, 'repeats', 20, ...
                'ind_finger', [1:5 1:5], 'ind_img', symbkey);
    end
end

%% Day 5 scan - or just keep same as previous?
for run = 1:10
    WriteScanTgt(tgt_path,2,run,symbkey);
end

%% Day 5 post-scan
% permute symbol key
symbkey_switched = symbkey;
symbkey_switched([2 4 8 10]) = symbkey([4 2 10 8]);

for blk = 1:numTrainingBlocks
    WriteRtTgt(tgt_path, 'day', 5, 'block', blk, 'swapped', [1 4],...
        'image_type', 1, 'repeats', 20, ...
        'ind_finger', [1:5 1:5], 'ind_img', symbkey_switched);
end

%for blk = 1:numTRblocks
 %   WriteTrTgt
