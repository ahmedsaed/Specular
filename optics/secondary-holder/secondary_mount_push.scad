// =====================================================================
//  SECONDARY MOUNT  -- v2-PUSH variant. Same tower and pocket as
//  secondary_mount.scad; DIFFERENT tilt stage.
//
//  This is the "3 push screws + central pull" arrangement, for comparison
//  against the sprung-pull version in secondary_mount.scad. Only the
//  mating-face features differ -- the mirror pocket geometry is identical
//  and is documented in that file's header.
//
//  HOW IT WORKS
//    - 3 collimation screws thread through NUTS CAPTURED IN THE DISC.
//      Their tips bear on the tower's flat mating face and PUSH it away.
//      Heads on the sky side, reachable past the vanes.
//    - ONE central member in TENSION pulls the tower back toward the disc.
//      Screw a tip in -> that corner is pushed away. Back it out -> the
//      central tension pulls that corner back. 3 corners = 2 tilt axes.
//    - A single large spring around the central member keeps the joint
//      preloaded and compliant so the screws stay light to turn.
//
//  THE CENTRE IS CONTESTED -- READ THIS
//  A textbook push-stage puts a central bolt down the axis, head on the
//  sky side. But on this scope the spider already has a MALE STUD on that
//  exact axis. Both cannot occupy it. Resolved here by making the STUD
//  ITSELF the central tension member:
//
//    stud -> clearance hole in the disc (disc located by jam nuts on the
//    stud) -> central spring -> generous clearance hole up through the
//    tower base -> threads into a nut that sits on a CONICAL SEAT inside
//    the tower.
//
//  The cone lets the nut rock, so the tower can tilt about it instead of
//  trying to bend a 5 mm steel stud. That nut is dropped in from above
//  through the pocket floor -- SO IT MUST BE FITTED BEFORE THE MIRROR IS
//  BONDED IN. After bonding it is unreachable. That is the main practical
//  cost of this variant versus the sprung-pull one.
//
//  part = "assembly" | "section" | "section_tower" | "tower" | "disc" | "mirror"
// =====================================================================

part = "section";

// ---- mirror ----
mirror_d     = 25;
mirror_thk   = 5;
mirror_tilt  = 45;

// ---- pocket ----
bore_clear   = 0.3;

// ---- tower ----
wall         = 1.5;
base_h       = 18;      // taller than the pull variant: has to swallow the central
                        //   nut seat as well. See the echoed stud-length window.
rim_drop     = 0.5;

// ---- tilt stage: 3 PUSH screws, nuts captured in the DISC ----
n_screws     = 3;
bolt_circle  = 9.5;     // RADIUS to the collimation screws. Pushed out from the pull
                        //   variant's 9: the DISC has to fit 3 nut pockets AND the central
                        //   spring seat on one face, and at 9 they were 0.35 mm apart.
screw_clear  = 3.4;     // M3 clearance
nut_af       = 5.5;     // M3 DIN934 across flats
nut_thk      = 2.4;
nut_slack    = 0.3;
gap_nom      = 6;       // nominal disc-to-tower gap at mid-travel
pad_d        = 6;       // shallow seat on the tower for a steel washer under each
pad_h        = 0.6;     //   screw tip -- stops the point denting the PLA. 0 = omit.

// ---- central tension member = the spider stud ----
stud_d       = 5;       // MEASURE. Could be M4/M5 or imperial.
stud_clear   = 0.6;     // clearance in the DISC (disc does not need to tilt)
stud_tilt_cl = 1.2;     // EXTRA clearance in the TOWER, so it can tilt about the cone.
                        //   1.2 over pull_seat_z = 11 allows ~6 deg, well past what is
                        //   needed, while keeping the spring seat wide enough to not
                        //   let the spring drop into the stud bore.
pull_nut_af  = 8.0;     // across flats of the nut that threads onto the stud (M5 = 8.0)
pull_nut_thk = 4.0;     // M5 = 4.0
pull_seat_z  = 11;      // height of the conical seat above the tower's mating face
cone_angle   = 90;      // included angle of the seat the nut rocks on

// ---- central spring (bigger than the M3 springs in the pull variant) ----
c_spring_od  = 8.5;     // ID must clear stud_bore_d or the spring falls into the stud hole
c_spring_seat_h = 1.5;

// ---- disc ----
disc_thk     = 5;

// ---- render quality ----
$fn = 120;

// =====================================================================
// ---- derived ----
tan_t    = tan(mirror_tilt);
vert_thk = mirror_thk / cos(mirror_tilt);

bore_d   = mirror_d + bore_clear;
bore_r   = bore_d / 2;
tower_od = bore_d + 2*wall;
tower_r  = tower_od / 2;
disc_od  = tower_od;

floor_z0 = base_h + bore_r*tan_t;
face_z0  = floor_z0 + vert_thk;
rim_z0   = face_z0 - rim_drop;
tower_h  = rim_z0 + tower_r*tan_t;

nut_cd      = (nut_af + nut_slack) / cos(30);
pull_nut_cd = (pull_nut_af + nut_slack) / cos(30);
stud_bore_d = stud_d + stud_tilt_cl;          // through the tower, allows tilt

// collimation screw: head on the sky face of the disc, through the disc, across the gap
cscrew_min = disc_thk + gap_nom - 2;
cscrew_max = disc_thk + gap_nom + 2;

// NOTE on radial limits: the mating faces of BOTH parts are solid right out to
// tower_r -- the mirror bore only begins above the pocket floor, far above any of
// these features. So the limit here is the outer wall, not bore_r.
assert(bolt_circle + pad_d/2 < tower_r - 0.8,  "washer pads run off the tower's rim");
assert(bolt_circle + nut_cd/2 < tower_r - 0.8, "disc nut pockets break out of the disc rim");
assert(bolt_circle - nut_cd/2 > (c_spring_od + 0.6)/2 + 0.8,
       "disc nut pockets crowd the central spring seat -- raise bolt_circle or shrink the spring");
assert((c_spring_od + 0.6)/2 > stud_bore_d/2 + 0.5,
       "central spring seat is narrower than the stud bore -- the spring will drop into it");
assert(pull_seat_z + pull_nut_thk + 1 < base_h,
       "base_h too short to contain the central nut seat");
assert(rim_drop > 0, "rim_drop must be > 0 or the wall can vignette the outgoing beam");

// ---------------------------------------------------------------------
module slant_above(z0, big = 400) {
    translate([0, 0, z0])
        rotate([0, -mirror_tilt, 0])
            translate([-big/2, -big/2, 0])
                cube([big, big, big]);
}
module slant_slab(z_lo, z_hi) {
    difference() { slant_above(z_lo); slant_above(z_hi); }
}
module screw_stations() {
    for (i = [0 : n_screws-1])
        rotate([0, 0, i * 360/n_screws])
            translate([bolt_circle, 0, 0])
                children();
}

// ---------------------------------------------------------------------
//  Central stud channel, cut from the TOWER. From the mating face upward:
//    spring seat -> oversize stud bore (tilt clearance) -> conical seat ->
//    nut pocket -> shaft up through the pocket floor so the nut can be
//    dropped in and the stud's spare thread has somewhere to go.
// ---------------------------------------------------------------------
module central_channel() {
    translate([0, 0, -0.01])                                    // central spring seat
        cylinder(d = c_spring_od + 0.6, h = c_spring_seat_h + 0.01);
    translate([0, 0, -1])                                       // oversize stud bore
        cylinder(d = stud_bore_d, h = pull_seat_z + 1);
    translate([0, 0, pull_seat_z])                              // conical rocking seat
        cylinder(d1 = stud_bore_d, d2 = pull_nut_cd,
                 h = (pull_nut_cd - stud_bore_d)/2 / tan(cone_angle/2));
    translate([0, 0, pull_seat_z])                              // nut pocket + drop-in shaft
        cylinder(d = pull_nut_cd, h = tower_h);
}

// ---------------------------------------------------------------------
//  TOWER -- printed flat-end DOWN, 45 deg cut UP. Self-supporting.
// ---------------------------------------------------------------------
module tower() {
    difference() {
        difference() {
            cylinder(d = tower_od, h = tower_h + 1);
            slant_above(rim_z0);
        }
        intersection() {                                        // mirror pocket
            translate([0, 0, -1]) cylinder(d = bore_d, h = tower_h + 3);
            slant_above(floor_z0);
        }
        central_channel();
        if (pad_h > 0)                                          // washer seats under the tips
            screw_stations()
                translate([0, 0, -0.01]) cylinder(d = pad_d, h = pad_h + 0.01);
    }
}

// ---------------------------------------------------------------------
//  DISC -- z = 0 is the SKY face (screw heads), z = disc_thk faces the tower.
//  The collimation nut pockets open on the TOWER-facing face: the screw tip
//  pushes the tower away, so the reaction seats each nut up against the solid
//  disc material above it rather than trying to push it out of its pocket.
// ---------------------------------------------------------------------
module base_disc() {
    difference() {
        cylinder(d = disc_od, h = disc_thk);
        translate([0, 0, -1])                                   // stud clearance
            cylinder(d = stud_d + stud_clear, h = disc_thk + 2);
        translate([0, 0, disc_thk - c_spring_seat_h])           // central spring seat
            cylinder(d = c_spring_od + 0.6, h = c_spring_seat_h + 0.01);
        screw_stations() {
            translate([0, 0, -1])                               // screw shank
                cylinder(d = screw_clear, h = disc_thk + 2);
            translate([0, 0, disc_thk - nut_thk - nut_slack])   // nut pocket, tower side
                cylinder(d = nut_cd, h = nut_thk + nut_slack + 0.01, $fn = 6);
        }
    }
}

module mirror_glass() {
    color("SkyBlue", 0.6)
        intersection() {
            translate([0, 0, -1]) cylinder(d = mirror_d, h = tower_h + 3);
            slant_slab(floor_z0, face_z0);
        }
}

// ---------------------------------------------------------------------
//  ASSEMBLY -- drawn with the disc BELOW the tower, i.e. upside-down
//  relative to the telescope. Geometrically identical.
// ---------------------------------------------------------------------
module assembly() {
    tower();
    mirror_glass();
    translate([0, 0, -(gap_nom + disc_thk)]) base_disc();

    color("Silver", 0.55) {                                     // central spring
        translate([0, 0, -gap_nom])
            difference() {
                cylinder(d = c_spring_od, h = gap_nom);
                translate([0, 0, -1]) cylinder(d = c_spring_od - 1.6, h = gap_nom + 2);
            }
        screw_stations()                                        // push screws, tips at the tower
            translate([0, 0, -(gap_nom + disc_thk)])
                cylinder(d = 3, h = gap_nom + disc_thk + pad_h);
    }
    color("DimGray", 0.7)                                       // the stud, in tension
        translate([0, 0, -(gap_nom + disc_thk + 8)])
            cylinder(d = stud_d, h = gap_nom + disc_thk + pull_seat_z + 8);
}

module half_cut() {
    difference() {
        children();
        translate([-200, -200, -200]) cube([400, 200, 400]);
    }
}

// ---------------------------------------------------------------------
if      (part == "section")       half_cut() assembly();
else if (part == "section_tower") half_cut() tower();
else if (part == "assembly")      assembly();
else if (part == "tower")         tower();
else if (part == "disc")          base_disc();
else if (part == "mirror")        mirror_glass();
else                              echo(str("unknown part: ", part));

// ---- derived values echoed on render ----
echo(str("PUSH variant. tower = ", tower_od, " mm OD, ", tower_h, " mm tall, bore ", bore_d));
echo(str("OBSTRUCTION: tower OD ", tower_od, " mm = ", 100*tower_od/114, "% of a 114 mm primary"));
echo(str("stack height, disc sky-face to mirror face = ", disc_thk + gap_nom + face_z0, " mm"));
echo(str("COLLIMATION SCREWS: 3x M3, length under head ", cscrew_min, " to ", cscrew_max,
        " mm -> buy M3x16 and expect to run it in"));
echo(str("COLLIMATION NUTS: 3x M3 hex, dropped into the DISC's tower-facing face"));
echo(str("PULL NUT: 1x ", pull_nut_af, " mm A/F to suit the stud thread, sits on the cone ",
        pull_seat_z, " mm inside the tower -- FIT BEFORE BONDING THE MIRROR"));
echo(str("STUD must reach ", gap_nom + disc_thk + pull_seat_z,
        " to ", gap_nom + disc_thk + pull_seat_z + pull_nut_thk,
        " mm below the spider hub face. MEASURE."));
echo(str("CENTRAL SPRING: 1x compression, OD ", c_spring_od, " mm, ID > ", stud_bore_d,
        " mm, free length ~", gap_nom + 4, " mm"));
