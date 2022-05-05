clear;clc;

trainImagesReader = VideoReader("train_images.avi");
labelsReader = VideoReader("labels.avi");

trainImages = read(trainImagesReader, [1, 500]);

labelsRGB = read(labelsReader, [1, 500]);

labels = uint8(zeros(size(labelsRGB, 1, 2, 4)));

for i = 1:length(labels)
    %may need to drop thrid channel
    labels(:, :, i) = im2gray(labelsRGB(:, :, :, i));
end

labels = labels./255;
labels = reshape(labels, size(labels, 1), size(labels, 2), 1, size(labels, 3));

cv = cvpartition(size(trainImages,4),"HoldOut", 0.2);
idx = cv.test;
xTrain = trainImages( :, :, :, ~idx);
xTest = trainImages(:, :, :, idx);

cv = cvpartition(size(labels,4),"HoldOut", 0.2);
idx = cv.test;
yTrain = labels(:, :, :, ~idx);
yTest = labels(:, :, :, idx);

clear trainImages;
clear labels;
clear labelsRGB;
clear trainImagesReader;
clear labelsReader;
clear cv;
clear idx;
clear i;


%add shuffle

%batchSize = 150;
epochs = 20;
poolSize = [2, 2];
inputSize = size(xTrain(:,:,:,1));

layers = [
    imageInputLayer(inputSize, "Name", "imageInputLayer")
    batchNormalizationLayer
    convolution2dLayer(3, 60, "Stride", 1, "Name", "Conv1")
    reluLayer
    convolution2dLayer(3, 50, "Stride", 1, "Name", "Conv2")
    reluLayer
    maxPooling2dLayer(poolSize, "Stride", 2, "Name", "maxpool1", "HasUnpoolingOutputs",true)
    convolution2dLayer(3, 40, "Stride", 1, "Name", "Conv3")
    reluLayer
    dropoutLayer(0.2)
    convolution2dLayer(3, 30, "Stride", 1, "Name", "Conv4")
    reluLayer
    dropoutLayer(0.2)
    convolution2dLayer(3, 20, "Stride", 1, "Name", "Conv5")
    reluLayer
    dropoutLayer(0.2)
    maxPooling2dLayer(poolSize, "Stride", 2, "Name", "maxpool2", "HasUnpoolingOutputs",true)
    convolution2dLayer(3, 10, "Stride", 1, "Name", "Conv6")
    reluLayer
    dropoutLayer(0.2)
    convolution2dLayer(3, 5, "Stride", 1, "Name", "Conv7")
    reluLayer
    dropoutLayer(0.2)
    maxPooling2dLayer(poolSize, "Stride", 2, "Name", "maxpool3", "HasUnpoolingOutputs",true)
    maxUnpooling2dLayer("Name", "unpool1")
    transposedConv2dLayer(3, 10, "Stride", 1, "Name", "Deconv1")
    reluLayer
    dropoutLayer(0.2)
    transposedConv2dLayer(3, 20, "Stride", 1, "Name", "Deconv2")
    reluLayer
    dropoutLayer(0.2)
    maxUnpooling2dLayer("Name", "unpool2")
    transposedConv2dLayer(3, 30, "Stride", 1, "Name", "Deconv3")
    reluLayer
    dropoutLayer(0.2)
    transposedConv2dLayer(3, 40, "Stride", 1, "Name", "Deconv4")
    reluLayer
    dropoutLayer(0.2)
    transposedConv2dLayer(3, 50, "Stride", 1, "Name", "Deconv5")
    reluLayer
    dropoutLayer(0.2)
    maxUnpooling2dLayer("Name", "unpool3")
    transposedConv2dLayer(3, 60, "Stride", 1, "Name", "Deconv6")
    transposedConv2dLayer(3, 1, "Stride", 1, "Name", "Final")
    regressionLayer
    ];

lgraph = layerGraph(layers);
lgraph = connectLayers(lgraph, "maxpool1/indices", "unpool3/indices");
lgraph = connectLayers(lgraph, "maxpool1/size", "unpool3/size");

lgraph = connectLayers(lgraph, "maxpool2/indices", "unpool2/indices");
lgraph = connectLayers(lgraph, "maxpool2/size", "unpool2/size");

lgraph = connectLayers(lgraph, "maxpool3/indices", "unpool1/indices");
lgraph = connectLayers(lgraph, "maxpool3/size", "unpool1/size");

options = trainingOptions("adam", "MaxEpochs", epochs,...
    "Plots", "training-progress", "Shuffle", "every-epoch", "Verbose",true,...
    "MiniBatchSize", 50);

clear layers;
clear poolSize;
clear epochs;
clear inputSize;

fullConvLaneNet = trainNetwork(xTrain, yTrain, lgraph, options);

save fullConvLaneNet

