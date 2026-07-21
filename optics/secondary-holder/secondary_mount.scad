// =====================================================================
//  SECONDARY MOUNT  -- v2, BONDED POCKET + 3-SCREW SPRUNG TILT STAGE
//
//  Replaces the v1 snap-arm clamp (see secondary_holder_hooks_v1.scad,
//  which works but relies partly on side friction and has no collimation
//  adjustment). Two printed parts:
//
//    TOWER  -- a cylinder cut at 45 deg. The mirror drops STRAIGHT DOWN
//              the tower axis into a plain cylindrical bore with a 45 deg
//              floor, and is bonded in with 3 dabs of neutral-cure RTV.
//    DISC   -- a flat disc that clamps onto the spider's central stud with
//              two jam nuts. Carries the 3 collimation screws.
//
//  WHY THE POCKET IS JUST A BORE: the mirror was cut from a round glass
//  rod at 45 deg, and that rod's axis IS the tube axis -- the 25 mm minor
//  axis is simply the beam cross-section it intercepts. So along the tower
//  axis the glass is a plain cylinder, and its shear is already baked in.
//  Do NOT model the pocket by extruding the mirror ELLIPSE perpendicular
//  to the 45 deg face: the mirror is an oblique prism whose back ellipse
//  sits a full mirror_thk off the front one, so a right-prism pocket misses
//  by 5 mm at the bottom and the glass will not go in.
//
//  TILT STAGE: 3 screws pass down through the disc, through a compression
//  spring, and thread into nuts captured in the tower. Screw in -> that
//  corner is pulled UP toward the disc. Screw out -> the spring pushes it
//  back down. Bidirectional and backlash-free; no central bolt, which
//  would only fight the tilt. Heads face the sky so you reach them from
//  the front opening, past the vanes.
//
//  OBSTRUCTION: everything here sits between the sky and the glass, so the
//  binding dimension is the tower OD = bore + 2*wall. At 28.3 mm that is
//  24.8% of a 114 mm primary by diameter. Do not let `wall` grow casually.
//
//  NO RIM ABOVE THE GLASS. The 45 deg cut is HIGHEST on the focuser side,
//  which is exactly where the reflected cone exits. `rim_drop` keeps the
//  tower wall below the mirror face everywhere so it cannot vignette.
//
//  MEASURE mirror_thk and the spider stud on arrival.
//
//  part = "assembly" | "section" | "tower" | "disc" | "mirror"
// =====================================================================

part = "assembly";

// ---- mirror (measure; these are the v1 confirmed values) ----
mirror_d     = 25;      // dia of the glass ROD it was cut from = minor axis = beam stop
mirror_thk   = 5;       // face-to-face, PERPENDICULAR (caliper across the faces)
mirror_tilt  = 45;      // the tilt it was ground for

// ---- pocket ----
bore_clear   = 0.3;     // diametral clearance = the RTV glue gap. 0.3 is a slip fit.
eject_d      = 4;       // axial hole through the tower: push the glass out with a rod
                        //   if you ever need to. 0 = omit.

// ---- tower ----
wall         = 1.5;     // OBSTRUCTION KNOB. tower_od = bore_d + 2*wall.
base_h       = 12;      // solid height below the pocket floor's lowest point. Must swallow
                        //   the nut pocket plus spare thread -- see the echoed screw window.
rim_drop     = 0.5;     // tower wall cut this far BELOW the mirror face plane, so no rim
                        //   can ever stand proud into the outgoing beam.

// ---- tilt stage ----
n_screws     = 3;
bolt_circle  = 9;       // RADIUS to the collimation screws.
screw_clear  = 3.4;     // M3 clearance
nut_af       = 5.5;     // M3 DIN934 across flats
nut_thk      = 2.4;
nut_depth    = 3.0;     // nut pocket starts this far below the tower's mating face
nut_slack    = 0.3;     // added to AF and thickness so a real nut drops in
spring_seat_d = 6.6;    // locating counterbore for the spring, in BOTH parts
spring_seat_h = 1.5;
gap_nom      = 6;       // nominal disc-to-tower gap at mid-travel = working spring length

// ---- disc ----
disc_thk     = 5;
stud_d       = 5;       // spider stud DIAMETER. MEASURE -- could be M4/M5 or imperial.
stud_clear   = 0.6;     // clearance so the disc can be shifted before the nuts are locked

// ---- render quality ----
$fn = 120;

// =====================================================================
// ---- derived ----
tan_t    = tan(mirror_tilt);
vert_thk = mirror_thk / cos(mirror_tilt);   // vertical height of the glass band (7.07 @ 45)

bore_d   = mirror_d + bore_clear;
bore_r   = bore_d / 2;
tower_od = bore_d + 2*wall;
tower_r  = tower_od / 2;
disc_od  = tower_od;                        // no reason for the disc to be wider

// The three defining planes, all parallel, all at mirror_tilt, given by their
// height ON THE AXIS (x = 0). Height at any x is  z0 + x*tan_t.
//   floor : the pocket floor the glass beds onto
//   face  : the reflective face = floor + one glass thickness
//   rim   : where the tower's outer wall is cut, held below face
floor_z0 = base_h + bore_r*tan_t;           // so the floor's lowest point over the bore = base_h
face_z0  = floor_z0 + vert_thk;
rim_z0   = face_z0 - rim_drop;

tower_h  = rim_z0 + tower_r*tan_t;          // tallest point, on the focuser side

// hex pocket: OpenSCAD's cylinder($fn=6) is sized by CIRCUMdiameter
nut_cd   = (nut_af + nut_slack) / cos(30);

// The spring is NOT squashed to gap_nom -- it also fills both seat counterbores.
// Getting this wrong buys a spring that is barely compressed and gives no preload.
spring_work = gap_nom + 2*spring_seat_h;
spring_free = spring_work / 0.7;            // ~30% compression at mid-travel

// usable screw-length window (length under the head)
screw_min = disc_thk + gap_nom + nut_depth + nut_thk;
screw_max = disc_thk + gap_nom + base_h - 0.5;

// the mating face is solid out to tower_r -- the mirror bore only begins above the
// pocket floor, far above the nut pockets -- so the limit is the outer wall, not bore_r
assert(bolt_circle + nut_cd/2 < tower_r - 0.8,
       "nut pockets break out of the tower's rim -- shrink bolt_circle or the nut");
assert(rim_drop > 0,
       "rim_drop must be > 0 or the tower wall can vignette the outgoing beam");
assert(nut_depth + nut_thk + nut_slack < base_h,
       "base_h is too short to contain the nut pocket");
assert(screw_min < screw_max, "no valid screw length -- raise base_h");

// ---------------------------------------------------------------------
//  Halfspace ABOVE the plane  z = z0 + x*tan(mirror_tilt).
//  Rotating a +z halfspace about Y by -tilt gives exactly z >= x*tan(tilt).
// ---------------------------------------------------------------------
module slant_above(z0, big = 400) {
    translate([0, 0, z0])
        rotate([0, -mirror_tilt, 0])
            translate([-big/2, -big/2, 0])
                cube([big, big, big]);
}

// the slab of material between two parallel slant planes
module slant_slab(z_lo, z_hi) {
    difference() { slant_above(z_lo); slant_above(z_hi); }
}

// ---------------------------------------------------------------------
//  One collimation screw station, cut from the TOWER base.
//  Bottom (z = 0) is the mating face. Working upward:
//    spring seat -> clearance shank -> hex nut pocket -> spare-thread relief
//  The nut pocket is buried, so it gets a side slot out through the wall to
//  drop the nut in. The relief stops at base_h, which is by construction
//  below the pocket floor at every screw position, so it cannot break through.
// ---------------------------------------------------------------------
module screw_station_tower() {
    translate([0, 0, -0.01])                                   // spring seat
        cylinder(d = spring_seat_d, h = spring_seat_h + 0.01);
    translate([0, 0, -1])                                      // shank clearance
        cylinder(d = screw_clear, h = nut_depth + 1);
    translate([0, 0, nut_depth])                               // nut pocket
        cylinder(d = nut_cd, h = nut_thk + nut_slack, $fn = 6);
    translate([-(nut_af + nut_slack)/2, 0, nut_depth])         // side slot to insert it
        cube([nut_af + nut_slack, tower_r + 2, nut_thk + nut_slack]);
    translate([0, 0, nut_depth])                               // spare-thread relief
        cylinder(d = screw_clear, h = base_h - nut_depth);
}

module screw_stations() {
    for (i = [0 : n_screws-1])
        rotate([0, 0, i * 360/n_screws])
            translate([bolt_circle, 0, 0])
                children();
}

// ---------------------------------------------------------------------
//  TOWER -- printed flat-end DOWN, 45 deg cut UP. Everything is either a
//  vertical wall or an upward-facing 45 deg ramp, so it needs no supports.
//  (In the telescope it is inverted: the 45 deg end points at the primary.)
// ---------------------------------------------------------------------
module tower() {
    difference() {
        difference() {                                  // body, cut by the rim plane
            cylinder(d = tower_od, h = tower_h + 1);
            slant_above(rim_z0);
        }
        intersection() {                                // mirror pocket = bore above the floor
            translate([0, 0, -1]) cylinder(d = bore_d, h = tower_h + 3);
            slant_above(floor_z0);
        }
        if (eject_d > 0)                                // ejection / lightening hole
            translate([0, 0, -1]) cylinder(d = eject_d, h = tower_h + 3);

        screw_stations() screw_station_tower();
    }
}

// ---------------------------------------------------------------------
//  DISC -- printed flat, spring seats UP. Clamps to the stud with two jam
//  nuts (one each side), which sets stack height and rotation independently.
// ---------------------------------------------------------------------
module base_disc() {
    difference() {
        cylinder(d = disc_od, h = disc_thk);
        translate([0, 0, -1])                                   // stud clearance
            cylinder(d = stud_d + stud_clear, h = disc_thk + 2);
        screw_stations() {
            translate([0, 0, -1])                               // screw clearance
                cylinder(d = screw_clear, h = disc_thk + 2);
            translate([0, 0, disc_thk - spring_seat_h])         // spring seat, top face
                cylinder(d = spring_seat_d, h = spring_seat_h + 0.01);
        }
    }
}

// mock glass: the slab of a mirror_d cylinder between the floor and face planes
module mirror_glass() {
    color("SkyBlue", 0.6)
        intersection() {
            translate([0, 0, -1]) cylinder(d = mirror_d, h = tower_h + 3);
            slant_slab(floor_z0, face_z0);
        }
}

// ---------------------------------------------------------------------
//  ASSEMBLY VIEW. The disc is drawn BELOW the tower's mating face, i.e. the
//  stack is shown upside-down relative to the telescope (where the disc is
//  up at the spider hub and the 45 deg end hangs down toward the primary).
//  Geometrically identical; just easier to read next to the print orientation.
// ---------------------------------------------------------------------
module assembly() {
    tower();
    mirror_glass();
    translate([0, 0, -(gap_nom + disc_thk)]) base_disc();
    color("Silver", 0.5)                                        // springs, indicative
        screw_stations()
            translate([0, 0, -gap_nom])
                difference() {
                    cylinder(d = spring_seat_d - 0.6, h = gap_nom);
                    translate([0, 0, -1]) cylinder(d = screw_clear + 0.6, h = gap_nom + 2);
                }
}

// half the assembly removed, cut on the tilt plane -- the only view that shows
// the pocket floor, the nut pockets and the spring gap all at once
module half_cut() {
    difference() {
        children();
        translate([-200, -200, -200]) cube([400, 200, 400]);
    }
}

// ---------------------------------------------------------------------
if      (part == "section")  half_cut() assembly();
else if (part == "section_tower") half_cut() tower();
else if (part == "assembly") assembly();
else if (part == "tower")    tower();
else if (part == "disc")     base_disc();
else if (part == "mirror")   mirror_glass();
else                         echo(str("unknown part: ", part));

// ---- derived values echoed on render ----
echo(str("mirror = ", mirror_d, " dia rod, ", mirror_thk, " mm thick, cut at ", mirror_tilt,
        " deg -> face ellipse ", mirror_d, " x ", mirror_d/cos(mirror_tilt),
        ", vertical glass band ", vert_thk, " mm"));
echo(str("tower = ", tower_od, " mm OD, ", tower_h, " mm tall, bore ", bore_d,
        " mm, wall ", wall, " mm"));
echo(str("OBSTRUCTION: tower OD ", tower_od, " mm = ", 100*tower_od/114,
        "% of a 114 mm primary by diameter (mirror alone would be ", 100*mirror_d/114, "%)"));
echo(str("mirror face sits ", face_z0, " mm above the tower's mating face, on the axis"));
echo(str("stack height, disc bottom to mirror face = ", disc_thk + gap_nom + face_z0, " mm"));
echo(str("SCREWS: 3x M3, length under head between ", screw_min, " and ", screw_max,
        " mm -> buy M3x20"));
echo(str("SPRINGS: 3x compression, OD <= ", spring_seat_d - 0.2, " mm, ID > ", screw_clear,
        " mm. Squashed length = ", spring_work, " mm (gap ", gap_nom,
        " + both seats), so buy free length ~", spring_free, " mm"));
echo(str("NUTS: 3x M3 hex captured in the tower (side slots), 2x ", stud_d,
        " mm jam nuts on the spider stud"));
