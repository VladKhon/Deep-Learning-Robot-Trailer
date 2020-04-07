sim('config5sim_KinematicController')

vref_min = min(vref);
vref_max = max(vref);
wref_min = min(wref);
wref_max = max(wref);
vQ_min = min(vQ);
vQ_max = max(vQ);
wQ_min = min(wQ);
wQ_max = max(wQ);

vref_rng = vref_max - vref_min;
wref_rng = wref_max - wref_min;
vQ_rng = vQ_max - vQ_min;
wQ_rng = wQ_max - wQ_min;

for i = 1:length(vref)
    vref_norm(i) = 2*(vref(i)-vref_min)/vref_rng - 1;
    wref_norm(i) = 2*(wref(i)-wref_min)/wref_rng - 1;
    vQ_norm(i) = 2*(vQ(i)-vQ_min)/vQ_rng - 1;
    wQ_norm(i) = 2*(wQ(i)-wQ_min)/wQ_rng - 1;
end

Vref = vref_norm';
Wref = wref_norm';
VQ = vQ_norm';
WQ = wQ_norm';