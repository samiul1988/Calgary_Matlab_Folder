x0 = [0 0];
      fun = @dejong5fcn;
      lb = [-64 -64];
      ub = [64 64];
      [x,fval] = simulannealbnd(fun,x0,lb,ub)