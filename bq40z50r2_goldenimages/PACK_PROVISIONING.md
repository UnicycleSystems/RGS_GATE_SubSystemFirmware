# BQ40Z50-R2 pack provisioning — record of the configuration session

Session of **2026-10-02** to **2026-10-05**, working against a reference pack —
first over EV2400 + bqStudio with RGS_BringUp in passive mode (menu `E`) holding
the rails and the bus pull-ups, then from the jig directly once it could do the
work itself.

Status: **configuration done, calibration done and verified, learning cycle NOT
started.**

---

## PRODUCTION SEQUENCE — provisioning a pack

This is the short version for someone doing it, not learning it. Everything
below this section is the reasoning and the history.

Requires a jig running **RGS_BringUp 3.5 of 2026-10-05 or later**. Earlier 3.5
builds exist with less in them — the full configuration table, the gain handling
and the single-step menu 1 all arrived during that day, so a jig flashed earlier
will not do all of this. Version numbers do not distinguish them; if in doubt,
reflash.

1. **Menu `1` — Configure battery pack.** One step, and it does everything:
   unseals, probes, enables the FETs and makes that persistent, then writes the
   whole configuration — cell count, temperature source, design capacity and
   voltage, Term Voltage, Quit Current, and every protection threshold derived
   from the cell datasheet. Seeds Qmax only if it still reads the 4400 factory
   default, so a characterised pack is never clobbered. Repairs a gain that is
   impossible, and writes the current-sense gain unconditionally.

   Check the golden-image report it prints: every line should end `ok`.

   *(Setting the gain was a separate menu 9 until 2026-10-05. It was folded in
   because TI's factory default is about 5× wrong for this board, so every pack
   needs it — there is no per-unit calibration for provisioning to destroy. If
   per-unit calibration is ever introduced, it has to come back out.)*

2. **Menu `0` — verify.** Expect:

   ```
   Safety    : 0x00000000  (clear)
   Gauging   : ... [QEN, ...]            <- QEN present, or it will never learn
   CC Gain   : 0x3F5EB852  ok (near nominal)
   Cap Gain  : 0x3F5EB852  ok (near nominal)
   ```

3. **Plug the charger in and confirm it charges** — roughly 0.9 A, no `OCC`
   trip, `Chg req` non-zero. This is the single best end-to-end check: it only
   passes when the gain, the protections and the capacity configuration are all
   right together. On the reference pack it read 837 mA against a meter's
   850 mA.

Menu **8** says `[NOT YET AVAILABLE]`: it is reserved for loading the
characterised image a learning cycle will produce, and does nothing yet.

A pack provisioned this way is **functional but not gauge-characterised**: state
of charge will be in the right ballpark but can be ~10% out, worst at the
extremes and under load, until a learning cycle has been run. `GaugingStatus`
will show `CF`, the gauge itself asking for a conditioning cycle. That is
expected on a tester pack, not a fault.

**If a pack misbehaves**, menu `0` first. It decodes the registers that say why:
`Safety` names the protection, `Charging` says whether charge is inhibited or
suspended, `Gauging` says whether Impedance Track is even enabled, and the gain
lines say whether current readings can be believed at all.

---

## Hardware

| | |
|---|---|
| Gauge | BQ40Z50-R2, device 4500, firmware **2.08**, build 50 |
| Cell | **BAK N18650COP**, 4S1P |
| Controlled datasheet | `P/PR03/PB-D-N18650COP-ZZ` rev **B/00**, 2023-08-02 |
| Gauge sense shunt | **1 mΩ** (SRP/SRN) |
| Charger sense resistor | **220 mΩ** — sets ~0.9 A from the charge IC's 200 mV reference. NOT the gauge's shunt; the two were confused early in this session |
| Thermistors | **none fitted** — internal gauge sensor only |
| Ring LED | disconnected on this board |

### Cell limits used, from the controlled datasheet

| Symbol | Meaning | Value |
|---|---|---|
| Ucl | limited charging voltage | 4.20 V |
| Uup | upper limited charging voltage (absolute) | 4.25 V |
| Ude | end of discharge voltage (operating) | **2.50 V** |
| Udo | discharge cut-off (absolute floor) | 2.00 V |
| — | rated / typical capacity | **2400** / 2500 mAh |
| — | nominal voltage, rated energy | 3.6 V, 8.64 Wh per cell |
| Icr / Icm | standard / max charge current | 1200 mA / 6000 mA |
| Idr / Idm | standard / max discharge current | 480 mA / 30000 mA |
| Tcl..Tcm | charge temperature range | **0 to 45 °C** |
| Tdl..Tdm | discharge temperature range | **−20 to 60 °C** |

**Two datasheets exist and they disagree on temperature.** The marketing sheet
(`BAK-N18650COP_en.pdf`) states charge 0-55 °C and discharge −20-75 °C. Those are
the controlled document's *maximum surface temperature* limits, not its *using
temperature range*. The controlled document governs; use 0-45 and −20-60.

---

## Values changed, and why

All in bqStudio **Data Memory**. "Was" is TI's default or the previous setting as
captured in `without_thermistors/withou.gg.csv` (the pre-session export).

### Capacity and energy

| Subclass | Parameter | Was | Now | Reason |
|---|---|---|---|---|
| Gas Gauging → Design | Design Capacity mAh | 2500 | **2400** | cell's RATED capacity, not typical — rated is the guaranteed minimum, so a weak-but-in-spec pack can still reach 100% |
| Gas Gauging → Design | Design Capacity cWh | 360 | **3456** | 2400 × 14400 / 10000. The old value was derived with a divisor of 100000 and was 10× low. Cross-checks against the datasheet's 8.64 Wh per cell × 4 = 34.56 Wh |
| Gas Gauging → Design | Design Voltage | 14400 | unchanged | 3.6 V nominal × 4 |

The parameter is named **`Design Capacity cWh`**, under Gas Gauging → Design. It is
NOT called "Design Energy"; that name wasted time in this session.

### Voltage limits

| Subclass | Parameter | Was | Now | Reason |
|---|---|---|---|---|
| Gas Gauging → IT Cfg | **Term Voltage** | 9000 mV | **10000 mV** | 2.50 V × 4 — puts the gauge's 0% at the cell's operating cut-off. The default would have discharged cells to 2.25 V, below the rated minimum |
| Protections → CUV | Threshold | 2500 mV | **2300 mV** | must sit below Term Voltage or it trips during the learning discharge; still 300 mV above the 2.00 V absolute floor |
| Protections → COV | Threshold, **all four bands** | 4300 mV | **4250 mV** | 4300 is above the datasheet's absolute ceiling of 4.25 V, so the default offered no protection at all |

### Temperature limits

| Subclass | Parameter | Was | Now | Reason |
|---|---|---|---|---|
| Protections → UTD | Threshold | 0.0 °C | **−20.0 °C** | the cell discharges to −20 °C. At 0 °C the pack refuses to discharge in cold weather — a gate that will not switch on in winter |
| Protections → UTD | Recovery | 5.0 °C | **−15.0 °C** | |
| Protections → OTC | Threshold | 55.0 °C | **45.0 °C** | 55 is the absolute surface limit; the charge using-limit is 45 |
| Protections → OTC | Recovery | 50.0 °C | **40.0 °C** | datasheet requires cooling to ≤45 before charge resumes |

Left alone and correct: OTD 60/55, UTC 0/5, OTF 80/65.

**Caveat:** with no thermistors, every temperature threshold is measured by the
gauge's internal sensor — the die, not the cells. During charge the cells run
warmer than the PCB, so these are a proxy with an unknown offset.

### Current limits

Sized to the product, not the cell. Measured: charger ~0.9 A nominal 1 A; system
draw ~0.6 A with the Jetson running.

| Subclass | Parameter | Was | Now |
|---|---|---|---|
| Protections → OCC1 | Threshold | 6000 mA | **1500 mA** |
| Protections → OCC2 | Threshold | 8000 mA | **2000 mA** |
| Protections → OCD1 | Threshold | −6000 mA | **−1500 mA** |
| Protections → OCD2 | Threshold | −8000 mA | **−2500 mA** |

Delays left at defaults (6 s / 3 s), which is what makes these thresholds safe
despite being tight — a Jetson inrush lasting milliseconds cannot trip them.

AOLD, ASCC, ASCD left at defaults (`f4`, `77`, `77`/`e7`). They are coded values
that depend on the sense resistor and should be derived from the schematic, not
guessed.

### Gauging thresholds

| Subclass | Parameter | Was | Now | Reason |
|---|---|---|---|---|
| Gas Gauging → Current Thresholds | **Quit Current** | 10 mA | **40 mA** | see below |

**Measured quiescent draw: 26.5 mA** — PIC running in passive mode, charger
disconnected, nothing lit.

That is 2.65× the default Quit Current, so the gauge would **never** detect
relaxation and neither Qmax update would happen. Both 5-hour relaxations would
have produced nothing.

**Deliberately NOT fixed with Board Offset.** Board Offset makes the gauge blind
to that current, but on this product it is a real load that flows whenever the
unit is on (the PIC holds its own rails through the soft latch). Nulling it would
make the coulomb counter under-count consumption for the whole time the unit is
in use, and field SoC would drift optimistic. `Board Offset` stays at **0**.

Raising Quit Current is also the correct product setting: with a non-removable
pack and a permanently attached board, a 10 mA threshold means the gauge would
rarely enter relaxation in the field either, and so would never take the OCV
corrections that keep Impedance Track honest between learning cycles. 40 mA on a
2400 mAh pack is 0.017C, far too small to cause meaningful polarisation error.

`Dsg Current Threshold` 100 mA and `Chg Current Threshold` 50 mA both sit above
26.5 mA already, so the board's draw is not mistaken for a charge or discharge.

---

## Calibration

`CC Auto Offset` is enabled (`CC Auto Config 07`), so the gauge nulls its own ADC
offset internally. The manual `CC Offset` / `Board Offset` routines are
deliberately NOT used: a true zero-current calibration is impossible here because
the PIC cannot be powered down — bqStudio needs it alive for the bus pull-ups —
so those routines would absorb the 26.5 mA as "offset".

### SETTLED 2026-10-05 — the gain MULTIPLIES, it does not divide

**Read this before touching a gain.** Despite being displayed in mΩ, raising
`CC Gain` RAISES the reported current. Proven by writing two values against an
unchanged 97 mA load:

```
CC Gain  3.5842  ->  gauge reported   338 mA
CC Gain 11.38    ->  gauge reported  1266 mA
```

Everything derived before that was understood was corrected in the **wrong
direction** — including a "nominal" of 4.369, a value of 11.38, and a repair
band of 3.0-6.0 mΩ. All are wrong. Do not re-derive them from the earlier
sections of this document.

| Parameter | Correct value |
|---|---|
| Calibration → Current → **CC Gain** | **0.87 mΩ** |
| Calibration → Current → **Capacity Gain** | **0.87 mΩ** |

**Verified on hardware**, meter in series against the gauge's own reading:

| Meter | Gauge |
|---|---|
| 99 mA | 96 mA |
| 65 mA | 64 mA |

3% and 1.5%, linear across several lamp combinations — inside a handheld meter's
own uncertainty at those currents, and far inside what gauging needs.

0.87 agrees with the **1 mΩ** the schematic shows, which is the first time the
schematic and the measurements have agreed. It also explains the symptom that
started all of this: a resting pack reporting `Current: 4 mA` while 17-26 mA
flowed, because TI's factory default of 4.369 reads roughly **4× LOW** on this
board — the opposite of what the earlier text here claimed.

**Set it from BringUp menu 9**, which writes both gains to the compiled-in
nominal and reads them back. It needs FULL ACCESS, so it unseals first. The gain
is the one value menu 1 will not fix on its own unless what is stored is
impossible, because it is per-unit calibration.

**STILL UNRESOLVED:** the reference pack read 423 mA at 99 mA with its gain at
1.0, which a multiplying gain cannot explain — at 1.0 it should have read LOW.
Either that board differs or that measurement is untrustworthy. Repeat it. If
boards genuinely differ, a compiled-in nominal is the wrong idea and every pack
needs calibrating against its own board.

**RESOLVED by the `crashed_recover.gg.csv` export.** Applying a load caused a
disconnect within a few seconds — an OCD1 trip — because the gain was **not** 1.0:

```
"Calibration","Current","CC Gain","0.175","mOhm"
```

Dividing by 0.175 instead of 1 makes the gauge read **5.7× high**, so a genuine
260 mA load appears as 1500 mA and trips OCD1 after its 6 s delay. The 0.175 came
from a calibration-routine run solving against an applied-current figure that did
not match reality. **Set both gains to 1.0 by hand; do not re-run the routine** —
the known shunt value is the better source.

Nothing latches: `OCD Latch Limit 0`, recovery 200 mA after 5 s.

---

## State observed

Before the session, from `withou.gg.csv`:

```
Qmax Cell 1..4, Qmax Pack   4400 mAh      <- TI default, against a real 2400
No Of Qmax Updates          0
Cycle Count                 0
Update Status               04
Mfg Status init             0018          <- FET_EN | GAUGE_EN, correct
DA Configuration            0007          <- 4S, NR, SLEEP off, correct
Temperature Enable          01            <- internal sensor only, correct
Manufacturer Info A Length  32            <- settles the stamp-size question
```

Nothing has been learned. After the configuration fixes, `OperationStatus` moved
from `0x4983` to `0x0187`: the CHG FET is now on and the XCHG charge-inhibit has
cleared, so the pack is willing to charge again. `PF Status` is clean across A+B
and C+D — no permanent failure at any point.

---

## OPEN QUESTION — OCC / OCD recovery thresholds

Raised 2026-10-05, deferred. TI's defaults are:

```
"Protections","OCC","Recovery Threshold","-200","mA"   (needs a DISCHARGE)
"Protections","OCD","Recovery Threshold", "200","mA"   (needs a CHARGE)
```

**A pack that trips OCC cannot recover unless something draws 200 mA from it.**
An idle unit draws 26 mA, and all four lamps together only reach ~125 mA, so a
pack sitting on a bench or in a cupboard stays unable to charge indefinitely. In
normal use the Jetson pulls ~600 mA whenever the unit is switched on, so it
would clear on the next use — but that relies on the user switching on a unit
that appears not to charge.

**Worse: OCC and OCD trip together deadlock.** Their recovery conditions are
mutually exclusive — one needs discharge, the other charge — and with both FETs
open the back-to-back body diodes block current in both directions, so neither
can ever be satisfied. Observed on 2026-10-05: the pack isolated completely and
could only be freed by a gauge reset. This is reachable in the field any time
both protections fire, e.g. from a corrupted gain.

Options if revisited: lower the OCC recovery threshold to something an idle unit
can reach; or accept it and make sure the field application can explain to the
user why a pack will not charge.

## Still to do, in order

**Picked up here on resuming.** State as of the `crashed_recover.gg.csv` export,
2026-10-02 17:21. Already done: Qmax seeded to 2400 on all four cells and the
pack; `Internal Temp Offset` calibrated to −1.8 °C; every protection and gauging
value in the tables above verified by diff against the pre-session export.

1. **Three values to correct** — all confirmed wrong in that export:

   | Parameter | Is | Set to |
   |---|---|---|
   | Calibration → Current → CC Gain **and** Capacity Gain | 0.175 | **1.0** |
   | Gas Gauging → Design → Design Capacity cWh | 3600 | **3456** |
   | Protections → COV → **Threshold Rec Temp** | 4300 | **4250** |

   The cWh is stale from before the move to 2400 mAh. COV has **FIVE** bands, not
   four — Low Temp, Standard Temp Low, Standard Temp High, High Temp **and Rec
   Temp**. The first four were set; Rec Temp was missed and still permits 4.3 V.

2. **`Update Status` — LEAVE IT AT `04`. Do NOT write `00`.**

   Settled against SLUUBK0B on 2026-10-05. The bit map is:

   ```
   Bit 3    QMax update in the field
   Bit 2    Enable - Impedance Track gauging and lifetime updating
   Bits 1:0 0,0 = IT gauging and lifetime updating DISABLED
            0,1 = QMax updated
            1,0 = QMax and Ra table have been updated
   ```

   So `04` means **Impedance Track is already enabled** with nothing learned yet
   — exactly the state a learning cycle should start from. Writing `00` would
   clear bit 2 and **disable Impedance Track**, and the cycle would learn
   nothing while appearing to run normally.

   The TRM confirms the working values elsewhere: *"Status is set to 0x6 by the
   gauge. To automatically update again, set Update Status to 0x4."* So the
   progression to watch is **0x04 → 0x05 (Qmax learned) → 0x06 (Qmax and Ra
   learned)**.

   An earlier draft of this document said to zero it. That was wrong.
3. **Verify voltage** against a meter at the cell terminals if not already done;
   within ~10 mV, leave the factory trims alone.
4. **Re-export** as `without_thermistors_configured.gg.csv`. Keep `withou.gg.csv`
   (pre-session, wrong values) and `crashed_recover.gg.csv` for the diffs.
5. **Run the learning cycle** — see below.
6. **Export again** afterwards. That export is the golden image source.

### Learning cycle

Roughly 24 hours, uninterrupted. Passive mode is built to survive it: no watchdog
reset, no inactivity timeout, no power-button path that drops the rail.

1. Charge fully to termination taper.
2. **Relax ≥5 hours.** Current must fall below Quit Current for the gauge to take
   its OCV point — which is what the 40 mA setting is for.
3. **Discharge at 240-480 mA** (C/10 to C/5) **continuously** to Term Voltage. The
   low rate is what makes Ra learning valid; an interruption invalidates the pass.
   480 mA is also the datasheet's standard discharge current, so the two
   procedures align.
4. **Relax ≥5 hours.**
5. Watch it progress. **`Update Status` 0x04 → 0x05 → 0x06**, and Qmax/Ra
   populating. `0x06` is the finished state: Qmax and the Ra tables both learned.

**`GaugingStatus` (MAC 0x0056) is the better progress indicator**, and BringUp
menu 0 now decodes it on a `Gauging` line. Watch for, in order:

| Flag | Meaning |
|---|---|
| `QEN` | Impedance Track enabled — if this is clear, nothing else matters |
| `REST` | an OCV reading was taken, so a relaxation actually counted |
| `VOK` | a DOD was saved, so a Qmax update is possible |
| `VDQ` | the discharge qualified for learning |
| `EDV` | termination voltage reached at the bottom of the discharge |
| `QMAX` / `RX` | toggle when a Qmax / resistance update lands |

If `VOK` never sets, the relaxation was not good enough — which is what the
40 mA `Quit Current` and the 8 mA deep-idle mode exist to prevent.

Note bqStudio's Bit Registers pane showed `Gauging Status` as only **8 bits**
(`0x90`), which hides QEN at bit 12 entirely. Menu 0 reads the full 24.

Do **not** reset the gauge or write data flash after learning — either throws away
what the cycle earned.

**Run the cycle in BringUp menu `D` — "EV2400 deep idle" — not menu `E`.**

`E` is the CALIBRATION mode: 5 V rail up so the lasers can be switched, load
toggles on keys 2-5, button live, LEDs running. Measured draw **26.5 mA**.

`D` is for the cycle: bus released, every emitter and LED off, Jetson 5 V rail
down, PIC asleep. Measured draw **8 mA**. No keys, no button, no serial once
asleep — power-cycle (pull a battery, EV2400 unwired FIRST) to leave it.

Board consumption over a ~20 hour run is therefore about **160 mAh, 6.7%** of a
2400 mAh pack, against 530 mAh / 22% in passive mode. Each 5-hour relaxation
drifts ~1.7% rather than ~5.5%, so the OCV points are much closer to a true rest.

The pack still will not sit at exactly 100%, and that is fine: Qmax is computed
from charge passed between two OCV points, and because Board Offset is zero every
one of those milliamp-hours is counted.

8 mA is also well inside the 40 mA `Quit Current`, so relaxation is detected
without argument. Note 40 mA remains correct for the FIELD, where the unit draws
26.5 mA while running — the deep-idle figure applies only to the bench cycle.

---

## Firmware changed alongside this

`CommonFiles/header/bq40z50.h`, so the compiled-in minimum configuration matches
what was set here:

```c
#define BQ_PACK_DESIGN_CAPACITY_MAH   2400   /* was 2500 */
#define BQ_PACK_DESIGN_CAPACITY_CWH   3456   /* was 360  */
#define BQ_PACK_DESIGN_VOLTAGE_MV     14400  /* unchanged */
```

Packs already provisioned carry the old values. `ApplyGoldenImage()` writes only
entries that read wrong, so running BringUp menu **1** on a pack corrects them and
leaves everything else alone.

The protection and temperature limits above are **not** in the firmware table —
`bq_golden[]` deliberately holds only the minimum-safe baseline. They belong in
the host-side image, per the architecture decision.
