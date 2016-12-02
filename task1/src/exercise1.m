function exercise1(input_directory, output_directory, file_extension)
    % close all figures
    close all;  

    % check optional file extension parameter
    if (~exist('file_extension')) || (isempty(file_extension))
      file_extension='png'; 
    end
    
    % create output directory
    if ~exist(output_directory, 'dir')
       if(~mkdir(output_directory)) 
           disp(['Cannot create output directory [' output_directory ']']);
           return;
       end
    end

    % read all the file names in a folder ending on the chosen file extension        
    file_list      = dir([input_directory '/*.' file_extension]); 
    if (numel(file_list) == 0)
        disp(['No input frames found in input directory ' input_directory '!'])
        return;
    end
 
    
    %----------------------------------------------------------------------
    % Task a+b: get foreground and background histograms 
    %----------------------------------------------------------------------
    bok = false; % boolean ok
    numbins = 30; % number of bins for color histogram
    % call function get_histograms with suitable parameters
    % [return parameters]=get_histograms(parameters,...);
    
    % scribble_count .. number of scribbled pixels
    % fg_scribbles .. binary map, 1 at scribbled locations
    % histo_fg, histo_bg .. binned color histograms of fg and bg scribbled pixels
    [bok,scribble_count, fg_scribbles, histo_fg, histo_bg] = get_histograms('../fg_frames/', file_list, numbins);
    if (~bok) % "boolean ok"
        disp(['No scribble or no reference frame found in input directory ' input_directory '!'])
        return;
    end 
    
    frames = [];
    count=0;
    loop_cnt = 0;
    loop_size= numbins;

    for j = 1:(numel(file_list))
        frame_name = file_list(j).name;

        % skip scribble and reference files
        if ((strcmp(frame_name(1),'s') == 1) || (strcmp(frame_name(1),'r') == 1)) 
            continue; 
        end;
            
        frame = imread([input_directory '/' frame_name]); %read image  
        
        count = count+1;
        
        % cache frames
        frames(:,:,:,count) = uint8(frame(:,:,:));
              
        % every <loop_size> frames run segmentation
        if (((mod(count, loop_size)) == 0) || (j==(numel(file_list)-3)))
            %--------------------------------------------------------------
            % Task c: Generate Cost-Volume 
            %--------------------------------------------------------------
            % call function segmentation with suitable parameters
            foreground_map = segmentation(frames, fg_scribbles, histo_fg, histo_bg, numbins);

            % store frames
            for i = 1:size(frames,4)    
                framecount=(loop_cnt*loop_size)+i;
                frame_number = int2str(framecount); 
                frame_str    = '00000';  
                frame_str(end-numel(frame_number)+1:end) = frame_number;  
                imwrite(foreground_map(:,:,i), sprintf('%s/frame%s.%s', output_directory, frame_str, file_extension));
                disp(sprintf('Storing frame [%d]', framecount));                                              
            end

            loop_cnt=loop_cnt+1;
            count=0;
            frames=[];
        end
    end
end

