function ids=getColHistBinIds(imr,img,imb,numbins)
    % for the given colors, return the respective bin ids in the color histogram

    imr = double(imr); % * 255 + 1;
    img = double(img); % * 255 + 1;
    imb = double(imb); % * 255 + 1;

    f = double(numbins)/256.0;
    ids = floor(imr*f) + floor(img*f)*numbins + floor(imb*f)*numbins*numbins+1;

end

