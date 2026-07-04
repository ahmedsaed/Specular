# Specular — 3D-printable parts for a 114/900 Newtonian

Parametric, 3D-printable **replacement and upgrade parts** for a small Newtonian
reflector. What started as a single focuser-base replica now holds a growing set
of telescope parts and accessories — each one a self-contained, parametric
OpenSCAD design with its own notes.

## The telescope

- **Type:** Newtonian reflector, truss/collapsible.
- **Aperture:** 114 mm · **Focal length:** 900 mm (≈ f/7.9).
- **Optical tube at focuser:** circumference ≈ 505 mm → **OD ≈ 160.7 mm**
  (saddle radius ≈ 80.4 mm). *Confirm by direct measurement.*
- **Material of choice:** PETG throughout (heat/creep resistance for outdoor use;
  light, non-load-bearing where it can be).

## Parts index

| Part | Subsystem | Status | Files |
|------|-----------|--------|-------|
| [Tube-side base](<focuser/base (original)/>) | Focuser | In design | `focuser/base (original)/` |
| [Quick-release variant](focuser/quick-release/) | Focuser | Prototype | `focuser/quick-release/` |
| [QR bracket dust cover](focuser/quick-release/) | Focuser | v1 | `focuser/quick-release/qr_cover.scad` |
| [Curved-seat M4 nut](focuser/curved-nut/) | Focuser | Backup | `focuser/curved-nut/` |
| [Secondary mirror holder](optics/secondary-holder/) | Optics | v1 (snap-arm clamp) | `optics/secondary-holder/` |
| [Microscope 1" → 1.25" filter adapter](eyepiece/microscope-adapter/) | Eyepiece | v1 | `eyepiece/microscope-adapter/` |

See [`focuser/`](focuser/), [`optics/`](optics/), and [`eyepiece/`](eyepiece/) for each subsystem's overview.

## Repository layout

```
specular/
├── README.md              this file — overview + index
├── focuser/               everything that mounts / replaces the focuser
│   ├── README.md          how the focuser is built + how the parts relate
│   ├── base (original)/   tube-side saddle base (drop-in replica)
│   ├── quick-release/     screw-free QR base + bracket + twist-in dust cover
│   └── curved-nut/        curved-seat M4 nut (backup for the original focuser)
├── optics/                optical-element mounts
│   └── secondary-holder/  45° secondary mirror mount (snap-arm edge clamp)
└── eyepiece/              eyepiece-side adapters
    └── microscope-adapter/  1" microscope EP → 1.25" focuser + M28.5 filter thread
```

## Conventions

- **One parametric `.scad` per part.** Multi-part files select with a `part = "..."`
  variable (e.g. `"pin" | "base" | "coupon"`). Bold parameters in each README are
  **confirm-before-printing** values (usually pending a caliper measurement).
- **`.stl` / `.png` and `output/` are git-ignored** — regenerate from source.
- Each part folder carries its own README with the design rationale, parameter
  table, printing notes, and bench-test steps.
