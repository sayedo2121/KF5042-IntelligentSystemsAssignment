clear;clc;

%load trained model
net = load("fullConvTULaneNet");

%create datastores that point to disk locations holding the imagaes and the
%pixel labels
frames = imageDatastore("TUSimple/TUSimple/train_set/clips/0313-1/", "IncludeSubfolders",true);
labels = imageDatastore("TUSimple/TUSimple/train_set/seg_label/0313-1/", "IncludeSubfolders",true);

%read one frame and resize it to the model's input size
frameToRead = 80;
testImage = readimage(frames, frameToRead);
testLabel = readimage(labels, frameToRead/20);
testImageSize = size(testImage, 1,2);
I = imresize(testImage, 0.4);

%predict a segmentation map using the model
C = semanticseg(I, net.fullConvLaneNet);

%up-scale predicted mask to the size of the original frame
C_resized = imresize(C, testImageSize);

%overlay the segmentation map onto the original image
final = labeloverlay(testImage, C_resized);

%show ground truth
figure
imshow(testLabel);

%show overlayed image
figure
imshow(final);