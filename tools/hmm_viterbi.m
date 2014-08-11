function [STA] = hmm_viterbi(OBS,HMM)
% For a single observation sequence OBS

K = length(OBS);   % Number of time slices
N = length(HMM.A); % Number of states

delta_pre = zeros(N,K);
delta     = zeros(N,K);
psi       = zeros(N,K);
%% forward pass %%
for k = 1 : K
    if k==1
        delta_pre(:,k) = HMM.pi;
    else
        [C I] = max( HMM.A .* repmat( delta(:,k-1),1,N )) ;
        delta_pre(:,k) = C';
        psi(:, k) = I';
    end
    
    %delta(:,k) = delta_pre(:,k) .* HMM.B(:,OBS(k));
    delta(:,k) = delta_pre(:,k) .* getObservationProbability(OBS(:,k), HMM.B);
end

%% Path Backtracking %%
STA = zeros(1,K);

for k = K:-1:1
    if k==K
        [C I] = max( delta(:,k) ); 
        STA(k) = I;
    else
        C = psi(:,k+1);
        STA(k) = C(STA(k+1));
    end
end

end