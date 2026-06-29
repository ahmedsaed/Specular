// =====================================================================
//  FOCUSER BASE (MALE bayonet)  -- mates the bracket's female receiver
//
//  Replaces the focuser's bottom base. Top = focuser mount (flat face +
//  3 captive M4 nut pockets at the sandwich BCD, so the lid+cylinder bolt
//  on as before). Bottom = bayonet male: a neck + 3 lugs that drop through
//  the bracket's gaps and twist under its lips.
//
//  *** Bayonet params MUST match qr_bracket.scad ***
//
//  v1: lugs + neck + focuser mount. Clamp RAMP + DETENT to be added next.
// =====================================================================

// ---- must match the bracket ----
bore_d        = 31;
bay_socket_id = 42;
bay_ledge_id  = 37;
bay_ledge_t   = 2.2;
bay_ring_od   = 54;      // bracket ring OD that the skirt wraps (match bracket)
bay_ring_h    = 8;       // bracket ring height (match bracket) - sets lock-hole height
bay_gap_arc   = 64;      // match bracket - used to locate the lock hole
bay_stop_arc  = 4;       // match bracket - used to locate the lock hole
bay_n         = 3;
bay_clear     = 0.4;     // rotating fit clearance (radial)

// ---- lock screw (radial M3; clearance through the skirt, taps the ring) ----
lock_clear    = 3.4;     // standard M3 clearance (screw passes through; ring is tapped)
lock_angle    = 0;       // bracket-frame lock angle (match bracket)

// ---- outer skirt (wraps the bracket ring -> radial register + centering) ----
skirt_od      = 60;      // flush with the bracket pad
skirt_clear   = 0.6;     // diametral slip-fit gap over the ring OD
skirt_depth   = 7;       // how far the skirt reaches down the ring

// ---- focuser mount (the sandwich) ----
flange_od     = 60;      // flush with the skirt / bracket pad
flange_thk    = 6.8;
stud_spacing  = 36.5;    // -> BCD 42.1 (matches the original screws)
nut_af        = 7.2;     // M4 hex nut across-flats + clearance
nut_thk       = 3.4;     // M4 nut thickness + clearance
screw_clear   = 4.4;     // M4 screw clearance
clocking_angle = 90;

// ---- lugs + clamp ramp ----
lug_arc       = 50;      // lug angular width (passes the 64-deg gaps)
lug_h         = 2.6;     // lug body height
entry_clear   = 0.5;     // gap under the lip at the ENTRY end of the lug (easy start)
preload       = 0.15;    // interference at the LOCKED end (the clamp). 0 = just touch.
ramp_dir      = 1;       // which way the ramp rises; flip to -1 if it tightens backwards

$fn = 120;
// =====================================================================
stud_bcd = stud_spacing/sqrt(3)*2;
// twist angle from drop-in (lug at gap) to the locked stop -> places the lock hole
ledge_arc  = 360/bay_n - bay_gap_arc;
lock_twist = (360/bay_n)*0.5 + ledge_arc/2 - bay_stop_arc - lug_arc/2;
neck_d   = bay_ledge_id - 2*bay_clear;          // passes within the lips
lug_ir   = neck_d/2 - 0.6;                       // overlap into the neck (manifold)
lug_or   = (bay_socket_id - 2*bay_clear)/2;     // fits the socket, under the lip

// lug-top heights (the ramp): low at entry, rising to a peak with interference,
// then a small dip = the detent the lip settles into at the locked end.
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

module male() {
    difference() {
        union() {
            cylinder(d = flange_od, h = flange_thk);                       // focuser-mount flange
            // outer skirt: a tube that drops over the bracket ring OD (radial register)
            difference() {
                translate([0,0, -skirt_depth]) cylinder(d = skirt_od, h = skirt_depth);
                translate([0,0, -skirt_depth-0.5]) cylinder(d = bay_ring_od + skirt_clear, h = skirt_depth + 0.5);
                translate([0,0, -skirt_depth-0.01])                         // lead-in chamfer
                    cylinder(d1 = bay_ring_od + skirt_clear + 2.5, d2 = bay_ring_od + skirt_clear, h = 1.6);
            }
            // neck extends a bit past the lip line to overlap the lugs (manifold)
            translate([0,0, -(bay_ledge_t + 0.6)]) cylinder(d = neck_d, h = bay_ledge_t + 0.62);
            // 3 ramped lugs at the gap angles (0,120,240) so they drop straight in
            for (i = [0:bay_n-1]) rotate([0,0, i*120 - lug_arc/2]) lug();
        }
        // light bore
        translate([0,0, -bay_ledge_t-lug_h-1])
            cylinder(d = bore_d, h = flange_thk + bay_ledge_t + lug_h + 2);
        // sandwich: screw clearance + captive M4 hex nut, at the screw BCD (90,210,330)
        for (i = [0:2]) rotate([0,0, clocking_angle + i*120]) translate([stud_bcd/2, 0, 0]) {
            translate([0,0,-0.01]) cylinder(d = screw_clear, h = flange_thk + 1);
            translate([0,0,-0.01]) cylinder(d = nut_af/cos(30), h = nut_thk, $fn = 6);
        }
        // radial lock-screw clearance through the skirt (lines up at the locked stop)
        rotate([0,0, lock_angle - lock_twist]) translate([0,0, -bay_ring_h/2])
            rotate([0,90,0]) cylinder(d = lock_clear, h = skirt_od/2 + 1, $fn = 24);
    }
    echo(str("MALE: flange ", flange_od, " neck ", neck_d, " lug r ", lug_ir, "-", lug_or,
             " at 0/120/240; nuts at ", clocking_angle, "/210/330 (BCD ", stud_bcd, ")"));
}

male();
