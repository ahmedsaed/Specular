// =====================================================================
//  SECONDARY MOUNT  -- v2: BONDED POCKET + 3-SCREW TILT STAGE
//  (3 push screws opposed by a sprung central pull on the spider stud)
//
//  Replaces the v1 snap-arm clamp (see secondary_holder_hooks_v1.scad,
//  which works but relies partly on side friction and has no collimation
//  adjustment). Two printed parts:
//
//    TOWER  -- a cylinder cut at 45 deg. The mirror drops STRAIGHT DOWN the
//              tower axis into a plain cylindrical bore with a 45 deg floor
//              and is bonded in with 3 dabs of NEUTRAL-CURE RTV (never CA --
//              it hazes the coating). Bond + pocket friction retain it, no clips.
//    DISC   -- a flat disc clamped to the spider's central stud by two jam
//              nuts. Carries the 3 collimation screws.
//
//  WHY THE POCKET IS JUST A BORE: the mirror was cut from a round glass rod
//  at 45 deg, and that rod's axis IS the tube axis -- the 25 mm minor axis is
//  simply the beam cross-section it intercepts. So along the tower axis the
//  glass is a plain cylinder, and its shear is already baked in. Do NOT model
//  the pocket by extruding the mirror ELLIPSE perpendicular to the 45 deg
//  face: the mirror is an oblique prism whose back ellipse sits a full
//  mirror_thk off the front one, so a right-prism pocket misses by 5 mm at
//  the bottom and the glass will not go in.
//
//  TILT STAGE
//    - 3 collimation screws thread through nuts (or heat-set inserts) CAPTURED
//      IN THE DISC. Their tips bear on the tower's flat mating face and PUSH it
//      away. Heads on the sky side, reached from the front opening past the vanes.
//    - The spider's STUD, in tension, pulls the tower back -- but not directly:
//      it squeezes a SPRING against a ledge inside the tower's central shaft, so
//      the pull is compliant. Screw a tip in -> that corner is pushed away. Back
//      it out -> the spring pulls it back. 3 corners = 2 tilt axes.
//
//        ┌─────────────┐
//        │   ╔═══╗     │  pull-nut, threaded on the stud
//        │   ║ § ║     │  spring, compressed between nut and ledge
//        │  ─╨───╨─    │  ledge -> pushes the TOWER toward the disc
//        └────────┼────┘
//                 │ stud, in tension
//        ═════╤═══╪══  DISC
//          ↓↓ │  ↓↓     3 screws push
//
//  A compression spring in the disc-to-tower GAP would only push the two apart
//  (the way the screws already do), so the spring lives INSIDE the tower, on the
//  far side of the joint, to pull instead. It also lets the tower rock with no
//  stiction and holds preload as the PLA creeps. The pull-nut sits in a HEXAGONAL
//  shaft -- keyed against rotation, free to slide -- so you thread the assembly on
//  by ROTATING THE TOWER, which also aims the mirror at the focuser; set aim that
//  way, then trim the gap with the disc's jam nuts.
//
//  SPRING AND NUT GO IN THROUGH THE POCKET FLOOR, BEFORE THE MIRROR IS BONDED.
//  After bonding they are unreachable.
//
//  OBSTRUCTION: everything sits between the sky and the glass, so the binding
//  dimension is the tower OD = bore + 2*wall. At 28.3 mm that is 24.8% of a
//  114 mm primary by diameter. Do not let `wall` grow casually.
//
//  NO RIM ABOVE THE GLASS on the focuser side: the 45 deg cut is HIGHEST there,
//  exactly where the reflected cone exits. `rim_drop` keeps the wall below the face.
//
//  MEASURE mirror_thk and the spider stud on arrival. Stud confirmed M6.
//
//  part = "assembly" | "section" | "section_tower" | "tower" | "disc" | "mirror"
// =====================================================================

part = "tower";

// ---- mirror ----
mirror_d     = 25;
mirror_thk   = 5;
mirror_tilt  = 45;

// ---- pocket ----
bore_clear   = 0.3;

// ---- tower ----
wall         = 1.5;
base_h       = 12;      // solid height below the pocket floor. Holds the ledge + spring;
                        //   the pull-nut and spare thread run up the shaft above it.
rim_drop     = 0.5;

// ---- tilt stage: 3 PUSH screws, nuts captured in the DISC ----
n_screws     = 3;
bolt_circle  = 9;       // RADIUS to the collimation screws
screw_clear  = 3.4;     // M3 clearance
nut_mode     = "pocket";// "pocket" = captured M3 hex nuts | "insert" = M3 heat-set brass.
                        //   Either way the feature opens on the TOWER-FACING face, so the
                        //   screw's reaction seats it INTO the disc rather than pushing it
                        //   out. Installing an insert from the sky face instead would load
                        //   it in its weakest direction.
nut_af       = 5.5;     // M3 DIN934 across flats     ] pocket mode
nut_thk      = 2.4;     //                            ]
nut_slack    = 0.3;     //                            ]
insert_hole_d = 4.0;    // insert mode: the HOLE size from the insert's datasheet, NOT its
                        //   OD -- heat-set inserts want a hole 0.4-0.6 under their OD so
                        //   there is material to melt and flow into the knurling.
insert_l      = 4.0;    // insert length. Must not exceed disc_thk.
gap_nom      = 6;       // nominal disc-to-tower gap at mid-travel. NOTHING is in this gap
                        //   now except the screw tips -- the spring moved inside the tower.
dimple_d     = 3.5;     // CONE DETENT at each screw tip. Nothing else locates the tower
dimple_angle = 90;      //   laterally -- the stud has stud_tilt_cl of radial slop -- so
                        //   without these the tower can walk around inside that slop as
                        //   the tube swings, which reads as collimation drift.
                        //   90 deg included is deliberate: the cone is cut into the BED
                        //   face, so its wall is a 45 deg overhang -- exactly printable.
                        //   Shallower (120, 150) droops. It is also a standard countersink
                        //   angle if you ever want to true it up with a drill.
                        //   dimple_d = 0 to omit. Steel washers were tried here and dropped:
                        //   at ~7 N the tip bears on PLA at ~2.6% of yield, so there is
                        //   nothing to protect against, and an M3 washer's 3.2 hole lets an
                        //   M3 tip pass straight through it anyway.

// ---- finger notch ----
// Retention is by the RTV bond plus the pocket's own friction -- no clips. (Snap tabs
// were tried and removed: too small to add real hold, and fiddly to print at this size.)
notch_enable = true;
notch_angle  = 0;               // THE TOP TIP (focuser side, highest rim). A cutout only
                                //   removes material, so it costs the beam nothing here, and
                                //   the exposed glass edge is easiest to reach from the top.
notch_width  = 8;               // tangential width of the finger scallop
notch_depth  = 3;               // how far below the local rim the scallop cuts down, exposing
                                //   the glass edge so you can push the mirror out

// ---- central tension member = the spider stud ----
stud_d       = 6;       // MEASURE. Could be M4/M5 or imperial.
stud_clear   = 0.6;     // clearance in the DISC (the disc does not tilt)
stud_tilt_cl = 1.2;     // EXTRA clearance in the TOWER's lower bore so it can rock.
                        //   1.2 over ledge_z = 6 allows ~11 deg, far past what is needed.
pull_nut_af  = 0;       // nut that threads onto the stud. 0 = AUTO from stud_d (DIN 934).
pull_nut_thk = 0;       //   Set both explicitly only for an imperial or odd stud.
ledge_z      = 6;       // height of the spring ledge above the tower's mating face

// ---- central spring: lives INSIDE the tower and provides the pull ----
pull_spring_od   = 0;   // 0 = AUTO, the widest that fits the hex shaft.
pull_spring_free = 10;  // free length. Compression is set by how far you thread the nut.

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
stud_bore_d = stud_d + stud_tilt_cl;            // lower bore: tilt clearance

// DIN 934 hex nut dimensions, so changing stud_d carries the nut and shaft with it
function din934_af(d)  = (d<=3) ? 5.5 : (d<=4) ? 7.0 : (d<=5) ?  8.0 : (d<=6) ? 10.0
                       : (d<=8) ? 13.0 : 0;
function din934_thk(d) = (d<=3) ? 2.4 : (d<=4) ? 3.2 : (d<=5) ?  4.0 : (d<=6) ?  5.0
                       : (d<=8) ?  6.5 : 0;
pull_nut_af_  = (pull_nut_af  == 0) ? din934_af(stud_d)  : pull_nut_af;
pull_nut_thk_ = (pull_nut_thk == 0) ? din934_thk(stud_d) : pull_nut_thk;

// hex shaft the pull-nut slides in: keyed against rotation, free to travel
shaft_af    = pull_nut_af_ + nut_slack;
shaft_cd    = shaft_af / cos(30);

// the annular land the spring actually sits on, at the top of the lower bore
spring_land = (shaft_af - stud_bore_d) / 2;

// widest spring/tube the shaft will take
pull_spring_od_ = (pull_spring_od == 0) ? shaft_af - 0.3 : pull_spring_od;

// cone detent depth, and how much of it the screw's end actually sinks into
dimple_h    = (dimple_d/2) / tan(dimple_angle/2);
screw_end_d = 2.4;                              // flat on a typical M3 cap-screw end
dimple_bite = (dimple_d - screw_end_d) / 2 / tan(dimple_angle/2);

// collimation screw: head on the sky face of the disc, through the disc, across the gap
cscrew_min = disc_thk + gap_nom - 2;
cscrew_max = disc_thk + gap_nom + 2;

// NOTE on radial limits: the mating faces of BOTH parts are solid right out to
// tower_r -- the mirror bore only begins above the pocket floor, far above any of
// these features. So the limit here is the outer wall, not bore_r.
assert(bolt_circle + dimple_d/2 < tower_r - 0.8, "cone detents run off the tower's rim");
assert(dimple_d == 0 || dimple_angle <= 90,
       "dimple_angle > 90 makes the cone wall a sub-45 deg overhang and it will droop -- the detent is cut into the face that sits on the bed");
assert(dimple_d == 0 || dimple_d > screw_end_d + 0.6,
       "dimple mouth is barely wider than the screw end -- it will not nest or centre");
disc_feat_d = (nut_mode == "insert") ? insert_hole_d : nut_cd;
assert(bolt_circle + disc_feat_d/2 < tower_r - 0.8,
       "disc nut pockets / insert bores break out of the disc rim");
assert(nut_mode != "insert" || insert_l <= disc_thk,
       "heat-set insert is longer than the disc is thick -- raise disc_thk to match");
assert(nut_mode == "insert" || nut_mode == "pocket", "nut_mode must be \"pocket\" or \"insert\"");
assert(bolt_circle - nut_cd/2 > (stud_d + stud_clear)/2 + 0.8,
       "disc nut pockets crowd the central stud hole");
assert(spring_land >= 0.8,
       "spring has almost no land to sit on -- reduce stud_tilt_cl or use a bigger nut");
assert(pull_spring_od_ <= shaft_af,
       "central spring is wider than the hex shaft it has to sit in");
assert(ledge_z + pull_spring_free + pull_nut_thk_ < floor_z0,
       "spring + nut are taller than the shaft -- raise base_h or shorten the spring");
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
//    round bore (stud passes through, oversize so the tower can rock)
//    -> LEDGE  -> hex shaft carrying the spring then the nut, running out
//    through the pocket floor so both can be dropped in from above.
// ---------------------------------------------------------------------
module central_channel() {
    translate([0, 0, -1])                                       // lower bore, tilt clearance
        cylinder(d = stud_bore_d, h = ledge_z + 1);
    translate([0, 0, ledge_z])                                  // hex shaft: spring, then nut
        cylinder(d = shaft_cd, h = tower_h, $fn = 6);
}

// ---------------------------------------------------------------------
function rim_z_at(phi) = rim_z0 + bore_r*cos(phi)*tan_t;

// finger scallop: removes the top notch_depth of the wall over notch_width, so a
// fingertip or tool can reach the glass edge and push the mirror back out
module notch_cut() {
    rotate([0, 0, notch_angle])
        translate([bore_r, 0, rim_z_at(notch_angle) - notch_depth])
            translate([-1, -notch_width/2, 0])
                cube([wall + 2, notch_width, tower_h]);
}

// ---------------------------------------------------------------------
//  TOWER -- printed flat-end DOWN, 45 deg cut UP. Fully self-supporting.
//  In the telescope the 45 deg end points at the primary.
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
        if (dimple_d > 0)                                       // cone detents under the tips
            screw_stations()
                translate([0, 0, -0.01])
                    cylinder(d1 = dimple_d, d2 = 0, h = dimple_h + 0.01);
        if (notch_enable) notch_cut();
    }
}

// ---------------------------------------------------------------------
//  DISC -- z = 0 is the SKY face (screw heads), z = disc_thk faces the tower.
//  The collimation nut pockets open on the TOWER-facing face: the screw tip
//  pushes the tower away, so the reaction seats each nut up against the solid
//  disc material above it rather than pushing it out of its pocket.
// ---------------------------------------------------------------------
module base_disc() {
    difference() {
        cylinder(d = disc_od, h = disc_thk);
        translate([0, 0, -1])                                   // stud clearance
            cylinder(d = stud_d + stud_clear, h = disc_thk + 2);
        screw_stations() {
            translate([0, 0, -1])                               // screw shank
                cylinder(d = screw_clear, h = disc_thk + 2);
            if (nut_mode == "insert")                           // heat-set bore, tower side
                translate([0, 0, disc_thk - insert_l])
                    cylinder(d = insert_hole_d, h = insert_l + 0.01);
            else                                                // hex nut pocket, tower side
                translate([0, 0, disc_thk - nut_thk - nut_slack])
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
    spring_fitted = pull_spring_free * 0.75;    // indicative compressed length

    tower();
    mirror_glass();
    translate([0, 0, -(gap_nom + disc_thk)]) base_disc();

    color("Silver", 0.55) {
        translate([0, 0, ledge_z])                              // the pull spring, in the shaft
            difference() {
                cylinder(d = pull_spring_od_, h = spring_fitted);
                translate([0, 0, -1])
                    cylinder(d = pull_spring_od_ - 1.6, h = spring_fitted + 2);
            }
        screw_stations()                                        // push screws, tips at the tower
            translate([0, 0, -(gap_nom + disc_thk)])
                cylinder(d = 3, h = gap_nom + disc_thk + dimple_bite);
    }
    color("Goldenrod", 0.8)                                     // the pull-nut, keyed in the hex
        translate([0, 0, ledge_z + spring_fitted])
            difference() {
                cylinder(d = shaft_cd, h = pull_nut_thk_, $fn = 6);
                translate([0, 0, -1]) cylinder(d = stud_d, h = pull_nut_thk_ + 2);
            }
    color("DimGray", 0.7)                                       // the stud, in tension
        translate([0, 0, -(gap_nom + disc_thk + 8)])
            cylinder(d = stud_d, h = gap_nom + disc_thk + ledge_z + spring_fitted
                                     + pull_nut_thk_ + 8);
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
// These screws SET the gap: whatever protrudes past the disc is where the tower ends up.
// Too long and the stack simply opens wider than gap_nom, dragging the spring and stud
// lengths with it. M3x12 lands the tip in the detents at close to the nominal gap.
echo(str("COLLIMATION SCREWS: 3x M3 socket cap, length under head ", cscrew_min, " to ",
        cscrew_max, " mm -> buy M3x12 (NOT longer: the tip would hold the gap open)"));
echo(nut_mode == "insert"
     ? str("COLLIMATION INSERTS: 3x M3 heat-set brass, ", insert_l, " mm long, into a ",
           insert_hole_d, " mm bore on the DISC tower-facing face. Fit from THAT face.")
     : str("COLLIMATION NUTS: 3x M3 hex, dropped into the DISC tower-facing face"));
echo(str("PULL SPRING: 1x compression, OD <= ", pull_spring_od_, " mm, ID > ", stud_bore_d,
        " mm, free length ", pull_spring_free, " mm. Sits on a ", spring_land,
        " mm land at z = ", ledge_z, " INSIDE the tower."));
echo(str("PULL NUT: 1x ", pull_nut_af_, " mm A/F to suit the stud thread. Slides in a hex ",
        "shaft, so it keys against rotation -- thread it on by TURNING THE TOWER."));
echo(str("  ^ SPRING AND NUT GO IN BEFORE THE MIRROR IS BONDED."));
echo(str("STUD must reach ", gap_nom + disc_thk + ledge_z, " to ",
        gap_nom + disc_thk + ledge_z + pull_spring_free + pull_nut_thk_,
        " mm below the spider hub face. MEASURE."));
