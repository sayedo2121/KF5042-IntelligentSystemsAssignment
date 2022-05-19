clear;clc;

%load trained model
net = load("fullConvTULaneNet.mat");
net = net.fullConvLaneNet;

%create datastores that point to disk locations holding the imagaes and the
%pixel labels
frames = imageDatastore("TUSimple/TUSimple/train_set/clips/0313-2/", "IncludeSubfolders",true);
labels = pixelLabelDatastore("TUSimple/TUSimple/train_set/seg_label/0313-2/", ["noLane", "lane1", "lane2", "lane3", "lane4"], [0, 2, 3, 4, 5], "IncludeSubfolders",true);

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

%create segmentation maps and store results in a temporary datastore
pxdsResults = semanticseg(frames20, net, "WriteLocation", tempdir,"MiniBatchSize",1);

%evaluate segmentation maps against ground truth with multiple metrics
metrics = evaluateSemanticSegmentation(pxdsResults,labels, "Metrics", "all");

%display confusion matrix
cm = confusionchart(metrics.ConfusionMatrix.Variables, ...
  ["noLane", "lane1", "lane2", "lane3", "lane4"], Normalization='row-normalized');
cm.Title = 'Normalized Confusion Matrix (%)';



