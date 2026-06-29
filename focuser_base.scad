// =====================================================================
//  Telescope Focuser — Tube-Side Base (replica of existing bottom base)
//  Phase 1: faithful drop-in replacement for the focuser's bottom base.
//
//  The focuser is a 3-layer stack (lid -> rotating cylinder -> base)
//  held by 3 long M4 screws. This part replaces ONLY the bottom base:
//    - concave saddle on the bottom (matches the optical tube)
//    - flat top face (the rotating cylinder seats on this)
//    - central light bore
//    - 3 screw holes for the long M4 assembly screws
//
//  All dimensions are parameters. MEASURE the marked ones on the real
//  base and update before printing.
// =====================================================================

// ---------- Tube (drives the saddle curve) ----------
tube_circumference = 505;            // mm, measured around the tube
tube_od            = tube_circumference / PI;   // ~160.7 mm  (or override directly)
// tube_od         = 160.7;          // <- uncomment to set OD directly

// ---------- Base footprint ----------
pad_diameter   = 60;     // overall disc diameter of the base
base_thickness = 6.8;    // thinnest material, over the tube apex (center of saddle).
                         // Measured "lowest depth of the saddle" = 6.8 mm.
                         // The rim (thickest) is derived = base_thickness + sagitta,
                         // which works out to ~12.6 mm (matches measured "highest depth").

// ---------- Saddle ----------
saddle_wrap = 7;         // skirt allowance below the apex contact line.
                         // Must be >= saddle sagitta (~5.8 mm); larger is harmless
                         // (the saddle cut trims it back to the true tube curve).

// ---------- Central light bore ----------
bore_d = 31;             // light path; >= the optical-tube hole

// ---------- Screw holes (3x long M4 assembly screws) ----------
stud_spacing  = 36.5;                    // center-to-center between screws
stud_bcd      = stud_spacing / sqrt(3) * 2;   // bolt-circle DIAMETER (~42.1 mm)
screw_hole_d  = 4.5;                     // M4 clearance (through-hole)
clocking_angle = 90;     // rotation of the 3-hole pattern (deg).
                         // 90 => one hole on +Y = the saddle groove centerline.

// ---------- Optional recesses (set 0 to disable) ----------
nut_pocket_d     = 0;    // e.g. 8.1 for an M4 nut trap on the tube side
nut_pocket_depth = 0;
head_cbore_d     = 0;    // counterbore on the top face for screw heads
head_cbore_depth = 0;

// ---------- Render quality ----------
$fn = 180;

// =====================================================================

Rt = tube_od / 2;        // tube outer radius -> saddle radius

module saddle_cut() {
    // Cylinder representing the tube; its apex sits at z = 0.
    // Subtracting it carves the concave saddle into the base bottom.
    translate([0, 0, -Rt])
        rotate([90, 0, 0])
            cylinder(r = Rt, h = pad_diameter * 2, center = true);
}

module screw_holes() {
    for (i = [0:2]) {
        a = clocking_angle + i * 120;
        x = (stud_bcd / 2) * cos(a);
        y = (stud_bcd / 2) * sin(a);
        translate([x, y, 0]) {
            // through-hole
            translate([0, 0, -saddle_wrap - 1])
                cylinder(d = screw_hole_d, h = base_thickness + saddle_wrap + 2);
            // optional nut pocket (tube side, bottom)
            if (nut_pocket_d > 0)
                translate([0, 0, -saddle_wrap - 0.01])
                    cylinder(d = nut_pocket_d, h = nut_pocket_depth, $fn = 6);
            // optional head counterbore (top side)
            if (head_cbore_d > 0)
                translate([0, 0, base_thickness - head_cbore_depth])
                    cylinder(d = head_cbore_d, h = head_cbore_depth + 0.01);
        }
    }
}

module base() {
    difference() {
        // solid disc: from below the apex (saddle skirt) up to the flat top
        translate([0, 0, -saddle_wrap])
            cylinder(d = pad_diameter, h = base_thickness + saddle_wrap);

        saddle_cut();                          // concave bottom
        translate([0, 0, -saddle_wrap - 1])    // central light bore
            cylinder(d = bore_d, h = base_thickness + saddle_wrap + 2);
        screw_holes();                         // 3 M4 holes (+ optional pockets)
    }
}

base();

// ---- Derived values printed to console on render ----
sagitta   = Rt - sqrt(Rt*Rt - pow(pad_diameter/2, 2));
rim_thick = base_thickness + sagitta;
echo(str("tube_od = ", tube_od, " mm  (saddle radius ", Rt, " mm)"));
echo(str("stud bolt-circle diameter = ", stud_bcd, " mm"));
echo(str("saddle sagitta = ", sagitta, " mm"));
echo(str("apex (thinnest) = ", base_thickness, " mm  | rim (thickest) = ", rim_thick,
        " mm  <- should match measured 6.8 / 12.6"));
