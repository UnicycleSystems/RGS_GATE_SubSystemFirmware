# RGS_BringUp.X

Production **bring-up / provisioning firmware** for the RGS board. It is a fork of
`RGS_PuttingGate.X` (the shipping application) and shares its hardware drivers, but
it is not a product build: it powers straight up, provisions the battery pack's
BQ40Z50-R2 gauge, and repeats forever. The product power-button and charger logic
is deliberately bypassed.

Firmware revision **9.x** identifies a jig build (the product app uses 0.x), published
through the Jetson-facing EEPROM interface so a unit running this image is obvious.

## Build configurations

Two MPLAB X configurations produce two different images from the same sources.

| | `standalone` | `default` |
|---|---|---|
| Loaded by | ICSP / debugger (ICD4) | Bootloader, over UART1 |
| Config words | This project sets them (`STANDALONE_BUILD`) | Bootloader owns them |
| Watchdog | **Off** | **On**, ~8.4 s |
| Post-build | none | hexmate CRC-signs the app region |
| Use it for | bench work, debugger sessions, watch windows | production, field firmware swaps |

Build from the command line:

```bash
"/c/Program Files/Microchip/MPLABX/v6.05/gnuBins/GnuWin32/bin/make.exe" CONF=standalone TYPE_IMAGE=PRODUCTION_IMAGE
```

Swap `CONF=default` for the bootloadable image. Production images only — debug builds
skip the CRC post-build step by design, so they are not loadable by the bootloader.

Output lands in `dist/<config>/production/RGS_BringUp.X.production.hex`, and a post-build
step also drops a copy named by configuration and firmware revision into the shared
firmware area:

```
C:\SubSystemFirmware\BatteryConfigBuilds\default\RGS_BATT_default_9_1.hex
C:\SubSystemFirmware\BatteryConfigBuilds\standalone\RGS_BATT_standalone_9_1.hex
```

The revision in the filename is read from `firmware_version.h` at build time, so bumping
the version there is all that is needed to produce a new drop. `deployHex.bat` does the
copy and **fails the build** if it cannot — a stale hex sitting in the drop directory is
more dangerous than a failed build. For the `default` configuration it deliberately runs
*after* `postBuild.bat`, so the dropped image is the CRC-signed one the bootloader will
accept.

### Which one do I want?

Use **standalone** while developing: the debugger attaches, and the `bq_dbg_*` globals
in `bq40z50.c` report progress in a watch window without needing the serial port.

Use **default** for the production flow: ICSP the bootloader once, then load this image
over UART, provision packs, and finally load the product application the same way. The
bootloader hands off to a valid CRC-signed app automatically at power-up, and holding
`JETSON_CALLING` high at reset keeps it in bootload mode — so loading jig firmware is
never a one-way trip and never needs the programmer again.

> The CRC post-build hook lives in `nbproject/configurations.xml`
> (`makeCustomizationType`, post step enabled for `default` only). Hand edits to the
> generated `Makefile-*.mk` are silently clobbered whenever MPLAB X regenerates them.

## What the jig does

`BQ40Z50_BringUp()` in [bq40z50.c](bq40z50.c) runs every ~5 seconds, with a green LED
heartbeat between passes. Every step is idempotent and the sequence continues past
failures, so progress accrues across passes even on an unreliable bus:

1. Plain SBS reads (pack and cell voltage) — legal in every security mode, so they
   prove the transport before anything else is attempted.
2. Probe (expect device type `0x4500`). A **sealed** gauge rejects
   `ManufacturerBlockAccess`, so on failure the default unseal keys are sent blind via
   `ManufacturerAccess` and the probe retried.
3. One `DeviceReset` per jig boot, clearing latched protection state.
4. DA Configuration → `0x17`: 4 series cells, non-removable (ignore the `PRES` pin).
5. Temperature source → internal die sensor.
6. FET enable, then `FET_EN` written into `Mfg Status Init` so it survives resets and
   the eventual seal.
7. Cell voltage readout.

Results go to UART1 at 115200 8N1 on RC4/RC5, and to the `bq_dbg_*` globals for the
debugger.

### Hardware notes

**Temperature configuration is bench-only.** Prototype packs have no thermistors
fitted, and the factory setting reads those open inputs as frozen, latching
under-temperature protection and holding the discharge FET off. The jig points the
gauge at its internal die sensor instead. **Packs with real thermistors need
`BQ_TEMP_ENABLE_BENCH` / `BQ_TEMP_MODE_BENCH` rewritten to match the fitment**, or they
ship with external thermal protection disabled.

**The gauge's FUSE pin needs a pull-down on boards with no fuse fitted.** It has an
internal 150–330 nA pull-up and a 1.5–2.5 V detection threshold, so it floats high; the
gauge reads that as a second-level protector firing the fuse and turns off both FETs.
100 kΩ to VSS fixes it. The next PCB spin should carry the footprint, fitted only on
fuse-less builds.

**Gauging is still off** on freshly provisioned packs (`Mfg Status Init` ships `0x0000`,
so `GAUGE_EN` is clear). State of charge will read zero until the golden-image stage
sets chemistry, capacity, protections and gauging.

## Relationship to the product repo

`origin` is this repository. A second remote, `puttinggate`, points at
`RGS_PuttingGate.git` so driver fixes can be cherry-picked between the two projects.
Nothing pushes there by default.
