function city = TSP(d)
cities = rand(d)*(99-60)+60;
city = triu(cities)+triu(cities,1)';
city(logical(eye(size(city))))=0;
end
