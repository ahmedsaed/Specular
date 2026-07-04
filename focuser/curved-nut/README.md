# Curved-seat M4 nut (`curved_nut.scad`)

Insurance so the **original** focuser can mount reliably to the curved carbon tube
even if the new screw-free design doesn't pan out. Fixes both original failure
modes:

1. The off-centre screws cross the concave inner wall at ~13° — **flat nuts rock
   and never clamp.**
2. The screws are **too short** for a normal nut to reach.

This is an **actual threaded M4 nut** whose threads start AT the curved wall face,
so the short screw engages thread immediately and uses all its remaining length.
The face is convex (R = inner radius ~75.3 mm) with an optional `seat_tilt`.

## Printing three variants

Print three, one per hole position:

- `seat_tilt = 0` → centre hole (`curved_nut_tilt0.stl`)
- `seat_tilt = +13` → one side hole (`curved_nut_tilt13.stl`)
- `seat_tilt = -13` → mirror side hole (`curved_nut_tiltneg13.stl`)

**Orientation:** flat winged (cage) side **down**, convex seat **up**, vertical
thread axis. Fit with **wings aligned to the tube's long axis**; hold by the wings,
turn the screw from outside.

## Knobs

- `right_hand` — flip to `-1` if the screw won't start.
- `thread_clearance` — raise if the thread is tight.
- **Fallback:** `use_modeled_thread = false` → a 3.3 mm pilot hole; the steel screw
  self-taps.

Tilt/radius are derived from the circumference-based OD + 5 mm wall — **re-confirm
with the scope** before committing.
