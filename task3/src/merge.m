%ypos, xpos: position for foreground (fg) in background (bg)
function result = merge(xpos, ypos, bg, foreground, foreground_map)
    %---------------------------------------------------------------------
    % Task c: Merge foreground and background
    %---------------------------------------------------------------------
    
    % put foreground into frame of same dimensions as background frame for
    % easier merging. insert foreground at [xpos ypos].
    foreground = double(foreground)/255;
    fg = zeros(size(bg));
    availableSpaceX = size(fg,2) - xpos;
    availableSpaceY = size(fg,1) - ypos;
    regionFilledX = min(availableSpaceX, size(foreground,2));
    regionFilledY = min(availableSpaceY, size(foreground,1));
    fg(ypos+1:ypos+regionFilledY, xpos+1:xpos+regionFilledX, :) = foreground(1:regionFilledY, 1:regionFilledX, :);
    %imshow(fg); return;
    
    % put foreground map into frame of same dimensions as background frame for
    % easier merging. insert foreground map at [xpos ypos].
    fgMap = zeros(size(bg,1), size(bg,2));
    availableSpaceX = size(fgMap,2) - xpos;
    availableSpaceY = size(fgMap,1) - ypos;
    regionFilledX = min(availableSpaceX, size(foreground,2));
    regionFilledY = min(availableSpaceY, size(foreground,1));
    fgMap(ypos+1:ypos+regionFilledY, xpos+1:xpos+regionFilledX) = foreground_map(1:regionFilledY, 1:regionFilledX);
    fgMap = repmat(fgMap,1,1,3);
    %imshow(fgMap); return;
    
    % merge foreground and background
    result = zeros(size(bg));
    result = fg .* fgMap + bg .* (1-fgMap);
    %imshow(result); return;
    
end