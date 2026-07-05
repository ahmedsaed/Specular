# Microscope 1" eyepiece → 1.25" focuser adapter (`microscope_1in_adapter.scad`)

A printed "1.25 inch eyepiece barrel" that carries a **1" microscope eyepiece**
(WF 10x/20) instead of glass, and threads a standard **1.25" astronomy filter** at
the bottom.

**Light path (bottom → top):** telescope → **filter** (female M28.5×0.6) → clear
bore → **microscope eyepiece** (seated by its flange, clamped by an M3 screw).

## Filter thread — researched

The **1.25" telescope filter thread is M28.5 × 0.6** (metric 60° form, 28.5 mm major
Ø, 0.6 mm pitch). Filters (incl. SVBONY 1.25") carry the **male** thread; this adapter
carries the **female** thread. Universal 1.25" standard.

- [Astronomy Threads Explained — Agena Astro](https://agenaastro.com/articles/miscellaneous/astronomy-threads-explained.html)
- [Telescope Filter Size Specification — Mad Scientist Guy](https://madscientistguy.com/astronomy/telescope-filter-size-specification/)

## Eyepiece — measured (by circumference, C = π·d)

- **Barrel:** ~78 mm circumference → **Ø 24.8 mm** (the part that enters the bore).
- **Flange:** ~115 mm circumference → **Ø 36.6 mm** (rests in the top recess).
- "WF 10x/20" is the optics: **W**ide **F**ield, **10×**, **field number 20 mm** —
  it confirms the Ø24 light path won't clip the field, but not the barrel size.

A wrapped-tape measurement is ±0.5 mm on Ø, so the bore is set a hair generous and
the **clamp screw takes up the slack** (it pushes the barrel against the far wall).

## Design

| Feature | Value |
|---|---|
| Focuser barrel | Ø31.6 (1.25") + safety undercut groove |
| Eyepiece bore | **Ø25.3** (`eyepiece_d` 24.8 + `eyepiece_clear` 0.5) |
| Flange recess | **Ø37.1 × 1.5 deep** (self-centres the Ø36.6 flange) |
| Filter thread | female **M28.5 × 0.6**, 4 mm engagement, lead-in chamfer |
| Retention | radial **M3 screw + captive M3 nut** on the bore side (dropped in from inside, trapped by the eyepiece), clamps the barrel |
| Light path | Ø24 clear (> the 20 mm field) |

`part = "adapter" | "thread_test"`.

Key params: `eyepiece_d` / `eyepiece_clear` (barrel fit), `eyepiece_flange_d` /
`recess_depth` (flange seat), `filter_thread_clear` (printed-thread fit), the
`screw_*`/`nut_*`/`boss_*` clamp, and `barrel_od` / `barrel_len` (focuser fit +
focus reach).

## Print & fit-test order

1. **Print `thread_test` first** (`part = "thread_test"`) — a short ring with just
   the filter thread. Screw a filter in; tune `filter_thread_clear` (raise if it
   won't start). This de-risks the one fit-sensitive feature (0.6 mm-pitch threads).
2. `recess_depth` (1.5 mm) assumes the eyepiece **flange is ≥ 1.5 mm thick** — drop it
   if the flange is thinner, so the flange seats on the recess floor.
3. Print the full `adapter`; drop an M3 nut into its bore-side pocket, seat the
   eyepiece (flange in the recess, barrel trapping the nut), and clamp with a
   radial M3 screw from outside.

**Focus note:** whether a microscope eyepiece reaches focus depends on where its
field stop lands. If it won't reach, adjust `barrel_len` / `eyepiece_depth`.
