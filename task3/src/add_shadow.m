% ypos, xpos: position for foreground shadow in background
% Note: we are operating on single frames here, not the whole video!!
function bg_with_shadow = add_shadow(xpos, ypos, bg, foreground_map)
    %---------------------------------------------------------------------
    % Task b: Add shadow of foreground object to background
    %---------------------------------------------------------------------
        
    % compute shadow as simple projection of foreground map
    % note: the projection here is not perspective correct
    % we just rotate and scale the x and y axis a bit, 
    % to get the impression of shadow at an angle
    projectionMatrix = [10 -5 0; 10 3 0; 0 0 1];
    transformationStructure = maketform('projective', projectionMatrix);
    shadowMapFromFgMap = imtransform(foreground_map, transformationStructure, 'XYScale', [22 12]); % XYScale specifies width and height of transformed pixels so that they can be automatically scaled down to square pixels
    
    % put shadow map into frame of same dimensions as background frame for
    % easier merging. insert shadowMap at [xpos ypos].
    shadowMap = zeros(size(bg,1), size(bg,2));
    availableSpaceX = size(shadowMap,2) - xpos;
    availableSpaceY = size(shadowMap,1) - ypos;
    regionFilledX = min(availableSpaceX, size(shadowMapFromFgMap,2));
    regionFilledY = min(availableSpaceY, size(shadowMapFromFgMap,1));
    shadowMap(ypos+1:ypos+regionFilledY, xpos+1:xpos+regionFilledX) = shadowMapFromFgMap(1:regionFilledY, 1:regionFilledX);
    %imshow(shadowMapFrame); return;
    
    % add color to shadow
    shadowColor = [0.0 0.0 0.0];
    shadowMapColor = cat(3, shadowMap .* shadowColor(1), shadowMap .* shadowColor(2), shadowMap .* shadowColor(3));
    %imshow(shadowMapFrameColor); return;
    
    % merge shadow with background
    % pixels without shadow (shadowMap == 0) will have full bgColor,
    % pixels with shadow will have shadowColor*shadowAlpha + bgColor*(1-shadowAlpha).
    shadowAlpha = 0.7;
    bg = double(bg)/255;
    shadowMapColor = shadowMapColor .* shadowAlpha;
    bg_with_shadow = shadowMapColor + bg .* (1-repmat(shadowMap,1,1,3).*shadowAlpha);
    %imshow(bg_with_shadow); return;
        
end

