// =====================================================================
//  Curved-seat M4 NUT  (printed threads)  -- BACKUP part
//
//  Lets the ORIGINAL focuser mount to the carbon optical tube using the
//  SHORT existing screws. A normal nut fails for two reasons:
//    1. off-centre screws cross the concave inner wall at ~13 deg, so a
//       flat nut rocks and never clamps;
//    2. the screws are too short for a nut to reach + tighten.
//  This part is an ACTUAL threaded nut whose threads begin AT the curved
//  wall face, so the screw engages thread the instant it clears the wall,
//  using all the remaining length. The face is convex (matches the inner
//  wall) and can be tilted to sit flush on the off-centre holes.
//
//  Print THREE: seat_tilt = 0 (centre hole) and +13 / -13 (side holes).
//  Fit with the WINGS aligned to the tube's long axis. Hand-tighten by the
//  wings while turning the screw from outside.
// =====================================================================

// ---------- Tube inner wall ----------
tube_od   = 160.7;                       // optical tube OD
wall_thk  = 5;                           // wall thickness
wall_R    = (tube_od - 2*wall_thk) / 2;  // inner radius ~ 75.35 mm

// ---------- Which hole ----------
seat_tilt = 0;        // 0 = centre hole; +13 / -13 = the two side holes

// ---------- Thread (M4 x 0.7) ----------
nominal_d        = 4.0;
pitch            = 0.7;
thread_clearance = 0.75;   // printed-thread looseness; raise if too tight
tooth_ang        = 110;    // thread tooth angular width (deg) - profile tuning
right_hand       = 1;      // 1 = standard RH thread. If the screw won't
                           // start, set to -1 (flips handedness).
lead_in          = 0.6;    // chamfer at the wall-side mouth so the screw starts

// ---------- Self-tap fallback ----------
use_modeled_thread = true; // false => plain 3.3 mm pilot hole; the steel M4
pilot_d            = 3.3;  // screw cuts its own thread into the PETG.

// ---------- Body / grip ----------
nut_h    = 6;     // threaded body height (engagement length)
body_d   = 10;    // grip cylinder diameter
wing_len = 8;     // finger-wing reach beyond the body
wing_w   = 5;
wing_h   = 3;
top_marg = 4;     // stock above the wall apex, trimmed by the curve

$fn = 120;

// =====================================================================

module wall_seat() {
    // keep only what is inside the inner-wall cylinder -> convex tilted top
    translate([wall_R * sin(seat_tilt), 0, -wall_R * cos(seat_tilt)])
        rotate([90, 0, 0])
            cylinder(r = wall_R, h = body_d * 4, center = true, $fn = 480);
}

module male_thread(maj_d, p, length, clr, ang) {
    Rmaj  = maj_d/2 + clr/2;
    Rmin  = Rmaj - 0.6134 * p;     // ISO thread depth approximation
    turns = length / p;
    linear_extrude(height = length, twist = right_hand * -360 * turns,
                   convexity = 10, slices = ceil(turns * 24))
        union() {
            circle(r = Rmin, $fn = 48);
            polygon([[Rmin*cos( ang/2), Rmin*sin( ang/2)],
                     [Rmaj, 0],
                     [Rmin*cos(-ang/2), Rmin*sin(-ang/2)]]);
        }
}

module blank() {
    union() {
        translate([0, 0, -nut_h]) cylinder(d = body_d, h = nut_h + top_marg);
        for (s = [-1, 1])
            translate([-wing_w/2, s*(body_d/2 - 1), -nut_h])
                cube([wing_w, wing_len, wing_h]);
    }
}

module curved_nut() {
    intersection() {
        difference() {
            blank();
            if (use_modeled_thread)
                translate([0, 0, -nut_h - 1])
                    male_thread(nominal_d, pitch, nut_h + top_marg + 2,
                                thread_clearance, tooth_ang);
            else
                translate([0, 0, -nut_h - 1])
                    cylinder(d = pilot_d, h = nut_h + top_marg + 2);
            // lead-in chamfer at the wall-side mouth (top)
            translate([0, 0, top_marg - lead_in])
                cylinder(d1 = nominal_d*0.6, d2 = nominal_d + 1.2, h = lead_in + 0.1);
        }
        wall_seat();
    }
}

curved_nut();

echo(str("inner wall radius = ", wall_R, " mm (convex seat radius)"));
echo(str("seat_tilt = ", seat_tilt, " deg  | thread = M", nominal_d, " x ", pitch,
        right_hand == 1 ? "  RH" : "  LH"));
echo(str("mode = ", use_modeled_thread ? "MODELED THREAD" : str("SELF-TAP pilot ", pilot_d, " mm")));
