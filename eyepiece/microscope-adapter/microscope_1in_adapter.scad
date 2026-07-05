// =====================================================================
//  MICROSCOPE 1" EYEPIECE -> 1.25" FOCUSER ADAPTER  (with filter thread)
//
//  A printed "1.25 inch eyepiece barrel" that carries a 1" microscope
//  eyepiece instead of glass, and threads a standard 1.25" astronomy
//  filter at the bottom.
//
//  Light path (bottom -> top):
//     telescope -> FILTER (female M28.5 x 0.6) -> clear bore -> MICROSCOPE
//     EYEPIECE (held in the top bore, slid for focus, locked by a setscrew)
//
//  1.25" filter thread = M28.5 x 0.6 (metric 60-deg). Filters carry the
//  MALE thread; this adapter carries the FEMALE thread. Universal 1.25"
//  standard -> fits SVBONY and any other 1.25" filter.
//
//  *** MEASURE eyepiece_d (and eyepiece barrel length) on your actual
//      microscope eyepiece and re-export. ***
//
//  part = "adapter" | "thread_test"
//    thread_test = a short ring with just the filter thread -- a cheap
//                  print to tune filter_thread_clear before the full part.
// =====================================================================

part = "adapter";

// ---- 1.25" focuser side (the barrel that drops into the focuser) ----
barrel_od      = 31.6;   // 1.25" = 31.75 mm, minus slip clearance for the focuser
barrel_len     = 30;     // barrel length below the flange (into the focuser)
undercut       = true;   // safety undercut groove near the bottom (focuser thumbscrew catches it)
undercut_d     = 30.0;   // groove root diameter
undercut_w     = 2.5;    // groove width
undercut_z     = 3.5;    // groove centre above the barrel bottom

// ---- top flange (rests on the focuser top; houses the clamp; grip) ----
flange_od      = 41;     // sized to support the eyepiece flange (Ø36.6) + a rim
flange_h       = 7;

// ---- microscope eyepiece side (the top bore; WF 10x/20, measured by circumference) ----
eyepiece_d     = 24.8;   // barrel OD, from ~78 mm circumference (78/pi). Tune if the fit is off.
eyepiece_clear = 0.5;    // slip fit (generous: the clamp screw takes up the slack)
eyepiece_depth = 20;     // bore depth available (>= the eyepiece barrel length below its flange)

// ---- eyepiece flange seat (the flange rests here; a recess self-centres it) ----
eyepiece_flange_d = 36.6; // eyepiece flange OD, from ~115 mm circumference (115/pi)
flange_recess     = true; // shallow recess in the top face to seat + centre the flange
recess_depth      = 1.5;  // recess depth (<= the eyepiece flange thickness)
recess_clear      = 0.5;  // diametral clearance around the flange

// ---- filter thread (female M28.5 x 0.6) at the bottom ----
filter_thread    = true;
filter_maj_d     = 28.5; // M28.5
filter_pitch     = 0.6;  // x 0.6
filter_thread_len= 4;    // engagement length (a few turns)
filter_thread_clear = 0.35; // printed-fit clearance (raise if the filter won't start)
thread_rh        = 1;    // 1 = right-hand (standard); -1 if a filter won't thread

// ---- light path ----
bore_min       = 24;     // clear bore between the eyepiece stop and the filter (< eyepiece_d)

// ---- eyepiece clamp: radial M3 screw into a CAPTIVE M3 NUT on the BORE side ----
//  The eyepiece locates by its own FLANGE resting on the adapter top face; this screw clamps
//  the barrel so it can't lift out. Drop the nut into its pocket from INSIDE the bore before
//  the eyepiece; the eyepiece barrel then traps it, and it keeps the screw from falling out.
clamp_screw   = true;
clamp_angle   = 0;       // where the clamp sits around the flange (deg)
screw_clear   = 3.4;     // M3 screw-shaft clearance
nut_af        = 5.9;     // M3 nut across-flats (5.5) + clearance
nut_thk       = 2.6;     // M3 nut thickness (2.4) + clearance

// ---- render quality ----
$fn = 96;
// =====================================================================
total_h   = barrel_len + flange_h;
eye_bore  = eyepiece_d + eyepiece_clear;
stop_z    = total_h - eyepiece_depth;      // eyepiece barrel bottoms no lower than here (safety)
clamp_z   = barrel_len + flange_h/2;       // mid-flange -> accessible above the focuser
nut_cor   = nut_af / cos(30);              // nut across-corners (hex pocket size)

assert(bore_min < eyepiece_d, "bore_min must be < eyepiece_d so the eyepiece has a stop ledge");
assert(stop_z > filter_thread_len, "eyepiece_depth too large -- it overruns the filter thread");

// ---- female filter thread: subtract this male-form helix from the bore ----
module filter_thread_neg() {
    depth = 0.6134 * filter_pitch;
    Rmaj  = filter_maj_d/2 + filter_thread_clear/2;     // female valley (a touch oversize)
    Rmin  = Rmaj - depth;                                // female crest (points inward)
    turns = filter_thread_len / filter_pitch;
    linear_extrude(height = filter_thread_len, twist = -thread_rh*360*turns,
                   convexity = 10, slices = ceil(turns*20))
        union() {
            circle(r = Rmin, $fn = 64);
            polygon([[Rmin*cos( 30), Rmin*sin( 30)],
                     [Rmaj, 0],
                     [Rmin*cos(-30), Rmin*sin(-30)]]);
        }
}

// ---- radial M3 clamp with a captive nut on the BORE side (no boss) ----
module clamp_cuts() {
    rotate([0,0, clamp_angle]) {
        // hex nut pocket, opening on the BORE (inner) side; nut inner face flush with the bore
        translate([eye_bore/2, 0, clamp_z]) rotate([0,90,0])
            cylinder(d = nut_cor, h = nut_thk, $fn = 6);
        // screw clearance: outside -> through the nut -> tip reaches the barrel (clamps it)
        translate([eye_bore/2 - 1.5, 0, clamp_z]) rotate([0,90,0])
            cylinder(d = screw_clear, h = flange_od/2 - eye_bore/2 + 2, $fn = 24);
    }
}

module undercut_cut() {
    translate([0,0, undercut_z - undercut_w/2])
        difference() {
            cylinder(d = barrel_od + 2, h = undercut_w);
            translate([0,0,-0.1]) cylinder(d = undercut_d, h = undercut_w + 0.2);
        }
}

module adapter() {
    difference() {
        // ---- solid body: barrel + flange ----
        union() {
            cylinder(d = barrel_od, h = barrel_len);
            translate([0,0, barrel_len]) cylinder(d = flange_od, h = flange_h);
        }
        // ---- stepped bore, top to bottom ----
        translate([0,0, stop_z]) cylinder(d = eye_bore, h = total_h - stop_z + 1);   // eyepiece bore
        translate([0,0, filter_thread_len]) cylinder(d = bore_min, h = stop_z - filter_thread_len + 0.1); // light path
        // ---- filter thread (or a plain pocket) at the bottom ----
        if (filter_thread) {
            translate([0,0,-0.01]) filter_thread_neg();
            translate([0,0,-0.01]) cylinder(d1 = filter_maj_d + 1.2, d2 = filter_maj_d, h = 1.0); // lead-in chamfer
        } else {
            translate([0,0,-0.01]) cylinder(d = filter_maj_d, h = filter_thread_len + 0.02);
        }
        // ---- eyepiece flange recess (self-centres the flange on the top face) ----
        if (flange_recess)
            translate([0,0, total_h - recess_depth])
                cylinder(d = eyepiece_flange_d + recess_clear, h = recess_depth + 0.1);
        // ---- eyepiece clamp: radial M3 + captive nut ----
        if (clamp_screw) clamp_cuts();
        // ---- safety undercut ----
        if (undercut) undercut_cut();
    }
    echo(str("ADAPTER: 1.25\" barrel Ø", barrel_od, " x ", barrel_len, ", flange Ø", flange_od,
             "; eyepiece bore Ø", eye_bore, " x ", eyepiece_depth, " deep; light path Ø", bore_min));
    echo(str("FILTER thread: female M", filter_maj_d, " x ", filter_pitch,
             " (clear ", filter_thread_clear, "), ", filter_thread_len, " mm engagement"));
    if (clamp_screw)
        echo(str("CLAMP: radial M3 screw + captive nut (AF ", nut_af, " x ", nut_thk,
                 ") on the BORE side (no boss); eyepiece flange rests on the top face"));
}

// short ring with just the filter thread -- cheap fit test before the full part
module thread_test() {
    difference() {
        cylinder(d = filter_maj_d + 6, h = filter_thread_len + 2);
        if (filter_thread) {
            translate([0,0,-0.01]) filter_thread_neg();
            translate([0,0,-0.01]) cylinder(d1 = filter_maj_d + 1.2, d2 = filter_maj_d, h = 1.0);
        } else translate([0,0,-0.01]) cylinder(d = filter_maj_d, h = filter_thread_len + 2.02);
    }
    echo(str("THREAD TEST: female M", filter_maj_d, " x ", filter_pitch, " clear ", filter_thread_clear));
}

// ---------------------------------------------------------------------
if      (part == "adapter")      adapter();
else if (part == "thread_test")  thread_test();
else                             echo(str("unknown part: ", part));
