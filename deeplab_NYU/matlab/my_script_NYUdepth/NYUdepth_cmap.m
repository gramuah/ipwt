NYUdepth.cmap_id = zeros(256, 3);
NYUdepth.cmap_trainid = zeros(256, 3);

colours = parula(40);

NYUdepth.cmap_id(1:40, :) = colours;

% NYUdepth.cmap_id(2, :) = [81,  0, 81];
% NYUdepth.cmap_id(3, :) = [128, 64,128];
% NYUdepth.cmap_id(4, :) = [244, 35,232];
% NYUdepth.cmap_id(5, :) = [111, 74,  0];
% NYUdepth.cmap_id(6, :) = [81,  0, 81];
% NYUdepth.cmap_id(7, :) = [128, 64,128];
% NYUdepth.cmap_id(8, :) = [244, 35,232];
% NYUdepth.cmap_id(9, :) = [250,170,160];
% 
% NYUdepth.cmap_id(10, :) = [230,150,140];
% NYUdepth.cmap_id(11, :) = [70, 70, 70];
% NYUdepth.cmap_id(12, :) = [102,102,156];
% NYUdepth.cmap_id(13, :) = [190,153,153];
% NYUdepth.cmap_id(14, :) = [180,165,180];
% NYUdepth.cmap_id(15, :) = [150,100,100];
% NYUdepth.cmap_id(16, :) = [150,120, 90];
% NYUdepth.cmap_id(17, :) = [153,153,153];
% NYUdepth.cmap_id(18, :) = [153,153,153];
% NYUdepth.cmap_id(19, :) = [250,170, 30];
% 
% NYUdepth.cmap_id(20, :) = [220,220,  0];
% NYUdepth.cmap_id(21, :) = [107,142, 35];
% NYUdepth.cmap_id(22, :) = [152,251,152];
% NYUdepth.cmap_id(23, :) = [70,130,180];
% NYUdepth.cmap_id(24, :) = [220, 20, 60];
% NYUdepth.cmap_id(25, :) = [255,  0,  0];
% NYUdepth.cmap_id(26, :) = [0,  0,142];
% NYUdepth.cmap_id(27, :) = [0,  0, 70];
% NYUdepth.cmap_id(28, :) = [0, 60,100];
% NYUdepth.cmap_id(29, :) = [0,  0, 90];
% 
% NYUdepth.cmap_id(30, :) = [0,  0,110];
% NYUdepth.cmap_id(31, :) = [0, 80,100];
% NYUdepth.cmap_id(32, :) = [0,  0,110];
% NYUdepth.cmap_id(33, :) = [0, 80,100];
% NYUdepth.cmap_id(34, :) = [0,  0,230];
% NYUdepth.cmap_id(35, :) = [119, 11, 32];
% NYUdepth.cmap_id(36, :) = [0,  0,230];
% NYUdepth.cmap_id(37, :) = [119, 11, 32];
% NYUdepth.cmap_id(38, :) = [0,  0,110];
% NYUdepth.cmap_id(39, :) = [0, 80,100];
% NYUdepth.cmap_id(40, :) = [0,  0,230];
% NYUdepth.cmap_id(255, :) = [0, 0, 0];
% 
% NYUdepth.cmap_id = NYUdepth.cmap_id / 255;