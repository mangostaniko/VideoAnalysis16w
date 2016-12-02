function foreground_map = segmentation(frames,fg_scribbles,Hfc,Hbc,numbins)
% frames .. video frames (r,g,b,frame)
% fg_scribbles .. binary map marking scribbled pixels in scribbled frame
% Hfc .. color histogram of foreground pixels with colors grouped into bins
% Hbc .. color histogram of background pixels with colors grouped into bins
% numbins .. the number of bins per channel to aggregate colors in histograms

    %----------------------------------------------------------------------
    % Task c: Generate cost-volume
    %----------------------------------------------------------------------
   
    % color histograms give absolute counts in reference/scribbled frame
    % normalize by total counts to get probability of bg pixel color
    % as "cost" measure for fg pixel color
    % we only have this cost measure for the refernce/scribbled frame!
    % but we compare all other frames to it.
    cost_fg = Hbc / (Hfc + Hbc); % cost for each bin
    
    % find cost of colors of scribbled pixel locations in each frame 
    % for each pixel location in each frame: determine bin to look up cost
    binIDs = getColHistBinIds(frames(1), frames(2), frames(3), numbins);
    
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
