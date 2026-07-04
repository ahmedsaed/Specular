# Focuser subsystem

Parts that replace or re-mount the telescope's focuser on the carbon/optical tube.

## How the focuser is built

The focuser is a **3-layer stack** held together by **3 long M4 screws** that run
top to bottom:

```
   [ top lid ]
   [ rotating cylinder ]   <- focus mechanism (foam grip)
   [ bottom base ]         <- saddle sits on the tube   <<< the swappable part
        |  3x long M4 screws pass through all layers and into the tube
```

The **base is the only swappable interface**. Replicate it faithfully → it drops
in and the focuser works exactly as before. The lid, cylinder, and screws never
change; every part here is "just a different base" with the same top interface.

## Parts

| Part | What it is | Status |
|------|-----------|--------|
| [`base (original)/`](<base (original)/>) | Faithful replica of the focuser's bottom base — concave saddle bottom, flat top, light bore, 3 screw holes. The drop-in interface. | In design |
| [`quick-release/`](quick-release/) | Same top interface, but a **screw-free push-pin QR** mechanism instead of a bolted saddle. Also holds the **twist-in dust cover** for closing the bracket when the focuser is off. | Prototype |
| [`curved-nut/`](curved-nut/) | Insurance part: a curved-seat M4 nut so the **original** focuser can still mount to the curved tube wall if the new designs don't pan out. | Backup |

## Focuser & mounting facts

- **Focuser:** foam-gripped cylinder, OD ≈ 59 mm, with an integral saddle flange.
- **Mounting studs:** 3 × **M4** threaded studs (M4 nuts confirmed to fit), epoxied
  into the focuser flange, in an equilateral triangle.
  - Stud span (outer edge to outer edge) = 40 mm → **center-to-center = 36.5 mm**
  - **Bolt-circle diameter ≈ 42.1 mm** (radius 21.1 mm)
  - **Light bore ID ≈ 31 mm**, concentric with the stud triangle
  - Radial gap from bore edge to stud center = **5.6 mm** (caliper-confirmed)
  - One stud sits on the saddle's "shallow" axis (clocking reference)
- **Tube:** circumference 505 mm + 5 mm wall → OD ≈ 160.7 mm (sagitta cross-checks
  the radius and the 60 mm footprint).
- The off-centre screws cross the concave inner wall at ~13° — a known failure mode
  of the original mount (flat nuts rock and never clamp; screws too short to reach).
  This is what [`curved-nut/`](curved-nut/) exists to fix.
