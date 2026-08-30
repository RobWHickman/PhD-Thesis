fsix = strfind(PD.file_name,'\');
file_spec = PD.file_name(fsix(end)+4:end-4);
dt = strfind(file_spec,'dot');
uid = file_spec(dt(1)-1:end);

file_spec=uid;
fn_PD = fieldnames(PD);
cl = strfind(fn_PD,'cluster');
cl_ix = cellfun(@isempty,cl);
cl_nams = fn_PD(~cl_ix);
%%
IT = PD.IT;
fe = PD.first_event_intan_time;
sd_vec = 1:200:(length(IT)*200);
signal_data_times = sd_vec+fe-5000;   
Signal_data_ms(:,2) = IT;
Signal_data_ms(:,1) = signal_data_times;
%%
bin = 50;
for iCN = 1:length(cl_nams)
    Cluster_struct = PD.(cl_nams{iCN});
    fnamClst = fieldnames(Cluster_struct);    
    for iSter = 1:length(fnamClst)
        for iClst = 1:length(Cluster_struct.(fnamClst{iSter}))
            
            spike_times_s = (Cluster_struct.(fnamClst{iSter})(iClst).TimeInSec);
            spike_times_ms = spike_times_s*1000;%put spike times in ms
            
            Tx_All_prec = PD.Precision_TxEvALL_intan_time;
            tx_dif = Tx_All_prec(:,3)-Tx_All_prec(:,1);
            [tx_dif_sort,tx_sort_ix] = sort(tx_dif);
            Tx_Times = Tx_All_prec(tx_sort_ix,1);
            
            rast = Raster(spike_times_ms,Tx_Times,2000,2000,bin,1);
            
            resp = nanmean(rast(:,2000/bin:3000/bin),2);
            cont = nanmean(rast(:,1:1000/bin),2);
            
            p = signrank(resp,cont);
            
            if p<0.05
                figure
                sta = SpikeTriggeredAverage(spike_times_ms,Signal_data_ms,2000,2000,5);
                            disp('f')

            end
            
            
            
            
        end
    end
end

            