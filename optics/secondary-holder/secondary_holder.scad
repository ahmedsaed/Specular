// =====================================================================
//  SECONDARY MIRROR HOLDER  -- v1, SNAP-ARM CLAMP (oblique-prism mirror)
//
//  Holds a 25 mm elliptical Newtonian secondary (AliExpress FJ-25) by
//  CLAMPING ITS EDGES with 4 short flexible hooks. Replaces the builder's
//  GLUE job (which let the old mirror fall off during collimation) with a
//  light, tool-free clamp.
//
//  THE MIRROR IS A 45-DEGREE CUT -- an OBLIQUE (sheared) elliptical prism,
//  not a flat plate: a slice of a glass cylinder cut at 45 deg. The
//  reflective TOP ellipse and the BACK ellipse are the same size but the
//  top is SHIFTED along the long (major) axis by `mirror_shear`, so the
//  side wall is a slanted band.
//
//  KEY IDEA: a 45-deg-cut mirror is just a vertical elliptical prism that
//  has been SHEARED along the major axis. So the whole upper assembly --
//  the mock mirror AND the 4 hooks -- is built vertically (the earlier,
//  approved geometry: short curved hooks at +/-45 deg, inward-only lip,
//  flush at the plate edge) and then sheared as one. Every hook then leans
//  to follow the glass wall; the two +major hooks lean OUTWARD (looser =
//  slide-in side) and the two -major hooks lean INWARD (tighter = clip
//  side). The PLATE is NOT sheared -- it stays flat on the bed.
//
//  This part lives IN THE MIRROR'S OWN PLANE (a flat clamp). The 45 deg
//  tilt toward the focuser is the MOUNT's job (future ball-stalk / spider
//  screw on the blank plate back). No collimation adjustment in v1.
//
//  MEASURE mirror_thk, the real major axis, and the shear on arrival.
//
//  part = "holder" | "mirror" | "coupon"
// =====================================================================

part = "holder";

// ---- mirror (measure on arrival; re-export) ----
mirror_minor = 25;      // minor axis (short) = the effective aperture stop, mm
mirror_major = 0;       // major axis (long). 0 = AUTO from the tilt below.
mirror_thk   = 4;       // face-to-face thickness. GUESS 3-5 mm -- CONFIRM on arrival.
mirror_tilt  = 45;      // the tilt the mirror is GROUND for; sets the major/minor ratio.
mirror_shear = 0;       // sideways offset of the TOP face vs the back, along +major.
                        //   0 = AUTO = mirror_thk (exact for a 45 deg cut). MEASURE on arrival.
edge_clear   = 0.4;     // gap between a hook's inner face and the glass edge, per side.

// ---- plate ----
plate_thk    = 4.5;     // backing-plate thickness (NOT sheared -- prints flat).
                        //   4.5 = 3.0 mm cap-head counterbore + 1.5 mm clamp floor. Drop to
                        //   2.5 with a countersunk (flat) head to save weight.
tab_margin   = 0.8;     // root collar around each hook foot. These local tabs are the ONLY
                        //   plate material beyond the mirror edge (keeps the light path clear).

// ---- centre mount screw (through the back plate; head recessed on the mirror side) ----
center_screw = true;    // set false to omit.
screw_shank_d = 3.4;    // clearance hole. M3 = 3.4, M2 = 2.4.
screw_head_style = "counterbore";  // "countersink" (flat head -- fits a thin plate) |
                                   // "counterbore" (cap/pan head -- needs plate >= head_h).
screw_head_d = 6.0;     // head OD. M3 flat ~6.0, M3 cap 5.5 ; M2 flat ~4.0, M2 cap 3.8.
screw_head_h = 3.0;     // head height (only used for "counterbore"). M3 cap = 3.0, M2 cap = 2.0.

// ---- hooks (the snap clamp) ----
arm_off      = 30;      // each hook this many deg from the LONG (major) axis end. Two hooks
                        //   straddle each end (+/-arm_off). 45 = evenly spaced; smaller = nearer
                        //   the tips (aligns the lean with the slide-in direction -> easier insert).
arm_wall     = 1.8;     // hook RADIAL thickness = the flex spring. Thinner = softer snap.
arm_span     = 4;       // hook LENGTH along the edge (deg of arc). Shorter = smaller hooks.
hook_grip    = 1.0;     // how far the lip covers the mirror FRONT face (mm). Keep small.
hook_lip_thk = 1.2;     // vertical thickness of the retaining lip.
hook_clamp   = 0.05;    // lip underside this far BELOW the front face = light preload.
lead_in      = 0.4;     // top-of-lip snap bevel (must stay < hook_grip).
arm_root     = 0.6;     // how far a hook foot sinks into the plate (weld overlap).

// ---- seating (print both, compare) ----
seat_mode    = "pads";  // "pads" = 3 contact bumps (no rock) | "flat" = full backing.
pad_count    = 3;
pad_d        = 5;
pad_h        = 0.6;
pad_phi0     = 90;
pad_bcr      = 0;       // 0 = AUTO (well inside the back ellipse).

// ---- coupon test print ----
coupon_thk   = 3;

// ---- render quality ----
$fn = 120;

// =====================================================================
// ---- derived ----
major   = (mirror_major == 0) ? mirror_minor / cos(mirror_tilt) : mirror_major;
a       = mirror_minor / 2;                 // semi-minor (X radius)
b       = major        / 2;                 // semi-major (Y radius)
shear_  = (mirror_shear == 0) ? mirror_thk : mirror_shear;

chamf   = (lead_in == 0) ? hook_lip_thk : lead_in;

// centre-screw head recess depth (90 deg countersink: depth = radius growth)
screw_head_depth = (screw_head_style == "countersink")
                   ? (screw_head_d - screw_shank_d) / 2
                   : screw_head_h;
hook_over = hook_grip + edge_clear;         // total inward reach of the lip from the hook face

// heights, measured from the PLATE TOP (local hook frame) ----
lseat   = (seat_mode == "pads") ? pad_h : 0;  // mirror back plane
lfront  = lseat + mirror_thk;                 // mirror front (reflective) plane
llip0   = lfront - hook_clamp;                // lip underside
larm_h  = llip0 + hook_lip_thk;               // hook total height above the plate top

// absolute z of the mirror back plane, and the shear rate
seat_z  = plate_thk + lseat;
ky      = shear_ / mirror_thk;                // +major (Y) offset per unit z above seat_z

pad_bcr_ = (pad_bcr == 0) ? 0.5 * min(a, b) : pad_bcr;

// radius to the mirror edge at a geometric angle phi (ellipse polar form)
function ell_r(phi) = 1 / sqrt(pow(cos(phi)/a, 2) + pow(sin(phi)/b, 2));

// hook angles: two straddling the +major end, two straddling the -major end
arm_angles = [90 - arm_off, 90 + arm_off, 270 - arm_off, 270 + arm_off];

// tangential arc a hook spans, and sweep resolution
arm_arc = ell_r(90 - arm_off) * arm_span * PI / 180;
arm_seg = max(4, ceil(arm_span / 2));

assert(hook_grip > 0,           "hook_grip must be > 0, else a lip does not retain the mirror");
assert(hook_clamp < mirror_thk, "hook_clamp must be < mirror_thk");
assert(chamf < hook_over,       "lead_in is larger than the lip reach -- reduce lead_in or raise hook_grip");
assert(!center_screw || screw_head_depth < plate_thk,
       "screw head is deeper than the plate -- use a countersunk head, a smaller screw, or a thicker plate");

// ---------------------------------------------------------------------
//  Shear: turns the vertical assembly into the 45-deg-cut oblique one.
//  y -> y + ky*(z - seat_z), so the mirror back (z = seat_z) is unmoved
//  and the front (z = seat_z + thk) is offset by exactly `shear_`.
// ---------------------------------------------------------------------
module shear_major() {
    multmatrix([[1, 0,  0,  0        ],
                [0, 1,  ky, -ky*seat_z],
                [0, 0,  1,  0        ],
                [0, 0,  0,  1        ]]) children();
}

// ---------------------------------------------------------------------
//  2D helper + plate + pads (plate/pads are NOT sheared)
// ---------------------------------------------------------------------
module ellipse2d(dx, dy) { scale([dx, dy]) circle(d = 1); }   // X-dia, Y-dia

module plate() {
    linear_extrude(plate_thk)
        union() {
            ellipse2d(mirror_minor, major);                    // plate = mirror outline, nothing more
            offset(r = tab_margin)                             // local tabs ONLY under the hook feet
                projection(cut = true)
                    translate([0, 0, -plate_thk]) shear_major() arms();
        }
}

module pads() {                                                // support the back ellipse
    if (seat_mode == "pads")
        for (i = [0 : pad_count-1])
            rotate([0, 0, pad_phi0 + i*360/pad_count])
                translate([pad_bcr_, 0, plate_thk - 0.01])
                    cylinder(d = pad_d, h = pad_h + 0.01);
}

// central mount hole: clearance shank through the plate + a head recess on
// the FRONT (mirror) face. Thread exits the flat BACK into the future mount.
module center_screw_cut() {
    translate([0, 0, -1])                                      // clearance shank
        cylinder(d = screw_shank_d, h = plate_thk + 2);
    if (screw_head_style == "counterbore")                     // cap/pan head recess
        translate([0, 0, plate_thk - screw_head_depth])
            cylinder(d = screw_head_d, h = screw_head_depth + 0.01);
    else                                                       // countersunk flat head
        translate([0, 0, plate_thk - screw_head_depth])
            cylinder(d1 = screw_shank_d, d2 = screw_head_d, h = screw_head_depth + 0.001);
}

// ---------------------------------------------------------------------
//  Hooks (built VERTICAL, then sheared). Radial cross-section = an
//  upright WALL plus an INWARD-only hooking LIP; each convex piece is
//  swept along the ellipse by hulling thin slices. Coords: x = radial
//  (outward +) from the wall inner face (x = 0, sitting edge_clear
//  outside the glass); z = height above the plate top.
// ---------------------------------------------------------------------
arm_wall_profile = [
    [0,        -arm_root],
    [arm_wall, -arm_root],
    [arm_wall,  larm_h  ],
    [0,         larm_h  ],
];
arm_lip_profile = [
    [-hook_over,       llip0       ],
    [0,                llip0       ],
    [0,                larm_h      ],
    [-hook_over+chamf, larm_h      ],
    [-hook_over,       larm_h-chamf],
];

module arm_slice(profile, phi) {
    rotate([0, 0, phi])
        translate([ell_r(phi) + edge_clear, 0, plate_thk])
            rotate([90, 0, 0])
                linear_extrude(0.02, center = true)
                    polygon(profile);
}
module arm_sweep(profile, phi0, phi1) {
    step = (phi1 - phi0) / arm_seg;
    for (k = [0 : arm_seg-1])
        hull() {
            arm_slice(profile, phi0 + k*step);
            arm_slice(profile, phi0 + (k+1)*step);
        }
}
module arms() {                                    // built vertical -- caller shears
    for (phi = arm_angles) {
        arm_sweep(arm_wall_profile, phi - arm_span/2, phi + arm_span/2);
        arm_sweep(arm_lip_profile,  phi - arm_span/2, phi + arm_span/2);
    }
}

// straight single hook (wall + lip), for the flat coupon
module one_arm(w = arm_arc) {
    rotate([90, 0, 0])
        linear_extrude(w, center = true) {
            polygon(arm_wall_profile);
            polygon(arm_lip_profile);
        }
}

// ---------------------------------------------------------------------
module holder() {
    difference() {
        union() {
            plate();
            pads();
            shear_major() arms();                  // hooks lean to follow the 45 deg wall
        }
        if (center_screw) center_screw_cut();
    }
}

// mock glass: a VERTICAL prism, sheared into the oblique 45-deg-cut shape
module mirror_slab() {
    color("SkyBlue", 0.55)
        shear_major()
            translate([0, 0, seat_z])
                linear_extrude(mirror_thk)
                    ellipse2d(mirror_minor, major);
}

// coupon: two hooks (outward-lean @ +major, inward-lean @ -major) on a
// flat bar, so the slide-and-clip can be rehearsed with a 45 deg shim.
module coupon() {
    span = b + shear_ + arm_wall + 8;
    union() {
        translate([-(arm_arc/2 + 6), -b - arm_wall - 4, plate_thk - coupon_thk])
            cube([arm_arc + 12, span, coupon_thk]);
        shear_major() {
            arm_sweep(arm_wall_profile, (90-arm_off) - arm_span/2, (90-arm_off) + arm_span/2);
            arm_sweep(arm_lip_profile,  (90-arm_off) - arm_span/2, (90-arm_off) + arm_span/2);
            arm_sweep(arm_wall_profile, (270+arm_off) - arm_span/2, (270+arm_off) + arm_span/2);
            arm_sweep(arm_lip_profile,  (270+arm_off) - arm_span/2, (270+arm_off) + arm_span/2);
        }
    }
}

// ---------------------------------------------------------------------
if (part == "holder")      holder();
else if (part == "mirror") { holder(); mirror_slab(); }
else if (part == "coupon") coupon();
else                       echo(str("unknown part: ", part));

// ---- derived values echoed on render ----
echo(str("mirror = ", mirror_minor, " x ", major, " mm, thk ", mirror_thk,
        " mm, shear ", shear_, " mm along +major (lean ", atan(ky), " deg)"));
echo(str("plate = mirror ellipse (", mirror_minor, " x ", major, ") + hook tabs, thk ", plate_thk, " mm"));
echo(str("hooks = 4 @ ", arm_off, " deg from the long axis (", arm_angles, "), ",
        arm_span, " deg arc (~", arm_arc, " mm), ", arm_wall, " mm wall; lip grips ", hook_grip, " mm"));
echo(str("+major hooks lean outward (slide-in) ; -major hooks lean inward (clip)"));
echo(str("clear minor aperture = ", mirror_minor, " mm"));
if (center_screw)
    echo(str("centre screw: ", screw_shank_d, " mm shank, ", screw_head_style, " head OD ",
            screw_head_d, " mm, recess ", screw_head_depth, " mm of ", plate_thk, " mm plate"));
