//////////////////////////////////////////////////////////////////////////////////////////////
// Paraboloid module for OpenScad
//
// Copyright (C) 2013  Lochner, Juergen
// http://www.thingiverse.com/Ablapo/designs
//
// This program is free software. It is
// licensed under the Attribution - Creative Commons license.
// http://creativecommons.org/licenses/by/3.0/
//////////////////////////////////////////////////////////////////////////////////////////////

//
// y = height of paraboloid
// f = focus distance
// rfa = radius of the focus area : 0 = point focus
// fc : 1 = center paraboloid in focus point(x=0, y=f); 0 = center paraboloid on top (x=0, y=0)
// detail = $fn of cone
//
fudge=0.01;   //prevent coplanar surfaces that cause ghost lines


module paraboloid (y=10, f=5, rfa=0, fc=1, detail=44) {
  hi = (y + 2 * f) / sqrt (2);            // height and radius of the cone -> alpha = 45° -> sin(45°)=1/sqrt(2)
  x = 2 * f * sqrt (y / f);               // x  = half size of parabola

  translate ([0, 0, -f * fc])             // center on focus
    rotate_extrude ($fn=detail)           // extrude paraboild
      intersection () {
        translate ([rfa, 0, 0])           // translate for fokus area
          union () {                      // adding square for focal area
            projection (cut=true)         // reduce from 3D cone to 2D parabola
              translate ([0, 0, f * 2])
                rotate ([45, 0, 0])       // rotate cone 45° and translate for cutting
            translate ([0, 0, -hi / 2])
              cylinder (h=hi, r1=hi, r2=0, center=true, $fn=detail); // center cone on tip
            translate ([-(rfa + x ), 0])
              square ([rfa + x, y]);      // focal area square
          }
          square ([2 * rfa + x, y + 1]);  // cut of half at rotation center
      }
}



module hollow_paraboloid (y=10, f=5, rfa=0, fc=1, thickness=1, detail=44) {
  hi = (y + 2 * f) / sqrt (2);            // height and radius of the cone -> alpha = 45° -> sin(45°)=1/sqrt(2)
  x = 2 * f * sqrt (y / f);               // x  = half size of parabola

  translate ([0, 0, -f * fc])             // center on focus
    rotate_extrude ($fn=detail)           // extrude paraboild
      
        translate ([rfa, 0, 0])           // translate for fokus area
          hollow_half_parabola(y, f, rfa,  fc, thickness, detail);
            
          
          
    }

module filled_parabola(y, f, rfa,  fc, detail){
    hi = (y + 2 * f) / sqrt (2);            // height and radius of the cone -> alpha = 45° -> sin(45°)=1/sqrt(2)
    x = 2 * f * sqrt (y / f);               // x  = half size of parabola    
    union () {                      // adding square for focal area
            projection (cut=true)         // reduce from 3D cone to 2D parabola
              translate ([0, 0, f * 2])
                rotate ([45, 0, 0])       // rotate cone 45° and translate for cutting
            translate ([0, 0, -hi / 2])
              cylinder (h=hi, r1=hi, r2=0, center=true, $fn=detail); // center cone on tip
            
          }
         
}

module hollow_half_parabola(y, f,rfa, fc, thickness, detail){
    hi = (y + 2 * f) / sqrt (2);            // height and radius of the cone -> alpha = 45° -> sin(45°)=1/sqrt(2)
    x = 2 * f * sqrt (y / f);               // x  = half size of parabola    
    difference(){
        filled_parabola(y, f, rfa, fc, detail);
        offset(delta=-thickness) filled_parabola(y, f, rfa, fc, detail);
        translate([0,thickness,0]) filled_parabola(y, f, rfa, fc, detail);
    translate ([-(rfa + x)-fudge , 0-fudge])
              square ([rfa + x+fudge, y+fudge]);      // focal area square          
    }
    
}

module compare_profiles(thickness=1){
    color("red") 
        translate([0,0,0.1]) 
            hollow_half_parabola(y=50, f=50, rfa=0, fc=1, thickness=thickness, detail=360);
    filled_parabola(y=50, f=50, rfa=0, fc=1, detail=360);
}    
    

compare_profiles(thickness=3)
*paraboloid(y=50, f=50, rfa=0, fc=1, detail=360);
*hollow_paraboloid(y=50, f=50, rfa=0, fc=1, thickness=3, detail=360);   



