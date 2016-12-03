function foreground_map = segmentation(frames,fg_scribbles,Hfc,Hbc,bins)
% frames .. video frames (r,g,b,frame)
% fg_scribbles .. binary map marking scribbled pixels in scribbled frame
% Hfc .. color histogram of foreground pixels with colors grouped into bins
% Hbc .. color histogram of background pixels with colors grouped into bins
% numbins .. the number of bins per channel to aggregate colors in histograms

    [size_y, size_x, size_col, size_frame] = size(frames(:,:,:,:));
    cost_volume = zeros(size_y, size_x, size_col);

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
                cost_volume(count_y, count_x, frame_counter) = Hfc(relevant_bin)/(Hfc(relevant_bin)+Hbc(relevant_bin));
            end
        end
    end
    
    cost_volume(isnan(cost_volume))=0;
    %----------------------------------------------------------------------
    % Task e: Filter cost-volume with guided filter
    %----------------------------------------------------------------------

    cost_volume_filtered = guidedfilter_vid_color(frames, cost_volume, 20, 1, 0.00001);
    fg_binary_map = cost_volume_filtered(cost_volume_filtered > 0.5);
    
    %----------------------------------------------------------------------
    % Task f: delete regions which are not connected to foreground scribble
    %----------------------------------------------------------------------

    fg_binary_map = keepConnected(fg_binary_map, fg_scribbles);
    
    %----------------------------------------------------------------------
    % Task g: Guided feathering
    %----------------------------------------------------------------------

    % apply guided filter again to feather edges
    fg_binary_map = guidedfilter_vid_color(frames, fg_binary_map, 20, 1, 0.00001);
    
    foreground_map = fg_binary_map;
    
    
    
end
