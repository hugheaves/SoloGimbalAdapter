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

// Change this to change the weight
bracket_thickness = 2;
bracket_vertical_thickness = 4;
// makes the bracket longer
straight_section_length = 10; // can go up to 17mm and still fit


beam_curve_diameter = 34;
beam_thickness = 1.2;
beam_height = 4;
beam_width = 5.7;
beam_length = beam_curve_diameter / 2;

bracket_length = beam_length;
bracket_width = beam_width + bracket_thickness + beam_thickness;
bracket_height = beam_height + bracket_vertical_thickness;
bracket_depth = 3;


center_cutout_width = 1;
screw_thread_diameter = 2.4;
screw_head_diameter = 5;
screw_head_height = 3;

module curve_cutout() {
  difference() {
    cylinder(d = beam_curve_diameter, h = 100, $fn = 64);
    cylinder(d = beam_curve_diameter - (beam_thickness * 2), h = 100, $fn = 64);
  }
}

module side_weight() {
  difference() {
    union() {
      difference() {
            cube([bracket_length, bracket_width, bracket_height]);
        
        translate([0, beam_curve_diameter / 2 + bracket_thickness, bracket_vertical_thickness])
          curve_cutout();
        
        translate([bracket_length - screw_head_diameter / 2- 1,bracket_width / 2 - 1, 0]){ 
          
          cylinder(d = screw_head_diameter, h = screw_head_height, $fn = 16);
     
          cylinder(d = screw_thread_diameter, h = bracket_height, $fn = 16);
        }
      }
      translate([-straight_section_length, 0, 0])
        difference() {
          cube([straight_section_length, bracket_width, bracket_height]);
          
         translate([0, bracket_thickness, bracket_vertical_thickness])
            cube([straight_section_length, beam_thickness, 100]);
        }
    }
  }
}

side_weight();

translate([0,20,0]) mirror([1,0,0]) side_weight();

//  translate([0,beam_curve_diameter/2 + bracket_thickness,bracket_thickness])
//  curve_cutout();
