%% Initiate Variables (wing freq and length)
% Two different bugs simulated (values can be changed)
m_butter = 8.5; % frequency Hz
m_butter_wing = 47.5; %length mm
h_bee = 245; % frequency Hz
h_bee_wing = 8; %length mm

x = 0.0005:.0005:0.5; %seconds
t =  0.0005:.0005:0.5; %used in gaussian filter

%% Create sinusoidal wave and add noise
% Monarch Butter Fly
y_m_butter = m_butter_wing*cos(2*pi*m_butter*x); 
% Gaussian filter used to limit amount of time "bug" is in the snapshot
gaussian_fn = gaussmf(t,[0.1 0.175]);
y_m_butter = y_m_butter(1:1000).*gaussian_fn(1:1000);
a=abs(randn(1,1000)*2);
y_m_buttern = y_m_butter+a;
% Introduce noise into simulation
a_noise = (y_m_buttern(1:1000).*(y_m_buttern(1:1000)>(m_butter_wing*.75)))+a(1:1000);
plot(t, a_noise);
a_fft = fft(a_noise);

% Honey Bee
y_h_bee = h_bee_wing*cos(2*pi*h_bee*x); % cosine function
gaussian_fn = gaussmf(t,[0.1 0.2]);
y_h_bee = y_h_bee(1:1000).*gaussian_fn;
a=abs(randn(1,1000).^(.6));
y_h_been = y_h_bee+a;
b_noise = (y_h_been(1:1000).*(y_h_been(1:1000)>(h_bee_wing*.75)))+a(1:1000); % add noise
plot(t, b_noise);
b_fft = fft(b_noise);

% hold on, plot(y_h_bee);
% plot(b_noise)
% plot(y_m_butter);
% plot(a_noise)

%% FFT
Fs = 2000;                    % Sampling frequency
T = 1/Fs;                     % Sampling period
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
x1 = 1.3*cos(2*pi*175*t);          % First row wave
x2 = a_noise;         % Second row wave
x3 = b_noise;         % Third row wave
X = [x1; x2; x3];

% for i = 1:3
%     subplot(3,1,i)
%     plot(t(1:1000),X(i,1:1000))
%     title(['Row ',num2str(i),' in the Time Domain'])
% end

n = 2^nextpow2(L);
dim = 2;
Y = fft(X,n,dim);
P2 = abs(Y/n);
P1 = P2(:,1:n/2+1);
P1(:,2:end-1) = 2*P1(:,2:end-1);

% for i=1:3
%     subplot(3,1,i)
%     plot(0:(Fs/n):(Fs/2-Fs/n),P1(i,1:n/2))
%     title(['Row ',num2str(i), ' in the Frequency Domain'])
% end
figure(1)
subplot(2,1,1),plot(t(1:1000),abs(X(2,1:1000)))
title('Monarch Butterfly Time Domain (s)'); %ylim([0 60]);
subplot(2,1,2),plot(0:(Fs/n):(Fs/2-Fs/n),P1(2,1:n/2));
title('Monarch Butterfly Frequency Domain (Wingbeat = 8.5 Hz)');

figure(2)
subplot(2,1,1),plot(t(1:1000),abs(X(3,1:1000)))
title('Honey Bee Time Domain (s)'); %ylim([0 60]); 
subplot(2,1,2),plot(0:(Fs/n):(Fs/2-Fs/n),P1(3,1:n/2))
title('Honey Bee Frequency Domain (Wingbeat = 245 Hz)')
