.. comment

Camera
======

Welcome. Here's a demo of camera projection online.

`Source <http://www.sitepoint.com/SitePoint>`_

TODO:

- More accurate camera model + distortion
- clean up object rotation

.. raw:: html

    <div id="demo">
    <canvas id="cnv" width="1" height="1" style="border:1px solid #000000"></canvas>
    <div>
        <div id="slider0">
        </div>
        <br>
        <div>
            <button type="button" id="Autorotate" style="background-color: #3383FF">Autorotate</button>
        </div>
        <br>
        <div id="camera_params">
            Camera Parameters:
            <br>
            <div>
                Focal Length: <input id="_focal" type="text" size="5"> </input> [mm]
            </div>
            <div>
                Resolution: <input id="_rezx" type="text" size="5"> </input> [x]
                            <input id="_rezy" type="text" size="5"> </input> [y] [px]
            </div>
            <div>
                Pixel Size: <input id="_spx" type="text" size="5"> </input> [um]
            </div>
            <div>
                Pixel Skew: <input id="_skew" type="text" size="3"> </input> (0,1)
            </div>
            <div>
                Distortion: <input id="_dist1" type="text" size="4"> </input>
                            <input id="_dist2" type="text" size="4"> </input>
                            <input id="_dist3" type="text" size="4"> </input>
                            <input id="_dist4" type="text" size="4"> </input>
                            <input id="_dist5" type="text" size="4"> </input>
                [t1, t2, r1, r2, r3]
            </div>
        </div>
        <div id="object_parameters">
            <hr>
            Object Parameteres:
            <br>
            <div>
                Dimensions: <input id="_objx" type="text" size="4"> </input> [x]
                            <input id="_objy" type="text" size="4"> </input> [y]
                            <input id="_objz" type="text" size="4"> </input> [z] [m]
            </div>
            <div>
                Center:     <input id="_objcx" type="text" size="4"> </input> [x]
                            <input id="_objcy" type="text" size="4"> </input> [y]
                            <input id="_objcz" type="text" size="4"> </input> [z] [m]
            </div>
            <div>
                 Theta:   <input id="_objtheta" type="text" size="6"> </input> [rad]
                 Phi      <input id="_objphi" type="text" size="6"> </input> [rad]
            </div>
        </div>

    </div>
    </div>

    <script>

    // Point3D object
    var Point3D = function(x, y, z) {
        this.__type__ = "point3d";
        this.x = parseFloat(x);
        this.y = parseFloat(y);
        this.z = parseFloat(z);
    };

    // Point2D object
    var Point2D = function(x, y) {
        this.__type__ = "point2d";
        this.x = parseFloat(x);
        this.y = parseFloat(y);
    };

    function r2d(v){
        return Math.round(v * 100) / 100
    }

    function translate(V, t){
        var Vr = new Point3D(0,0,0);
        Vr.x = V.x + t.x;
        Vr.y = V.y + t.y;
        Vr.z = V.z + t.z;
        return Vr;
    }

    function norm(p){
        if (p.__type__==="point3d"){
            return Math.sqrt(Math.pow(p.x,2)+Math.pow(p.y,2)+Math.pow(p.z,2));
        }else if (p.__type__==="point2d"){
            return Math.sqrt(Math.pow(p.x,2)+Math.pow(p.y,2));
        }else{
            return null;
        }
    }

    function normalize(p){
        if (p.__type__==="point3d"){
            var n = norm(p);
            return new Point3D(p.x/n, p.y/n, p.z/n);
        }else if (p.__type__==="point2d"){
            n = norm(p);
            return new Point2D(p.x/n, p.y/n);
        }else{
            return null;
        }
    }

    // Camera Object
    var Camera = function(f, spx, rx, ry, skew, t1, t2, r1, r2, r3){
        this.f = f; // [mm]
        this.rx = rx; // [px]
        this.ry = ry; // [px]
        this.spx = spx; // [um]
        this.skew = skew; // (0,1)
        this.t1 = t1;
        this.t2 = t2;
        this.r1 = r1;
        this.r2 = r2;
        this.r3 = r3;

    };

    // cube object
    var Cube = function(x,y,z, cx, cy, cz, theta, phi){
        this.x = x; // all in [m]
        this.y = y;
        this.z = z;
        this.cx = cx;
        this.cy = cy;
        this.cz = cz;
        this.theta = theta;
        this.phi = phi;

        this.vertices = [
            new Point3D(- this.x/2,- this.y/2, + this.z/2),
            new Point3D(- this.x/2,- this.y/2, - this.z/2),
            new Point3D(+ this.x/2,- this.y/2, - this.z/2),
            new Point3D(+ this.x/2,- this.y/2, + this.z/2),
            new Point3D(+ this.x/2,+ this.y/2, + this.z/2),
            new Point3D(+ this.x/2,+ this.y/2, - this.z/2),
            new Point3D(- this.x/2,+ this.y/2, - this.z/2),
            new Point3D(- this.x/2,+ this.y/2, + this.z/2)
        ];

        // Generate the faces
        this.faces = [
            [this.vertices[0], this.vertices[1], this.vertices[2], this.vertices[3]], // TOP
            [this.vertices[3], this.vertices[2], this.vertices[5], this.vertices[4]], // RIGHT
            [this.vertices[4], this.vertices[5], this.vertices[6], this.vertices[7]], // BOTTOM
            [this.vertices[7], this.vertices[6], this.vertices[1], this.vertices[0]], // LEFT
            [this.vertices[7], this.vertices[0], this.vertices[3], this.vertices[4]], // BACK
            [this.vertices[1], this.vertices[6], this.vertices[5], this.vertices[2]]  // FRONT
        ];

        // Generate face normals
        this.faceNormals = [
            new Point3D(0,-1,0), // TOP
            new Point3D(1,0,0),  // RIGHT
            new Point3D(0,1,0),  // BOTTOM
            new Point3D(-1,0,0), // LEFT
            new Point3D(0,0,1),  // BACK
            new Point3D(0,0,-1), // FRONT
        ];

        // Face Centers:
        this.faceCenters = [
            new Point3D(0,-this.y/2,0),
            new Point3D(this.x/2,0,0),
            new Point3D(0,this.y/2,0),
            new Point3D(-this.x/2,0,0),
            new Point3D(0,0,this.z/2),
            new Point3D(0,0,-this.z/2),
        ]

    };

    // Perspective Projection
    function project(P,cam){
        // X -> point {x,y,z}
        // K -> projection matrix [3 x 3]
        // k -> distortion coefficients [1 x 5]
        // R -> Rotation Matrix (world->cam frame) [3 x 3] -> [1, 0, 0] ,[0, 0, -1], [0, 1, 0]
        // t -> Translation vector (camera is 0'ed)
        // Camera and Object are in the same 3D space, therefore, no need for RT

        var _x = P.x/P.z;
        var _y = P.y/P.z;
        var _xx = 0;
        var _yy = 0;
        // test for distortion:
        if (Math.sqrt(Math.pow(cam.t1,2)+Math.pow(cam.t2,2)+Math.pow(cam.r1,2)+Math.pow(cam.r2,2)+Math.pow(cam.r3,2))> 1e-3){
            var r2 = Math.pow(_x,2) + Match.pow(_y,2);
            var r4 = Math.pow(r2,2);
            var r6 = Math.pow(r2,3);
        }else{
            _xx = _x;
            _yy = _y;
        }

        return new Point2D( _xx*cam.f/(1e-3*cam.spx) + cam.skew*( _yy*cam.f/(1e-3*cam.spx)) + cam.rx/2, _yy*cam.f/(1e-3*cam.spx) + cam.ry/2)
    }


    // render(camera, window, objects)
    // renders objects in camera view scaled to window properties
    /*
    * Camera
    *   Focal length
    *   Pixel size
    *   Resolution
    *   Radial distortion
    *   Tangential distortion
    *   -> always at 0,0,0, no rotation
    *
    * Window
    *   canvas width (projected objects rescaled to canvas size)
    *   canvas height (projected objects rescaled to canvas size)
    *
    * Objects
    *   [object]
    *
    * Object
    *   [verticies]
    *   [quad faces]
    *   [normals]
    *   [center point]
    *   [rotation]
    *
    * Process flow:
    *   for each object in objects:
    *       rotate vertices <- this implies applying rotation at each render... though rended is only called on change.
    *       calculate normals
    *       translate object
    *       for each face:
    *           check back-face culling
    *           if culled, skip
    *           project first Point3D into windows frame (world->camera->window)
    *               project & draw line for remainder vertices in face into window frame
    *               close path & fill
    *
    *
    *
    * OTHER CONSIDERATIONS:
    * - might as well create new objects from old ones per motion
    * - try to capture mouse/touch xy starting position and associate it with object to rotate
    *
    * */

    // render with camera scaling
    function render(objects, cam, ctx, w, h){
        // each object is already rotated locally, just need to translate and draw
        // Clear the previous frame
        ctx.clearRect(0, 0, w, h);
        // display frame scaling factor:
        var _sx = w/cam.rx;
        var _sy = h/cam.ry;
        // For each object
        for (var i = 0, n_obj = objects.length; i < n_obj; ++i) {
            // object center:
            var oc = new Point3D(objects[i].cx, objects[i].cy, objects[i].cz);
            // For each face
            for (var j = 0, n_faces = objects[i].faces.length; j < n_faces; ++j) {
                // back-face culling:
                // https://en.wikipedia.org/wiki/Back-face_culling
                // get face normal:
                var n = objects[i].faceNormals[j];
                // translate face center:
                var nc = translate(objects[i].faceCenters[j], oc);
                // don't draw face if dot(nc,n) >= 0; continue
                // since nc is the vector from cam center to face center
                if ((n.x*nc.x+n.y*nc.y+n.z*nc.z)>= 0)
                    continue;
                // back-culling passed
                // Get Current face
                var face = objects[i].faces[j];
                // translate first vertex in face:
                var _p = translate(face[0], oc);
                // Project into camera frame:
                var P = project(_p,cam);
                // start path drawing:
                ctx.beginPath();
                // rescale to fit window
                ctx.moveTo(_sx*P.x, _sy*P.y);
                //
                // Draw the other vertices
                for (var k = 1, n_vertices = face.length; k < n_vertices; ++k) {
                    _p = translate(face[k], oc);
                    P = project(_p,cam);
                    ctx.lineTo(_sx*P.x, _sy*P.y);
                }
                // Close the path and draw the face
                ctx.closePath();
                ctx.stroke();
                ctx.fill();
            }
        }
    }

    function update_page(cam, cube){
        document.getElementById("_focal").value = cam.f;
        document.getElementById("_rezx").value = cam.rx;
        document.getElementById("_rezy").value = cam.ry;
        document.getElementById("_spx").value = cam.spx;
        document.getElementById("_skew").value = cam.skew;
        document.getElementById("_dist1").value = cam.r1;
        document.getElementById("_dist2").value = cam.r2;
        document.getElementById("_dist3").value = cam.r3;
        document.getElementById("_dist4").value = cam.t1;
        document.getElementById("_dist5").value = cam.t2;

        document.getElementById("_objx").value = cube.x;
        document.getElementById("_objy").value = cube.y;
        document.getElementById("_objz").value = cube.z;
        document.getElementById("_objcx").value = -cube.cx;
        document.getElementById("_objcy").value = cube.cy;
        document.getElementById("_objcz").value = -cube.cz;
        document.getElementById("_objtheta").value = cube.theta;
        document.getElementById("_objphi").value = cube.phi;


    }

    function get_page_values(){
        return {
            focal: document.getElementById("_focal").value,
            rx: document.getElementById("_rezx").value,
            ry: document.getElementById("_rezy").value,
            spx: document.getElementById("_spx").value,
            skew: document.getElementById("_skew").value,
            d1: document.getElementById("_dist1").value,
            d2: document.getElementById("_dist2").value,
            d3: document.getElementById("_dist3").value,
            d4: document.getElementById("_dist4").value,
            d5: document.getElementById("_dist5").value,
            ox: document.getElementById("_objx").value,
            oy: document.getElementById("_objy").value,
            oz: document.getElementById("_objz").value,
            ocx: document.getElementById("_objcx").value,
            ocy: document.getElementById("_objcy").value,
            ocz: document.getElementById("_objcz").value,
        }
    }



    function set_canvas(cam, canvas, ctx){
         // update canvas...
        document.getElementById('cnv').height = canvas.offsetWidth * (cam.ry/cam.rx);
        // Objects style
        ctx.strokeStyle = 'rgba(0, 0, 0, 0.2)';
        ctx.fillStyle = 'rgba(0, 150, 255, 0.2)';
    }

    (function() {



        var autorotate_toggle = false;

        // Initial Camera parameters:
        var cam = new Camera(8, 4.8, 1920, 1200, 0, 0, 0, 0, 0, 0);

        var canvas = document.getElementById('cnv');
        offsetWidth = canvas.offsetWidth;
        offsetHeight = canvas.offsetHeight;
        var ctx = canvas.getContext('2d');
        // Initial new Cube:
        var cube = new Cube(1,1,1,0,0,-5,0,0);
        var objects = [cube];
        var rendered = false;

        function update_size(){
                console.log("im here");
                // try to get window width/height on load
                var w = window.innerWidth; // this doesn't work in sphinx
                // create listener for window resize:
                // sphinx ONLY
                if (document.getElementById('camera')!==null){
                    var page = document.getElementById('camera');
                    console.log("sphinx page width: ", page.offsetWidth);
                    // width is set by browser, height is set by camera
                    canvas.width = page.offsetWidth;
                    canvas.height = offsetHeight;
                }else{
                    // width is set by browser, height is set by camera
                    canvas.width = offsetWidth;
                    canvas.height = offsetHeight;
                    if (w >= 800){
                        canvas.width = 800;
                    }else{
                        canvas.width = 0.8*w;
                    }
                }
                // setup canvas:
                set_canvas(cam, canvas, ctx);
                if (rendered)
                    render(objects, cam, ctx, canvas.width, canvas.height);
        }

        update_size();

        // todo: retain old cube..
        window.addEventListener('resize', update_size);





        // update html page:
        update_page(cam, cube);

        // callback to update something: must call render!
        function update_parameter(o){
            return function(event){
                var valid = false; // validation parameter to update page
                var change = false;
                // get page values:
                var values = get_page_values();
                // console.log("key: ", event.key, "\nshift key:", window.event.shiftKey);
                if (event.key == "Enter"){
                    // o is property to change
                    change = true;
                    switch(o){
                        case "_focal":
                            if (values.focal > 1 && values.focal < 300){
                                cam.f = r2d(values.focal);
                                valid = true;
                            }
                            break;
                        case "_rezx":
                            if (values.rx > 10 && values.rx < 3000){
                                cam.rx = Math.round(values.rx);
                                set_canvas(cam, canvas, ctx);
                                valid = true;
                            }
                            break;
                        case "_rezy":
                            if (values.ry > 10 && values.ry < 3000){
                                cam.ry = Math.round(values.ry);
                                set_canvas(cam, canvas, ctx);
                                valid = true;
                            }
                            break;
                        case "_spx":
                            if (values.spx > 1 && values.spx < 10){
                                cam.spx = r2d(values.spx);
                                valid = true;
                            }
                            break;
                        case "_skew":
                            if (values.skew > 0 && values.skew < 1){
                                cam.skew = r2d(values.skew);
                                valid = true;
                            }
                            break;
                        case "_dist1":
                            break;
                        case "_dist2":
                            break;
                        case "_dist3":
                            break;
                        case "_dist4":
                            break;
                        case "_dist5":
                            break;
                        case "_objx": // width in x
                            /*
                            *  for this to work correctly, need to have cube rotation matrix,
                            *  create new cube with changed parameter, copy unchanged parametersapply rotation matrix
                            * */
                            if (values.ox > 0 && values.ox < 100){
                            }
                            break;
                        case "_objy": // height in y
                            if (values.oy > 0 && values.oy < 100){
                            }
                            break;
                        case "_objz": // depth in z
                            if (values.oz > 0 && values.oz < 100){
                            }
                            break;
                        case "_objcx": // pose in x (lateral)
                            if (Math.abs(values.ocx) < 1000){
                                cube.cx = r2d(-values.ocx);
                                valid = true;
                            }
                            break;
                        case "_objcy": // pose in y (height)
                            if (Math.abs(values.ocy) < 1000){
                                cube.cy = r2d(-values.ocy);
                                valid = true;
                            }
                            break;
                        case "_objcz": // pose in x (depth)
                            if (values.ocz > 0 && values.ocz < 1000){
                                cube.cz = r2d(-values.ocz);
                                valid = true;
                            }
                            break;
                    }

                }else if (event.key == "ArrowUp"){
                    change = true;
                    // bump value up by 1 increment
                    var _m = 1;
                    // shift key to reduce increment:
                    if (window.event.shiftKey)
                        _m = 0.1;
                    switch(o){
                        case "_focal":
                            if (r2d(cam.f+_m) < 300){
                                cam.f = r2d(cam.f+_m);
                                valid = true;
                            }
                            break;
                        case "_rezx":
                            if (Math.round(cam.rx+(_m*100)) < 3000){
                                cam.rx = Math.round(cam.rx+(_m*100));
                                set_canvas(cam, canvas, ctx);
                                valid = true;
                            }
                            break;
                        case "_rezy":
                            if (Math.round(cam.ry+(_m*100)) < 3000){
                                cam.ry = Math.round(cam.ry+(_m*100)); // shift shouldn't work here
                                set_canvas(cam, canvas, ctx);
                                valid = true;
                            }
                            break;
                        case "_spx":
                            if (cam.spx+_m < 10){
                                cam.spx = r2d(cam.spx+_m);
                                valid = true;
                            }
                            break;
                        case "_skew":
                            if (r2d(cam.skew+_m*0.2) < 1){
                                cam.skew = r2d(cam.skew+_m*0.2);
                                valid = true;
                            }
                            break;
                        case "_dist1":
                            break;
                        case "_dist2":
                            break;
                        case "_dist3":
                            break;
                        case "_dist4":
                            break;
                        case "_dist5":
                            break;
                        case "_objx": // width in x
                            /*
                            *  for this to work correctly, need to have cube rotation matrix,
                            *  create new cube with changed parameter, copy unchanged parametersapply rotation matrix
                            * */
                            if (values.ox > 0 && values.ox < 100){
                            }
                            break;
                        case "_objy": // height in y
                            if (values.oy > 0 && values.oy < 100){
                            }
                            break;
                        case "_objz": // depth in z
                            if (values.oz > 0 && values.oz < 100){
                            }
                            break;
                        case "_objcx": // pose in x (lateral)
                            if (Math.abs(cube.cx-_m) < 1000){
                                cube.cx = r2d(cube.cx-_m);
                                valid = true;
                            }
                            break;
                        case "_objcy": // pose in y (height)
                            if (Math.abs(cube.cy+_m) < 1000){
                                cube.cy = r2d(cube.cy+_m);
                                valid = true;
                            }
                            break;
                        case "_objcz": // pose in x (depth)
                            if (r2d(cube.cz-_m) > -1000){
                                cube.cz = r2d(cube.cz-_m);
                                valid = true;
                            }
                            break;
                    }
                }else if (event.key == "ArrowDown"){
                    change = true;
                    // bump value down by 1 increment
                     var _m = -1;
                    // shift key to reduce increment:
                    if (window.event.shiftKey)
                        _m = -0.1;
                    switch(o){
                        case "_focal":
                            if (r2d(cam.f+_m) > 1){
                                cam.f = r2d(cam.f+_m);
                                valid = true;
                            }
                            break;
                        case "_rezx":
                            if (Math.round(cam.rx+(_m*100)) > 100){
                                cam.rx = Math.round(cam.rx+(_m*100));
                                set_canvas(cam, canvas, ctx);
                                valid = true;
                            }
                            break;
                        case "_rezy":
                            if (Math.round(cam.ry+(_m*100)) > 100){
                                cam.ry = Math.round(cam.ry+(_m*100));
                                set_canvas(cam, canvas, ctx);
                                valid = true;
                            }
                            break;
                        case "_spx":
                            if (r2d(cam.spx+_m) > 1){
                                cam.spx = r2d(cam.spx+_m);
                                valid = true;
                            }
                            break;
                        case "_skew":
                            if (r2d(values.skew+_m*0.2) > 0){
                                cam.skew = r2d(values.skew+_m*0.2);
                                valid = true;
                            }
                            break;
                        case "_dist1":
                            break;
                        case "_dist2":
                            break;
                        case "_dist3":
                            break;
                        case "_dist4":
                            break;
                        case "_dist5":
                            break;
                        case "_objx": // width in x
                            /*
                            *  for this to work correctly, need to have cube rotation matrix,
                            *  create new cube with changed parameter, copy unchanged parametersapply rotation matrix
                            * */
                            if (values.ox > 0 && values.ox < 100){
                            }
                            break;
                        case "_objy": // height in y
                            if (values.oy > 0 && values.oy < 100){
                            }
                            break;
                        case "_objz": // depth in z
                            if (values.oz > 0 && values.oz < 100){
                            }
                            break;
                        case "_objcx": // pose in x (lateral)
                            if (Math.abs(r2d(cube.cx-_m)) < 1000){
                                cube.cx = r2d(cube.cx-_m);
                                valid = true;
                            }
                            break;
                        case "_objcy": // pose in y (height)
                            if (Math.abs(r2d(cube.cy+_m)) < 1000){
                                cube.cy = r2d(cube.cy+_m);
                                valid = true;
                            }
                            break;
                        case "_objcz": // pose in x (depth)
                            if (r2d(cube.cz-_m) < -0.1){
                                cube.cz = r2d(cube.cz-_m);
                                valid = true;
                            }
                            break;
                    }
                }
                if (change)
                    update_page(cam, cube);
                if (valid)
                    render(objects, cam, ctx, canvas.width, canvas.height);

            }
        }
        var param_list = ["_focal", "_rezx", "_rezy","_spx","_skew","_dist1","_dist2","_dist3","_dist4","_dist5","_objx","_objy","_objz","_objcx","_objcy","_objcz"];
        // GENERIC Listeners:
        // TODO: automate this with list
        for (var k =0; k < param_list.length; k++){
            document.getElementById(param_list[k]).addEventListener("keydown", update_parameter(param_list[k]));
        }

        // autorotate button:
        function toggle_autorotate(){
            autorotate_toggle = !autorotate_toggle;
            if (autorotate_toggle)
                document.getElementById("Autorotate").style = "background-color: #3383FF";
            else
                document.getElementById("Autorotate").style = "background-color: #FC3737";
        }
        document.getElementById("Autorotate").addEventListener("click", toggle_autorotate);


        // First render
        render(objects, cam, ctx, canvas.width, canvas.height);
        rendered = true;

        // Events
        var mousedown = false;
        var mx = 0;
        var my = 0;

        canvas.addEventListener('mousedown', initMove);
        document.addEventListener('mousemove', move);
        document.addEventListener('mouseup', stopMove);

        canvas.addEventListener("touchstart", initMove);
        document.addEventListener('touchmove', move);
        document.addEventListener('touchend', stopMove);


        function rotate_in_place(M, theta, phi){
            // Rotation matrix coefficients
            var ct = Math.cos(theta);
            var st = Math.sin(theta);
            var cp = Math.cos(phi);
            var sp = Math.sin(phi);

            // Rotation
            var x = M.x;
            var y = M.y;
            var z = M.z;

            M.x = ct * x - st * cp * y + st * sp * z;
            M.y = st * x + ct * cp * y - ct * sp * z;
            M.z = sp * y + cp * z;
        }

        function rotate_obj_in_place(O, theta, phi){
            for (var j = 0, n_verts = O.vertices.length; j < n_verts; ++j) {
                rotate_in_place(O.vertices[j], theta, phi);
            }
            for (var j = 0, n_faces = O.faces.length; j < n_faces; ++j) {
                rotate_in_place(O.faceCenters[j], theta, phi);
                rotate_in_place(O.faceNormals[j], theta, phi);
            }
        }

        // Initialize the movement
        function initMove(evt) {
            // clearTimeout(autorotate_timeout);
            mousedown = true;
            // event type
            // console.log(evt.type);
            if (evt.type==="mousedown"){
                mx = evt.clientX;
                my = evt.clientY;
            }else if (evt.type==="touchstart"){
                canvas.style.overflow = 'hidden';
                evt.preventDefault();
                mx = evt.touches[0].clientX;
                my = evt.touches[0].clientY;
            }

        }


        // this motion function is relative motion...
        function move(evt) {
            if (mousedown) {
                var mmx, mmy;
                // set tep vars:
                if (evt.type==="mousemove"){
                    mmx = evt.clientX;
                    mmy = evt.clientY;
                }else if (evt.type==="touchmove"){
                    evt.preventDefault();
                    mmx = evt.touches[0].clientX;
                    mmy = evt.touches[0].clientY;
                }
                // relative rotation:
                var theta = (mmx - mx) * Math.PI / 360;
                var phi = (mmy - my) * Math.PI / 180;

                // absolute - but limits rotation
                // cube.theta = (cube.theta + theta) % Math.PI;
                // cube.phi   = (cube.phi + phi) % Math.PI;
                // apply relative rotation to current object on vertices, normals, centers:
                // Rotate object in place, and translate it for render
                rotate_obj_in_place(cube, theta, phi);
                // TODO: decompose object orientation matrix into euler angles

                mx = mmx;
                my = mmy;
                render(objects,cam, ctx, canvas.width, canvas.height);
            }
        }


        function stopMove(evt) {
            mousedown = false;
            if (evt.type==="touchend")
                canvas.style.overflow = 'auto';
            // autorotate_timeout = setTimeout(autorotate, 2000);
        }


        // TODO: add button to turn feature on/off
        function autorotate() {
            for (var i = 0; i < 8; ++i)
                rotate_obj_in_place(cube, -Math.PI / 720, Math.PI / 720);

            render(objects,cam, ctx, canvas.width, canvas.height);

            autorotate_timeout = setTimeout(autorotate, 30);
        }

        // autorotate_timeout = setTimeout(autorotate, 2000);


    })();
    </script>
