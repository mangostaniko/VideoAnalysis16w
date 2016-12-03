%   BOXFILTER   O(1) time box filtering using cumulative sum
%
%   - Definition imDst(x, y)=sum(sum(imSrc(x-r:x+r,y-r:y+r)));
%   - Running time independent of r; 
%   - Equivalent to the function: colfilt(imSrc, [2*r+1, 2*r+1], 'sliding', @sum);
%   - But much faster.
function vidDst = boxfilter_vid(vidSrcC, r, rt)
% r .. filter radius (manhattan distance)
% rt .. filter radius in time (how many neighboring frames included)

    % the size of each local patch; N=(2r+1)^3 except for boundary pixels.
    [hei, wid, frames] = size(vidSrcC);
    vidDst = zeros(size(vidSrcC));
    
    for i=1:frames
                
        imDst = zeros(size(vidSrcC));
        % cumulative sum over Y axis
        imCum = cumsum(vidSrcC, 1);
        
        % difference over Y axis
        imDst(1:r+1, :, :) = imCum(1+r:2*r+1, :, :); % left edge case (margin of size of radius)
        imDst(r+2:hei-r, :, :) = imCum(2*r+2:hei, :, :) - imCum(1:hei-2*r-1, :, :);
        imDst(hei-r+1:hei, :, :) = repmat(imCum(hei, :, :), [r, 1]) - imCum(hei-2*r:hei-r-1, :, :); % right edge case (margin of size of radius)

        % cumulative sum over X axis
        imCum = cumsum(imDst, 2);
        % difference over X axis
        imDst(:, 1:r+1,:) = imCum(:, 1+r:2*r+1,:);  % left edge case (margin of size of radius)
        imDst(:, r+2:wid-r,:) = imCum(:, 2*r+2:wid,:) - imCum(:, 1:wid-2*r-1,:);
        imDst(:, wid-r+1:wid,:) = repmat(imCum(:, wid,:), [1, r]) - imCum(:, wid-2*r:wid-r-1,:);
        
        % cumulative sum over Z axis
        imCum = cumsum(imDst, 3);
        % difference over Z axis
        imDst(:, :, 1:rt+1) = imCum(:, :, 1+rt:2*rt+1);
        imDst(:, :, rt+2:frames-rt) = imCum(:, :, 2*rt+2:frames) - imCum(:,:,1:frames-2*rt-1);
        imDst(:, :, frames-rt+1:frames) = repmat(imCum(:, :, frames), [1, 1, rt]) - imCum(:,:,frames-2*rt:frames-rt-1);
        
        vidDst(:,:,i) = imDst(:,:,i);
        
    end  
end



