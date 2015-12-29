%
%      This HDR Toolbox demo creates an HDR radiance map:
%	   1) Read a stack of LDR images
%	   2) Read exposure values from the EXIF
%	   3) Estimate the Camera Response Function (CRF)
%	   4) Build the radiance map using the stack and stack_exposure
%	   5) Save the radiance map in .hdr format
%	   6) Show the tone mapped version of the radiance map
%
%       Author: Francesco Banterle
%       Copyright 2015 (c)
%

%clear all;

dirs = dir('images');

for directory=dirs'
    %directory.name
    dir_name = directory.name;
    dir_path = sprintf('images/%s', directory.name);
    fprintf('is "%s" dir? %d\n', dir_path, isdir(dir_path))
    
    if isdir(dir_path) && ~strcmp(dir_name, '.') && ~strcmp(dir_name, '..')
        
        format = 'jpg';
        
        fprintf('----- Processing directory "%s" -----\n', dir_name);

        disp('1) Read a stack of LDR images');
        stack = ReadLDRStack(dir_path, format);

        disp('2) Read exposure values from the exif');
        stack_exposure = ReadLDRStackInfo(dir_path, format);

        disp('3) Estimate the Camera Response Function (CRF)');
        [lin_fun, ~] = ComputeCRF(stack, stack_exposure, 512);    
        h = figure(1);
        set(h, 'Name', 'The Camera Response Function (CRF)');
        plot(lin_fun);

        disp('4) Build the radiance map using the stack and stack_exposure');
        imgHDR = BuildHDR(stack, stack_exposure, 'LUT', lin_fun, 'Deb97', 'log');

        disp('5) Save the radiance map in the .hdr format');
        hdrimwrite(imgHDR, sprintf('%s/hdr_image.pfm', dir_path));

        %disp('6) Show the tone mapped version of the radiance map with gamma encoding');
        %h = figure(2);
        %set(h, 'Name', 'Tone mapped version of the built HDR image');
        %GammaTMO(ReinhardBilTMO(imgHDR, 0.18), 2.2, 0, 1);
    end;
end;
