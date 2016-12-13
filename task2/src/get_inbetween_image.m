
function new_image = get_inbetween_image(image, u, v)
    %---------------------------------------------------------------------
    % Task c: Generate new x- and y-values of new frame
    %---------------------------------------------------------------------
    
    [size_y, size_x, size_col] = size(image(:,:,:));
    new_image = image;
    
    %calculate offset
    x_offset = round(u./2);
    y_offset = round(v./2);
    
    % calculate the x and y values of the image
    [old_x, old_y] = meshgrid(1:size_x, 1:size_y);
    
    % calculate the x and y values of the pixel
    new_x = old_x + x_offset;
    new_y = old_y + y_offset;
    
    % handling the values outside the frame
    for y = 1:size_y
        for x = 1:size_x
            
            if(new_x(y,x) < 1)
                new_x(y,x) = 1;
            end
            if(new_x(y,x) > size_x)
                new_x(y,x) = size_x;
            end
            if(new_y(y,x) < 1)
                new_y(y,x) = 1;
            end
            if(new_y(y,x) > size_y)
                new_y(y,x) = size_y;
            end
        end
    end
            
    %---------------------------------------------------------------------
    % Task d: Generate new frame
    %---------------------------------------------------------------------
    new_image = single(new_image);
    new_image(:,:,1) = interp2(old_x, old_y, new_image(:,:,1), new_x, new_y);
    new_image(:,:,2) = interp2(old_x, old_y, new_image(:,:,2), new_x, new_y);
    new_image(:,:,3) = interp2(old_x, old_y, new_image(:,:,3), new_x, new_y);
    
    
end
