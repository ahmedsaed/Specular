# Secondary mirror holder — v1 (snap-arm clamp) (`secondary_holder_hooks_v1.scad`)

> **Superseded by v2** — see `secondary_mount_push.scad` (bonded pocket + 3-screw
> tilt stage: 3 push screws opposed by a sprung central pull on the spider stud).
> v1 works and holds the mirror securely, but retains partly by side friction and
> has no collimation adjustment. Kept for record.

The original **secondary** mirror was **glued** straight to its mount by the builder
and **detached during collimation on 2026-06-25**. A replacement 25 mm elliptical
mirror (AliExpress `1005009092127851`, model **FJ-25**, ~35 mm major axis,
first-surface) is on order. This part replaces the glue job with a light, tool-free
**mechanical edge clamp** — a set of flexible hooks that grip the glass edge.

## The mirror is a 45° cut (oblique prism)

A Newtonian diagonal is a **slice of a glass cylinder cut at 45°**: the reflective
top ellipse and the back ellipse are the same size, but the top is **shifted along
the long (major) axis** by `mirror_shear`, so the side wall is a slanted 45° band —
it is **not** a flat plate. That shear is why the two long ends need *different*
hooks.

## Mechanism

**Key idea:** a 45°-cut mirror is just a vertical elliptical prism that has been
**sheared** along the major axis. So the whole upper assembly — the mock mirror
**and** the 4 hooks — is modelled *vertically* (short curved hooks, inward-only lip,
flush edge) and then **sheared as one transform**. Every hook then leans to follow
the glass wall automatically:

- the two **+major hooks lean outward** → looser → the **slide-in** side;
- the two **−major hooks lean inward** → tighter → the **clip** side.

**Assembly:** slide the mirror toward the +major (slide-in) end, then clip the
−major end down. The hooks sit at **±`arm_off` from the long axis** (default 30°),
clustered toward the two tips so the lean aligns with the slide direction.

The mirror's back seats on **3 pads** (defined 3-point contact, no rock) or **flat**
on the plate — switchable via `seat_mode`. The **plate is not sheared** — it stays
flat on the bed, sized to the mirror outline (no light-blocking ring; only small
local **tabs** poke out under each hook foot). A central **M3 cap-head hole** in the
plate is the mount interface.

One parametric file, `part = "holder" | "mirror" | "coupon"`:
- `holder` — the printable clamp (default).
- `mirror` — holder + a mock oblique-prism glass slab, for a visual sanity check.
- `coupon` — the two end hooks on a flat bar, to rehearse the slide-and-clip.

## Design parameters

The mirror had not arrived at design time. **Bold = measure on arrival.**

| Parameter | Value | Notes |
|-----------|-------|-------|
| `mirror_minor` | 25 mm | Minor axis (short) = the effective aperture stop. |
| `mirror_major` | 0 (auto) | 0 → `minor / cos(mirror_tilt)` ≈ 35.36 mm. Set to the measured major. |
| `mirror_thk` | **4 mm** | Face-to-face thickness. **Guess 3–5 mm.** |
| `mirror_tilt` | 45° | Sets the major/minor ratio (does not tilt the part). |
| `mirror_shear` | 0 (auto) | Sideways offset of the top face along +major. 0 → = `mirror_thk` (exact for a 45° cut). **Measure.** |
| `edge_clear` | 0.4 mm | Gap between a hook's inner face and the glass edge. |
| `plate_thk` | 4.5 mm | = 3.0 mm cap-head counterbore + 1.5 mm floor. Drop to 2.5 with a countersunk head. |
| `tab_margin` | 0.8 mm | Root collar on the hook tabs — the only plate beyond the mirror edge. |
| `arm_off` | 30° | Each hook this far from the long axis (2 per end). 45° = evenly spaced; smaller = nearer the tips. |
| `arm_wall` | 1.8 mm | Hook radial thickness = the flex spring. **Tune for snap force.** |
| `arm_span` | 4° | Hook length along the edge (~1 mm arc). |
| `hook_grip` | 1.0 mm | How far the lip covers the front face. |
| `hook_lip_thk` | 1.2 mm | Retaining-lip thickness. |
| `lead_in` | 0.4 mm | Top-of-lip snap bevel. |
| `seat_mode` | "pads" | `"pads"` (3 bumps) or `"flat"`. Print both, compare. |

**Centre mount screw:** `center_screw`, `screw_shank_d` (3.4 = M3, 2.4 = M2),
`screw_head_style` (`counterbore` for a cap head / `countersink` for a flat head),
`screw_head_d`, `screw_head_h`. An assert blocks export if the head is deeper than
the plate — a cap head needs `plate_thk ≥ 4.0`.

## Printing

- **Material:** PETG. **Orientation:** plate flat on the bed, hooks up (no supports;
  the arms print in their flex direction). **Infill:** 20–30%, 3+ perimeters.

## Bench test (once the mirror arrives)

1. **Measure** `mirror_thk`, the real major axis, and the shear; set them and re-export.
2. Print the **coupon**; rehearse the slide-and-clip with a 45° test shim, tuning
   `arm_wall` (snap force) and `edge_clear`.
3. Print the **holder** in both `seat_mode`s; slide the mirror in, clip it, check it
   seats with no rock and the lips hold it captive when inverted.

## Not in v1 (future)

- **Mount** on the plate back — a ball-stalk for the scope's existing spherical
  collimation holder, or a screw into the spider (the central M3 hole is the start).
- Collimation adjustment.
