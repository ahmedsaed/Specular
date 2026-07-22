# Focuser — screw-free quick-release variant

Phase 2 of the focuser: the same top interface as the [base](<../base (original)/>), but a
**screw-free push-pin QR** mechanism instead of a bolted saddle. The lid,
cylinder, and screws never change.

## Files

- `qr_bracket.scad` — the bracket that stays on the tube. One parametric file,
  three parts via `part = "pin" | "base" | "coupon"`. Exports `qr_pin.stl`,
  `qr_base.stl`, `qr_coupon.stl`.
- `qr_focuser_base.scad` — the focuser-side base (MALE bayonet) that mates into the bracket.
- `qr_cover.scad` — a **twist-in dust cover** that locks into the bracket to close it
  when the focuser is off (see below).
- `assembly.scad` — visual check: imports `qr_bracket.stl` and
  `qr_focuser_base.stl` and shows the male part locked into the bracket
  (seated on the ring top, twisted ~59° to the stop). Export both STLs into this
  folder first, then render `assembly.scad`.

## Bayonet interface (shared by the base and the cover)

The bracket ring is **8 mm** tall; the male **skirt reaches 7.5 mm** down it, leaving
**0.5 mm clearance** to the base-pad shoulder — so the bayonet lugs clamp against the
ring lip *before* the skirt can bottom out. Don't let `skirt_depth` reach `bay_ring_h`
(8 mm) or the skirt bottoms first and the joint goes loose. Both `qr_focuser_base.scad`
and `qr_cover.scad` copy the same bayonet params (`bay_*`, `skirt_*`, `lug_*`) — keep
them in sync with the bracket.

### Lug-root fillets (anti-detach)

Each lug cantilevers **outward** off the neck and was joined only across a thin
top-inner band — a sharp re-entrant corner that concentrates stress, so a knock can pry
a lug loose (observed in use). The male parts add a **root gusset** at that corner
(`root_fil_*` in `qr_focuser_base.scad` **and** `qr_cover.scad`): a chamfer that climbs
the neck wall onto the lug top and blends down onto the underside, following the ramp so
it fuses solidly. It's inset 2° from the lug ends so it can't foul the rotation stop.

Because the gusset grows outward past the neck toward the lip, the bracket's lip is
**relieved** to clear it: `lip_relief_*` in `qr_bracket.scad` chamfers the lip's
inner-bottom edge along the full arc (only the empty inner-bottom corner is removed — the
lug's bearing surface is untouched, so lock strength is unchanged). **Coupling rule:**
keep `lip_relief_r ≥ root_fil_r + 0.3`. The cover uses the same gusset and mates the same
relieved lip.

## Captive nut heights

Both halves hold M4 nuts that a screw has to reach across a long run, and both were
originally set too far from the screw head.

**Bracket (`bnut_shelf`, screw mode).** The three tube holes do *not* sit at the same
height: the tube curves away, so the two side holes are **2.1 mm lower** than the apex
hole. A single flat nut band therefore left the side nuts ~2.2 mm further from the wall,
and a 12 mm M4 only bit **0.7 mm** into them (vs 2.9 mm at the apex). Each nut is now
referenced to **its own** saddle face — `bnut_shelf` mm of clamp shelf underneath — which
drops the two side nuts 2.5 mm and equalises the screws at **2.7 / 2.6 mm** of engagement.

`bnut_shelf` is bounded on both sides: the nut's slide-in channel from the bore runs
uphill toward the apex, so going below ~1.6 mm feathers the channel floor out through the
saddle contact face near the bore mouth; going above ~2.2 mm eats the roof over the apex
nut. **1.8 mm** is the middle of that window.

**Focuser base (`nut_z`).** The nut used to sit *on* the register face, so the screw had
to cross the whole `mount_h` (19 mm) to reach it and caught only its last threads. It now
sits `nut_z` = 2 mm up and slides in radially from the bore, held by a floor + roof instead
of dropping into a face-open pocket. The screw clearance still runs down *through* that
floor as tip relief, so an over-long screw behaves exactly as before — past 19 mm the tip
pokes below the register face and holds the joint off the ring.

### Which face the nut bears on (the two halves are opposite)

This decides where you add clearance, and it is **not** the same in both parts:

- **Focuser base** — the screw head bears on the focuser lid at the *top*, so tightening
  pulls the nut **UP onto the pocket roof** (`nut_z + nut_thk` = 5.4). The roof is the
  load-bearing face and sets where the nut really ends up; the floor below it only retains
  the nut and closes the register face.
- **Bracket** — the screw is driven *up* from inside the cage, so tightening pulls the nut
  **DOWN onto the shelf** (`bnut_shelf`). There the floor is structural and the roof is not.

So the base's `nut_sag` = 1 mm of bridge-droop clearance for support-free printing is added
**below** the nut (channel z 1.0–5.4, floor thinned to 1 mm), leaving the roof where it is.
Putting it above would have raised the roof, carried the nut up with it, and given back half
the travel `nut_z` just bought. The bracket's channel is unchanged at 3.6 mm — its droop
hangs off a non-structural roof and those nuts already went in on the printed part.

Verified by intersecting the two solids in the locked position: the only contact is the
intended 0.12 mm lug/lip preload at z ≈ 12.6, nothing near the nut pockets.

## Mechanism (v1)

Releasable push-pin from outside. A snug shaft centres in the carbon hole (this
gives rigidity / no wobble); a split barbed tip springs behind the inner wall to
retain; reach into the open cage and pinch the finger tips to release. One pin
fits all three holes (13° tilt absorbed by clearance).

- **Defaults:** hole 4.0 → shaft 3.65, barb OD 5.25, grip 14.2, pin length 24.2 mm.
- **Key knob:** `carbon_hole_d` (set to the real measured hole, re-export). Also
  `shaft_clear` (raise if the pin won't enter, lower if sloppy).
- Pin head currently sits proud on the base top — fine for this stage; integrate
  with the focuser sandwich (and a head counterbore) later.

## Bench test (no scope)

Print coupon + pins; check snap-in, no-wiggle, and pinch-to-release. This
calibrates printer tolerance before the tube is involved.

- Print the pin **upright** for a first try; **on its side** if the fingers crack
  (flex fatigue).

## Dust cover (`qr_cover.scad`)

A twist-in cap that **closes the bracket** when the focuser is off and the scope is
stored. It reuses the exact bayonet male interface (skirt + neck + 3 lugs) so it
drops in and twists to lock just like the focuser base, but:

- **solid top, no bore** — actually blocks dust/light;
- no focuser-mount flange, no M4/M3 holes;
- a short **gear-toothed knob** lid (Ø66, 20 filleted teeth) for a tool-free finger twist;
- ~16 mm tall vs. the base's ~26 mm.

Knobs: `knob_teeth` / `tooth_d` / `tooth_fillet` (grip feel), `knob_h` (height),
`top_relief` (>0 for a finger dish in the lid). Verified seating in the bracket via
the same locked-position assembly as the base.
