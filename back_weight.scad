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

// This is the size (width) of the weight. Larger values make it bigger and heavier.
weight_length = 29.9;

// Values greater than zero move the weight to the outer side of the gimbal
weight_offset = 0;

thickness = 2;
length = 57.8;
width = 34;
weight_thickness = 100;
cutout_offset = 37;
cutout_length = 18;
cutout_thickness = 4;
cutout_gap = 0.4;
hole_diameter = 2.5;
$fn = 16;

module clip() {
  intersection() {
    difference() {
      union() {
        cube([length, width, thickness]);
        translate([weight_offset, 0, -weight_thickness])
          cube([weight_length, width, weight_thickness]);
        translate([12, 0, thickness])
          cube([3, width, 3.4]);
        translate([33.6, 0, thickness])
          cube([3, width, 4]);
        translate([54.8, 0, thickness])
          cube([3, width, 4]); 
        
       translate([36, 0, 0]) {
        translate([4.5, 18, -2])
          cylinder(d = 5, h = 2);
        translate([16.5, 6.75, -2])
          cylinder(d = 5, h = 2);
        translate([13.5, 27, -2])
          cylinder(d = 5, h = 2);
       }

      }
      translate([36, 0, 0]) {
        translate([4.5, 18, -90])
          cylinder(d = hole_diameter, h = 100);
        translate([16.5, 6.75, -90])
          cylinder(d = hole_diameter, h = 100);
        translate([13.5, 27, -90])
          cylinder(d = hole_diameter, h = 100);
      } 

    }
    mirror([-1, 0, 1])
      translate([26, width / 2, 0]) {
        cylinder(d = 77, h = 14, $fn = 64);
        translate([0, 0, 14])
          cylinder(d = 70, h = 16, $fn = 64);
        translate([0, 0, 30])
          cylinder(d = 77, h = 100, $fn = 64);
      }
  }
}

rotate([90,0,0])
clip();