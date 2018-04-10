function angle = rot2anglemat(C)

roll = acosd(C(3,3,:));
pitch = atand(C(1,3,:)./C(2,3,:));
yaw = atand(C(3,1,:)./C(3,2,:));

angle = [pitch, yaw, roll];

end