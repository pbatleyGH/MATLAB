%Load image of typical room, creates a 534x800x3 RGB matrix 
Typical_room = imread('Typical_room.jpg');

clear Typical_room_*
%Reduce red light by 1%, leaving green and blue unaltered
Typical_room_1_percent(:,:,1) = Typical_room(:,:,1) * 0.99;
Typical_room_1_percent(:,:,1) = round(Typical_room_1_percent(:,:,1));
Typical_room_1_percent(:,:,2:3) = Typical_room(:,:,2:3);

%Reduce red light by 5%
Typical_room_5_percent(:,:,1) = Typical_room(:,:,1) * 0.95;
Typical_room_5_percent(:,:,1) = round(Typical_room_5_percent(:,:,1));
Typical_room_5_percent(:,:,2:3) = Typical_room(:,:,2:3);

%Reduce red and green light by 10% (pessimistic estimate)
Typical_room_10_percent_RB(:,:,1) = Typical_room(:,:,1) * 0.9;
Typical_room_10_percent_RB(:,:,1) = round(Typical_room_10_percent_RB(:,:,1));
Typical_room_10_percent_RB(:,:,2) = Typical_room(:,:,2) * 0.9;
Typical_room_10_percent_RB(:,:,1) = round(Typical_room_10_percent_RB(:,:,1));
Typical_room_10_percent_RB(:,:,3) = Typical_room(:,:,3);

%Reduce red and green light by 15% (pessimistic estimate)
Typical_room_20_percent_RB(:,:,1) = Typical_room(:,:,1) * 0.8;
Typical_room_20_percent_RB(:,:,1) = round(Typical_room_20_percent_RB(:,:,1));
Typical_room_20_percent_RB(:,:,2) = Typical_room(:,:,2) * 0.8;
Typical_room_20_percent_RB(:,:,1) = round(Typical_room_20_percent_RB(:,:,1));
Typical_room_20_percent_RB(:,:,3) = Typical_room(:,:,3);

%Plot all four for comparison
figure
subplot (2,3,1), semilogy(XYZ_Wavelengths,CIE_XYZ); axis on
xlabel ('Wavelength/nm')
ylabel ('Relative Sensitivity')
axis ([350 750 1e-4 10])
subplot (2,3,2), image (Typical_room); title ('Original image'); axis off;
subplot (2,3,3), image (Typical_room_1_percent); title ('-1% Red'); axis off;
subplot (2,3,4), image (Typical_room_5_percent); title ('-5% Red'); axis off;
subplot (2,3,5), image (Typical_room_10_percent_RB); title ('-10% Red+Green'); axis off;
subplot (2,3,6), image (Typical_room_20_percent_RB); title ('-20% Red+Green'); axis off;