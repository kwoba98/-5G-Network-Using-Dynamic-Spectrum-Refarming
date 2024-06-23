
% Step 1: Define User Classes and QoS Requirements
user_classes = {'Class1', 'Class2', 'Class3'};  % Define user classes
qos_requirements = [10 100;  % [Latency, Throughput] requirements for Class1
                    20 50;   % [Latency, Throughput] requirements for Class2
                    30 80];  % [Latency, Throughput] requirements for Class3

% Step 2: Network Configuration
num_base_stations = 1;  % Number of base stations
total_bandwidth = 100;  % Total available bandwidth
power_levels = [10];   % Power levels for the base station

% Step 3: User Association
rng(0,'twister');
b=1;
a=100;
num_users = 3;  % Number of users
user_locations = (b-a).*rand(num_users, 2)+a;  % User locations (assume 2D coordinates)

% Perform user association based on signal strength and proximity to the base station
user_associations = zeros(num_users, 1);  % User-to-base station associations

for i = 1:num_users
    user_location = user_locations(i, :);
    % Compute signal strength to the base station
    base_station_location = [0, 0];  % Base station location
    distance = norm(user_location - base_station_location);  % Euclidean distance between user and base station
    path_loss = (4 * pi * distance)^2;  % Path loss model
    signal_strength = 1 / path_loss;  % Signal strength as the inverse of path loss
    % Select the base station with the strongest signal
    [~, user_associations(i)] = max(signal_strength);
end

% Step 4: Resource Allocation Framework (Proportional Fair)
user_utilities = zeros(num_users, 1);  % User utilities based on QoS requirements and achieved QoS
allocated_bandwidth = zeros(num_base_stations, 1);  % Allocated bandwidth for the base stations

for i = 1:num_users
    user_class = user_classes{i};
    qos_requirement = qos_requirements(i, :);
    achieved_qos = [0, 0];  % Placeholder for achieved QoS (latency, throughput)
    
    % Generate achieved QoS values with reduced latency and increased throughput
   

    achieved_qos(1)= distance/total_bandwidth;  % Randomly generate new latency lower than the requirement
    achieved_qos(2) = qos_requirement(2) + total_bandwidth;   % Randomly generate new throughput above the requirement

    
    % Compute the user utility based on QoS requirements and achieved QoS
    user_utilities(i) = (qos_requirement(1) / achieved_qos(1)) * (achieved_qos(2) / qos_requirement(2));
end

% Allocate resources based on proportional fair allocation
total_utility = sum(user_utilities);
for i = 1:num_base_stations
    % Compute the allocated bandwidth based on user utilities and available bandwidth
    allocated_bandwidth(i) = total_bandwidth * (user_utilities(i) / total_utility);
end

% Step 5: Resource Mapping
% Map the allocated resources to the user classes based on their QoS requirements
resource_mapping = zeros(num_users, num_base_stations);  % Resource allocation matrix

for i = 1:num_users
    user_class = user_classes{i};
    user_qos_requirement = qos_requirements(i, :);
    allocated_bw = allocated_bandwidth(user_associations(i));
    
    % Map the allocated bandwidth to the user class based on QoS requirements
    resource_mapping(i, user_associations(i)) = allocated_bw;
end
% Step 6: Dynamic Resource Allocation (not implemented in this example)
% Assume dynamic changes in network conditions or user demands

% Increase the available bandwidth
total_bandwidth = total_bandwidth + 200;

% Reallocate resources based on proportional fair allocation
user_utilities = zeros(num_users, 1);  % Reset user utilities based on new achieved QoS

for i = 1:num_users
    user_location = user_locations(i, :);
    base_station_location = [0, 0];  % Base station location
    distance = norm(user_location - base_station_location); 
    user_class = user_classes{i};
    qos_requirement = qos_requirements(i, :);
    achieved_qos = [0, 0];  % Placeholder for new achieved QoS (latency, throughput)
    
    % Compute the new achieved QoS for the user
    %achieved_qos(1) = %distance/total_bandwidth;
    achieved_qos(1)= (distance/total_bandwidth);  % Randomly generate new latency lower than the requirement
    achieved_qos(2) = qos_requirement(2) + total_bandwidth;   % Randomly generate new throughput above the requirement
    

    % Compute the new user utility based on QoS requirements and new achieved QoS
    user_utilities(i) = (achieved_qos(1) / qos_requirement(1)) * (achieved_qos(2) / qos_requirement(2));
    
    disp(achieved_qos(1));
    disp(achieved_qos(2));
   
    
end

%allocated_bandwidth = zeros(num_base_stations, 1);  % Reset allocated bandwidth for the base stations

%for i = 1:num_base_stations
    % Compute the new allocated bandwidth based on new user utilities and increased available bandwidth
 %   allocated_bandwidth(i) = total_bandwidth * (user_utilities(i) / sum(user_utilities));
%end

% Update the resource mapping based on the new allocation
for i = 1:num_users
    user_class = user_classes{i};
    user_qos_requirement = qos_requirements(i, :);
  %  allocated_bw = allocated_bandwidth(user_associations(i));
   % resource_mapping(i, user_associations(i)) = allocated_bw;

     
end

% Step 7: Performance Evaluation
% Calculate the achieved QoS for each user based on the new allocated resources
%achieved_qos = zeros(num_users, 2);  % [Latency, Throughput] achieved by each user

for i = 1:num_users
    
   user_class = user_classes{i};
  % user_qos_requirement = qos_requirements(i, :);
   %allocated_bw = resource_mapping(i, user_associations(i));
    
    % Compute the achieved QoS for the user based on the allocated bandwidth
   % achieved_qos(i, 1) = user_qos_requirement(1) ;% * (allocated_bw / user_qos_requirement(1))^2;
    %achieved_qos(i, 2) = user_qos_requirement(2) ;%* (allocated_bw / user_qos_requirement(2))^2;
end

% Print the achieved QoS for each user
disp('Achieved QoS:')
for i = 1:num_users
    user_class = user_classes{i};
    fprintf('User %d: Class %s, Achieved QoS [Latency: %.2f, Throughput: %.2f]\n', i, user_class, achieved_qos(1), achieved_qos(2));
end
