%% Load data
% example 1
%load('./data.mat')
% example 2
load('./data2.mat')
%% Step 1: Histogram Equalization
cd ./Histo-Equal
[ img_source_new ] = histo_equal( img_source,img_style,[1,0,0] );
cd ../
%% Step 2: Shape Deformation
% original AMAT
figure;subplot(1,2,1);imshow(visualize_radius( img_source,branches_source,radius_source ));
subplot(1,2,2);imshow(visualize_radius( img_style,branches_style,radius_style ));
% pre-processing
cd ./Preprocess_Branches
[ branches_source ] = kill_dots( branches_source,2 );
[ branches_style ] = kill_dots( branches_style,2 );
[ branches_source,branches_style ] = balance_branches( branches_source,branches_style );
[ radius_source ] = get_radius( branches_source );
[ radius_style ] = get_radius( branches_style );
cd ../
figure;subplot(1,2,1);imshow(visualize_radius( img_source,branches_source,radius_source ));
subplot(1,2,2);imshow(visualize_radius( img_style,branches_style,radius_style ));
% local shapes
radius_source_new=branches_source;radius_source_new(radius_source_new>0)=28;
radius_style_new=branches_style;radius_style_new(radius_style_new>0)=28;
[ x_source ] = get_patches( branches_source>0,branches_source,radius_source_new,56 );
[ x_style ] = get_patches( branches_style>0,branches_style,radius_style_new,56 );
% matching
cd ./AMAT-NN
[ match_xy ] = match_shape_new( x_source,x_style,[100,500] );
visualize_match( img_source,branches_source,img_style,branches_style,match_xy );
% deform axis
[ branches_source_new,radius_source_new,deform_xy ] = axis_deform( match_xy,branches_source,branches_style );
cd ../
figure;imshow(visualize_radius( img_source,branches_source_new,radius_source_new ));
% deform image
cd ./AMAT-NN
[ img_deform ] = paint_patches_deform( img_source_new,radius_source,radius_source_new,deform_xy );
figure;imshow(img_deform);
cd ../
%% Step 3: Texture Transfer
cd ./Texture-Guide
[ img_guided ] = texture_guide( img_deform,img_style,30,2 );
cd ../