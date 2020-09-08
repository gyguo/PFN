function show_heatmap( heatmap )
%heatmap
map=double(heatmap);
range= [min(map(:)) max(map(:))];
img = mat2gray(map, range);
imshow(img)

end

