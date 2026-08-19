# Retired

Source kept for reference only. **Nothing here is built by any project**, and
nothing here should be added back to a project without being fixed first.

## RTOSJobs.c / RTOSJobs.h

Moved out of `CommonFiles/` on 2026-08-17. They had already been absent from
every project's `configurations.xml` for some time, so they were never compiled
— but sitting in `CommonFiles/source` and `CommonFiles/header` they looked like
live shared code.

Entirely self-contained: `RTOSJobs.h` was included only by `RTOSJobs.c`, and all
three functions it declares (`DoSingleByteJob`, `DoMultiByteJob`,
`BallDetectedJob`) exist nowhere else in the codebase.

**Does not compile as it stands.** `BallDetectedJob()` uses `TransitTimeAddr`,
which was defined only in the block of `MemoryMap.h` that was commented out when
the `FirmwareVersionAddr` / `TableVersionAddr` macro collision with
`EEpromBlockLabels.h` was cleaned up. `TransitTimeAddr` is redundant and was
deliberately not rehomed. Anyone reviving ball-transit-time work needs to give
it an address in `EEpromBlockLabels.h`, which is the definitive EEPROM map.
