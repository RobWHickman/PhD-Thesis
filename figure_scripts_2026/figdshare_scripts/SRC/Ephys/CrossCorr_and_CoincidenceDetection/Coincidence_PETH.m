function coin_rast = Coincidence_PETH(rast,bin_sz)
if nargin < 2
    bin_sz = 80;
end

BIN = num2str(bin_sz);

bn = { '20' '50' '80' '200' '500'};

ir = find(strcmp(BIN,bn));

fnams = fieldnames(rast);
warning(['Only analyzing coincidence for ',bn{ir},' ms bins!'])
for icl = 1:length(rast.(fnams{ir})(:,1))
    for icl2 = icl:length(rast.(fnams{ir})(:,1))
        if ~strcmp(rast.(fnams{ir}){icl,2},rast.(fnams{ir}){icl2,2})
            r1 = rast.(fnams{ir}){icl,1};
            r2 = rast.(fnams{ir}){icl2,1};
            
            coin = min(r1,r2);
            if sum(sum(coin))>0
                sc = sum(coin);
                
                coin_fig = figure;
                set(coin_fig,'Visible','off');
                wind = (bin_sz*(length(sc)-1))/2;
                xax = (1/bin_sz:length(sc))*bin_sz;
                xchnk = wind/bin_sz;
                % figure
                subplot(6,1,1:5)
                scaleFactor = 1;
                scale = [min(min(coin))*scaleFactor max(max(coin))/scaleFactor];
                imagesc(coin,scale)
                colormap(flipud(gray))
                ylabel('Trial count')
                xticks([])
                
                subplot(6,1,6)
                bar(xax,sc,'FaceColor','k','EdgeColor','k')
                xticks(xax(1:xchnk:end)-1)
                xt = (xax(1:xchnk:end)-1)-wind;
                for ixt = 1:length(xt)
                    xtck{ixt} = num2str(xt(ixt));
                end
                xticklabels(xtck)
                xlabel('Time (ms)')
                ylabel('Count (spikes/bin)')
                axis tight
                pubify_figure_axis_robust
                
                titstr = [rast.(fnams{ir}){icl,2},' X ',rast.(fnams{ir}){icl2,2},'_bin_',num2str(bin_sz)];
                FigureTitle(titstr)
                %title(titstr)
                LongFigs
                finam = strrep(titstr,' ','_');
                saveas(coin_fig,finam,'png')
                close(coin_fig)
            end
        end
        clear coin
    end
end

