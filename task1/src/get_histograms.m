function [bok,scribble_count, fg_scribbles, histo_fg, histo_bg] = get_histograms(input_directory,file_list,bins)     
    % load reference frame and its foreground and background scribbles
    % other frames are not considered here!!
    
    bok=false;
    scribble_count=0;
    reference_frame=[];
    fg_scribbles=[];
    histo_fg=[];
    histo_bg=[];
    for j = 1:numel(file_list)
        frame_name = file_list(j).name;

        if (strcmp(frame_name(1),'s') == 1) % scribble files begin with s
           frame = imread([input_directory '/' frame_name]); %read image      
           scribble_count=scribble_count +1;
           frames_scribbles(:,:,:,scribble_count) = frame(:,:,:);             
        elseif (strcmp(frame_name(1),'r') == 1) % reference file begin with r
           frame = imread([input_directory '/' frame_name]); % read image     
           reference_frame=uint8(frame(:,:,:));
        end
    end
    frames_scribbles=uint8(frames_scribbles);
   
    if ((scribble_count==2) && (~isempty(reference_frame))) 
        bok=true;
    else 
        return;
    end;
    
    %----------------------------------------------------------------------
    % Task a: Filter user scribbles to indicate foreground and background   
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Task b: Generate color models for foreground and background
    %----------------------------------------------------------------------
    
    [size_y, size_x, size_col] = size(reference_frame);
    foreground_map = zeros(size_y, size_x);
    foreground_colors = [];
    background_map = zeros(size_y, size_x);
    background_colors = [];
    foregroundCount = 1;
    backgroundCount = 1;
    
    for count_y = 1 : size_y
        for count_x = 1 : size_x
            % Foreground scribble pixels
            if frames_scribbles(count_y, count_x,1,1) ~= reference_frame(count_y, count_x,1)
                foreground_map(count_y, count_x) = 1; % binary map
                foreground_colors(foregroundCount,1) = reference_frame(count_y, count_x,1);
                foreground_colors(foregroundCount,2) = reference_frame(count_y, count_x,2);
                foreground_colors(foregroundCount,3) = reference_frame(count_y, count_x,3);
                foregroundCount = foregroundCount+1;
            end
            % Background scribbled pixels
            if frames_scribbles(count_y, count_x,1,1) ~= reference_frame(count_y, count_x,1)
                background_map(count_y, count_x) = 1;
                background_colors(backgroundCount,1) = reference_frame(count_y, count_x,1);
                background_colors(backgroundCount,2) = reference_frame(count_y, count_x,2);
                background_colors(backgroundCount,3) = reference_frame(count_y, count_x,3);
                backgroundCount = backgroundCount+1;
            end
        end
    end
    
    % create binned color histograms
    fg_scribbles = foreground_map;
    histo_fg = colHist(foreground_colors(:,1), foreground_colors(:,2), foreground_colors(:,3), bins);
    histo_bg = colHist(background_colors(:,1), background_colors(:,2), background_colors(:,3), bins);
    
end