            
            %             bid_third = 100/3;
            % %                     bid_lmh = {mnmb:mnmb+bid_third-1, mnmb+bid_third:mnmb+(bid_third*2), mnmb+(bid_third*2)+1:mnmb+(bid_third*3)+1};
            %             bid_lmh = {0:bid_third-1, bid_third:bid_third*2, (bid_third*2)+1:(bid_third*3)};
            %             bid_lmh = cellfun(@round,bid_lmh,'UniformOutput',false);
            
            
            %             bid_half = (mxmb-mnmb)/2;
            %             bid_lmh = {0:mnmb+bid_half-1, mnmb+bid_half:mnmb+(bid_half*2), mnmb+(bid_half*2)+1:mnmb+(bid_half*3)+1};
            %             bid_lmh = cellfun(@round,bid_lmh,'UniformOutput',false);
            
            % edgs = quantile(mb(gi),4);
            % edgs(1)=0;
            % [~,~,bn] = histcounts(mb,edgs);
            % bid_lmh = bn;
            
            %             bid_third = (mxmb-mnmb)/3;
            %             %             bid_lmh = {mnmb:mnmb+bid_third, mnmb+bid_third:mnmb+(bid_third*2), mnmb+(bid_third*2):mnmb+(bid_third*3)};
            %             bid_lmh = {0:mnmb+bid_third-1, mnmb+bid_third:mnmb+(bid_third*2), mnmb+(bid_third*2)+1:mnmb+(bid_third*3)};
            %             bid_lmh = cellfun(@round,bid_lmh,'UniformOutput',false);
            %
            %             bid_fourth = (mxmb-mnmb)/4;
            %             bid_lmh = {mnmb:mnmb+bid_fourth-1, mnmb+bid_fourth:mnmb+(bid_fourth*2), mnmb+(bid_fourth*2)+1:mnmb+(bid_fourth*3)+1,...
            %                 mnmb+(bid_fourth*3)+1:mnmb+(bid_fourth*4)};
            %             bid_lmh = cellfun(@round,bid_lmh,'UniformOutput',false);
            
%             bid_fifth = (mxmb-mnmb)/5;
%             bid_lmh = {0:mnmb+bid_fifth-1, mnmb+bid_fifth:mnmb+(bid_fifth*2), mnmb+(bid_fifth*2)+1:mnmb+(bid_fifth*3)+1,...
%                 mnmb+(bid_fifth*3)+1:mnmb+(bid_fifth*4)+1, mnmb+(bid_fifth*4)+1:mnmb+(bid_fifth*5)};
%             bid_lmh = cellfun(@round,bid_lmh,'UniformOutput',false);
            