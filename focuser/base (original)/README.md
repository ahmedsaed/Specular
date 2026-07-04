# Focuser — tube-side base (`focuser_base.scad`)

A 3D-printable **replica of the focuser's bottom base**, designed as a drop-in
replacement. The base is the only swappable interface in the focuser stack (see
the [subsystem overview](../README.md)) — replicate it faithfully and the focuser
works exactly as before.

**Phase 1 = this base.** Phase 2 (the screw-free variant) lives in
[`../quick-release/`](../quick-release/).

## Design parameters

These are the variables in the OpenSCAD file. **Bold = confirm before printing.**

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

### Saddle geometry

The saddle is a cylindrical (concave) cut of radius `tube_od/2` taken from the
bottom face, its axis running **along the tube length**. Across a 60 mm footprint
the saddle depth varies by ≈ 5.8 mm (the "sagitta"). Keeping the footprint narrow
keeps the part thin — which matters because total stack height (adapter +
mechanism + focuser) eats into focuser in-travel and can prevent reaching focus.

## Base facts — all confirmed

- Footprint = 60 mm ✓ · bore = 31 mm ✓ · screws = M4 ✓ · spacing 36.5 mm / BCD 42.1 mm ✓
- Radial gap bore→stud = 5.6 mm ✓ · clocking = one hole on groove centerline (param) ✓
- **Saddle depths:** thinnest (apex) = 6.8 mm = `base_thickness`; thickest (rim) = 12.6 mm
  (= base_thickness + 5.81 mm sagitta — model echoes 12.61 mm ✓). These two
  measurements independently confirm the tube radius and the 60 mm footprint.
- **Top face:** flat — cylinder seats flat-on-flat, no centering boss/recess needed. ✓
- **No focus thread in the base** — the helix lives in the lid + cylinder; the base
  is a mount only. ✓
- **Original retention (NOT replicated this phase):** M4 nuts are pocketed + glued
  into the base; lid screws thread down through the cylinder into those captive
  nuts, clamping lid/cylinder/base as a sandwich. For now the base just has 4.5 mm
  clearance holes. (`nut_pocket_*` params exist for adding captive-nut pockets later.)

## Tube attachment

- **Interim (now):** the 3 × M4 holes let you bolt the adapter to the existing tube
  holes with M4 screws + nuts to test fit.
- **Planned (later):** replace screws with printed **snap-hooks** that flex through
  each tube hole and catch the inner wall — tool-free. Holes stay in the same
  positions, so this is a drop-in change.

## Printing

- **Material:** PETG (heat/creep resistance for outdoor load-bearing use).
- **Orientation:** flat top face on the bed (saddle valley faces up — no supports;
  clean flat reference face). Trade-off: layer lines then run across the radial
  pull-off direction, so use high infill / extra walls. May revisit orientation.
- **Infill:** 40–50%, gyroid or grid. 4+ perimeters.

## Status: ready for a saddle-fit test print

Print the base and verify the saddle seats on the tube with no rocking and the
holes/bore line up. Then move to the [quick-release variant](../quick-release/).
