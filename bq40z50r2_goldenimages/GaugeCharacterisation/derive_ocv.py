import json, os
SP=os.path.dirname(os.path.abspath(__file__))
I=0.4183   # A, average discharge current (2400 mAh assumption)
print("=== load-step events in the log -> pack resistance ===")
steps=[("10-14 12:33:42->12:34:05","shutdown, load off",13.308,13.607,23,I),
       ("10-15 16:59:52->17:01:26","shutdown, load off",13.337,13.687,94,I),
       ("10-14 16:01:01->16:02:02","charge resumes",15.895,16.186,61,0.80),
       ("10-15 09:38:42->09:39:43","charge resumes",15.880,16.193,61,0.85)]
for lbl,what,v0,v1,dt,i in steps:
    dv=abs(v1-v0)
    print(f"  {lbl}  {what:<18} dV={dv*1000:5.0f} mV over {dt:3d}s  @~{i*1000:.0f} mA -> R={dv/i:.2f} ohm")
print()
R_HI, R_LO, KNEE = 0.37, 0.71, 30.0
def R(soc): return R_HI if soc>=KNEE else R_HI+(KNEE-soc)/KNEE*(R_LO-R_HI)
lut=json.load(open(os.path.join(SP,'lut.json')))['lut']
print(f"R model: {R_HI} ohm above {KNEE:.0f}% SOC, rising linearly to {R_LO} ohm at 0%")
print(f"Discharge current for correction: {I*1000:.0f} mA")
print()
print(f"{'SOC %':>6} {'loaded V':>9} {'R ohm':>6} {'IR mV':>6} {'OCV V':>8} {'OCV/cell':>9}")
out=[]
for soc,q,v in lut:
    if soc>=100: r=0.0; ocv=v           # entry 0 is a float reading, already ~OCV
    else: r=R(soc); ocv=v+I*r
    print(f"{soc:6.1f} {v:9.3f} {r:6.2f} {I*r*1000:6.0f} {ocv:8.3f} {ocv/4:9.3f}")
    out.append((soc,q,round(ocv,3)))
print()
print("sanity checks:")
print(f"  OCV at 0% SOC            = {out[-1][2]:.3f} V  ({out[-1][2]/4:.3f} V/cell)")
print(f"  measured rested after 15h= 13.942 V  (3.486 V/cell)")
print(f"  gap                      = {(13.942-out[-1][2])*1000:.0f} mV  <- diffusion polarisation, not an R error")
json.dump(out, open(os.path.join(SP,'ocv_lut.json'),'w'))
