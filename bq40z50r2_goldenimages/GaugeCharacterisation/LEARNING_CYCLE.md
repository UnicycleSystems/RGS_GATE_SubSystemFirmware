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
