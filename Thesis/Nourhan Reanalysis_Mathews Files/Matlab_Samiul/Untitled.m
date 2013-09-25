x = [0 1 0];
y = [1 1 .5];
z = [0 0.5 1];
stem3(x,y,z), xlabel('X'),ylabel('Y'),zlabel('Z');

x = [0 1];
y =[0 1];
 [X,Y] = meshgrid(x,y);
 Z = [1 0; 1 0];
 surf(X,Y,Z), xlabel('X'),ylabel('Y'),zlabel('Z');
 vol = trapz(y,trapz(x,Z,2),1)
 
 x = [0 1];
y =[0 1];
 [X,Y] = meshgrid(x,y);
 Z = [1 0; 1 0];
 surf(X,Y,Z), xlabel('X'),ylabel('Y'),zlabel('Z');
 vol = trapz(y,trapz(x,Z,2),1)



 

 x = [0 1 1 0];
 y = [0 0 1 1];
 z = [.5 .75 1 1];
 
 tri = delaunay(x,y);
 trisurf(tri,x,y,z);
 xlim([0 1]),ylim([0 1]),zlim([0 1]);
 xlabel('X'),ylabel('Y'),zlabel('Z');

  x = oo(:,1); y = oo(:,2); z = oo(:,3); 
 plot3(x,y,z),grid on
 xlim([0 1]),ylim([0 1]),zlim([0 1]);
 xlabel('X'),ylabel('Y'),zlabel('Z');
 
       y = [-0.5 0.5 0.5 -0.5]';
       tri = delaunay(x,y);
       triplot(tri,x,y);
       
       
x = [0 .5 .8 1];
y = [1 .5 .2 0];
t = trapz(x,y)