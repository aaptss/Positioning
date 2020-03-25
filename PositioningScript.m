[params, beacons, distToRover, noisedDistToRover, roverInitPosition] = ...
          ProblemInit(15, 2, 1500, 10);
PlotSpace(beacons,0,roverInitPosition,params)
%% Method 1: an analytical solution, mean of coordinates of intersections of pairs of circles      
roverAnalytAcq  = AnalyticalMetod(params,beacons,distToRover);

figure
FinPlotSpace(beacons, 0, roverInitPosition, roverAnalytAcq, params)
title('Method of Analytical Intersections')

errAnalyt = CalcError(roverInitPosition, roverAnalytAcq);
%% Method 2: Trilaterating the position of the POI
roverTrilatAcq  = TrilaterationMethod(params,beacons,distToRover);

figure
FinPlotSpace(beacons, 0, roverInitPosition, roverTrilatAcq, params)
title('Trilateration Method')

errTrilat = CalcError(roverInitPosition, roverTrilatAcq);
%% GP Functions
function FinPlotSpace(beacons,circles,roverInit,roverCalc,params)
%plots the original POI and calculated one.
    PlotSpace(beacons,circles,roverInit,params)
    hold on
    scatter(roverCalc.x,roverCalc.y,...
        'diamond','green');
    hold off
end

function PlotSpace(beacons,circles,roverInit,params)
%plots the space with beacons and the POI placed. if circles == equations of 
%circles around each beacon, plots the outline of the circles. if circles ==0, 
%plots only the beacons and the POI
    scatter(beacons(:,1),beacons(:,2),'x','magenta');
    hold on
    scatter(roverInit.x,roverInit.y,...
          'diamond','black','filled');
    title('Initial Space')
    xlabel('\chi');
    ylabel('\phi')
if circles == 0
    return
else
    fimplicit(circles(:), [min(params.space.x) max(params.space.x)]);
end
    hold off
    grid on
end

function err = CalcError(roverInit, roverAcq)
%calculates the difference between the initial position and the acquired one
    err = norm([roverInit.x; roverInit.y] - ...
               [roverAcq.x;  roverAcq.y]);
end