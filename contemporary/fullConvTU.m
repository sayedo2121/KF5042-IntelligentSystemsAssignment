%this is the training script

clear;clc;

%create datastores that point to disk locations holding the imagaes and the
%pixel labels
frames = imageDatastore("TUSimple/TUSimple/train_set/clips/0313-1/", "IncludeSubfolders",true);
labels = pixelLabelDatastore("TUSimple/TUSimple/train_set/seg_label/0313-1/", ["noLane", "lane1", "lane2", "lane3", "lane4"], [0, 2, 3, 4, 5], "IncludeSubfolders",true);

%skip 20 frames in the 'frames' datastore because they do not have
%corresponding ground truth
indices = [];
for i=1: size(frames.Files, 1)/20
    indices = [indices 20*i];
end
frames20 = subset(frames, indices);

%set a custom read function for the datastores that resize the image to 40%
frames20.ReadFcn = @customReadDatastoreImage;
labels.ReadFcn = @customReadDatastoreImage;

%read a sample from each datastore
I = readimage(frames20, 1);
C = readimage(labels, 1);

%combine the two datastores and create a test partition
combinedDir = combine(frames20, labels);
train = combinedDir;
test = partition(combinedDir, 50, 50);

%set training hyperparameters
batchSize = 1;
epochs = 10;
poolSize = [2, 2];
inputSize = size(I);
valFreq = 200;
learnRate = 0.01;
optimiser = "adam";

%set model layers
layers = [
    imageInputLayer(inputSize, "Name", "imageInputLayer")
    batchNormalizationLayer("Name", "batchNorm")


    convolution2dLayer(3, 300, "Stride", 1, "Name", "Conv1")
    reluLayer("Name", "relu1")
    maxPooling2dLayer(poolSize, "Stride", 2, "Name", "maxpool1", "HasUnpoolingOutputs",true)

    convolution2dLayer(3, 100, "Stride", 1, "Name", "Conv2")
    reluLayer("Name", "relu2")
    maxPooling2dLayer(poolSize, "Stride", 2, "Name", "maxpool2", "HasUnpoolingOutputs",true)


    maxUnpooling2dLayer("Name", "unpool1")
    transposedConv2dLayer(3, 300, "Stride", 1, "Name", "Deconv1")
    reluLayer("Name", "relu4")

    maxUnpooling2dLayer("Name", "unpool2")
    transposedConv2dLayer(3, 5, "Stride", 1, "Name", "Final")


    softmaxLayer("Name", "softmaxLayer")
    pixelClassificationLayer("Classes", ["noLane", "lane1", "lane2", "lane3", "lane4"], "Name", "pixelClassificationLayer")
    ];

%connect maxpooling and unpooling layers such that the unpooling happens in
%the same way
lgraph = layerGraph(layers);
lgraph = connectLayers(lgraph, "maxpool1/indices", "unpool2/indices");
lgraph = connectLayers(lgraph, "maxpool1/size", "unpool2/size");

lgraph = connectLayers(lgraph, "maxpool2/indices", "unpool1/indices");
lgraph = connectLayers(lgraph, "maxpool2/size", "unpool1/size");

%set more hyperparameters plus show training in GUI
options = trainingOptions(optimiser, "MaxEpochs", epochs,...
    "Plots", "training-progress", "Shuffle", "every-epoch",...
    "MiniBatchSize", batchSize, "ValidationData", test, ...
    "ValidationFrequency", valFreq, "InitialLearnRate", learnRate);

%remove from memory for more space
clear layers;
clear poolSize;
clear epochs;
clear inputSize;

%train model
fullConvLaneNet = trainNetwork(train, lgraph, options);

%export model to current directory
save fullConvTULaneNet