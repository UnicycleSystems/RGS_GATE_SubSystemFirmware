import datetime, os, json
SP=os.path.dirname(os.path.abspath(__file__))
rows=[]
for line in open(os.path.join(SP,'raw.csv')):
    p=line.strip().split(',')
    if len(p)<2: continue
    rows.append((datetime.datetime.strptime(p[0],'%Y-%m-%d %H:%M:%S'), float(p[1])))
rows.sort()

T0=datetime.datetime(2026,10,15,11,15,35)   # last float reading, 16.628 V
T1=datetime.datetime(2026,10,15,16,59,52)   # graceful shutdown, 13.337 V
CAP=2400.0
dur=(T1-T0).total_seconds()/3600.0
I=CAP/dur
print(f"Discharge window : {T0}  ->  {T1}")
print(f"Duration         : {dur:.4f} h  ({int(dur)}h {round((dur%1)*60)}m)")
print(f"Assumed capacity : {CAP:.0f} mAh")
print(f"AVERAGE CURRENT  : {I:.1f} mA   ({I/CAP*1000:.3f} C)")
print(f"Average power    : {I/1000*15.0:.2f} W at 15 V nominal")
print()

disc=[(t,v) for t,v in rows if T0<=t<=T1]
pts=[((t-T0).total_seconds()/3600.0*I, v) for t,v in disc]   # (mAh used, V)
print(f"{len(pts)} samples in window; gaps:")
for i in range(1,len(disc)):
    g=(disc[i][0]-disc[i-1][0]).total_seconds()/60
    if g>5: print(f"   {disc[i-1][0].time()} -> {disc[i][0].time()}  {g:.0f} min "
                  f"({pts[i-1][0]:.0f} -> {pts[i][0]:.0f} mAh, {disc[i-1][1]:.3f} -> {disc[i][1]:.3f} V)")

def v_at(q):
    if q<=pts[0][0]: return pts[0][1]
    if q>=pts[-1][0]: return pts[-1][1]
    for i in range(1,len(pts)):
        if pts[i][0]>=q:
            q0,v0=pts[i-1]; q1,v1=pts[i]
            return v0+(v1-v0)*(q-q0)/(q1-q0)

print()
print("=== 16-POINT LUT (even charge steps of 160 mAh) ===")
print(f"{'idx':>3} {'SOC %':>6} {'used mAh':>9} {'pack V':>8} {'V/cell':>7} {'mV/%SOC':>8}")
lut=[]
prev=None
for i in range(16):
    q=CAP*i/15.0
    v=v_at(q)
    soc=100.0*(1-i/15.0)
    slope='' if prev is None else f"{abs(prev-v)*1000/(100/15):7.1f}"
    print(f"{i:3d} {soc:6.1f} {q:9.0f} {v:8.3f} {v/4:7.3f} {slope:>8}")
    lut.append((round(soc,1), round(q), round(v,3)))
    prev=v
json.dump({'lut':lut,'I':I,'dur':dur}, open(os.path.join(SP,'lut.json'),'w'))
