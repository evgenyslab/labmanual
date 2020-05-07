.. comment

Camera
======

Welcome. Here's a demo of camera projection online.

`Source <http://www.sitepoint.com/SitePoint>`_

TODO:

- More accurate camera model + distortion
- clean up object rotation

.. raw:: html

    <canvas id="cnv" width="800" height="600"></canvas>
    <div>
    <div id="slider0">
    </div>
    <div>
        Focal Length: <input id="input1" type="text"> </input>
        <button type="button" id="button1">Send</button>
    </div>
    <div>
        Pixel Size: <input id="input2" type="text"> </input>
    </div>

    <div>
        Obj_x: <input id="Obj_x" type="text"> </input>
        Obj_y: <input id="Obj_y" type="text"> </input>
        Obj_z: <input id="Obj_z" type="text"> </input>
    </div>
    </div>

    <script>
    var Vertex = function(x, y, z) {
        this.x = parseFloat(x);
        this.y = parseFloat(y);
        this.z = parseFloat(z);
    };

    var Vertex2D = function(x, y) {
        this.x = parseFloat(x);
        this.y = parseFloat(y);
    };

    var cross = function(x,y){
        // cross product of two vectors
        return Vertex(0,0,0);
    };

    var Cube = function(center, side) {
        // Generate the vertices
        var d = side / 2;
        var x = center.x;
        var y = center.y;
        var z = center.z;
        this.x = x;
        this.y = y;
        this.z = z;

        this.vertices = [
            new Vertex(x - d, y - d, z + d),
            new Vertex(x - d, y - d, z - d),
            new Vertex(x + d, y - d, z - d),
            new Vertex(x + d, y - d, z + d),
            new Vertex(x + d, y + d, z + d),
            new Vertex(x + d, y + d, z - d),
            new Vertex(x - d, y + d, z - d),
            new Vertex(x - d, y + d, z + d)
        ];

        // Generate the faces
        this.faces = [
            [this.vertices[0], this.vertices[1], this.vertices[2], this.vertices[3]],
            [this.vertices[3], this.vertices[2], this.vertices[5], this.vertices[4]],
            [this.vertices[4], this.vertices[5], this.vertices[6], this.vertices[7]],
            [this.vertices[7], this.vertices[6], this.vertices[1], this.vertices[0]],
            [this.vertices[7], this.vertices[0], this.vertices[3], this.vertices[4]],
            [this.vertices[1], this.vertices[6], this.vertices[5], this.vertices[2]]
        ];
    };

    function prespective_project(P,f,cx,cy){
        // X -> point {x,y,z}
        // K -> projection matrix [3 x 3]
        // k -> distortion coefficients [1 x 5]
        // R -> Rotation Matrix (world->cam frame) [3 x 3] -> [1, 0, 0] ,[0, 0, -1], [0, 1, 0]
        // t -> Translation vector (camera is 0'ed)
        // console.log(f, cx, cy);
        return new Vertex2D((f*P.x/P.z)+cx, (f*P.y/P.z)+cy);
    }
    console.log("blah1");
    function project(M) {
        // Distance between the camera and the plane
        var d = 50;
        var r = d / M.y;
        // M is a vertex of the cube object, if we apply true perspective projection:
        // need to do some math here...

        // maybe implement better perspective projection
        return new Vertex2D(r * M.x, r * M.z);
    }

    console.log("blah2");
    function render(objects, ctx, dx, dy, f) {
        // Clear the previous frame
        ctx.clearRect(0, 0, 2*dx, 2*dy);

        // For each object
        for (var i = 0, n_obj = objects.length; i < n_obj; ++i) {
            // For each face
            for (var j = 0, n_faces = objects[i].faces.length; j < n_faces; ++j) {
                // Current face
                var face = objects[i].faces[j];
                // todo: back-face culling:
                // https://en.wikipedia.org/wiki/Back-face_culling

                // Draw the first vertex
                // var P = project(face[0]);
                // console.log(face[0]);
                var P = prespective_project(face[0],f,dx,dy);
                // console.log(P);
                ctx.beginPath();
                // ctx.moveTo(P.x + dx, -P.y + dy);
                ctx.moveTo(P.x, P.y);

                // Draw the other vertices
                for (var k = 1, n_vertices = face.length; k < n_vertices; ++k) {
                    // P = project(face[k]);
                    var P = prespective_project(face[k],f,dx,dy);
                    // console.log(P);
                    // ctx.lineTo(P.x + dx, -P.y + dy);
                    ctx.lineTo(P.x, P.y);
                }

                // Close the path and draw the face
                ctx.closePath();
                ctx.stroke();
                ctx.fill();
            }
        }
    }


    (function() {



        // Fix the canvas width and height
        var canvas = document.getElementById('cnv');
        canvas.width = canvas.offsetWidth;
        canvas.height = canvas.offsetHeight;
        var dx = canvas.width / 2;
        var dy = canvas.height / 2;
        var focalScale = 50;
        var f  = focalScale*(canvas.width + canvas.height)/2;

        // Objects style
        var ctx = canvas.getContext('2d');
        ctx.strokeStyle = 'rgba(0, 0, 0, 1)';
        ctx.fillStyle = 'rgba(0, 150, 255, 1)';

        // Create the cube
        console.log(dy);
        console.log(dx);
        var cube_center = new Vertex(0, 0, 100);
        var cube = new Cube(cube_center, 1);
        var objects = [cube];

        var mystring = "";

        // scaled focal length:
        document.getElementById("input1").value = focalScale;
        document.getElementById("Obj_x").value = cube.x;
        document.getElementById("Obj_y").value = cube.y;
        document.getElementById("Obj_z").value = cube.z;

        // callback to update something: must call render!
        var logKey = function(event){
            if (event.key=="Enter"){
                console.log(document.getElementById("input1").value);
                // validate..
                mystring = document.getElementById("input1").value;
            }
        };

        var myFunction = function(event){
            console.log("im here");
            console.log(mystring);
        };

        // focal length updating
        var focalScaleUpdate = function(event){
            if (event.key=="Enter"){
                if (isNaN(document.getElementById("input1").value)){
                    console.log("Not a number");
                    // reset the object
                    document.getElementById("input1").value = focalScale;
                }else{
                    console.log("Is a number");
                    // validate between (0, 100):
                    x = document.getElementById("input1").value;
                    console.log(x);
                    if (x > 0 && x < 100){
                        focalScale = x;
                        document.getElementById("input1").value = focalScale;
                        f  = focalScale*(canvas.width + canvas.height)/2;
                        // render?
                        render(objects, ctx, dx, dy, f);
                    }else{
                        // reset
                        document.getElementById("input1").value = focalScale;
                    }
                }
            }
        };

        function obj_update(o){
            return function(event){
                // o is property to change
                console.log("key: ", event.key, " param: ", o);
                if (event.key == "Enter"){
                    if (isNaN(document.getElementById("Obj_x").value)){
                        // reset the object
                        if (o=="x"){
                            document.getElementById("Obj_x").value = cube.x;
                        }else if (o=="y"){
                            document.getElementById("Obj_y").value = cube.y;
                        }else if (o=="z"){
                            document.getElementById("Obj_z").value = cube.z;
                        }

                }else{
                    console.log("Is a number");
                    // validate between (0, 100):
                    x = document.getElementById("Obj_x").value;
                    console.log(x);
                    cube_center = new Vertex(x, cube_center.y, cube_center.z);
                    cube = new Cube(cube_center, 1);
                    objects = [cube];
                    document.getElementById("Obj_x").value = cube.x;
                    // render?
                    render(objects, ctx, dx, dy, f);
                }
                }else if (event.key == "ArrowUp"){

                }else if (event.key == "ArrowDown"){

                }
            }
        }
        // focal length updating
        var objx_update = function(event){
            if (event.key=="Enter"){
                if (isNaN(document.getElementById("Obj_x").value)){
                    console.log("Not a number");
                    // reset the object
                    document.getElementById("Obj_x").value = cube.x;
                }else{
                    console.log("Is a number");
                    // validate between (0, 100):
                    x = document.getElementById("Obj_x").value;
                    console.log(x);
                    cube_center = new Vertex(x, cube_center.y, cube_center.z);
                    cube = new Cube(cube_center, 1);
                    objects = [cube];
                    document.getElementById("Obj_x").value = cube.x;
                    // render?
                    render(objects, ctx, dx, dy, f);
                }
            }else if(event.key =="ArrowUp") {
                cube_center = new Vertex(cube_center.x+1, cube_center.y, cube_center.z);
                cube = new Cube(cube_center, 1);
                objects = [cube];
                document.getElementById("Obj_x").value = cube.x;
                // render?
                render(objects, ctx, dx, dy, f);
            }else if(event.key =="ArrowDown"){
                cube_center = new Vertex(cube_center.x-1, cube_center.y, cube_center.z);
                cube = new Cube(cube_center, 1);
                objects = [cube];
                document.getElementById("Obj_x").value = cube.x;
                // render?
                render(objects, ctx, dx, dy, f);
            }
        };

        document.getElementById("button1").addEventListener("click", myFunction);
        // this works but doesnt update live..only updates on click
        document.getElementById("input1").addEventListener("keydown", focalScaleUpdate);

        document.getElementById("Obj_x").addEventListener("keydown", objx_update);
        document.getElementById("Obj_y").addEventListener("keydown", obj_update("y"));
        // document.getElementById("Obj_z").addEventListener("keydown", objz_update);
        // grab inputs for objects... & set callbacks for auto update




        // First render
        render(objects, ctx, dx, dy, f);

        // Events
        var mousedown = false;
        var mx = 0;
        var my = 0;

        canvas.addEventListener('mousedown', initMove);
        document.addEventListener('mousemove', move);
        document.addEventListener('mouseup', stopMove);

        // Rotate a vertice
        function rotate(M, center, theta, phi) {
            // Rotation matrix coefficients
            var ct = Math.cos(theta);
            var st = Math.sin(theta);
            var cp = Math.cos(phi);
            var sp = Math.sin(phi);

            // Rotation
            var x = M.x - center.x;
            var y = M.y - center.y;
            var z = M.z - center.z;

            M.x = ct * x - st * cp * y + st * sp * z + center.x;
            M.y = st * x + ct * cp * y - ct * sp * z + center.y;
            M.z = sp * y + cp * z + center.z;
        }

        // Initialize the movement
        function initMove(evt) {
            // clearTimeout(autorotate_timeout);
            mousedown = true;
            mx = evt.clientX;
            my = evt.clientY;
        }

        function move(evt) {
            if (mousedown) {
                var theta = (evt.clientX - mx) * Math.PI / 360;
                var phi = (evt.clientY - my) * Math.PI / 180;

                for (var i = 0; i < 8; ++i)
                    rotate(cube.vertices[i], cube_center, theta, phi);

                mx = evt.clientX;
                my = evt.clientY;

                render(objects, ctx, dx, dy, f);
            }
        }

        function stopMove() {
            mousedown = false;
            // autorotate_timeout = setTimeout(autorotate, 2000);
        }

        function autorotate() {
            console.log("autoR");
            for (var i = 0; i < 8; ++i)
                rotate(cube.vertices[i], cube_center, -Math.PI / 720, Math.PI / 720);

            render(objects, ctx, dx, dy, f);

            autorotate_timeout = setTimeout(autorotate, 30);
        }

        // autorotate_timeout = setTimeout(autorotate, 2000);


    })();
    </script>
