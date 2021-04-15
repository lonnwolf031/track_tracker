/*
Overpass query:
==========
// query part for: “road”
  way["highway"="primary"]["surface"="asphalt"]({{bbox}});
  ==========================================

[out:json][timeout:25];
(
  // query part for: “surface=*”  highway=*
  way["surface"](around:10,51.28845, 4.502601);
);
// print results
out body;
>;
out skel qt;



 */