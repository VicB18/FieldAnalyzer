function x_pix=M2PixX(X,MapXmin,MapPix_Meter)
x_pix=floor((X-MapXmin)*MapPix_Meter);