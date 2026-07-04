// =====================================================================
//  SECONDARY MIRROR HOLDER  -- v1, MIRROR MOUNT ONLY
//
//  Holds a 25 mm elliptical Newtonian secondary (AliExpress FJ-25,
//  ~35 mm major axis) at 45 deg to the incoming light path. Replaces
//  the builder's GLUE job (which let the old mirror fall off during
//  collimation) with a proper mechanical seat.
//
//  How it works:
//    - A 45 deg wedge presents a flat elliptical PAD to the beam.
//    - The mirror's uncoated BACK rests on the pad; its coated FIRST
//      SURFACE faces the beam. It is held by 3 SILICONE DABS (standard
//      practice -- allows thermal expansion, and is removable).
//    - A shallow RETAINING LIP rings the mirror edge as a mechanical
//      backstop (belt-and-suspenders after the glue failure). The lip
//      is deliberately SHORTER than the glass so it never shadows the
//      reflective surface -- enforced by an assert() below.
//    - 3 shallow POCKETS key the silicone dabs to the pad.
//
//  v1 SCOPE: the mirror-holding part only. The back of the wedge is a
//  plain flat placeholder face for a FUTURE hub/spider attach part --
//  no hub coupling, no collimation adjustment in v1.
//
//  All mirror dimensions are parameters. The replacement mirror had not
//  arrived at design time: MEASURE mirror_thk (and the real major axis)
//  on arrival and re-export.
//
//  part = "holder" | "mirror" | "coupon"
//    holder = the printable part (default).
//    mirror = holder + a mock glass slab, for a visual sanity check only.
//    coupon = just the seat on a flat plate -- a cheap mirror-fit /
//             silicone test print before committing the full part.
// =====================================================================

part = "holder";

// ---- mirror (measure on arrival; re-export) ----
mirror_minor = 25;      // minor axis (short) = the effective aperture stop, mm
mirror_major = 0;       // major axis (long), lies IN the 45 deg tilt plane.
                        //   0 = AUTO (mirror_minor / cos(tilt) ~ 35.36 for 45 deg).
                        //   Set to the caliper-measured major once the mirror arrives.
mirror_thk   = 4;       // GUESS 3-5 mm -- CONFIRM on arrival (drives lip clearance).
edge_clear   = 0.4;     // gap around the mirror edge inside the lip, per side.

// ---- seat / lip ----
tilt         = 45;      // mirror tilt vs the incoming light path (deg).
lip_h        = 1.5;     // lip height above the pad. MUST stay < mirror_thk (else the
                        //   lip shadows the reflective front surface -- see assert).
lip_w        = 1.5;     // lip wall thickness.
silicone_pocket = true; // 3 shallow pockets to key the silicone dabs.
pocket_d     = 6;       // silicone pocket diameter.
pocket_depth = 0.8;     // silicone pocket depth (shallow -- just a key).

// ---- body ----
seat_margin  = 4;       // body border around the lip on the seat face. Also sets the
                        //   backing thickness under the mirror ends -- do not go tiny.
coupon_thk   = 3;       // plate thickness for the "coupon" test print.

// ---- future hooks (leave 0 in v1) ----
offset_major = 0;       // secondary offset along the slope (mm). <1 mm at f/7.9 -- v1 = 0.
offset_minor = 0;       // secondary offset across the slope (mm). v1 = 0.

// ---- render quality ----
$fn = 120;

// =====================================================================

// ---- derived ----
major   = (mirror_major == 0) ? mirror_minor / cos(tilt) : mirror_major;

seat_x  = mirror_minor + 2*edge_clear + 2*lip_w;   // outer lip extent, across slope (X)
seat_y  = major        + 2*edge_clear + 2*lip_w;   // outer lip extent, along slope (Y)

W       = seat_x + 2*seat_margin;                  // body width (X)
hyp_len = seat_y + 2*seat_margin;                  // length of the 45 deg seat face
L       = hyp_len / sqrt(2);                        // triangle leg of the wedge

pocket_bcr = mirror_minor * 0.3;                   // silicone pocket bolt-circle radius

// The lip must not stand proud of the reflective (front) surface, or it
// obstructs light and casts a shadow into the view.
assert(lip_h < mirror_thk,
       "lip_h must be < mirror_thk, else the retaining lip shadows the mirror's reflective face");

// ---------------------------------------------------------------------
//  Seat primitives -- built in a LOCAL frame where the pad is the XY
//  plane, the mirror sits on +Z, major axis along Y, minor axis along X.
// ---------------------------------------------------------------------

module pad_ellipse(mn, mj) {          // ellipse: X-diameter = mn, Y-diameter = mj
    translate([offset_minor, offset_major, 0])
        scale([mn, mj]) circle(d = 1);
}

module lip() {
    linear_extrude(lip_h)
        difference() {
            pad_ellipse(seat_x, seat_y);                                   // outer
            pad_ellipse(mirror_minor + 2*edge_clear, major + 2*edge_clear); // inner (mirror drops in)
        }
}

module pockets() {
    if (silicone_pocket)
        for (i = [0:2])
            rotate([0, 0, 120*i + 90])
                translate([0, pocket_bcr, 0])
                    translate([0, 0, -pocket_depth])
                        cylinder(d = pocket_d, h = pocket_depth + 0.01);
}

// Place children onto the 45 deg seat face of the wedge (local +Z = outward normal).
module on_seat() {
    translate([0, L/2, L/2])
        rotate([-tilt, 0, 0])
            children();
}

// ---------------------------------------------------------------------
//  Wedge body -- right-triangular prism. Cross-section in YZ is a right
//  triangle with legs L (right angle at the origin); extruded W along X.
//  Faces:  z = 0  -> bottom (goes on the print bed)
//          y = 0  -> flat vertical face = PLACEHOLDER hub interface (v1)
//          y+z=L  -> the 45 deg mirror seat (hypotenuse)
// ---------------------------------------------------------------------

module wedge() {
    translate([-W/2, 0, 0])
        rotate(120, [1, 1, 1])          // cyclic axis map: local x->Y, y->Z, z->X
            linear_extrude(height = W)
                polygon([[0, 0], [L, 0], [0, L]]);
}

module holder() {
    difference() {
        union() {
            wedge();
            on_seat() lip();
        }
        on_seat() pockets();
    }
}

module mirror_slab() {
    color("SkyBlue", 0.55)
        on_seat()
            linear_extrude(mirror_thk)
                pad_ellipse(mirror_minor, major);
}

// Flat test coupon: same seat features on a small plate, no 45 deg wedge.
module coupon() {
    difference() {
        union() {
            translate([-W/2, -hyp_len/2, -coupon_thk])
                cube([W, hyp_len, coupon_thk]);
            lip();
        }
        pockets();
    }
}

// ---------------------------------------------------------------------
if (part == "holder")      holder();
else if (part == "mirror") { holder(); mirror_slab(); }
else if (part == "coupon") coupon();
else                       echo(str("unknown part: ", part));

// ---- Derived values printed to console on render ----
echo(str("mirror = ", mirror_minor, " x ", major, " mm (minor x major), thk ", mirror_thk, " mm"));
echo(str("pad recess (mirror + clearance) = ",
        mirror_minor + 2*edge_clear, " x ", major + 2*edge_clear, " mm"));
echo(str("lip: outer ", seat_x, " x ", seat_y, " mm, height ", lip_h,
        " mm  -> clears reflective face by ", mirror_thk - lip_h, " mm"));
echo(str("seat face (45 deg) = ", W, " x ", hyp_len, " mm"));
echo(str("body envelope (WxYxZ) = ", W, " x ", L, " x ", L, " mm"));
