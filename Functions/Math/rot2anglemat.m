function angle = rot2anglemat(C)

pitch = atand(C(2,3,:)./C(3,3,:));
yaw = -asind(C(1,3,:));
roll = atand(C(1,2,:)./C(1,1,:));

angle = [pitch, yaw, roll];

end