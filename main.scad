/*
Generic Action Camera Adapter for 3DR Solo
Copyright (C) 2016 - 2017  Hugh Eaves

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

/***************************************************
 * NOTE: this file contains the code and paramters
 * for the camera adapter and bracket, but does not
 * render them. Open "adapter.scad" or "bracket.scad"
 * to actually render the adapter and bracket models.
 ***************************************************
 
/*********************
 * CAMERA DIMENSIONS *
 *********************/

// No-name SJ4000 clone
// camera_length = 59.8;
// camera_width = 40.8;
// camera_height = 25.6;

// GitUp Git2P
camera_length = 59.4;
camera_width = 41.1;
camera_height = 19.6;

/********************
 * MAIN PARAMETERS *
 ********************/
/* How much to shift the camera to the right to avoid the curved protrusion from the pitch motor housing */
camera_offset = 3.2;

/* Dimensions of the base of the camera adapter, so that it is a nice snug fit inside the 3DR gimbal mount */
base_height = 8; // (thickness) thick enough to clear the GoPro plug in the back
base_width  = 42;
base_length = 60;

/* Dimensions of the small bracket that holds the camera adapter to the gimbal mount */
bracket_width = 9;
bracket_depth = 9.5;
bracket_thickness = 3;
bracket_radius = 2;


/********************
 * OTHER PARAMETERS *
 ********************/

/* Dimensions of the "stud" that the 3DR balancing weights attach to */
stud_height = 2.5;
stud_diameter = 6.4;
stud_hole_diameter = 2;

bottom_lip_width = 4.5;
bottom_lip_height = 2.6;

// cutout for GoPro plug
plug_thickness = 5;
plug_width = 23;
plug_offset = 55.5 - (plug_thickness / 2);

// cutout for right side wall of "gimbal bracket"
side_wall_length = 31;
side_wall_height = 6.4;
side_wall_width = 2.4;
side_wall_offset = 59.8;

// height of hook on bottom left of "gimbal bracket"
hook_width = 17.6;
hook_height = 2.5; // distance from bottom
hook_length = 4;
hook_thickness = 1;

// width of protrusion on front of "pitch motor"
motor_protrusion_width = 20;

// thickness / length of camera retaining clips
clip_thickness = 1.6;
clip_length = 3;
right_clip_opening_width =  26;
// left_clip_opening_width = motor_protrusion_width;
left_clip_opening_width = right_clip_opening_width;

x_midpoint = base_width / 2;
main_length = camera_length + camera_offset * 2;
camera_gap = (base_width - camera_width) / 2;

camera_height_adjustment = 0;

module lip_cutout() {
cube([bottom_lip_width, base_length, bottom_lip_height]);
  translate([0,0,bottom_lip_height])
  mirror([1,-1,0])
  wedge(base_length, bottom_lip_width, bottom_lip_width, false, false);
}


module side_wall_cutout() {
   translate ([0, side_wall_offset, 0]) {
      cutout_base_height = side_wall_height - (side_wall_width / 2);
      cube([side_wall_length, side_wall_width, cutout_base_height ]);
        translate([0,0,cutout_base_height ])
        prism (side_wall_length, side_wall_width, side_wall_width / 2);
    }
}

module hook_cutout() {
  translate ([x_midpoint - hook_width/2 ,0,hook_height]) {
    cube([hook_width,hook_length,hook_thickness]);
    translate([0,0,hook_thickness])
      wedge (hook_width, hook_length, hook_length, false); 
  }
}

module bracket_cutout() {
  bracket_clearance = 0.4;
  adj_bracket_width = bracket_width + bracket_clearance;
  adj_bracket_depth = bracket_depth + bracket_clearance;
  translate([base_width - bracket_depth, base_length + bracket_clearance / 2 - adj_bracket_width, 0]) {
    translate([-bracket_clearance,0,base_height - bracket_thickness])
      cube([adj_bracket_depth,adj_bracket_width,bracket_thickness + 5]);
    translate([bracket_depth - bracket_thickness,0,0])
      cube([bracket_depth,adj_bracket_width,base_height]);
  }

}

module clip_corner(length) {
    
  cube([clip_thickness, length + clip_thickness, length]);
    wedge(clip_thickness, length + clip_thickness, length + clip_thickness, false, true);
      
}


module clip(length) {
  cube([base_width,clip_thickness,camera_height]);
  translate([-clip_thickness + camera_gap,0,camera_height])
  cube([camera_width+clip_thickness*2,clip_thickness,length * 2 + camera_height_adjustment]);
  translate ([-clip_thickness + camera_gap, clip_thickness, camera_height + camera_height_adjustment])
    mirror([0,1,-1])
      prism(camera_width+clip_thickness*2,length*2,length);
 //   cube([camera_width+clip_thickness*2, length + clip_thickness, clip_thickness ]);
  wedge(base_width,camera_offset - clip_thickness,camera_height+ length * 2 + camera_height_adjustment, true, false);
  translate([0,0,camera_height + clip_length + camera_height_adjustment - length]) {
  translate([-clip_thickness + camera_gap,0,0]) clip_corner(length);
  translate([base_width - camera_gap,0,0]) clip_corner(length);
  }
}

module left_clip() {
  translate ([0,camera_offset - clip_thickness,base_height]) {
    difference() {
      clip(clip_length);
      translate ([x_midpoint - left_clip_opening_width / 2,-clip_thickness,2])
        cube([left_clip_opening_width,clip_length + clip_thickness * 2,camera_height+clip_length*2]);
    }
  }
}

module right_clip() {
  translate ([0,camera_length + camera_offset + clip_thickness,base_height]) {
    mirror ([0,1,0]) difference() {
      clip(clip_length);
      translate ([x_midpoint - right_clip_opening_width / 2,-clip_thickness,2])
        cube([right_clip_opening_width,clip_length + clip_thickness * 2,camera_height+clip_length*2]);
    }

//    translate([-clip_thickness + camera_gap,0,-clip_thickness ])
//      wedge(clip_thickness,4,10, true, false);
//    translate([base_width -  camera_gap,0,-clip_thickness ])
//      wedge(clip_thickness,4,10, true, false);
  }
}

module prism(x, y, z, upside_down){
  translate([0,y/2,0]) {
  wedge(x, y/2, z, true, upside_down);
  wedge(x, y/2, z, false, upside_down);
  }
}

module wedge(x, y, z, reverse, upside_down){
  ly = reverse ? -y : y;
  lz = upside_down ? -z : z;
  polyhedron(
    points=[[0,0,0], [x,0,0], [x,ly,0], [0,ly,0], [0,0,lz], [x,0,lz]],
    faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
  );
}

module weight_stud() {
  difference() {
    cylinder(d=stud_diameter - 0.4, h=stud_height, $fn=32);
    cylinder(d=stud_hole_diameter, h=stud_height, $fn=16);
  }
}


/********************************************
 * Top level function to render the adapter
 ********************************************/
module adapter() {

  difference () {
    union() {
    cube([base_width, main_length, base_height]);
 
//        translate([0,0,base_height]) {
//    cube([(base_width - camera_width), main_length, 1]);
//    translate([camera_width , 0,0])
//      cube([(base_width - camera_width), main_length, 1]);
//  }

    }
    
    lip_cutout();
    
    translate([base_width,0,0]) mirror([-1,0,0])lip_cutout();
    
    side_wall_cutout();

    translate ([x_midpoint - plug_width/2, plug_offset ,0])
      cube([plug_width, plug_thickness, base_height]);

    hook_cutout();
    
    bracket_cutout();
  }
  
  left_clip();
  right_clip();
  
}

/********************************************
 * Top level function to render the bracket
 ********************************************/
module bracket() {
  bracket_inside_height = 11.4 + base_height - bracket_thickness;

  difference() {
    union() { 
      hull() { 
        cube([bracket_width, bracket_thickness, bracket_depth + bracket_thickness - bracket_radius]);
        cube([1, bracket_thickness, bracket_depth + bracket_thickness]);
        translate([bracket_width - bracket_radius,0,bracket_depth + bracket_thickness - bracket_radius])
          mirror ([0,-1,1]) cylinder(r = bracket_radius, h = bracket_thickness, $fn=16);
      }    
      translate([0, bracket_inside_height + bracket_thickness, 0]) 
        cube([bracket_width, bracket_thickness, bracket_depth + bracket_thickness]);
      translate([0, bracket_thickness, 0]) 
        cube([bracket_width, bracket_inside_height, bracket_thickness * 2]);
    }
    
    translate([bracket_width - 3,bracket_thickness,bracket_thickness - 0.2])
    cube([2,bracket_inside_height,bracket_depth]);
    translate ([bracket_width - 3.6,0,bracket_depth + bracket_thickness - 2.8])
      mirror ([0,-1,1]) {
        translate([0,0,-bracket_thickness/2])
          cylinder(d = 4, h = bracket_thickness, $fn=16);
        translate([0,0,bracket_thickness / 2])
          cylinder(d = 2, h = bracket_thickness, $fn=16);
    }
  }
}

// Render the objects for preview
translate([-20,0,0])
  bracket();

adapter();
 




