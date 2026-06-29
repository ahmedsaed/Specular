// male locked into the bracket: seat on the ring top (z=14.8), twisted to the stop (~59 deg)
import("qr_bracket.stl");
color("orange") translate([0,0,14.8]) rotate([0,0,59]) import("qr_focuser_base.stl");
