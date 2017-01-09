function create_video(video_filename, input_directory, file_extension)
    %---------------------------------------------------------------------
    % Task d: Create output video of all resulting frames
    %---------------------------------------------------------------------
    
    % get list of input file names
    frameFileList = dir([input_directory '/*.' file_extension]); 
    if (numel(frameFileList) == 0)
        disp(['No frames for video creation found in directory ' input_directory '!'])
        return;
    end
    
    % open video writer object
    video = VideoWriter(['../output/' video_filename '.avi']);
    video.FrameRate = 24;
    open(video);
    
    % write frames
    for i = 1:numel(frameFileList)
        frame = imread([input_directory '/' frameFileList(i).name]);
        writeVideo(video, frame);
    end
    
    close(video);
    
end

