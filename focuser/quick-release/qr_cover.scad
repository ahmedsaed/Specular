// =====================================================================
//  QR BRACKET COVER  -- twist-in dust cap for the quick-release bracket
//
//  Closes the bracket when the focuser is off and the scope is stored. It
//  reuses the SAME bayonet male interface as qr_focuser_base.scad (skirt +
//  neck + 3 ramped lugs) so it drops in and twists to lock exactly like the
//  focuser base -- but with:
//    - NO focuser-mount flange, NO M4 screw/nut pockets, NO M3 lock screw
//    - NO light bore: the top is SOLID so it actually blocks dust/light
//    - a short GEAR-TOOTHED KNOB as the lid, for a tool-free finger twist
//
//  *** The bayonet params below MUST match qr_bracket.scad (copied from
//      qr_focuser_base.scad). Change them here if you change the bracket. ***
// =====================================================================

// ---- must match the bracket (copied from qr_focuser_base.scad) ----
bore_d        = 31;      // (only used to size the lug inner reach)
bay_socket_id = 42;
bay_ledge_id  = 37;
bay_ledge_t   = 2.2;
bay_ring_od   = 54;
bay_gap_arc   = 64;
bay_n         = 3;
bay_clear     = 0.4;     // rotating fit clearance (radial)

// ---- outer skirt (wraps the bracket ring -> radial register + centering) ----
skirt_od      = 60;
skirt_clear   = 0.6;     // diametral slip-fit gap over the ring OD
skirt_depth   = 7.5;     // how far the skirt reaches down the ring (of the 8 mm ring; 0.5 mm
                         // clearance to the base-pad shoulder so the bayonet still clamps first)

// ---- lugs + clamp ramp (match qr_focuser_base.scad) ----
lug_arc       = 50;      // lug angular width (passes the 64-deg gaps)
lug_h         = 2.6;     // lug body height
entry_clear   = 0.5;     // gap under the lip at the ENTRY end of the lug (easy start)
preload       = 0.15;    // interference at the LOCKED end (the clamp). 0 = just touch.
ramp_dir      = 1;       // which way the ramp rises; flip to -1 if it tightens backwards

// ---- lug-root fillets (match qr_focuser_base.scad) ----
//  Same anti-detach gusset as the focuser base: fills the sharp corner where each lug
//  cantilevers off the neck wall. Clears the bracket's relieved lip (lip_relief_* there).
root_fil     = true;
root_fil_r   = 0.9;      // radial spread onto the lug top (needs lip_relief_r >= this + ~0.3)
root_fil_h   = 1.6;      // how far the gusset climbs the neck wall
root_fil_bot = 0.9;      // down-blend onto the lug underside

// ---- gear knob (the lid / grip) ----
knob_h        = 9;       // knob height above the register face (well under the 19 mm base)
knob_body_d   = 60;      // solid body diameter (caps the skirt flush)
knob_teeth    = 20;      // number of grip teeth
tooth_d       = 6;       // tooth (rounded lobe) diameter; teeth straddle the body rim
                         //   -> tip diameter = knob_body_d + tooth_d
tooth_fillet  = 1.2;     // fillet blending each tooth into the body (rounds the valleys). 0 = off.
top_relief    = 0;       // optional shallow finger dish in the top (0 = flat lid)

$fn = 120;
// =====================================================================
// ---- derived (bayonet -- identical to the focuser base) ----
neck_d   = bay_ledge_id - 2*bay_clear;          // passes within the lips
lug_ir   = bore_d/2 - 0.6;                       // inner reach (fuses into the neck)
lug_or   = (bay_socket_id - 2*bay_clear)/2;     // fits the socket, under the lip

lug_top_lo   = -(bay_ledge_t + entry_clear);
lug_top_peak = -(bay_ledge_t - preload);
lug_bot      = lug_top_lo - lug_h;
function ztop(a) =
    let (p = (ramp_dir > 0 ? a : lug_arc - a) / lug_arc)            // 0 = entry, 1 = locked
    lug_top_lo + p * (lug_top_peak - lug_top_lo);                   // monotonic rise to peak

// one lug: stepped segments whose top follows the ramp/detent profile
module lug() {
    step = 2;
    for (a = [0 : step : lug_arc - 0.001]) {
        seg = min(step + 0.7, lug_arc - a);
        rotate([0,0, a]) rotate_extrude(angle = seg)
            translate([lug_ir, lug_bot]) square([lug_or - lug_ir, ztop(a) - lug_bot]);
    }
}

// lug-root gusset (identical to qr_focuser_base.scad): chamfer at the lug-top <-> neck-wall
// corner, climbing the wall (root_fil_h) and blending down (root_fil_bot), inset from the
// lug ends so it can't foul the rotation stop.
module lug_root_gusset() {
    step = 2;
    gm   = 2;
    nr   = neck_d/2;
    for (a = [gm : step : lug_arc - gm - 0.001]) {
        seg = min(step + 0.7, lug_arc - gm - a);
        zt  = ztop(a);
        rotate([0,0, a]) rotate_extrude(angle = seg)
            polygon([[nr - 0.6, zt - root_fil_bot],
                     [nr + root_fil_r, zt],
                     [nr - 0.6, zt + root_fil_h]]);
    }
}

// ---- gear-shaped knob (rounded teeth = grippy + print-friendly) ----
module knob_teeth_raw() {
    union() {
        circle(d = knob_body_d);
        for (i = [0 : knob_teeth-1])
            rotate([0, 0, i*360/knob_teeth])
                translate([knob_body_d/2, 0]) circle(d = tooth_d);
    }
}
module knob_profile() {
    if (tooth_fillet > 0)
        offset(r = -tooth_fillet) offset(r = +tooth_fillet)   // "close": fillets the valleys
            knob_teeth_raw();
    else
        knob_teeth_raw();
}
module knob() {
    difference() {
        linear_extrude(knob_h) knob_profile();
        if (top_relief > 0)                          // optional finger dish in the top
            translate([0, 0, knob_h + (knob_body_d*knob_body_d/(8*top_relief) + top_relief/2) - top_relief])
                sphere(r = knob_body_d*knob_body_d/(8*top_relief) + top_relief/2);
    }
}

// ---- the cover: gear knob lid + the shared bayonet male ----
module cover() {
    union() {
        knob();                                                        // solid gear lid, z = 0..knob_h
        // outer skirt: a tube that drops over the bracket ring OD (radial register)
        difference() {
            translate([0,0, -skirt_depth]) cylinder(d = skirt_od, h = skirt_depth);
            translate([0,0, -skirt_depth-0.5]) cylinder(d = bay_ring_od + skirt_clear, h = skirt_depth + 0.5);
        }
        // neck extends a bit past the lip line to overlap the lugs (manifold)
        translate([0,0, -(bay_ledge_t + 0.6)]) cylinder(d = neck_d, h = bay_ledge_t + 0.62);
        // 3 ramped lugs at the gap angles (0,120,240) so they drop straight in
        for (i = [0:bay_n-1]) rotate([0,0, i*120 - lug_arc/2]) lug();
        // anti-detach root gussets (clears the bracket's relieved lip)
        if (root_fil) for (i = [0:bay_n-1]) rotate([0,0, i*120 - lug_arc/2]) lug_root_gusset();
    }
    echo(str("COVER: knob ", knob_body_d + tooth_d, " mm OD x ", knob_teeth, " teeth, ",
             knob_h, " mm tall; skirt ", skirt_od, ", lugs at 0/120/240 -- solid top (no bore)"));
}

cover();
