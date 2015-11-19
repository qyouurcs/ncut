clear
clc
addpath('./improved nystrom');
addpath('./fun');
debug = 0;
imagefiles = {'q54082_8.png','q304034_8.png','q253027_8.png','q163085_8.png','q108082_8.png','q103070_8.png','q86016_8.png','q14037_8.png'};
files = {'q54082_8','q304034_8','q253027_8','q163085_8','q108082_8','q103070_8','q86016_8','q14037_8'};
showfiles = {'54082.jpg','304034.jpg','253027.jpg','163085.jpg','108082.jpg','103070.jpg','86016.jpg','14037.jpg'};
cluster_num = [5,2,2,3,3,4,3,2];
imagefile=imagefiles{1};
K  = cluster_num(1);
sample_num = 50;
% mask_IS = ScriptSegIS(imagefile,imagefile,K, sample_num);
% mask_LS = ScriptSegLS(imagefile,imagefile,K, sample_num);
% mask_FS = ScriptSegFS(imagefile,imagefile,K, sample_num);
% mask_RS = ScriptSegRandom(imagefile,imagefile,K, sample_num);
% mask_SC = ScriptSegSC(imagefile,imagefile,K, sample_num);%


