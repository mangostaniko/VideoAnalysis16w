function foreground_map = segmentation(frames,fg_scribbles,Hfc,Hbc,bins)
% frames .. video frames (r,g,b,frame)
% fg_scribbles .. binary map marking scribbled pixels in scribbled frame
% Hfc .. color histogram of foreground pixels with colors grouped into bins
% Hbc .. color histogram of background pixels with colors grouped into bins
% numbins .. the number of bins per channel to aggregate colors in histograms

    [size_y, size_x, size_col, size_frame] = size(frames(:,:,:,:));
    foreground_map = zeros(size_y, size_x, size_col);

    %----------------------------------------------------------------------
    % Task c: Generate cost-volume
    %----------------------------------------------------------------------
   
    % To calculate the cost-volume matrice we need to visit each pixel of 
    % the frame, and for each one calculate the cost-volume.
    for frame_counter=1:size_frame
        for count_y=1:size_y
            for count_x=1:size_x
                
                % For each color-value of the pixels we need to determine
                % the corresponded color-value in the "Bins"
                imr = double(frames(count_y, count_x, 1, frame_counter));
                img = double(frames(count_y, count_x, 2, frame_counter));
                imb = double(frames(count_y, count_x, 3, frame_counter));
                f = double(bins)/256.0;
                relevant_bin = floor(imr*f) + floor(img*f)*bins + floor(imb*f)*bins*bins+1;
                
                % Now we use the founded Bin to get the volume-cost
                foreground_map(count_y, count_x, frame_counter) = Hfc(relevant_bin)/(Hfc(relevant_bin)+Hbc(relevant_bin));
            end
        end
    end
    
    %----------------------------------------------------------------------
    % Task e: Filter cost-volume with guided filter
    %----------------------------------------------------------------------
 
    
    %----------------------------------------------------------------------
    % Task f: delete regions which are not connected to foreground scribble
    %----------------------------------------------------------------------
    

    %----------------------------------------------------------------------
    % Task g: Guided feathering
    %----------------------------------------------------------------------
    foreground_map=[];
    
    
end
