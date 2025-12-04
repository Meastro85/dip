calf = dicomread("images/BO2WL_F_10089_T1_CALF.dcm");
bic1 = dicomread("images/BO2WL_F_20048_T1_BIC.dcm");
bic2 = dicomread("images/BO2WL_F_20050_T1_BIC.dcm");
tri = dicomread("images/BO2WL_F_20052_T1_TRI.dcm");

figure;
subplot(1, 4, 1), imshow(calf, []), title('Calf Image');
subplot(1, 4, 2), imshow(bic1, []), title('Bic1 Image');
subplot(1, 4, 3), imshow(bic2, []), title('Bic2 Image');
subplot(1, 4, 4), imshow(tri, []), title('Tri Image');