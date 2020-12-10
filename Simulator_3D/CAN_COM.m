function CAN_COM(t,x,f,m,p,T)
        to_output = transpose([ t ; x ;f*1000/(9.80665*m); p;T ]);
        dlmwrite('test.csv',to_output,'-append');
end
