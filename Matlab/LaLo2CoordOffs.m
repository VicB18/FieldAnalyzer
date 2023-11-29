function [X,Y]=LaLo2CoordOffs(la,lo,laOffs,loOffs)
R=6362132;%[meter]
X=R*cos(la/180*pi).*(lo-loOffs)/180*pi;
Y=R*(la-laOffs)/180*pi;