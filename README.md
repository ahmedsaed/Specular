# Telescope Focuser — Tube-Side Base

A 3D-printable **replica of the focuser's bottom base**, designed as a drop-in
replacement. This repo currently covers **Phase 1 only: the base.**

## How the focuser is built

The focuser is a **3-layer stack** held together by **3 long M4 screws** that run
top to bottom:

```
   [ top lid ]
   [ rotating cylinder ]   <- focus mechanism (foam grip)
   [ bottom base ]         <- saddle sits on the tube   <<< THIS PART
        |  3x long M4 screws pass through all layers and into the tube
```

The **base is the only swappable interface**. Replicate it faithfully → it drops
in and the focuser works exactly as before. Later, the quick-release bracket is
**just a different base** with the same top interface but a QR mechanism instead
of a fixed saddle — the lid, cylinder, and screws never change.

## Scope

| Phase | Part | Status |
|-------|------|--------|
| **1 (now)** | Base replica — concave saddle bottom, flat top, light bore, 3 screw holes | **In design** (`focuser_base.scad`) |
| 2 (later) | Quick-release base variant (same top interface, QR instead of saddle) | Not started |

## Telescope & focuser facts

- **Scope:** Newtonian reflector, 114 mm aperture, 900 mm focal length, truss/collapsible.
- **Optical tube at focuser:** circumference ≈ 505 mm → **OD ≈ 160.7 mm** (saddle radius ≈ 80.4 mm). *(confirm by direct measurement)*
- **Focuser:** foam-gripped cylinder, OD ≈ 59 mm, with an integral saddle flange.
- **Mounting studs:** 3 × **M4** threaded studs (M4 nuts confirmed to fit), epoxied into the focuser flange, in an equilateral triangle.
  - Stud span (outer edge to outer edge) = 40 mm → **center-to-center = 36.5 mm**
  - **Bolt-circle diameter ≈ 42.1 mm** (radius 21.1 mm)
  - **Light bore ID ≈ 31 mm**, concentric with the stud triangle
  - Radial gap from bore edge to stud center = **5.6 mm** (caliper-confirmed)
  - One stud sits on the saddle's "shallow" axis (clocking reference — see params)

## Saddle adapter — design parameters

These become the variables in the OpenSCAD file. **Bold = confirm before printing.**

| Parameter | Value | Notes |
|-----------|-------|-------|
| `tube_od` | **160.7 mm** | Drives saddle radius (80.35 mm). Confirm by direct caliper. |
| `pad_diameter` | 60 mm | Footprint of the adapter disc. Proposed. |
| `bore_d` | **31 mm** | Light path. Must be ≥ the optical-tube hole. Confirm tube hole size. |
| `stud_bcd` | 42.1 mm | 3 holes at 120°, derived from 36.5 mm spacing. |
| `stud_hole_d` | 4.5 mm | M4 clearance. |
| `clocking` | one hole on +Y (tube-length axis) | **Confirm**: does the lone stud point along the tube length? |
| `min_wall` | 4 mm | Thinnest material over the deepest part of the saddle. |
| `base_thickness` | ≈ 10 mm | = saddle sagitta (~5.8 mm across 60 mm) + min_wall. Keep minimal. |

### Saddle geometry note
The saddle is a cylindrical (concave) cut of radius `tube_od/2` taken from the
bottom face, its axis running **along the tube length**. Across a 60 mm footprint
the saddle depth varies by ≈ 5.8 mm (the "sagitta"). Keeping the footprint narrow
keeps the part thin — which matters later, because total stack height
(adapter + mechanism + focuser) eats into focuser in-travel and can prevent
reaching focus.

## Tube attachment

- **Interim (now):** the 3 × M4 holes let you bolt the adapter to the existing
  tube holes with M4 screws + nuts to test fit.
- **Planned (later):** replace screws with printed **snap-hooks** that flex through
  each tube hole and catch the inner wall — tool-free. Holes stay in the same
  positions, so this is a drop-in change.

## Printing (planned)

- **Material:** PETG (heat/creep resistance for outdoor load-bearing use).
- **Orientation:** flat top face on the bed (saddle valley faces up — no supports;
  clean flat reference face). Trade-off: layer lines then run across the radial
  pull-off direction, so use high infill / extra walls. May revisit orientation.
- **Infill:** 40–50%, gyroid or grid. 4+ perimeters.

## Base facts — all confirmed

- Footprint = 60 mm ✓ · bore = 31 mm ✓ · screws = M4 ✓ · spacing 36.5 mm / BCD 42.1 mm ✓
- Radial gap bore→stud = 5.6 mm ✓ · clocking = one hole on groove centerline (param) ✓
- Tube: circumference 505 mm + 5 mm wall → OD ≈ 160.7 mm (sagitta cross-checks below).
- **Saddle depths:** thinnest (apex) = 6.8 mm = `base_thickness`; thickest (rim) = 12.6 mm
  (derived = base_thickness + 5.81 mm sagitta — model echoes 12.61 mm ✓). These two
  measurements independently confirm the tube radius and the 60 mm footprint.
- **Top face:** flat — cylinder seats flat-on-flat, no centering boss/recess needed. ✓
- **No focus thread in the base** — helix lives in lid + cylinder; base is a mount only. ✓
- **Original retention (NOT replicated this phase):** M4 nuts are pocketed + glued into
  the base; lid screws thread down through the cylinder into those captive nuts, clamping
  lid/cylinder/base as a sandwich. For now the base just has 4.5 mm clearance holes.
  (`nut_pocket_*` params exist for adding captive-nut pockets later.)

## Status: ready for a saddle-fit test print

Print `focuser_base.stl` and verify the saddle seats on the tube with no rocking and
the holes/bore line up. Then we discuss Phase 2 (the quick-release base variant).

## Phase 2: screw-free quick-release attachment (`qr.scad`)

One parametric file, three parts via `part = "pin" | "base" | "coupon"`.

**Mechanism (v1):** releasable push-pin from outside. A snug shaft centres in the
carbon hole (this gives rigidity / no wobble); a split barbed tip springs behind
the inner wall to retain; reach into the open cage and pinch the finger tips to
release. One pin fits all three holes (13° tilt absorbed by clearance).

- Exported: `qr_pin.stl`, `qr_base.stl`, `qr_coupon.stl`.
- Defaults: hole 4.0 → shaft 3.65, barb OD 5.25, grip 14.2, pin length 24.2 mm.
- **Key knob:** `carbon_hole_d` (set to the real measured hole, re-export). Also
  `shaft_clear` (raise if pin won't enter, lower if sloppy).
- **Test now (no scope):** print coupon + pins; check snap-in, no-wiggle, and
  pinch-to-release. Calibrates printer tolerance before the tube is involved.
- Print pin upright for a first try; on its side if fingers crack (flex fatigue).
- Pin head currently sits proud on the base top — fine for this stage; integrate
  with the focuser sandwich (and a head counterbore) later.

## Backup part: curved-seat M4 nut (`curved_nut.scad`)

Insurance so the **original** focuser can mount reliably to the carbon tube even
if the new screw-free design doesn't pan out. Fixes both original failures:
the off-centre screws cross the concave inner wall at ~13° (flat nuts rock and
never clamp), AND the screws are too short for a normal nut to reach. This is an
**actual threaded M4 nut** whose threads start AT the curved wall face, so the
short screw engages thread immediately and uses all its remaining length. The
face is convex (R = inner radius ~75.3 mm) with an optional `seat_tilt`.

- Print three: `seat_tilt = 0` (centre hole) + `+13` / `-13` (side holes, mirror pair).
- Exported: `curved_nut_tilt0.stl`, `curved_nut_tilt13.stl`, `curved_nut_tiltneg13.stl`.
- Orientation: flat winged (cage) side **down**, convex seat **up**, vertical thread axis.
- Fit with **wings aligned to the tube's long axis**; hold by the wings, turn the screw from outside.
- Printed-thread knobs: `right_hand` (flip to -1 if the screw won't start),
  `thread_clearance` (raise if tight). Fallback: `use_modeled_thread = false` →
  3.3 mm pilot hole, steel screw self-taps.
- Tilt/radius derived from circumference-based OD + 5 mm wall — re-confirm with the scope.

## Secondary mirror holder — v1 (mirror mount only) (`secondary_holder.scad`)

The original **secondary** mirror was **glued** straight to its mount by the builder
and **detached during collimation on 2026-06-25**. A replacement 25 mm elliptical
mirror (AliExpress `1005009092127851`, model **FJ-25**, ~35 mm major axis, first-surface)
is on order. This part replaces the glue job with a proper **mechanical seat**.

**Mechanism:** a 45° wedge presents a flat elliptical **pad** to the beam. The mirror's
uncoated back rests on the pad (coated first surface faces the beam), held by **3 silicone
dabs** — standard practice: allows thermal expansion, removable. A shallow **retaining lip**
rings the mirror edge as a mechanical backstop, kept **shorter than the glass** so it never
shadows the reflective surface (an `assert` blocks export if `lip_h >= mirror_thk`). Three
shallow **pockets** key the silicone dabs.

**v1 scope:** the mirror-holding part **only**. The scope's support is a 4-vane spider +
central hub, but that coupling is **out of scope for v1** — the back of the wedge is a plain
flat placeholder face for a future attach part. No collimation adjustment in v1.

One parametric file, three parts via `part = "holder" | "mirror" | "coupon"`:
- `holder` — the printable part.
- `mirror` — holder + a mock glass slab, for a visual sanity check only (not printed).
- `coupon` — the seat on a flat plate; a cheap mirror-fit / silicone test print.

### Design parameters
The mirror had not arrived at design time. **Bold = confirm before printing.**

| Parameter | Value | Notes |
|-----------|-------|-------|
| `mirror_minor` | 25 mm | Minor axis (short) = the effective aperture stop. |
| `mirror_thk` | **4 mm** | **Guess 3–5 mm.** Measure on arrival — drives lip clearance. |
| `mirror_major` | 0 (auto) | 0 → `minor / cos(tilt)` ≈ 35.36 mm. Set to the measured major once known. |
| `tilt` | 45° | Mirror tilt vs the light path. |
| `lip_h` | 1.5 mm | Retaining-lip height. Must stay `< mirror_thk` (asserted). |
| `lip_w` | 1.5 mm | Lip wall thickness. |
| `edge_clear` | 0.4 mm | Gap around the mirror edge inside the lip, per side. Printer-tune. |
| `seat_margin` | 4 mm | Body border around the lip; also sets backing under the mirror ends. |

Secondary **offset** at f/7.9 is <1 mm — negligible for visual, and v1 has no collimation,
so the mirror is centred (`offset_major`/`offset_minor` = 0, left as future hooks).

### Printing (planned)
- **Material:** PETG (matches the rest of the scope; light, non-load-bearing part).
- **Orientation:** print **as modelled — bottom face flat on the bed**, seat facing up as a
  self-supporting ~45° ramp. That angle is right at the support-free limit; if the seat face
  or lip sags, add a brim / a hair of support or revisit orientation.
- **Infill:** 30–40%, 3+ perimeters. The mirror is light — strength is not the concern; a
  clean flat pad and lip are.

### Bench test (no scope, once the mirror arrives)
- Print `coupon` first. Dry-set the mirror in the lip: confirm it drops in with a little
  `edge_clear` play and the lip top sits **below** the reflective face (the render echoes the
  clearance, e.g. "clears reflective face by 2.5 mm").
- Then trial the 3 silicone dabs in the pockets before printing the full `holder`.

## Deliverables (planned)

- `saddle_adapter.scad` — parametric source
- `saddle_adapter.stl` — sliceable export
- This README as the running design + assembly guide
