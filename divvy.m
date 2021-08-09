function divvy()
 %%
 %% Divvy rider data analysis: avg duration, avg age,
 %% rider and starting hour histograms, and stations
 %% near me.
 %%
 %% <<your name >> 
 %% U. of Illinois, Chicago
 %% CS109, Fall 2017
 %% Project #12
 %%

  fprintf('** Divvy Analysis Program **\n')
  fprintf('\n');
  
  filename = input('Divvy ridership file to analyze> ', 's');
  analysis = input('Analysis to perform (1-5, 0 to exit)> ');
 
 
  %% let's make sure the file exists:
  if exist(filename, 'file') ~= 2  
      fprintf('**Error: file "%s" cannot be found\n', filename);
      Result = '**Error: file not found';
      return;
  end
  while analysis ~=0
      
  if analysis == 1
      %% avg ride duration:
      Result = AverageDuration(filename); 
      fprintf('Average ride duration: %f minutes \n', Result);
      analysis = input('Analysis to perform (1-5, 0 to exit)> ');
  elseif analysis == 2
      %% avg rider age:
      Result = AverageAge(filename);
      fprintf('Average ride age: %f years old \n', Result);
      analysis = input('Analysis to perform (1-5, 0 to exit)> ');
  elseif analysis == 3
      %% histogram of durations:  
      %% 1/2 hour, 1 hr, 2 hrs, 4 hrs, more than 4 hrs
      Result = DurationHistogram(filename);
      fprintf('Ride duration breakdown: \n');
      fprintf('# rides <= 30 mins: %d \n', Result(1));
      fprintf('# rides <= 1 hours: %d \n', Result(2));
      fprintf('# rides <= 2 hours: %d \n', Result(3));
      fprintf('# rides <= 4 hours: %d \n', Result(4));
      fprintf('# rides > 4 hours: %d \n', Result(5));
      analysis = input('Analysis to perform (1-5, 0 to exit)> ');
  elseif analysis == 4
      %% histogram of ride starting hours:
      %% 0, 1, 2, 3, ..., 23
      Result = RideHistogram(filename);
        X = (0:23);
        Y = Result;
        plot(X,Y,'r+-');
        title('# of rides starting each hour');
        xlabel('starting hour');
        ylabel('# of rides');
        xlim([0,23]);
        analysis = input('Analysis to perform (1-5, 0 to exit)> ');
      
  elseif analysis == 5
      %% stations near me
      Result = StationsNear(filename);
      %fprintf('Station %d: %f miles, "%s" \n', Result);
      analysis = input('Analysis to perform (1-5, 0 to exit)> ');
  else
      %% invalid analysis value:
      Result = '**Error: invalid analysis parameter';
      analysis = input('Analysis to perform (1-5, 0 to exit)> ');
  end
  end 
  
  fprintf('\n');
  fprintf('** Done **\n');
  fprintf('\n');
  
 end
 
 function Result = DivvyAnalysis(filename, analysis)
 end
 
 function AvgDuration = AverageDuration(file)
    
  data1 = load(file);
  a = data1(:,3);
  avg = mean(a/60);
  
  AvgDuration = avg;
end

function AvgAge = AverageAge(file)
  data2 = load(file);
  b = data2(:,7);
  c = clock();
  currentyear = c(1);
  LI = b==0;
  b(LI)=[];
  
  AvgAge= mean(currentyear-b);
  
end

function Result = DurationHistogram(file)   
  data1 = load(file);
  a = data1(:,3);
  avg = (a/60);
  z = sum(avg<=30);
  y = sum(avg>30 & avg<=60);
  x = sum(avg>60 & avg<=120);
  b = sum(avg>120 & avg<=240);
  c = sum(avg>240);
  
  
    
Result = [z, y, x, b, c];
  
end


function Result = RideHistogram(file)
    data3 = load(file);
    c = data3 (:,1);
   
    
    
  Result = hist(c,24);  %% row vector of 24 zeros
end

 function Result = StationsNear(file)

     data4 = load('divvy-stations.csv');
    
     lat1 = input('Enter your latitude>');
     long1 = input('Enter your longitude>');
     miles = input('Within how many miles?');
     
     lat2 = data4(:,2);
     long2 = data4(:,3);
 
     distance = DistBetween2Points(lat1,long1,lat2,long2);
     
     id = data4(:,1);
     
     %% sort:
     [sorted, newIndex] = sort(distance, 'ascend');
     distance=sorted;
     id = id(newIndex);
     
     
     %% two vectors to hold search resukts for distance & id:
    
    LI=(sorted<= miles);
    id=id(LI);
    distance = distance(LI);
   num = sum(LI);
  
   for i = 1:length(id)
    %fprintf('Station %d: %f miles, "%s" \n', id, distance, num);
    fprintf('Station %d: ' , id(i));
    fprintf('%f miles, ' , distance(i));
    name = GetStationName(id(i));
    fprintf ('"%s"\n', name);
   end
    fprintf('# stations: %d \n' , num); 

    Result = 1;
       
 end    