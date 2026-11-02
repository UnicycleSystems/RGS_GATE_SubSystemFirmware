# Gauge characterisation — Impedance Track learning cycle

Running log of learning cycles run on the BQ40Z50-R2 reference pack. Newest
entry at the bottom; each entry records the state at a phase boundary so the
result can be judged against evidence rather than recollection.

Device: BQ40Z50-R2, firmware 2.08, device 4500. Pack: 4S BAK N18650COP,
design capacity 2400 mAh.

Pre-learning data flash snapshot: `SubSystemFirmware/BeforeLearning_15_10_26__AM.gg.csv`

---

## Cycle 1 — 2026-10-15

Purpose: prove the process end to end and get a usable Qmax. **This run is
knowingly compromised** and is expected to be repeated — see the charger note
below — but a working gauge with a slightly low Qmax is worth more right now
than no gauge at all.

### Known limitation: charge ceiling

The bench charger outputs **16.55 V**, measured. A 4S pack needs 16.8 V to
reach 4.2 V/cell, so the pack tops out around **4.14 V/cell** and the charge
tapers to nothing because the supply runs out of headroom, not because the
pack is full.

> **UPDATE — this is a fault, not a design limit.** The charger IC is an
> **MP26124GR-P**, whose regulation voltage is specified as **16.67–16.93 V**.
> The measured 16.55 V is *below the datasheet minimum*, so something is
> actively reducing it rather than it being tolerance. See "Charger output
> below spec" at the end of this entry.

Consequences accepted for this run:

- `VCT` and `FC` never set — there is no valid charge termination, so the
  cycle has no conventional "full" anchor. Qmax can still be learned, because
  it is derived from two relaxed OCV readings and the charge counted between
  them; the gauge reads its starting depth of discharge from the OCV rather
  than assuming 100%.
- Roughly 10% of rated capacity is left in the cells, so FCC and SOH both come
  out low. That is the charger, not cell degradation.

To be redone once the charger is corrected.

---

### Before discharge

**Phase:** end of rest 1, ≈3–4 h after charger removed, immediately before
discharge. Charger physically disconnected.

#### Conditions

| | |
|---|---|
| Temperature | 18.4 °C |
| Voltage | 16311 mV |
| Current | −7 mA |
| Average Current | −7 mA |
| BAT pin | 16324 mV |
| PACK pin | 16546 mV |

#### Cells

| cell | mV | |
|---|---|---|
| 1 | 4089 | highest |
| 2 | 4066 | lowest |
| 3 | 4082 | |
| 4 | 4076 | |

Spread **23 mV**, converged from 30 mV earlier in the rest, and from 147 mV
before the balancing work. Cell 1 highest / cell 2 lowest — the same ordering
as the pre-charge reading, so a consistent characteristic of the pack rather
than noise. Cell 2 will be the cell that ends the discharge.

#### Gauge

| | |
|---|---|
| Relative State of Charge | 99 % |
| Absolute State of Charge | 90 % |
| Remaining Capacity | 2142 mAh |
| Full Charge Capacity | 2168 mAh |
| State of Health | 93 % |
| Max Error | **100 %** |
| Design Capacity | 2400 mAh / 3456 cWh |

#### Flags

| register | value | set bits |
|---|---|---|
| Gauging Status | `0xD0` | `CF`, `DSG`, `BAL_EN` |
| IT Status | `0x0011` | `QEN`, `REST` |
| Charging Status | `0x0008` | `HV` |
| Manufacturing Status | `0x0018` | `FET_EN`, `GAUGE_EN` |
| Safety Alert A+B | `0x0000` | none |
| Temp Range | `0x04` | `STL` |

`CB` confirmed clear — balancing permitted but not bleeding, correct at a
23 mV spread. `VOK` clear. `QMAX`, `VDQ`, `RX`, `OCVFR` all clear: nothing
learned yet. `RDIS` has **cleared** since the start of the rest (it was set
during charge), so resistance updates are now enabled.

#### Observations

- **`Max Error 100%`** — the gauge has no confidence at all in its state of
  charge. This is the expected signature of an unlearned pack and is the single
  clearest thing the cycle should fix. Watch it after rest 2.
- **FCC 2168 mAh against a 2400 mAh design**, and SOH 93%, both follow from the
  4.14 V/cell charge ceiling rather than from cell wear.
- RSOC 99% vs ASOC 90% is the same gap expressed two ways.
- **Open question:** PACK pin reads 222 mV above BAT pin with both FETs on and
  only 7 mA flowing. Those should agree within a few millivolts. Something is
  still attached at the pack terminals; unexplained, and present in every
  reading taken today.

#### Thresholds confirmed in data flash

| | |
|---|---|
| Dsg Current Threshold | 100 mA |
| Chg Current Threshold | 50 mA |
| Quit Current | 40 mA |
| Dsg Relax Time | 1 s |
| Chg Relax Time | 60 s |

The standing load of 6–7 mA is well inside `Quit Current`, so relaxation
detection is not load-limited and nothing needed changing. `REST` took around
three hours to set despite the 60 s relax time — the relax timer gates a state
transition, it does not mean an OCV reading has been taken, and the cells need
hours to settle regardless.

#### Standing load correction

Deep-idle draw measures **12 mA** with the Jetson comms lead removed. The
previously recorded 8 mA figure was taken with the lead attached and was
flattered by back-feed through it — the lead was powering the PIC rail, so the
pack never saw the load. Worth re-measuring deliberately.

Implications beyond this cycle: 12 mA is ~290 mAh/day, roughly 12% of the pack
daily, so flat in a little over a week from full. And since the load is
permanent and hard-wired, field relaxation detection depends on `Quit Current`
staying comfortably above it — which at 40 mA it is.

### Discharge plan

Continuous discharge into **24 Ω**: ≈0.69 A at 16.5 V falling to ≈0.53 A near
the end, so roughly C/3.5 tapering to C/4.5. Slightly above the C/5 ideal but
acceptable. A fixed resistor is deliberately chosen — the main thing that
invalidates a learning discharge is interruption, and a resistor cannot
interrupt itself.

Resistor dissipates ~11.3 W at the start, ~7 W at the end; keep it away from
the pack so it does not warm the cells. Both rest phases should happen at
similar temperatures for the two OCV readings to be comparable.

Disconnect at `EDV` rather than letting it coast into undervoltage protection.

Record `RemainingCapacity` at cut-off: the difference from **2142 mAh** is the
charge actually delivered, measured by the coulomb counter, and is the
independent check against whatever Qmax the gauge reports after rest 2.

---

### Discharge — as run

Ran for approximately **3.4 hours** into 24 Ω, uninterrupted. Current started
at 680 mA and tapered to 520 mA, tracking pack voltage exactly as predicted
(V/24 at every reading).

Progress, lowest cell and spread:

| elapsed | pack mV | current mA | cell 2 (low) | spread |
|---|---|---|---|---|
| 0 h | 16311 | 680 | 4066 | 23 mV |
| 2.25 h | 14216 | 592 | 3533 | 20 mV |
| ~2.8 h | 13571 | 565 | 3348 | 50 mV |
| ~3.2 h | 12516 | 521 | 3065 | 78 mV |
| stop | 12480 | 520 | 3058 | 75 mV |

The spread narrowed through the plateau and then opened sharply below ~3.4
V/cell, as expected from the curve shape — not a change in cell matching, just
the curve steepening. **Cell 2 was the lowest cell at every single reading**
and diverged fastest at the end, confirming it as the capacity-limiting cell
rather than a reading that happened to come out low once.

Stopped manually at cell 2 = 3058 mV.

### At cut-off

| | |
|---|---|
| Temperature | 19.8 °C |
| Voltage | 12434 mV |
| Current | −501 mA |
| BAT pin | 12480 mV |
| PACK pin | 12633 mV |

| cell | mV |
|---|---|
| 1 | 3128 |
| 2 | **3058** (lowest) |
| 3 | 3133 (highest) |
| 4 | 3115 |

| register | value | set bits |
|---|---|---|
| Gauging Status | `0xC0` | `CF`, `DSG` (`BAL_EN` cleared on the way down) |
| IT Status | `0x0119` | `VDQ`, `QEN`, `VOK`, `REST` |
| Charging Status | `0x0002` | `LV` |
| Manufacturing Status | `0x0018` | `FET_EN`, `GAUGE_EN` |
| Safety Alert A | `0x0000` | none |

`RDIS` clear, `QMAX` and `RX` still clear. Everything required for a Qmax
update is in place going into rest 2. `REST` set immediately on removing the
load — `Dsg Relax Time` is 1 s, against the ~3 hours relaxation after the
charge took.

### Why no flag fired at the bottom — and why the flags are blocked

Discharge was stopped manually at cell 2 = 3058 mV rather than waiting for a
flag. Reading the configuration afterwards shows that was the right call, for
two independent reasons.

#### 1. Terminate thresholds are a long way below where we stopped

| parameter | value | note |
|---|---|---|
| Term Voltage | 10000 mV | **pack** figure — 2.5 V/cell averaged |
| Term Min Cell V | 2800 mV | the real floor; cell 2 reaches this first |
| Term V Hold Time | 1 s | |
| Term Voltage Delta | 300 mV | |

The gauge would not have called terminate until cell 2 reached **2800 mV** —
another 258 mV down the steepest part of the curve, roughly 10–20 minutes and
100–150 mAh further at 500 mA. That is the BAK datasheet's bold 2 V cut-off
showing up in the configuration; `Term Min Cell V` at 2800 is what stops it
being worse.

**Action for production: raise the terminate point.** Ending discharge around
3.0 V/cell costs very little usable capacity and is markedly kinder to the
cells — particularly to the weakest one, now identified as cell 2 on this pack.

#### 2. The flags are gated on RSOC, which is frozen

`FD`/`FC`/`TD`/`TC` each require **both** a voltage condition and an RSOC
condition:

| flag | set voltage | set RSOC | what happened |
|---|---|---|---|
| FD | 3000 mV | 0 % | voltage not quite reached (stopped at 3058); RSOC 99% |
| TD | 3200 mV | 6 % | **voltage condition WAS met** at 3058 mV; RSOC 99% blocked it |
| FC | 4200 mV | 100 % | charger tops out ~4138 mV; RSOC 99% — both halves failed |
| TC | 4200 mV | 100 % | as FC |

So the frozen capacity model is not merely a reporting problem — **it is
cascading into the flag logic and disabling it**. `TD` should have set on the
way down and could not. `FC` and `VCT` could never have set during the charge,
for two separate reasons at once.

The thresholds themselves are sensible (3000/3100 mV for `FD`, 3200/3300 mV for
`TD`); nothing needs changing there.

#### Other IT configuration noted at the same time

| parameter | value |
|---|---|
| Qmax Delta | 5 % |
| Qmax Upper Bound | 130 % (= 3120 mAh against a 2400 mAh design) |
| Resistance Update Voltage | 50 mV |
| Qmax Cell 1 | 2400 mAh — the seeded default, not learned |
| Cycle Count | 0 |

**`Qmax Delta` may change what success looks like.** If it caps the permitted
change per update at 5% — the reading to confirm against the TRM — then a
single cycle can move Qmax by only ~120 mAh from its current 2400. With the
true figure apparently nearer 2000 mAh, that is a 17% gap needing roughly four
cycles to close.

So `QMAX` setting with a result near 2280 mAh would be the clamp working
correctly, not a failure. Repeat the cycle to converge.

### Capacity anomaly — gauge not tracking the discharge

**`RemainingCapacity` read 2142 mAh and RSOC 99% at cut-off — unchanged from
before the discharge.** `RunTimeToEmpty` of 257 min is computed from that same
figure (2142 mAh ÷ 501 mA), so this is not a stale display: the gauge genuinely
believes nothing was removed, while the pack fell from 16.3 V to 12.4 V.

Independent estimate of charge actually delivered, by integrating the measured
current over the run: **approximately 1900–2100 mAh**. That is a sensible
figure for this pack charged to 4.14 V/cell. The pack is behaving correctly;
the gauge's capacity bookkeeping is not.

Consistent with `Max Error 100%` and with the original "100% / 0 mAh" symptom
that prompted this whole exercise. Two consequences:

- The intended independent cross-check (difference in `RemainingCapacity`) is
  unavailable. The ~2000 mAh coulomb estimate above is the only figure to
  compare a learned Qmax against.
- If `QMAX` fails to set after rest 2, a frozen capacity accumulator is the
  first thing to investigate.

### Rest 2 and result — CYCLE FAILED, NOTHING LEARNED

Rested 3 hours at empty, no charger, standing load −8 mA. Readings at the end:

| | before discharge | after rest 2 |
|---|---|---|
| Remaining Capacity | 2142 mAh | **2142 mAh** |
| Relative State of Charge | 99 % | **99 %** |
| Absolute State of Charge | 90 % | **90 %** |
| Full Charge Capacity | 2168 mAh | **2168 mAh** |
| Max Error | 100 % | **100 %** |
| Qmax cells 1–4 | 2400 mAh | **2400 mAh** |

| register | value | set bits |
|---|---|---|
| Gauging Status | `0xD0` | `CF`, `DSG`, `BAL_EN` |
| IT Status | `0x0111` | `VDQ`, `QEN`, `REST` |
| Charging Status | `0x0002` | `LV` |
| Safety Alert A | `0x0000` | none |

`QMAX` and `RX` never set. All four `Qmax Cell n` remain at the seeded 2400 mAh.
`Cell 4 DODEOC` read 864.

**`VOK` cleared during the rest** — it was set at cut-off (`0x0119`) and is gone
now (`0x0111`). `VDQ` is still set, so the discharge itself still qualifies;
the gauge simply no longer considers it holds a usable voltage reference.

#### The headline fault

`RemainingCapacity` did not move by a single mAh across a ~2000 mAh discharge
and a three hour rest. That is not an inaccurate gauge — it is one that is not
integrating current into its capacity registers at all.

Current *measurement* demonstrably works: it read −501 mA into a 24 Ω load that
should draw 520 mA, and tracked the taper correctly for three and a half hours.
So the front end is fine and the accumulation is not.

#### Two candidate causes

**1. No valid full-charge anchor (leading explanation).** Qmax is derived from
the charge counted between two OCV readings, anchored at a known full state.
This charge never produced a valid termination — `FC` and `VCT` never set, for
the two independent reasons recorded above — so the gauge never had a
trustworthy "this is full" reference to measure from.

If that is the cause, **this cycle was never going to succeed**, and fixing the
16.55 V charger is a precondition for learning rather than a refinement to it.

**2. Capacity accumulation genuinely broken.** Candidate 1 does not explain
`RemainingCapacity` sitting frozen through a two-amp-hour discharge. A gauge
without a full-charge anchor should still coulomb-count; it would simply not
know what the count meant. This may be the more fundamental fault.

#### Gas Gauging → State, read with the pack on charge

| | |
|---|---|
| Update Status | **04** — IT enabled, nothing learned. No progression. |
| Qmax Cycle Count | **0** — Qmax has never been updated on this pack |
| Qmax cells 1–4, Qmax Pack | 2400 mAh (seeded default) |
| Cycle Count | 0 |
| Cell 1–4 Chg Voltage at EoC | 4144 / 4121 / 4153 / 4139 mV |
| Current at EoC | **191 mA** |
| Cell 4 DODEOC | 864 |
| Avg I Last Run | **−582 mA** |
| Max Avg I Last Run | −642 mA |
| Delta Voltage | 0 mV |

#### ✅ The one hard result: usable capacity ≈ 1980 mAh

`Avg I Last Run = −582 mA` is the gauge's own record of this discharge. Over
the 3.4 hour run that gives **≈1980 mAh**, which sits almost exactly in the
middle of the 1900–2100 mAh estimated independently by integrating the measured
current by hand. Two methods, one answer.

So the pack's real usable capacity from 4.14 V/cell down to 3.05 V/cell is
about **1980 mAh**. That is the figure a successful Qmax should converge on,
and it is worth having regardless of the cycle failing. Expect a true Qmax
(measured to a proper 4.2 V/cell full charge) to come out somewhat higher —
call it 2100–2200 mAh.

#### The failure is at the BOTTOM, not the top

The end-of-charge records show the gauge did capture a top-end snapshot, so it
is not missing a reference entirely. But note what it recorded: cells at
4.12–4.15 V with **191 mA still flowing**, and `DODEOC` of 864 rather than
zero. The gauge is explicitly recording that the pack was not full when
charging stopped. It knows.

`VOK` was set at cut-off and had cleared by the end of the rest — the gauge
evaluated its second OCV reading and rejected it. With a top reference it
distrusts and a bottom reference it rejected, there was nothing to compute
Qmax from.

It is plausible the bottom reading was rejected *because* it could not be
reconciled against a top reference the gauge already knew was invalid. That
would make the charger the single root cause rather than one of two.

#### Chem ID — checked and CORRECT, hypothesis eliminated

**Chem ID reads `0x7551`, which is the expected value.** The chemistry table is
not the problem.

This *sharpens* the remaining question rather than helping. With a correct
chemistry table, a sense gain verified against a meter, and demonstrably
correct current measurement, a gauge reporting 99% at 3.1 V/cell is more
anomalous, not less: a valid OCV table maps 3.1 V/cell to nearly empty, so if
the gauge were performing an OCV lookup at all it could not report 99%.

The frozen RSOC is therefore not a bad lookup. The gauge is not updating its
capacity state at any point — which matches `Update Status 04`: Impedance
Track enabled, and the algorithm has simply never run an update despite
everything it needs appearing to be present.

#### How to read Chem ID (worth keeping — this took a while)

**Do not use ManufacturerAccess at `0x00`.** Word-write the subcommand there,
word-read it back, and the answer carries no indication of which question it
answers. A read this way returned `0187` — which is the value of
`OperationStatus`, not a Chem ID — and did so repeatedly, including with
bqStudio polling stopped. Without an echo there is no way to tell a stale or
wrong answer from a real one.

**Use ManufacturerBlockAccess at `0x44`, as a BLOCK transfer** (not word — a
word write/read to `0x44` returns empty). In bqStudio's Advanced Comm SMB pane,
the Block Read/Write section:

1. **Write Block**, command `44` (hex), block data `0600`
2. **Read Block**, command `44` (hex)

Response: `06 00 51 75` — the subcommand echoed back as `06 00`, then the value
little-endian, giving **`0x7551`**. The echo is the point: it proves the answer
belongs to the question asked.

Applies to any manual MAC transaction, not just this one.

#### Verifying chemistry from a file instead

Chem ID is a MAC query, not a data flash parameter, so it does **not** appear
in a `.gg.csv` export. What does appear:

```
"System Data","Integrity","Static Chem DF Signature","73b5","hex"
"SBS Configuration","Data","Device Chemistry","LION","-"
```

`LION` is a descriptive string and says nothing about which OCV table is
loaded. **`Static Chem DF Signature = 73b5`** is a checksum over the chemistry
data — matching signatures mean matching chemistry tables.

Useful for production: chemistry can be verified by comparing an exported
signature against a known-good reference, with no live SMBus transaction
needed.

#### Next diagnostics

- Re-examine the frozen `RemainingCapacity` once the charger is fixed. If a
  valid full-charge termination re-anchors the gauge and capacity starts
  tracking, candidate 2 dissolves into candidate 1. If capacity stays frozen
  through a properly terminated charge, it is a separate fault.

---

## Charger output below spec — MP26124GR-P

**The charger is an MP26124GR-P. Its regulation voltage is specified as
16.67–16.93 V. Measured output is 16.55 V — below the datasheet minimum.**

So the charge ceiling that broke cycle 1 is not an inherent limit of the
hardware. Something is reducing it, and it should be possible to reach 16.8 V
once found.

### Leading suspect: JEITA temperature zones / NTC

Most 4S charger ICs reduce regulation voltage, charge current, or both when
their NTC input places the pack in a cool or warm band. The gauge independently
reports `Temp Range = STL` (standard temp **low**) at 18.6 °C. If the charger's
own NTC divider reads colder than reality, it may be sitting in a
reduced-voltage zone permanently.

The shortfall is 250 mV at the pack, about 62 mV/cell — worth checking against
whatever reduction the MP26124 datasheet specifies, since a mismatch would
point away from JEITA and toward the feedback network.

### Checks, in order

1. **What temperature the charger thinks it sees** — measure the NTC voltage at
   the IC pin and work back to a temperature. A wrong divider resistor would
   skew this permanently and silently.
2. **Whether the IC reduces voltage or only current in cool zones** — if it
   only derates current, JEITA is not the explanation and the feedback network
   is.
3. **Measure at the pack terminals as well as the charger output**, to rule out
   drop across cabling, connector and the pack FETs. Note that the PACK pin
   reading cannot be used for this — see below, it over-reads by ~226 mV.

---

## PACK pin over-reads by ~226 mV — `Pack Gain` calibration

The persistent gap between `PACK pin voltage` and `BAT pin voltage`, present in
every reading taken across both cycles, is **a measurement error, not a real
voltage difference**.

| phase | PACK | BAT | PACK − BAT | current |
|---|---|---|---|---|
| at rest | 16546 | 16324 | **+222 mV** | 7 mA |
| discharging | 12633 | 12480 | **+153 mV** | 500 mA **out** |
| charging | 16676 | 16450 | **+226 mV** | 30 mA **in** |

### Why it cannot be the sense resistor or the FETs

**The sign is wrong.** During discharge, current flows from the cells out to
the pack terminal, so any resistance between those nodes would make PACK read
*below* BAT. It reads 153 mV *above*. No resistance in that path can produce
that.

**The magnitude is wrong.** A sense resistor must be a few milliohms or it
wastes power as heat. Sense resistor plus FET resistance gives single-digit
millivolts at half an amp, not 153.

**It does not scale with current.** 222 mV at 7 mA, 153 mV at 500 mA, 226 mV at
30 mA — essentially constant across a 70:1 range. A resistive drop would scale
almost linearly.

### Which reading is wrong

The four cell voltages sum to 16441 mV against a BAT reading of 16450 — those
agree, so **BAT is correct and PACK is the outlier**, over-reading by about
226 mV, roughly **1.4%**.

`Cell Gain` (12101) and `Pack Gain` (49669) are separate calibration constants,
so an error in one and not the other produces exactly this signature.

### Consequences

- **The charger may be healthier than assumed.** A PACK reading of 16676 could
  be an over-read of a true ~16.45 V. Do not use the PACK pin reading when
  investigating the MP26124 output — use a meter.
- **If the charge algorithm uses PACK voltage** anywhere in its termination
  logic, a 226 mV over-read works against reaching termination.

### Action

Recalibrate `Pack Gain` against a meter on the pack terminals. **Not during a
cycle** — it is another variable in flight, and calibration should be done
deliberately rather than inferred from these readings.

### ⚠ Revert reminder

`Standard Temp Low Charging → Voltage` and `Standard Temp High Charging →
Voltage` were lowered from **4200 → 4100 mV** to get a valid termination out of
the 16.55 V charger (see cycle 2).

**Once the charger reaches 16.8 V, set both back to 4200.** Left at 4100, the
gauge would terminate at 4.1 V/cell while the charger continued to 4.2 — a pack
reporting full some way below actual full. Same class of error as cycle 1, just
quieter and harder to notice.

#### Conclusion

Cycle 1 produced no learning. The process itself ran correctly — balance,
relaxation, a clean uninterrupted discharge, `VDQ` held throughout — so the
method is sound and repeatable. What it demonstrated is that the pack cannot
learn while the charger cannot reach a valid termination, and that the capacity
accumulator needs investigating before another cycle is attempted.

Do not repeat the cycle until at least the charger is resolved.

---

## Cycle 2 attempt — 2026-10-16 — still no `VCT`

Aim was to get a valid charge termination by lowering the charging voltage to
something the 16.55 V charger can actually reach. Did not succeed, but
established two concrete mechanisms that were invisible before.

### ✅ Root cause of cycle 1 found: the gauge was never in a charging state

**`DSG` in `Gauging Status` stayed set through the entire four-hour charge.**
The gauge believed the pack was still *discharging*, latched from the previous
run.

Clearing `DSG` requires charge current above **`Chg Current Threshold` = 50 mA**.
The pack had risen to meet the charger, so the charger could only supply ~42 mA,
of which the PIC's parasitic load eats 12 mA — leaving **30 mA net, permanently
below the threshold**.

The upper `Charging Status` row confirmed it: `NCT`, `CCC`, `CVR`, `CCR` all
clear for the whole charge. Only `HV` was set, which is a voltage-region
observation, not a charging state.

**You cannot terminate a charge the gauge does not believe has started.** No
amount of threshold tuning addresses this.

Proven by fixing it: after discharging deeply to restore headroom, the charger
went to 808 mA and **`DSG` cleared within seconds** (`Gauging Status` `0xC0` →
`0x90`).

### ⚠ Temperature band switched mid-charge, STL → RT

`Temp Range` moved from `0x04` (`STL`) to `0x08` (`RT`) as the pack warmed from
18.6 °C to 21.8 °C.

**Only `Standard Temp Low` and `Standard Temp High` had been lowered to
4050 mV. `Rec Temp` was left at 4100 mV** — it was already "low enough" when
looked at in isolation. So the active charging voltage silently became
**16400 mV (4100 mV/cell)**, confirmed by the `Charging Voltage` register
reading 16400.

Cell 2 reached 4111 mV against that 4100 mV target: **11 mV of margin**, where
4050 would have given 60 mV.

**Lesson: change every temperature band together.** A charging voltage that
works at 18 °C and fails at 22 °C is an intermittent fault that would be
extremely expensive to diagnose in the field, and nothing about the symptom
points at temperature.

### `VCT` still did not set — unexplained

Current tapered 800 mA → 32 mA, so it necessarily crossed the 250 mA
`Charge Term Taper Current` threshold. At that point `DSG` was still clear and
the cells were above the voltage condition (target − `Charge Term Voltage`
75 mV). That window should have worked.

Either the band change disrupted the evaluation mid-taper, or something gates
`VCT` that has not been found. **This remains open.**

Once current fell below 50 mA, `DSG` re-latched and the gauge dropped out of
charging state again — the same trap as cycle 1.

### Readings at the end of the charge

| | |
|---|---|
| Cells | 4151 / 4111 / 4141 / 4127 mV (spread 40 mV) |
| BAT pin | 16540 mV |
| Current | 32 mA |
| Temperature | 21.8 °C (`RT` band) |
| Charging Voltage (register) | 16400 mV |
| Gauging Status | `0xD0` — `CF`, `DSG`, `BAL_EN` |
| IT Status | `0x0118` — `VDQ`, `QEN`, `VOK` |
| Remaining Capacity | 2142 mAh (**still frozen**) |
| Max Error | 100 % |
| Qmax cells 1–4 | 2400 mAh |

New registers seen: `True Full Chg Q` = 1532 mAh, `Initial Q` = 80 mAh — the
gauge tracks *something*. But **`QMax Passed Q` = 0 mAh**, so the accumulator
that matters is still frozen.

Per-cell `QMax DOD0` values differ wildly: cell 1 = 1308, cell 2 = 6473,
cell 3 = 4669, cell 4 = 1504. Directionally consistent with cell 2 being
weakest, but a factor of five apart is striking and worth understanding.

### Also noted

**The deep discharge overshot.** Intended 20–30%, actually went to cell 2 =
2799 mV — below the 2800 mV `Term Min Cell V` floor. No safety flags tripped
and no damage apparent, but watch the clock on resistor discharges: an hour at
0.68 A takes this pack most of the way down, not a third.

**Pre-charge works as expected.** From 2.8 V/cell the charger trickled at
~47 mA, then switched to full 808 mA within minutes once cells passed ~3.0 V.
During trickle the PACK/BAT gap was 4285 mV — that is current limiting, not the
~226 mV calibration offset.

### Plan for next attempt

1. **`Rec Temp Charging Voltage` → 4050 mV**, so all bands agree and cell 2 has
   margin regardless of temperature.
2. **Raise `Charge Term Taper Current` from 250 mA to ~400 mA.** Declare
   termination while current is still high and the gauge is unambiguously in a
   charging state, rather than relying on a window that closes as current falls
   toward the thresholds that eject it. C/5 is a cruder definition of full, but
   a termination that can be reached beats a precise one that cannot.
3. Partial discharge (20–30 min on the 24 Ω resistor) to create headroom, then
   recharge and watch `VCT` as current tapers through 400 mA.

### Overnight on charge — 2026-10-17 morning

Left on charge overnight deliberately, to let balancing run at high SOC.

**Balancing worked.** Spread down from 40 mV to **17 mV** (4055 / 4067 / 4072 /
4063), with cell 2 pulled up. The margin problem that blocked earlier attempts
has largely solved itself.

**The capacity registers are no longer frozen.**

| | before | now |
|---|---|---|
| Remaining Capacity | 2142 mAh | **2050 mAh** |
| Full Charge Capacity | 2168 mAh | **2098 mAh** |
| Relative State of Charge | 99 % | 98 % |
| Absolute State of Charge | 90 % | 86 % |
| True Full Chg Q | 1532 mAh | **2087 mAh** |

After being static through an entire discharge and recharge, they are updating.
**This substantially weakens "candidate 2" (broken accumulator) from the cycle 1
post-mortem.** `True Full Chg Q` at 2087 mAh is also converging on the ~1980 mAh
actually measured.

`QMax` remains 2400 on all cells and `QMax Passed Q` remains 0, so there is
still no true Impedance Track learning — the movement above is estimation, not
a Qmax update.

**Still no `VCT`**, with conditions apparently satisfied: cells 4055–4072 mV
against a 4050 mV target, current 50 mA against a 250 mA taper threshold, `DSG`
clear.

Temperature fell to 14.5 °C overnight, so `Temp Range` returned to `STL` and
`Charging Voltage` now reads 16200 mV — the 4050 setting is active. But the band
has now switched **twice** (`STL` → `RT` warming during charge, `RT` → `STL`
cooling overnight). If a band change resets the termination evaluation, the
algorithm never gets an uninterrupted run at it.

### ⚠ The structural hypothesis — why this may never work as configured

**`CVR` (constant-voltage region) has been clear in every single reading across
three days.**

The BQ40Z50 is designed to *command* a smart charger over SMBus using the
`ChargingVoltage` and `ChargingCurrent` registers. This system uses a dumb
fixed-voltage supply that ignores them entirely. Worse, lowering the target to
16200 mV guarantees the measured pack voltage sits *above* what the gauge is
requesting.

If the gauge never recognises a constant-voltage regulation phase — and `CVR`
says it never has — then `VCT` may be unreachable by design in this topology.
No threshold change fixes that. The answers would be a charger the gauge can
control, or accepting that this pack cannot self-declare termination.

**This hypothesis is untested.** It is the best remaining explanation after
thresholds, chemistry, calibration and charge state were each eliminated.

---

## CLOSING ENTRY — 2026-10-17: parking IT learning, moving to a PIC-side gauge

### Decision

Stop pursuing Impedance Track learning for now. Use the BQ40Z50 as a
**measurement and protection device only**, and compute state of charge on the
PIC.

Rationale: testers need plausible battery reporting now, and the gauge's
learning algorithm is fighting a hardware topology it was not designed for. An
approximate gauge that works beats an accurate one that cannot be made to run.

### What NOT to change

**Leave the BQ40Z50 configuration exactly as it is.** Do not disable gauging —
simply ignore `RSOC`, `FullChargeCapacity` and `RemainingCapacity`.

Everything else the device does remains valuable and independent of the
gauging:

- COV, CUV, OCC, OCD and overtemperature protections
- charge and discharge FET control
- calibrated cell voltages, pack current and temperature — the inputs the
  PIC-side gauge needs

Leaving the configuration untouched also means returning to this later costs
nothing.

### What is reusable — cycle 1 was not wasted

**Measured usable capacity ≈ 1980 mAh** (4.14 V/cell → 3.05 V/cell), confirmed
two ways: by integrating measured current by hand, and by the gauge's own
`Avg I Last Run` of −582 mA over a 3.4 hour run.

**A clean discharge curve.** Cycle 1 produced an uninterrupted discharge at a
known, slowly tapering current with cell voltages logged throughout. **That
curve is the voltage-to-SOC table** for a PIC-side estimator — the single most
useful input to the new approach, produced by the run that "failed".

**Cell 2 is the capacity-limiting cell**, lowest at every reading across both
cycles and first to diverge at the bottom of the curve.

### Design notes for the PIC-side gauge

**The map already has the destination.** `BatteryChargeState` at address 14 is
a one-byte percentage, with `BatteryPackVoltage` at 15–16 beside it. The Jetson
interface does not change — only how that byte is computed.

**Anchoring is the thing that will bite.** Coulomb counting drifts without a
reference. Two natural anchors are available and both are observable:

- a cell reaching the terminate voltage → empty
- current tapering below a threshold with cells near the charge voltage → full

Integrate current between anchors; reset at an anchor. That is essentially what
Impedance Track does, minus the impedance modelling this application does not
need.

**Sleep is the awkward case.** Charge consumed in deep idle cannot be counted
if nothing is polling. But the load is now precisely known: **12 mA**, measured
with the Jetson comms lead removed. Elapsed time × 12 mA closes the gap well
enough.

**Watch flash wear** if persisting SOC across resets — write on significant
change or at power-down, not on every update.

### Open questions for when this is revisited

1. **Is the `CVR` / smart-charger hypothesis correct?** Untested, and it
   determines whether IT learning is achievable at all in this topology.
2. **Why did `VCT` not set when current crossed 250 mA** with `DSG` clear and
   the voltage condition met? Never explained.
3. **Charger output below datasheet minimum** — MP26124GR-P reading 16.55 V
   against a 16.67 V spec floor. NTC/JEITA investigation outstanding.
4. **`Pack Gain` calibration** out by ~1.4%.
5. **`Term Voltage` at 2.5 V/cell averaged** — too low to ship.
6. **Per-cell `QMax DOD0` values differ by a factor of five** (1144 / 2078 /
   1649 / 1628). Directionally consistent with cell 2 being weakest, but the
   magnitude is unexplained.
7. **`TDSETV` and `FDSETV` are both clear**, so the discharge-end flags depend
   entirely on a gauging model that has been demonstrated to be wrong by 99
   percentage points. Enabling the voltage-based set bits would give a floor
   that holds even when gauging is broken — worth doing for production
   regardless of which gauge is used.

### Before moving on

Take a fresh data flash snapshot, so three days of configuration work is
preserved exactly as it stands.

---

## Proposed PIC-side gauge — APPROACH A: coulomb counting with anchors

Design sketch only; no implementation yet. Integer arithmetic throughout — the
PIC24 has no FPU and floats have already been removed elsewhere in this project.

**See the comparison at the end of this document — approach B is recommended
to build first.**

### State and units

Track remaining charge in **milliamp-seconds**, not mAh, to avoid fractional
accumulation:

```
Q_remaining  [int32, mA·s]
1 mAh = 3600 mA·s
Full pack ≈ 1980 mAh = 7,128,000 mA·s
```

Fits int32 (max 2.1 × 10⁹) with ~300× headroom. Convert only when reporting.

### Integration step

On a **fixed timer interrupt** — 1 Hz is ample, the loads change slowly — so
Δt is exactly known rather than inferred from loop timing:

```
Q_remaining += I_mA × Δt_s
```

Current positive on charge, negative on discharge, matching the gauge.

**If the I²C read fails, skip the step entirely.** A dropped sample loses one
second of charge; a stale or zero sample corrupts the state.

### Reporting

```
SOC% = (Q_remaining × 100) / (FCC_mAh × 3600)
```

Numerator stays inside int32. Clamp 0–100, write the byte to
`BatteryChargeState` (address 14). The Jetson interface does not change.

Start with **FCC = 1980 mAh** — the measured figure. That is capacity to the
present charger's 4.14 V/cell ceiling; if the charger is fixed it rises to
perhaps 2100–2200 mAh.

### Anchors — what stops the drift

Coulomb counting drifts without a reference. Both anchors are observable.

**Full:**

```
if  I > 0
and min(cell) ≥ V_full        (≈ 4050 mV; charger reaches ~4130)
and |I| < I_taper             (≈ 100 mA)
sustained for T_hold          (≈ 60 s)
→ Q_remaining = FCC × 3600
```

**Empty:**

```
if  min(cell) + (I_discharge × R_cell) ≤ V_empty    (≈ 3000 mV)
→ Q_remaining = 0
```

**Always use the minimum cell, never the pack average.** Cell 2 is the limiter
and reaches the floor while the others still hold charge — that difference is
real capacity which cannot be used.

### IR compensation

A loaded measurement is not OCV:

```
OCV ≈ V_measured + (I_discharge × R_cell)     discharging
OCV ≈ V_measured − (I_charge × R_cell)        charging
```

Derive `R_cell` empirically — note cell voltage immediately before and after
removing a known load, take ΔV/ΔI — rather than from the gauge's `CompRes`
values, whose scaling is unconfirmed. Cycle 1 data suggests roughly
**50–70 mΩ per cell**, about 35 mV at 500 mA. Small, but not negligible near
the floor where the curve is steep.

### Cold-start initialisation from OCV

With no stored state, estimate from voltage once current has been low long
enough for the reading to mean something. Lookup table of **OCV per cell →
SOC%**, linearly interpolated.

Approximate anchors from the cycle 1 discharge, IR-compensated — **fill in
properly from the logged data**:

| OCV/cell | SOC |
|---|---|
| 4140 mV | 100% |
| 3950 mV | ~80% |
| 3750 mV | ~55% |
| 3570 mV | ~28% |
| 3390 mV | ~16% |
| 3100 mV | ~3% |
| 3000 mV | 0% |

The curve is flat in the middle — a 10 mV error near 3.7 V is several percent
of SOC. **Treat OCV as a coarse starting estimate that coulomb counting then
refines, not as a continuous source of truth.**

### Sleep

The PIC cannot sample while asleep, but the load is known:

```
Q_remaining -= 12 mA × t_sleep_s
```

Needs a time source across sleep — counting watchdog wakeups suffices. **This
is the largest single error term in the design**, so re-measure the 12 mA
figure carefully, with the Jetson comms lead removed.

### Persistence

Store `Q_remaining` and `FCC`. Write on **significant change** (~every 5%) and
at power-down. Never every update — flash endurance is ~10k cycles per page.

⚠ `PERSIST_SaveFromEeprom()` currently mirrors all 256 bytes including live
measurement fields, which change constantly, so its "has anything changed?"
guard never fires and **every call burns an erase cycle**. Either narrow
`PERSIST_MIRROR_FIRST`/`PERSIST_MIRROR_BYTES` to the configuration region as
`persist_store.h` suggests, or use `PERSIST_SetByte()` directly.

### Expected accuracy and known limits

Within a few percent over a cycle, provided the anchors fire. The current
measurement is already verified against a meter at two points, which is the
foundation everything else rests on.

Error sources, largest first:

1. **Sleep-time estimation**
2. **Temperature** — a cold pack delivers noticeably less than `FCC` assumes
3. **Ageing** — `FCC` is fixed unless logic is added to update it when a
   full-to-empty run completes between two anchors. That is the natural place
   for later refinement, and amounts to a crude Qmax learn of our own.

**What this gives up:** no impedance model, so no prediction of sag under load.
"Time to empty" under heavy load will read optimistic. For a percentage
display, acceptable.

---

## APPROACH B: voltage lookup with load compensation

### The key realisation

There is **real-world logged data** from a unit running at full load supporting
the Jetson, with battery voltage recorded periodically against timestamps.

With a roughly constant load, **elapsed time is proportional to charge
delivered**, so that log converts directly into a voltage → SOC table:

```
SOC at time t  =  1 − (t / t_total)
```

The curve already exists. No coulomb counting is needed to build it, and none
is needed to use it. Because it is measured **at the actual operating load**,
the normal case needs no IR compensation at all — terminal voltage under
typical load maps straight to SOC.

### Three reported states

Use `/ACOK` on RA7 for charger presence — a hardware signal, so charging
detection does not depend on inferring a current sign. That is precisely where
the BQ40Z50 kept failing against its 50 mA threshold.

| state | condition | reported |
|---|---|---|
| **charging** | `/ACOK` asserted, not yet terminated | "charging", no percentage |
| **charged** | termination detected | reset to 100% |
| **discharging** | `/ACOK` deasserted | voltage-derived percentage |

Reporting a state rather than a number while charging avoids lying: during
charge the voltage is elevated by IR and by the charge profile, so a
voltage-derived SOC would read falsely high.

### Load deviation correction

The curve is only valid at the load it was measured at. When the lasers switch
or the Jetson's draw changes, terminal voltage moves without SOC changing.
Reference back to the curve's load:

```
V_corrected = V_measured − (I_actual − I_reference) × R_pack
```

At 50–70 mΩ per cell that is ~35 mV per 500 mA of deviation — several percent
of SOC in the flat region. This is the only modelling approach B needs.

### Filtering and monotonic reporting

Instantaneous readings jitter, and without smoothing the display bounces —
worse, it climbs when a load drops off, which reads as a fault.

- 30–60 second average
- **reported value may only decrease while discharging**, resetting on charge

### Use the minimum cell

Not the pack average. Cell 2 is the limiter and reaches the floor while the
others still hold charge.

### Known weak points

**The flat middle.** Between roughly 3.7 and 3.9 V/cell a handful of millivolts
spans several percent of SOC. Resolution is not the problem (1 mV
measurement) — load variation and noise are. Expect good accuracy at both ends
and vagueness in the middle; do not over-promise.

**Surface charge.** A pack just off the charger reads high for a while. If a
charge is interrupted before termination, estimation starts at the worst
possible moment and will over-read. Either hold the last state briefly after
`/ACOK` drops, or apply a decay correction for the first few minutes.

**Interrupted charge** is the genuine gap: not charging, not terminated,
voltage still elevated. Decide deliberately what that reports rather than
letting it fall through to a wrong number.

---

## COMPARISON — A vs B

They fail in opposite ways, which is what makes the choice clear.

### Where each is accurate

**A (coulomb)** is excellent in the flat middle of the curve, exactly where B
is useless. It tracks short-term change precisely and does not care that
3.75 V and 3.78 V are 20% of SOC apart.

**B (voltage)** is good at both ends where the curve is steep, and vague in the
middle. But it **never drifts** — every reading is independent, so error is
bounded by curve accuracy rather than accumulating.

### Where each fails — and why it matters here

**A fails silently and cumulatively**, and it **inherits the exact failure mode
that defeated the BQ40Z50**: correctness depends on an anchor firing, and three
days of this document establish that reliable full-charge termination detection
on this hardware is genuinely hard. If the anchor does not fire, drift is
unbounded and nothing reports it.

**The offset problem is worse than it looks.** Coulomb counting error is
dominated by *offset*, not gain. The gain is verified at two points — but a
2 mA zero-offset error integrates to **48 mAh/day (~2.4% of the pack), ~17%
over a week of standby**. Gain calibration does not help; only offset
calibration does, and it was never checked.

**B fails loudly and transiently.** A wrong reading is wrong for one sample,
then self-corrects. It cannot walk away from reality.

### Practical differences

| | A — coulomb | B — voltage |
|---|---|---|
| state to persist | `Q_remaining`, `FCC` | none |
| behaviour after a reset | needs stored state, else falls back to a voltage guess anyway | immediate, correct |
| sleep accounting | **required — largest error term** | irrelevant |
| flash wear | yes | none |
| depends on an anchor firing | **yes** | no |
| flat middle of curve | good | poor |
| CPU / flash cost | moderate | light |

The reset row matters more than it appears: PuttingGate resets for firmware
updates and bootloader handoff, and **a coulomb counter without valid stored
state must initialise from a voltage lookup anyway** — so B ends up being
built regardless, as a subsystem of A.

### Ageing and temperature

Both degrade, differently.

**A's `FCC` becomes wrong as the pack ages**, so the percentage quietly becomes
a percentage of the wrong number.

**B's curve also shifts — but its endpoints stay anchored by physics.** An aged
pack still reads 0% when genuinely empty, which is the number that matters
operationally. That is a real robustness advantage.

**Temperature hurts B more**: a cold pack sags, so B under-reports. Worth a
correction term eventually, or a second curve at low temperature.

### The synthesis, for later

They are complementary rather than competing. Voltage provides the absolute
reference; coulomb counting interpolates between voltage readings, smoothing
the flat middle and removing jitter:

```
SOC = α · SOC_coulomb + (1 − α) · SOC_voltage
```

with α high in the flat region and low near the ends — equivalently, integrate
current short-term and let it decay toward the voltage estimate with a long
time constant. No unbounded drift, because voltage keeps pulling it back.

But it reintroduces state, sleep accounting and persistence.

### ✅ Recommendation

**Build B first.** Stateless, self-correcting, survives resets, ignores sleep
entirely, and the characterisation data already exists.

Ship it, see whether the vagueness in the middle actually troubles anyone, and
add the coulomb term as a refinement only if it does.

The failure mode of starting with A is spending a week on sleep accounting and
anchor detection to solve a problem the users may not have — and doing it with
an uncalibrated current offset, on hardware that has already proven hostile to
anchor detection.

---

## FIELD CHARACTERISATION — voltage vs SOC from real usage

Derived from a real unit supporting the Jetson at full load, logged
periodically with timestamps.

**Source data:** `field_discharge_log_2026-10-14_16.csv` (554 samples,
2026-10-14 11:49 → 2026-10-16 08:00)
**Derivation:** `derive_lut.py` — rerun it if the capacity assumption changes.

### Method

With a roughly constant load, elapsed time is proportional to charge
delivered, so the timestamped log converts straight into a voltage → SOC
table:

```
SOC at time t  =  1 − (t / t_total)
```

### The discharge window

| | |
|---|---|
| Window | 2026-10-15 11:15:35 → 16:59:52 |
| Start | 16.628 V (float voltage — full) |
| End | 13.337 V, logged `graceful shutdown` |
| Duration | **5 h 44 m** (5.738 h) |

Two `graceful shutdown` events in the log, at 13.308 V (10-14) and 13.337 V
(10-15) — so the system's own low-battery cutoff sits at about **3.33 V/cell**,
well above the cell floor.

### ⚠ Average current — depends on an assumption that is probably wrong

At the assumed 2400 mAh: **418 mA** (≈ C/5.7, ~6.3 W at 15 V).

**But the bench data contradicts 2400 mAh.** Cycle 1 measured ~1980 mAh down
to 3.05 V/cell. This run stops at **3.334 V/cell**, well above that, so it used
*less* — probably nearer 1850 mAh, giving an average current of about
**320 mA**.

Honest range: **320–420 mA**, with the lower end better supported.

**One logged current reading from a running unit would settle this and pin
down the whole model.** Worth capturing next time one is on the bench.

### 16-point LUT — even 160 mAh steps

| idx | SOC % | used mAh | pack V | V/cell |
|---:|---:|---:|---:|---:|
| 0 | 100.0 | 0 | 16.628 | 4.157 |
| 1 | 93.3 | 160 | 16.401 | 4.100 |
| 2 | 86.7 | 320 | 16.174 | 4.044 |
| 3 | 80.0 | 480 | 15.947 | 3.987 |
| 4 | 73.3 | 640 | 15.720 | 3.930 |
| 5 | 66.7 | 800 | 15.493 | 3.873 |
| 6 | 60.0 | 960 | 15.266 | 3.817 |
| 7 | 53.3 | 1120 | 15.043 | 3.761 |
| 8 | 46.7 | 1280 | 14.821 | 3.705 |
| 9 | 40.0 | 1440 | 14.632 | 3.658 |
| 10 | 33.3 | 1600 | 14.443 | 3.611 |
| 11 | 26.7 | 1760 | 14.301 | 3.575 |
| 12 | 20.0 | 1920 | 14.140 | 3.535 |
| 13 | 13.3 | 2080 | 13.915 | 3.479 |
| 14 | 6.7 | 2240 | 13.678 | 3.420 |
| 15 | 0.0 | 2400 | 13.337 | 3.334 |

### ⚠ Entries 1–6 are interpolation, not measurement

**There is a 143-minute hole in the log** between 11:15 (16.628 V) and 13:38
(15.217 V) — **995 mAh, 41% of the discharge, with no samples**. Those LUT
entries are a straight line drawn across it.

The 10-15 09:00 fragment suggests the real curve there is *flatter* than the
straight line, with a steeper drop in the first minutes off float as surface
charge dissipates. So expect the LUT to **over-read SOC just below 16.6 V and
under-read around 16.1 V**.

**One properly logged full discharge fixes this** — log at 1-minute intervals
from float all the way to shutdown, with no gaps, and rerun `derive_lut.py`.

A second caveat on entry 0: the 11:15 sample is at float voltage, so the pack
may still have been on charge at that moment and the discharge may have begun
later. That would make the real average current higher and compress the top of
the curve further.

### As a function, if a LUT is not wanted

The measured region is close to linear:

```
20% ≤ SOC ≤ 58%:   SOC = 20.4 + (V_pack − 14.144) / 0.0280
SOC < 20%:         SOC = (V_pack − 13.337) / 0.0396
```

**Prefer the LUT with linear interpolation.** Same cost in practice, and it
handles the curved ends honestly rather than pretending they are straight.

### 🔑 The number that sizes the load-compensation problem

**27–28 mV of pack voltage per 1% SOC** through the usable middle.

A 500 mA change in load shifts pack voltage by roughly 105 mV across the pack
resistance — **nearly 4% of SOC**. Without load compensation that is the error
floor, and it is far larger than anything the table's resolution contributes.

This is the single strongest argument for implementing the `V_corrected`
term in approach B rather than treating it as optional.

---

## PACK RESISTANCE AND THE IR-CORRECTED (QUASI-OCV) TABLE

### The governing relationship

```
V_terminal = OCV(SOC) − I·R(SOC,T) − V_polarisation
```

Analytical forms for `OCV(SOC)` exist — Shepherd, Nernst, and Plett's combined
model (which is linear in its coefficients, so it fits by ordinary least
squares). **None is worth using here.** On a PIC24 with no FPU you would call
`ln()` to reproduce a curve already measured, and the LUT is both cheaper and
exactly faithful to the data.

What *is* worth doing is removing the load term, so the table works at any
load rather than only at the one it was characterised at.

### R, measured from four load-step events in the log

The log contains four moments where the load changes abruptly. Each gives a
voltage step, and the step divided by the current change is the resistance.

| event | ΔV | current | R |
|---|---|---|---|
| 10-14 12:33:42→12:34:05 shutdown, load off (23 s) | 299 mV | ~418 mA | **0.71 Ω** |
| 10-15 16:59:52→17:01:26 shutdown, load off (94 s) | 350 mV | ~418 mA | 0.84 Ω |
| 10-14 16:01:01→16:02:02 charge resumes (61 s) | 291 mV | ~800 mA | **0.36 Ω** |
| 10-15 09:38:42→09:39:43 charge resumes (61 s) | 313 mV | ~850 mA | **0.37 Ω** |

Two clean clusters: **~0.37 Ω at high SOC, ~0.71 Ω near empty** — the expected
shape, resistance rising as the pack empties. The 0.84 Ω figure is from a 94 s
window, so it includes more diffusion than the 23 s one; prefer 0.71 Ω.

R model used below — two measured anchors, flat above the knee:

```
R = 0.37 Ω                                for SOC ≥ 30%
R = 0.37 + (30 − SOC)/30 × 0.34  Ω        for SOC < 30%
```

### IR-corrected table

`V_OCV = V_loaded + I·R(SOC)`, at the 418 mA characterisation current.

| SOC % | loaded V | R Ω | IR mV | **quasi-OCV V** | **V/cell** |
|---:|---:|---:|---:|---:|---:|
| 100.0 | 16.628 | — | — | **16.628** | 4.157 |
| 93.3 | 16.401 | 0.37 | 155 | **16.556** | 4.139 |
| 86.7 | 16.174 | 0.37 | 155 | **16.329** | 4.082 |
| 80.0 | 15.947 | 0.37 | 155 | **16.102** | 4.025 |
| 73.3 | 15.720 | 0.37 | 155 | **15.875** | 3.969 |
| 66.7 | 15.493 | 0.37 | 155 | **15.648** | 3.912 |
| 60.0 | 15.266 | 0.37 | 155 | **15.421** | 3.855 |
| 53.3 | 15.043 | 0.37 | 155 | **15.198** | 3.799 |
| 46.7 | 14.821 | 0.37 | 155 | **14.976** | 3.744 |
| 40.0 | 14.632 | 0.37 | 155 | **14.787** | 3.697 |
| 33.3 | 14.443 | 0.37 | 155 | **14.598** | 3.649 |
| 26.7 | 14.301 | 0.41 | 170 | **14.471** | 3.618 |
| 20.0 | 14.140 | 0.48 | 202 | **14.342** | 3.586 |
| 13.3 | 13.915 | 0.56 | 234 | **14.149** | 3.537 |
| 6.7 | 13.678 | 0.63 | 265 | **13.943** | 3.486 |
| 0.0 | 13.337 | 0.71 | 297 | **13.634** | 3.408 |

Entry 0 takes no correction — 16.628 V is a float reading at near-zero
current, so it is already approximately OCV.

The mid-range values are physically plausible for LiCoO2: 3.855 V/cell at 60%,
3.697 at 40%. That is a useful independent check that nothing is badly wrong.

Runtime use:

```
SOC = LUT_quasiOCV( V_measured + I_discharge × R(SOC) )
```

R depends on SOC, which is what you are solving for — so use the previous
iteration's SOC, or do one pass with R = 0.37 Ω and a second with the
corrected value. At 1 Hz this converges instantly.

### ⚠ This is IR-corrected, NOT true rested OCV

At the shutdown point, the pack read 13.337 V under load. After **15 hours of
rest** it read **13.942 V**. The IR correction only accounts for 297 mV of
that 605 mV recovery.

**The remaining 308 mV is diffusion polarisation** — the slow term — and it is
not an error in R. The fast ohmic step really is 299 mV, measured over 23
seconds; the rest takes hours to appear.

Two consequences that matter:

**The table over-reads on a rested pack.** Feed the 15-hour rested reading of
13.942 V into the quasi-OCV table and it returns **6.7% SOC**, when the pack
was in fact at the shutdown point — defined here as 0%. So after the unit has
sat idle, expect roughly **+7% optimism** until it has been under load for a
while. Cold-start initialisation should allow for this.

**Sustained load changes drift further than R predicts.** The instantaneous R
handles a load step correctly for the first seconds. If the new load persists,
polarisation builds and the voltage drifts further in the same direction. The
total effective resistance at the bottom is about **1.45 Ω** (605 mV ÷ 418 mA),
roughly double the instantaneous figure.

### What one measurement would fix

A mid-SOC load step with the current logged — pack voltage immediately before
and after a known change, at say 50% SOC — would confirm the 0.37 Ω figure
directly rather than inferring it from charge-resume events where the current
is assumed.

### Smaller effects, deliberately ignored

- **Peukert's law** — exponent ~1.05 for Li-ion, worth about a percent over
  this load range. Ignore.
- **OCV hysteresis** — 10–20 mV higher after charging than after discharging
  at the same SOC. A discharge-derived curve therefore slightly over-reads
  following a charge.
- **Temperature** — acts mainly through R, which roughly doubles from 25 °C to
  0 °C. Since R is now the term being corrected for, that is where a
  temperature coefficient would go.
