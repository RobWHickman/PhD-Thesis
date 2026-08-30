function [CBid, Distribution, CBidn] = CBidMaker(BidType, DistType)

global TP TO

rng('shuffle');
switch BidType
    case 'D' % DISCRETE
        switch DistType
            case 'U'
                
                CBidn           = randi(TO.Params.BDM.D_nDivs);
                CBid            = CBidn/TO.Params.BDM.D_nDivs;
                Distribution    = [0, 0];
            case 'P'              

                Distribution    = [TP.Reward.PCoeffs(1), TP.Reward.PCoeffs(2)];
                Rx              = betarnd(Distribution(1), Distribution(2));
                CBidn           = ceil(TO.Params.BDM.D_nDivs*Rx);

                CBid            = CBidn/TO.Params.BDM.D_nDivs;

            case 'C'

                Distribution    = [TP.Reward.PCoeffs(1), TP.Reward.PCoeffs(2)];
                Rx              = betarnd(Distribution(1), Distribution(2));
                CBidn           = ceil(TO.Params.BDM.D_nDivs*Rx);
                CBid            = CBidn/TO.Params.BDM.D_nDivs;

        end
    case 'C' % CONTINUOUS
        CBidn   = nan;
        switch DistType
            case 'U'
                
                CBid            = rand;
                Distribution    = [0 0];
                
            case 'P'
                
                Distribution = [TP.Reward.PCoeffs(1), TP.Reward.PCoeffs(2)];
                CBid         = betarnd(Distribution(1), Distribution(2));

            case 'C'

                Distribution = [TP.Reward.PCoeffs(1), TP.Reward.PCoeffs(2)];
                CBid         = betarnd(Distribution(1), Distribution(2));

        end
end

end