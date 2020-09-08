function plot_skeletons( imgPath,joints,edges,opt )
%plot joint and skeletons

img= imread(imgPath);
img = imresize(img,opt.dims);
figure
hold off
imshow(img);
hold on
scatter(joints(1,:),joints(2,:),'g','filled');
for i =1:size(edges,1)
    line([joints(1,edges(i,1)),joints(1,edges(i,2))],[joints(2,edges(i,1)),joints(2,edges(i,2))],'LineWidth',2,'Color','r')
end

end

