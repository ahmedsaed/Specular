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

// ---- lock screw (radial M3; nut sits in a hex cutout in the skirt) ----
lock_angle    = 0;       // bracket-frame lock angle (match bracket)
m3_clear      = 3.4;     // screw clearance
m3_nut_af     = 5.9;     // M3 nut across-flats (5.5) + 0.2 clearance
m3_nut_thk    = 2.5;     // M3 nut thickness + clearance
lpad_out      = 1.5;     // local skirt thickening so the cutout has a back wall (minimal)
lpad_w        = 8;       // pad width (just clears the nut)
lpad_z        = 7;       // pad height (just clears the nut)
lock_drop     = 2.8;     // lock centre below the ring top (keeps the pad inside the skirt)

// ---- outer skirt (wraps the bracket ring -> radial register + centering) ----
skirt_od      = 60;      // flush with the bracket pad
skirt_clear   = 0.6;     // diametral slip-fit gap over the ring OD
skirt_depth   = 7.5;     // how far the skirt reaches down the ring (of the 8 mm ring; 0.5 mm
                         // clearance to the base-pad shoulder so the bayonet still clamps first)

// ---- focuser mount (the sandwich) ----
flange_od     = 60;      // flush with the skirt / bracket pad
mount_h       = 19;      // focuser-mount-face height above the register face. The screw
                         // comes DOWN from the top and travels this far to the captive
                         // nut at the BOTTOM. Make it taller to swallow an over-long
                         // screw (less tip pokes past the nut into the socket). Keep it
                         // >= the screw's protrusion length. Adds stack height -> recover
                         // focus by shortening the truss.
stud_spacing  = 36.5;    // -> BCD 42.1 (matches the original screws)
nut_af        = 7.4;     // M4 hex nut across-flats + clearance
nut_thk       = 3.4;     // M4 nut thickness + clearance
screw_clear   = 4.4;     // M4 screw clearance + stud-tip relief
nut_z         = 2.0;     // nut seat above the register face. The nut used to sit ON the
                         // register face (nut_z = 0), so the screw had to travel the full
                         // mount_h to reach it and only caught the last threads. Raising it
                         // shortens the travel by this much for the same screw.
                         // The ROOF (nut_z + nut_thk) is what matters: the screw head bears
                         // on the lid at the top, so tightening pulls the nut UP against the
                         // roof. The floor below is only there to retain the nut and close
                         // the register face -- it carries no clamp load.
nut_sag       = 1.0;     // extra channel height BELOW the nut, for the bridge droop on the
                         // roof when printing without supports. Goes below, never above:
                         // raising the roof would carry the nut up with it and undo the
                         // travel gained by nut_z. Floor thins to nut_z - nut_sag.
nut_slide     = true;    // slide the nut in radially from the bore (floor + roof hold it)
                         // instead of dropping it into a pocket open at the register face
nut_grip      = 0.3;     // floor ridge at the channel mouth: the nut rides over it and is
                         // then held from sliding back out toward the bore
nut_grip_len  = 1.2;     // length of that ridge
clocking_angle = 90;

// ---- lugs + clamp ramp ----
lug_arc       = 50;      // lug angular width (passes the 64-deg gaps)
lug_h         = 2.6;     // lug body height
entry_clear   = 0.5;     // gap under the lip at the ENTRY end of the lug (easy start)
preload       = 0.15;    // interference at the LOCKED end (the clamp). 0 = just touch.
ramp_dir      = 1;       // which way the ramp rises; flip to -1 if it tightens backwards

// ---- lug-root fillets (anti-detach gussets tying each lug back to the neck wall) ----
//  The lug cantilevers OUTWARD off the neck, joined only across a thin top-inner band --
//  a sharp re-entrant corner that concentrates stress, so a knock pries the lug loose.
//  These add a chamfered gusset that climbs the neck wall onto the lug top (the pry-out /
//  TOP corner) plus a smaller one on the lug underside (the tension face). The female lip
//  is relieved (lip_relief_* in qr_bracket.scad) so the top gusset clears on twist.
root_fil     = true;
root_fil_r   = 0.9;      // radial spread of the top gusset onto the lug top -> DRIVES the
                         //   female lip relief (keep lip_relief_r >= this + clearance)
root_fil_h   = 1.6;      // how far the top gusset climbs the neck wall (more = stiffer root)
root_fil_bot = 0.9;      // bottom gusset: climbs UNDER the neck rim onto the lug underside

$fn = 120;
// =====================================================================
stud_bcd = stud_spacing/sqrt(3)*2;
flange_thk = mount_h;                            // focuser-mount face height (nut at the bottom)
// twist angle from drop-in (lug at gap) to the locked stop -> places the lock hole
ledge_arc  = 360/bay_n - bay_gap_arc;
lock_twist = (360/bay_n)*0.5 + ledge_arc/2 - bay_stop_arc - lug_arc/2;
neck_d   = bay_ledge_id - 2*bay_clear;          // passes within the lips
lug_ir   = bore_d/2 - 0.6;                       // reach inward to the bore wall (the bore
                                                 // cut trims it flush) so each lug fuses
                                                 // solidly into the body instead of floating
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

// lug-root gusset: at the re-entrant corner where the lug top meets the neck wall,
// sweep a chamfer that climbs the neck wall (root_fil_h, the TOP/pry-out side) and
// blends DOWN into the lug underside (root_fil_bot, the tension side), spreading
// root_fil_r out onto the lug top. Follows the same ramp/arc as the lug so it fuses
// solidly. Grows outward past the neck (nr) toward the lip -> the female is relieved.
module lug_root_gusset() {
    step = 2;
    gm   = 2;                                   // inset from the lug ends so the gusset can't
                                                //   foul the rotation stop / entry gap
    nr   = neck_d/2;                            // neck outer wall (the "wall carrying" the lug)
    for (a = [gm : step : lug_arc - gm - 0.001]) {
        seg = min(step + 0.7, lug_arc - gm - a);
        zt  = ztop(a);
        rotate([0,0, a]) rotate_extrude(angle = seg)
            polygon([[nr - 0.6, zt - root_fil_bot],   // down the (buried) wall onto the lug
                     [nr + root_fil_r, zt],           // out onto the lug top (drives lip relief)
                     [nr - 0.6, zt + root_fil_h]]);   // up the neck wall (ties lug to the body)
    }
}

// lock boss: encloses the M3 nut at the bottom and runs the FULL height up to the
// mount face, so it's tied into the body (not floating) and doubles as a thumb grip
// / lever for twisting the bayonet home.
module lock_pad() {
    z0 = -lock_drop - lpad_z/2;     // bottom: wraps the captive M3 nut
    z1 = flange_thk;                // top: flush with the focuser-mount face
    rotate([0,0, lock_angle - lock_twist])
        translate([skirt_od/2 - 2, -lpad_w/2, z0])
            cube([lpad_out + 2, lpad_w, z1 - z0]);
}

// hex nut cutout (open at the outer face) + screw clearance through to the ring
module lock_nut_cuts() {
    xin = (bay_ring_od + skirt_clear)/2;              // skirt inner face (toward the ring)
    rotate([0,0, lock_angle - lock_twist]) translate([0,0, -lock_drop]) {
        translate([xin - 0.2, 0, 0]) rotate([0,90,0])                   // hex pocket, opens INWARD
            cylinder(d = m3_nut_af/cos(30), h = m3_nut_thk + 0.5, $fn = 6); // (ring retains the nut)
        translate([skirt_od/2 - 4, 0, 0]) rotate([0,90,0])              // screw clearance
            cylinder(d = m3_clear, h = lpad_out + 6, $fn = 24);
    }
}

module male() {
    difference() {
        union() {
            cylinder(d = flange_od, h = flange_thk);                       // focuser-mount flange
            lock_pad();                                                    // local pad for the nut cutout
            // outer skirt: a tube that drops over the bracket ring OD (radial register)
            difference() {
                translate([0,0, -skirt_depth]) cylinder(d = skirt_od, h = skirt_depth);
                translate([0,0, -skirt_depth-0.5]) cylinder(d = bay_ring_od + skirt_clear, h = skirt_depth + 0.5);
            }
            // neck extends a bit past the lip line to overlap the lugs (manifold)
            translate([0,0, -(bay_ledge_t + 0.6)]) cylinder(d = neck_d, h = bay_ledge_t + 0.62);
            // 3 ramped lugs at the gap angles (0,120,240) so they drop straight in
            for (i = [0:bay_n-1]) rotate([0,0, i*120 - lug_arc/2]) lug();
            // anti-detach root gussets on each lug (needs the female lip relief)
            if (root_fil) for (i = [0:bay_n-1]) rotate([0,0, i*120 - lug_arc/2]) lug_root_gusset();
        }
        // light bore
        translate([0,0, -bay_ledge_t-lug_h-1])
            cylinder(d = bore_d, h = flange_thk + bay_ledge_t + lug_h + 2);
        // sandwich at the screw BCD (90,210,330): captive M4 hex nut near the bottom,
        // sitting nut_z above the register face on a solid floor, with full-height screw
        // clearance above it. The clearance continues DOWN through the floor as tip relief,
        // so an over-long screw behaves exactly as it did when the nut sat on the face.
        for (i = [0:2]) rotate([0,0, clocking_angle + i*120]) {
            translate([stud_bcd/2, 0, -0.01])                                  // screw clearance
                cylinder(d = screw_clear, h = flange_thk + 1);                 //   + tip relief
            translate([stud_bcd/2, 0, nut_z - nut_sag])                        // hex seat, dropped
                cylinder(d = nut_af/cos(30), h = nut_thk + nut_sag, $fn = 6);  //   by the sag
            if (nut_slide)                                                     // slide-in channel
                difference() {                                                 //   from the bore
                    translate([0, -nut_af/2, nut_z - nut_sag])
                        cube([stud_bcd/2, nut_af, nut_thk + nut_sag]);
                    translate([bore_d/2 - 0.5, -nut_af/2 - 0.1, nut_z - nut_sag])
                        cube([nut_grip_len, nut_af + 0.2, nut_grip]);          // ridge = retention
                }
        }
        lock_nut_cuts();   // screw clearance + captive-nut pocket + insert slot
    }
    echo(str("MALE: flange ", flange_od, " neck ", neck_d, " lug r ", lug_ir, "-", lug_or,
             " at 0/120/240; nuts at ", clocking_angle, "/210/330 (BCD ", stud_bcd, ")"));
    echo(str("  nut channel z ", nut_z - nut_sag, "-", nut_z + nut_thk, " (", nut_thk + nut_sag,
             " mm clear for a 3.2 mm nut + ", nut_sag, " mm bridge droop) on a ",
             nut_z - nut_sag, " mm floor, roof ", flange_thk - nut_z - nut_thk, " mm."));
    echo(str("  nut is pulled UP onto the roof at z ", nut_z + nut_thk,
             ", so M4 from the top face (z ", flange_thk, ") starts biting at ",
             flange_thk - nut_z - nut_thk, " mm long and is fully through the nut at ",
             flange_thk - nut_z - nut_thk + 3.2,
             " mm; past ", flange_thk, " mm the tip pokes below the register face."));
}

male();
