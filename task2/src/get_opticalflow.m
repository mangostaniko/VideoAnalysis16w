%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optical Flow Computation: Horn & Schunck Method
% img1 : second frame
% img2 : first frame
% alpha: regularization parameter for degree of smoothness
% iterations: number of iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [flow] = get_opticalflow(img1, img2, alpha, iterations)

img1 = double(rgb2gray(img1));
img2 = double(rgb2gray(img2));

%1. differentiate the first time & gradients              
[Fx,Fy,Ft] = getDerivatives(img1, img2);

%2. solve equation iteratively
% initial flow vectors
u = double(zeros(size(Fx)));
v = double(zeros(size(Fy)));

% iterations
for i=1:iterations
    % compute local averages of the flow vectors
    uAvg = getAvg(u);
    vAvg = getAvg(v);
    
    %----------------------------------------------------------------------
    % Task b: compute optical flow vectors 
    %----------------------------------------------------------------------
    
    % calculate new optical flow vector (u,v) of this iteration.
    % optical flow vectors are based on brightness constancy assumption:
    % i.e. take flow vector along which linear extrapolation of brightness gradients 
    % yields minimal change in brightness. The brightnessConstancyTerm 
    % below takes the direction of greatest change (along the brightness gradient)
    % for the average flow vector, and we subtract this from the average
    % flow vector to get more and more away from the direction of greatest change.
    % smoothness term models smoothness assumption: if field is smooth, 
    % optical flow vectors are scaled down less and can use more of
    % neighboring values
    brightnessConstancyTerm = uAvg.*Fx + vAvg.*Fy + Ft;
    smoothnessTerm = Fx.*Fx + Fy.*Fy + alpha; % small if field is smooth (less scaling down)
    u = uAvg - brightnessConstancyTerm .* Fx ./ smoothnessTerm;
    v = vAvg - brightnessConstancyTerm .* Fy ./ smoothnessTerm;
    
end

% apply median filter to remove outliers
u = medfilt2(u);
v = medfilt2(v);

%3. return result (flow vector field)
u(isnan(u))=0;
v(isnan(v))=0;
[h,w] = size(u);
flow = zeros(h,w,2);
flow(:,:,1)= u;
flow(:,:,2)= v;
end


function [Fx,Fy,Ft] = getDerivatives(img1, img2)
    %spatial and temporal derivatives
    Fx = conv2(img1,0.25* [-1 1; -1 1],'same') + conv2(img2, 0.25*[-1 1; -1 1],'same');
    Fy = conv2(img1, 0.25*[-1 -1; 1 1], 'same') + conv2(img2, 0.25*[-1 -1; 1 1], 'same');
    Ft = conv2(img1, 0.25*ones(2),'same') + conv2(img2, -0.25*ones(2),'same');
end

function avgMotion = getAvg(u)
  % for approximation of laplacian gradient: compute motion average of
  % neighbor pixels
  kernel_1=double([1/12 1/6 1/12;1/6 0 1/6;1/12 1/6 1/12]);
  avgMotion = conv2(u,kernel_1,'same');
end
    
